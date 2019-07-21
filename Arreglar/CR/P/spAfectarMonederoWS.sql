SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAfectarMonederoWS
@Empresa      varchar( 5),
@Sucursal     int        ,
@Accion       varchar(20),
@ID           int        ,
@Usuario      varchar(10),
@Modulo       varchar( 5),
@Mov          varchar(20),
@Estatus      varchar(15),
@Ok			int				OUTPUT,
@OkRef		varchar(255)	OUTPUT
AS
BEGIN
DECLARE
@MovID                   varchar(20),
@Serie                   varchar(20),
@FechaMov                datetime   ,
@EstatusN                varchar(15),
@Rama                    varchar( 5),
@Moneda                  varchar(10),
@TipoCambio              float      ,
@Cuenta                  varchar(20),
@CuentaDestino           varchar(20),
@SubCuenta               varchar(50),
@Grupo                   varchar(10),
@Cargo                   money      ,
@Abono                   money      ,
@Fecha                   datetime   ,
@EjercicioAfectacion     int        ,
@PeriodoAfectacion       int        ,
@AcumulaSinDetalles      bit        ,
@AcumulaEnLinea          bit        ,
@GeneraAuxiliar          bit        ,
@GeneraSaldo             bit        ,
@Conciliar               bit        ,
@Aplica                  varchar(20),
@AplicaID                varchar(20),
@EsResultados            bit        ,
@Renglon                 float      ,
@RenglonSub              int        ,
@RenglonID               int        ,
@SubCuenta2              varchar(50),
@SubCuenta3              varchar(50),
@Proyecto                varchar(50),
@Observaciones           varchar(100),
@Referencia              varchar(50),
@UEN                     int        ,
@ImporteMov              money
BEGIN TRANSACTION
SELECT @Moneda = ContMoneda, @TipoCambio = 1.0, @Rama = 'MONEL', @SubCuenta = '', @Grupo = 'ME',
@AcumulaSinDetalles = 1, @AcumulaEnLinea = 1, @GeneraAuxiliar = 1, @GeneraSaldo = 1, @Conciliar = 0, @EsResultados = 0
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @Modulo = 'MONEL'
BEGIn
IF @Accion = 'AFECTAR'
BEGIn
IF @Estatus = 'SINAFECTAR'
BEGIN
SELECT @EstatusN = 'CONCLUIDO', @FechaMov = GETDATE()
IF @Mov = 'Activacion Tarjeta' AND @Ok IS NULL
BEGIN
EXEC spConsecutivoMonedero @Sucursal, @Empresa, @Modulo, @ID, @Mov, NULL, NULL, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @MovID IS NOT NULL AND @OK IS NULL
BEGIN
UPDATE Monedero SET MovID = @MovID WHERE ID = @ID
IF EXISTS(SELECT * FROM MonederoD WHERE ID = @ID)
BEGIN
IF NOT EXISTS(SELECT *
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.Serie = T.Serie
WHERE M.ID = @ID
AND T.Estatus IN ('ACTIVA'))
BEGIN
UPDATE TarjetaMonedero
SET TarjetaMonedero.Estatus           = 'ACTIVA',
TarjetaMonedero.TieneMovimientos  = 1       ,
TarjetaMonedero.UsuarioActivacion = @Usuario,
TarjetaMonedero.FechaActivacion   = M.FechaEmision
FROM Monedero  M
JOIN MonederoD D ON M.ID = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.Serie = T.Serie
WHERE M.ID = @ID
UPDATE Monedero
SET UltimoCambio    = @FechaMov  ,
Estatus         = @EstatusN,
FechaConclusion = @FechaMov  ,
Ejercicio       = YEAR (FechaEmision),
Periodo         = MONTH(FechaEmision)
WHERE ID = @ID
SELECT @EjercicioAfectacion = Ejercicio, @PeriodoAfectacion = Periodo, @Fecha = FechaEmision, @Referencia = Referencia, @Observaciones = Observaciones
FROM Monedero
WHERE ID = @ID
IF NOT EXISTS(SELECT * FROM MovTiempo WHERE Modulo = @Modulo AND ID = @ID AND Estatus = @EstatusN)
INSERT MovTiempo
(Modulo , ID, FechaComenzo, FechaInicio, Estatus ,  Sucursal, Usuario)
VALUES (@Modulo,@ID, @FechaMov   , @FechaMov  ,@EstatusN, @Sucursal,@Usuario)
IF @OK IS NULL
EXEC spMovInsertar @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @EjercicioAfectacion, @PeriodoAfectacion, @FechaMov, @Fecha,
NULL, NULL, @Moneda, @TipoCambio, @Usuario, NULL, @Referencia, NULL, @Observaciones, @Ok OUTPUT
END
ELSE
SELECT @OK = 99001, @OKRef = T.Serie
FROM Monedero        M
JOIN MonederoD       D ON M.ID      = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.Serie = T.Serie
WHERE M.ID = @ID
AND T.Estatus IN ('ACTIVA')
END
ELSE
SELECT @OK = 60010
END
END
END
END
END
IF @OK IS NULL
BEGIN
COMMIT TRANSACTION
END
ELSE
BEGIN
ROLLBACK TRANSACTION
END
RETURN
END

