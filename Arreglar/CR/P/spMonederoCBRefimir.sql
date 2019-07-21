SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spMonederoCBRefimir
@Empresa              char( 5),
@Sucursal             int,
@Modulo               char( 5),
@ID                   int,
@MonederoCBSerie		varchar(20),
@MonederoCBImporte	varchar(20),
@Posicion				int
AS
BEGIN
DECLARE
@Accion               varchar(20),
@Moneda               varchar(10),
@TipoCambio           float,
@UEN                  int,
@Puntos               money,
@SaldoPMonuntos       money,
@DiferenciaPuntos     money,
@Rama                 varchar( 5),
@Cuenta               varchar(50),
@SubCuenta            varchar(50),
@Grupo                varchar(10),
@EjercicioAfectacion  int,
@PeriodoAfectacion    int,
@AcumulaSinDetalles   bit,
@AcumulaEnLinea       bit,
@GeneraAuxiliar       bit,
@GeneraSaldo	        bit,
@Conciliar            bit,
@EsResultados         bit,
@Renglon              float,
@RenglonSub           int,
@RenglonID            int,
@Bandera				int,
@Estatus              varchar(15),
@MovTipo              varchar(20),
@EstatusNuevo         varchar(15),
@Usuario              varchar(10),
@FechaEmision         datetime,
@FechaRegistro        datetime,
@Mov                  varchar(20),
@MovID                varchar(20),
@Ok                   int,
@OkRef                varchar(255),
@Mensaje				varchar(max)
SELECT @Rama = 'MONEL',
@SubCuenta = '',
@Grupo = 'ME',
@AcumulaSinDetalles = 1,
@AcumulaEnLinea = 1,
@GeneraAuxiliar = 1,
@GeneraSaldo = 1,
@Conciliar = 0,
@EsResultados = 0
BEGIN TRAN
IF @Modulo = 'VTAS'
BEGIN
INSERT INTO SerieTarjetaMovM (Empresa,	Modulo,	 ID,  Serie,			Importe,			Sucursal,	Posicion)
VALUES						 (@Empresa, @Modulo, @ID, @MonederoCBSerie, @MonederoCBImporte, @Sucursal, @Posicion)
SELECT @Moneda				= V.Moneda,
@TipoCambio			= V.TipoCambio,
@UEN					= V.Uen,
@EjercicioAfectacion = V.Ejercicio,
@PeriodoAfectacion	= V.Periodo,
@Estatus				= V.Estatus,
@MovTipo				= MT.Clave,
@Usuario				= V.Usuario,
@FechaEmision		= V.FechaEmision,
@FechaRegistro		= ISNULL(V.FechaRegistro,GETDATE()),
@Mov					= v.Mov,
@MovID				= v.MovID
FROM Venta               V
JOIN MovTipo MT ON V.Mov = MT.Mov
AND MT. Modulo = 'VTAS'
WHERE V.ID = @ID
IF @Estatus = 'SINAFECTAR' AND @MovTipo = 'VTAS.N'
SET @EstatusNuevo = 'PROCESAR'
IF @Estatus = 'SINAFECTAR' AND @MovTipo = 'VTAS.F'
SET @EstatusNuevo = 'CONCLUIDO'
IF @MovTipo IN ('VTAS.N', 'VTAS.F')
BEGIN
IF @EstatusNuevo IN ('PROCESAR', 'CONCLUIDO')
BEGIN
SELECT @Accion =  'AFECTAR'
EXEC  xpVerificarMovMonedero @ID , @Bandera OUTPUT
IF EXISTS(SELECT * FROM SerieTarjetaMovM WHERE Modulo = @Modulo AND ID = @ID) 
BEGIN
SELECT @Cuenta = NULLIF(Serie,''),
@Puntos = ISNULL(Importe,0.0)
FROM SerieTarjetaMovM
WHERE Modulo = @Modulo
AND ID = @ID
AND Posicion = @Posicion
IF @Cuenta IS NOT NULL AND ISNULL(@Puntos,0.0) > 0.0
BEGIN
IF EXISTS(SELECT *
FROM TarjetaMonedero T
WHERE T.Serie = @Cuenta AND T.Estatus IN ('ACTIVA'))
BEGIn
SELECT @SaldoPMonuntos = SUM(ISNULL(Saldo,0.0))
FROM SaldoPMon
WHERE Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta 
EXEC spSaldoPMon @Sucursal, @Accion, @Empresa, @Rama, @Moneda, @TipoCambio, @Cuenta, @SubCuenta, @Grupo, @Modulo, @ID, @Mov, @MovID, @Puntos, NULL, @FechaEmision,
@EjercicioAfectacion, @PeriodoAfectacion,@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Mov, @MovID,
@EsResultados, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @UEN = @UEN
IF @OK IS NULL
BEGIN
IF @Posicion = 1	UPDATE VentaCobro SET Importe1 = @Puntos, TCProcesado1 = 1, Referencia1 = 'APROBADA' WHERE ID = @ID
IF @Posicion = 2	UPDATE VentaCobro SET Importe2 = @Puntos, TCProcesado2 = 1, Referencia2 = 'APROBADA' WHERE ID = @ID
IF @Posicion = 3	UPDATE VentaCobro SET Importe3 = @Puntos, TCProcesado3 = 1, Referencia3 = 'APROBADA' WHERE ID = @ID
IF @Posicion = 4	UPDATE VentaCobro SET Importe4 = @Puntos, TCProcesado4 = 1, Referencia4 = 'APROBADA' WHERE ID = @ID
IF @Posicion = 5	UPDATE VentaCobro SET Importe5 = @Puntos, TCProcesado5 = 1, Referencia5 = 'APROBADA' WHERE ID = @ID
END
END
ELSE
SELECT @OK = 99005, @OKRef = 'La Cuenta ' + @Cuenta + 'no Existe o no está Activa'
END
END
END
END
END
IF @OK IS NULL
COMMIT TRAN
ELSE
BEGIN
ROLLBACK TRAN
SELECT @Mensaje = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Mensaje = @Mensaje + @OkRef
END
SELECT @Mensaje
END

