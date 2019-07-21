SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spAfectarMonedero
@Empresa      varchar( 5),
@Sucursal     int        ,
@Accion       varchar(20),
@ID           int        ,
@Usuario      varchar(10),
@Modulo       varchar( 5),
@Mov          varchar(20),
@Estatus      varchar(15)
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
@ImporteMov              money      ,
@Ok                      int        ,
@OkRef                   varchar(255)
BEGIN TRANSACTION
SELECT @Moneda = ContMoneda, @TipoCambio = 1.0, @Rama = 'MONEL', @SubCuenta = '', @Grupo = 'ME',
@AcumulaSinDetalles = 1, @AcumulaEnLinea = 1, @GeneraAuxiliar = 1, @GeneraSaldo = 1, @Conciliar = 0, @EsResultados = 0
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @Modulo = 'MONEL'
BEGIN
IF @Accion = 'AFECTAR'
BEGIN
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
IF @Mov = 'Baja Tarjeta' AND @Ok IS NULL
BEGIN
EXEC spConsecutivoMonedero @Sucursal, @Empresa, @Modulo, @ID, @Mov, NULL, NULL, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @MovID IS NOT NULL AND @OK IS NULL
BEGIN
UPDATE Monedero SET MovID = @MovID WHERE ID = @ID
IF EXISTS(SELECT * FROM Monedero WHERE ID = @ID)
BEGIN
IF NOT EXISTS(SELECT *
FROM Monedero  M
JOIN MonederoD D ON M.ID = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.Serie = T.Serie
WHERE M.ID = @ID
AND T.Estatus IN ('ALTA','BAJA'))
BEGIN
IF ISNULL((SELECT SUM(ISNULL(Saldo,0.0)) FROM SaldoPMon WHERE Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta IN (SELECT Serie FROM MonederoD WHERE ID = @ID )),0.0) = 0.0
BEGIN
UPDATE TarjetaMonedero
SET TarjetaMonedero.Estatus          = 'BAJA',
TarjetaMonedero.TieneMovimientos = 1     ,
TarjetaMonedero.FechaBaja        = M.FechaEmision
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
SELECT @OK = 99004, @OKRef = Cuenta
FROM SaldoPMon
WHERE Empresa = @Empresa
AND Rama = @Rama
AND Moneda = @Moneda
AND Grupo = @Grupo
AND Cuenta IN (SELECT Serie FROM MonederoD WHERE ID = @ID)
AND ISNULL(Saldo,0.0) > 0.0
END
ELSE
SELECT @OK = 99001, @OKRef = T.Serie
FROM Monedero        M
JOIN MonederoD       D ON M.ID      = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.Serie = T.Serie
WHERE M.ID = @ID
AND T.Estatus IN ('ALTA','BAJA')
END
ELSE
SELECT @OK = 60010
END
END
IF @Mov = 'Aumento Saldo' AND @Ok IS NULL
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
AND T.Estatus IN ('ALTA','BAJA'))
BEGIN
IF NOT EXISTS(SELECT *
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
WHERE M.ID = @ID
AND NULLIF(D.Importe,0.0) IS NULL)
BEGIN
SELECT @RenglonID = 0
DECLARE crAumentarSaldoME CURSOR LOCAL FOR
SELECT C.Mov, C.MovID, C.FechaEmision, YEAR(C.FechaEmision), MONTH(C.FechaEmision), C.Mov, C.MovID, ISNULL(C.Uen,''), C.Referencia, C.Observaciones,
D.Renglon, D.RenglonSub, D.Serie, ISNULL(D.Importe,0.0)
FROM Monedero  C
JOIN MonederoD D ON C.ID = D.ID
WHERE C.ID = @ID
ORDER BY C.ID, D.Renglon
OPEN crAumentarSaldoME
FETCH NEXT FROM crAumentarSaldoME INTO @Mov, @MovID, @Fecha, @EjercicioAfectacion, @PeriodoAfectacion, @Aplica, @AplicaID, @UEN, @Referencia, @Observaciones,
@Renglon, @RenglonSub, @Cuenta, @Cargo
WHILE @@FETCH_STATUS <> -1 AND @Cuenta IS NOT NULL AND @OK IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @RenglonID = @RenglonID + 1, @ImporteMov = ISNULL(@ImporteMov,0.0) + ISNULL(@Cargo,0.0)
EXEC spSaldoPMon 0, @Accion, @Empresa, @Rama, @Moneda, @TipoCambio, @Cuenta, @SubCuenta, @Grupo, @Modulo, @ID, @Mov, @MovID, @Cargo, @Abono, @Fecha,
@EjercicioAfectacion, @PeriodoAfectacion,@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Aplica, @AplicaID,
@EsResultados, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @UEN = @UEN
END
FETCH NEXT FROM crAumentarSaldoME INTO @Mov, @MovID, @Fecha, @EjercicioAfectacion, @PeriodoAfectacion, @Aplica, @AplicaID, @UEN, @Referencia, @Observaciones,
@Renglon, @RenglonSub, @Cuenta, @Cargo
END
CLOSE crAumentarSaldoME
DEALLOCATE crAumentarSaldoME
UPDATE Monedero
SET UltimoCambio    = @FechaMov  ,
Estatus         = @EstatusN  ,
FechaConclusion = @FechaMov  ,
Importe         = @ImporteMov,
Ejercicio       = YEAR (FechaEmision),
Periodo         = MONTH(FechaEmision)
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
SELECT @OK = 30100, @OKRef = D.Serie
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
WHERE M.ID = @ID
AND NULLIF(D.Importe,0.0) IS NULL
END
ELSE
SELECT @OK = 99001, @OKRef = T.Serie
FROM Monedero        M
JOIN MonederoD       D ON M.ID      = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.Serie = T.Serie
WHERE M.ID = @ID
AND T.Estatus IN ('ALTA','BAJA')
END
ELSE
SELECT @OK = 60010
END
END
IF @Mov = 'Disminucion Saldo' AND @Ok IS NULL
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
AND T.Estatus IN ('ALTA','BAJA'))
BEGIN
IF NOT EXISTS(SELECT *
FROM Monedero  M
JOIN MonederoD D ON M.ID = D.ID
WHERE M.ID = @ID
AND NULLIF(D.Importe,0.0) IS NULL)
BEGIN
SELECT @RenglonID = 0
DECLARE crDisminuirSaldoME CURSOR LOCAL FOR
SELECT C.Mov, C.MovID, C.FechaEmision, YEAR(C.FechaEmision), MONTH(C.FechaEmision), C.Mov, C.MovID, ISNULL(C.Uen,''), C.Referencia, C.Observaciones,
D.Renglon, D.RenglonSub, D.Serie, ISNULL(D.Importe,0.0)
FROM Monedero  C
JOIN MonederoD D ON C.ID = D.ID
WHERE C.ID = @ID
ORDER BY C.ID, D.Renglon
OPEN crDisminuirSaldoME
FETCH NEXT FROM crDisminuirSaldoME INTO @Mov, @MovID, @Fecha, @EjercicioAfectacion, @PeriodoAfectacion, @Aplica, @AplicaID, @UEN, @Referencia, @Observaciones,
@Renglon, @RenglonSub, @Cuenta, @Abono
WHILE @@FETCH_STATUS <> -1 AND @Cuenta IS NOT NULL AND @OK IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @RenglonID = @RenglonID + 1, @ImporteMov = ISNULL(@ImporteMov,0.0) + ISNULL(@Abono,0.0)
IF (SELECT SUM(ISNULL(Saldo,0.0)) FROM SaldoPMon WHERE Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND UEN = ISNULL(NULLIF(@UEN,''),'0')) >= @Abono
EXEC spSaldoPMon 0, @Accion, @Empresa, @Rama, @Moneda, @TipoCambio, @Cuenta, @SubCuenta, @Grupo, @Modulo, @ID, @Mov, @MovID, @Cargo, @Abono, @Fecha,
@EjercicioAfectacion, @PeriodoAfectacion,@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Aplica, @AplicaID,
@EsResultados, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @UEN = @UEN
ELSE
SELECT @OK = 99002, @OKRef = @Cuenta
END
FETCH NEXT FROM crDisminuirSaldoME INTO @Mov, @MovID, @Fecha, @EjercicioAfectacion, @PeriodoAfectacion, @Aplica, @AplicaID, @UEN, @Referencia, @Observaciones,
@Renglon, @RenglonSub, @Cuenta, @Abono
END
CLOSE crDisminuirSaldoME
DEALLOCATE crDisminuirSaldoME
UPDATE Monedero
SET UltimoCambio    = @FechaMov  ,
Estatus         = @EstatusN  ,
FechaConclusion = @FechaMov  ,
Importe         = @ImporteMov,
Ejercicio       = YEAR (FechaEmision),
Periodo         = MONTH(FechaEmision)
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
SELECT @OK = 30100, @OKRef = D.Serie
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
WHERE M.ID = @ID
AND NULLIF(D.Importe,0.0) IS NULL
END
ELSE
SELECT @OK = 99001, @OKRef = T.Serie
FROM Monedero        M
JOIN MonederoD       D ON M.ID      = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.Serie = T.Serie
WHERE M.ID = @ID
AND T.Estatus IN ('ALTA','BAJA')
END
ELSE
SELECT @OK = 60010
END
END
IF @Mov = 'Traspaso Saldo' AND @Ok IS NULL
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
AND T.Estatus IN ('ALTA','BAJA'))
BEGIN
IF NOT EXISTS(SELECT *
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
LEFT OUTER JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.SerieDestino = T.Serie
WHERE M.ID = @ID
AND T.Serie IS NULL)
BEGIN
IF NOT EXISTS(SELECT *
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.SerieDestino = T.Serie
WHERE M.ID = @ID
AND T.Estatus IN ('ALTA','BAJA'))
BEGIN
IF NOT EXISTS(SELECT *
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
WHERE M.ID = @ID
AND NULLIF(D.Importe,0.0) IS NULL)
BEGIN
SELECT @RenglonID = 0
DECLARE crTraspasarSaldoME CURSOR LOCAL FOR
SELECT C.Mov, C.MovID, C.FechaEmision, YEAR(C.FechaEmision), MONTH(C.FechaEmision), C.Mov, C.MovID, ISNULL(C.Uen,''), C.Referencia, C.Observaciones,
D.Renglon, D.RenglonSub, D.Serie, D.SerieDestino, ISNULL(D.Importe,0.0), ISNULL(D.Importe,0.0)
FROM Monedero  C
JOIN MonederoD D ON C.ID = D.ID
WHERE C.ID = @ID
ORDER BY C.ID, D.Renglon
OPEN crTraspasarSaldoME
FETCH NEXT FROM crTraspasarSaldoME INTO @Mov, @MovID, @Fecha, @EjercicioAfectacion, @PeriodoAfectacion, @Aplica, @AplicaID, @UEN, @Referencia, @Observaciones,
@Renglon, @RenglonSub, @Cuenta, @CuentaDestino, @Cargo, @Abono
WHILE @@FETCH_STATUS <> -1 AND @Cuenta IS NOT NULL AND @OK IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @RenglonID = @RenglonID + 1, @ImporteMov = ISNULL(@ImporteMov,0.0) + ISNULL(@Abono,0.0)
IF (SELECT SUM(ISNULL(Saldo,0.0)) FROM SaldoPMon WHERE Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND UEN = ISNULL(NULLIF(@UEN,''),'0')) > @Abono
BEGIN
EXEC spSaldoPMon 0, @Accion, @Empresa, @Rama, @Moneda, @TipoCambio, @Cuenta, @SubCuenta, @Grupo, @Modulo, @ID, @Mov, @MovID, NULL, @Abono, @Fecha,
@EjercicioAfectacion, @PeriodoAfectacion,@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Aplica, @AplicaID,
@EsResultados, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @UEN = @UEN
IF @OK IS NULL
EXEC spSaldoPMon 0, @Accion, @Empresa, @Rama, @Moneda, @TipoCambio, @CuentaDestino, @SubCuenta, @Grupo, @Modulo, @ID, @Mov, @MovID, @Cargo, NULL, @Fecha,
@EjercicioAfectacion, @PeriodoAfectacion,@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Aplica, @AplicaID,
@EsResultados, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @UEN = @UEN
END
ELSE
SELECT @OK = 99002, @OKRef = @Cuenta
END
FETCH NEXT FROM crTraspasarSaldoME INTO @Mov, @MovID, @Fecha, @EjercicioAfectacion, @PeriodoAfectacion, @Aplica, @AplicaID, @UEN, @Referencia, @Observaciones,
@Renglon, @RenglonSub, @Cuenta, @CuentaDestino, @Cargo, @Abono
END
CLOSE crTraspasarSaldoME
DEALLOCATE crTraspasarSaldoME
UPDATE Monedero
SET UltimoCambio    = @FechaMov  ,
Estatus         = @EstatusN  ,
FechaConclusion = @FechaMov  ,
Importe         = @ImporteMov,
Ejercicio       = YEAR (FechaEmision),
Periodo         = MONTH(FechaEmision)
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
SELECT @OK = 30100, @OKRef = D.Serie
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
WHERE M.ID = @ID
AND NULLIF(D.Importe,0.0) IS NULL
END
ELSE
SELECT @OK = 99001, @OKRef = T.Serie
FROM Monedero        M
JOIN MonederoD       D ON M.ID      = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.SerieDestino = T.Serie
WHERE M.ID = @ID
AND T.Estatus IN ('ALTA','BAJA')
END
ELSE
SELECT @OK = 99003, @OKRef = D.SerieDestino
FROM Monedero        M
JOIN MonederoD       D ON M.ID      = D.ID
LEFT OUTER JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.SerieDestino = T.Serie
WHERE M.ID = @ID
AND T.Serie IS NULL
END
ELSE
SELECT @OK = 99001, @OKRef = T.Serie
FROM Monedero        M
JOIN MonederoD       D ON M.ID      = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.Serie = T.Serie
WHERE M.ID = @ID
AND T.Estatus IN ('ALTA','BAJA')
END
ELSE
SELECT @OK = 60010
END
END
END
END
IF @Accion = 'CANCELAR'
BEGIN
IF @Estatus = 'CONCLUIDO'
BEGIN
SELECT @EstatusN = 'CANCELADO', @FechaMov = GETDATE()
IF @Mov = 'Activacion Tarjeta' AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM MonederoD WHERE ID = @ID)
BEGIN
IF EXISTS(SELECT *
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.Serie = T.Serie
WHERE M.ID = @ID
AND T.Estatus IN ('ACTIVA'))
BEGIN
IF ISNULL((SELECT SUM(ISNULL(Saldo,0.0)) FROM SaldoPMon WHERE Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta IN (SELECT Serie FROM MonederoD WHERE ID = @ID )),0.0) = 0.0
BEGIN
UPDATE TarjetaMonedero
SET TarjetaMonedero.Estatus           = 'ALTA',
TarjetaMonedero.TieneMovimientos  = 1       ,
TarjetaMonedero.UsuarioActivacion = NULL,
TarjetaMonedero.FechaActivacion   = NULL
FROM Monedero  M
JOIN MonederoD D ON M.ID = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.Serie = T.Serie
WHERE M.ID = @ID
UPDATE Monedero
SET UltimoCambio     = @FechaMov,
Estatus          = @EstatusN,
FechaCancelacion = @FechaMov
WHERE ID = @ID
IF NOT EXISTS(SELECT * FROM MovTiempo WHERE Modulo = @Modulo AND ID = @ID AND Estatus = @EstatusN)
INSERT MovTiempo
(Modulo , ID, FechaComenzo, FechaInicio, Estatus ,  Sucursal, Usuario)
VALUES (@Modulo,@ID, @FechaMov   , @FechaMov  ,@EstatusN, @Sucursal,@Usuario)
END
ELSE
SELECT @OK = 99006, @OKRef = Cuenta
FROM SaldoPMon
WHERE Empresa = @Empresa
AND Rama = @Rama
AND Moneda = @Moneda
AND Grupo = @Grupo
AND Cuenta IN (SELECT Serie FROM MonederoD WHERE ID = @ID)
AND ISNULL(Saldo,0.0) > 0.0
END
ELSE
SELECT @OK = 99005, @OKRef = T.Serie
FROM Monedero        M
JOIN MonederoD       D ON M.ID      = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.Serie = T.Serie
WHERE M.ID = @ID
AND T.Estatus NOT IN ('ACTIVA')
END
ELSE
SELECT @OK = 60010
END
IF @Mov = 'Baja Tarjeta' AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM MonederoD WHERE ID = @ID)
BEGIN
IF EXISTS(SELECT *
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.Serie = T.Serie
WHERE M.ID = @ID
AND T.Estatus IN ('BAJA'))
BEGIN
UPDATE TarjetaMonedero
SET TarjetaMonedero.Estatus          = 'ACTIVA',
TarjetaMonedero.TieneMovimientos = 1       ,
TarjetaMonedero.FechaBaja        = NULL
FROM Monedero  M
JOIN MonederoD D ON M.ID = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.Serie = T.Serie
WHERE M.ID = @ID
UPDATE Monedero
SET UltimoCambio     = @FechaMov  ,
Estatus          = @EstatusN,
FechaCancelacion = @FechaMov
WHERE ID = @ID
IF NOT EXISTS(SELECT * FROM MovTiempo WHERE Modulo = @Modulo AND ID = @ID AND Estatus = @EstatusN)
INSERT MovTiempo
(Modulo , ID, FechaComenzo, FechaInicio, Estatus ,  Sucursal, Usuario)
VALUES (@Modulo,@ID, @FechaMov   , @FechaMov  ,@EstatusN, @Sucursal,@Usuario)
END
ELSE
SELECT @OK = 99007, @OKRef = T.Serie
FROM Monedero        M
JOIN MonederoD       D ON M.ID      = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.Serie = T.Serie
WHERE M.ID = @ID
AND T.Estatus NOT IN ('BAJA')
END
ELSE
SELECT @OK = 60010
END
IF @Mov = 'Aumento Saldo' AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM MonederoD WHERE ID = @ID)
BEGIN
IF NOT EXISTS(SELECT *
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.Serie = T.Serie
WHERE M.ID = @ID
AND T.Estatus IN ('ALTA','BAJA'))
BEGIN
IF NOT EXISTS(SELECT *
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
WHERE M.ID = @ID
AND NULLIF(D.Importe,0.0) IS NULL)
BEGIN
SELECT @RenglonID = 0
DECLARE crAumentarSaldoME CURSOR LOCAL FOR
SELECT C.Mov, C.MovID, C.FechaEmision, YEAR(C.FechaEmision), MONTH(C.FechaEmision), C.Mov, C.MovID, ISNULL(C.Uen,''), C.Referencia, C.Observaciones,
D.Renglon, D.RenglonSub, D.Serie, ISNULL(D.Importe,0.0)
FROM Monedero  C
JOIN MonederoD D ON C.ID = D.ID
WHERE C.ID = @ID
ORDER BY C.ID, D.Renglon
OPEN crAumentarSaldoME
FETCH NEXT FROM crAumentarSaldoME INTO @Mov, @MovID, @Fecha, @EjercicioAfectacion, @PeriodoAfectacion, @Aplica, @AplicaID, @UEN, @Referencia, @Observaciones,
@Renglon, @RenglonSub, @Cuenta, @Cargo
WHILE @@FETCH_STATUS <> -1 AND @Cuenta IS NOT NULL AND @OK IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @RenglonID = @RenglonID + 1, @ImporteMov = ISNULL(@ImporteMov,0.0) + ISNULL(@Cargo,0.0)
IF ISNULL((SELECT SUM(ISNULL(Saldo,0.0)) FROM SaldoPMon WHERE Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND UEN = ISNULL(NULLIF(@UEN,''),'0')),0.0)  > @Cargo
EXEC spSaldoPMon 0, @Accion, @Empresa, @Rama, @Moneda, @TipoCambio, @Cuenta, @SubCuenta, @Grupo, @Modulo, @ID, @Mov, @MovID, @Abono, @Cargo, @Fecha,
@EjercicioAfectacion, @PeriodoAfectacion,@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Aplica, @AplicaID,
@EsResultados, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @UEN = @UEN
ELSE
SELECT @OK = 99002, @OKRef = @Cuenta
END
FETCH NEXT FROM crAumentarSaldoME INTO @Mov, @MovID, @Fecha, @EjercicioAfectacion, @PeriodoAfectacion, @Aplica, @AplicaID, @UEN, @Referencia, @Observaciones,
@Renglon, @RenglonSub, @Cuenta, @Cargo
END
CLOSE crAumentarSaldoME
DEALLOCATE crAumentarSaldoME
IF @OK IS NULL
BEGIN
UPDATE Monedero
SET UltimoCambio     = @FechaMov  ,
Estatus          = @EstatusN,
FechaCancelacion = @FechaMov
WHERE ID = @ID
IF NOT EXISTS(SELECT * FROM MovTiempo WHERE Modulo = @Modulo AND ID = @ID AND Estatus = @EstatusN)
INSERT MovTiempo
(Modulo , ID, FechaComenzo, FechaInicio, Estatus ,  Sucursal, Usuario)
VALUES (@Modulo,@ID, @FechaMov   , @FechaMov  ,@EstatusN, @Sucursal,@Usuario)
END
END
ELSE
SELECT @OK = 30100, @OKRef = D.Serie
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
WHERE M.ID = @ID
AND NULLIF(D.Importe,0.0) IS NULL
END
ELSE
SELECT @OK = 99001, @OKRef = T.Serie
FROM Monedero        M
JOIN MonederoD       D ON M.ID      = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.Serie = T.Serie
WHERE M.ID = @ID
AND T.Estatus IN ('ALTA','BAJA')
END
ELSE
SELECT @OK = 60010
END
IF @Mov = 'Disminucion Saldo' AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM MonederoD WHERE ID = @ID)
BEGIN
IF NOT EXISTS(SELECT *
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.Serie = T.Serie
WHERE M.ID = @ID
AND T.Estatus IN ('ALTA','BAJA'))
BEGIN
IF NOT EXISTS(SELECT *
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
WHERE M.ID = @ID
AND NULLIF(D.Importe,0.0) IS NULL)
BEGIN
SELECT @RenglonID = 0
DECLARE crDisminuirSaldoME CURSOR LOCAL FOR
SELECT C.Mov, C.MovID, C.FechaEmision, YEAR(C.FechaEmision), MONTH(C.FechaEmision), C.Mov, C.MovID, ISNULL(C.Uen,''), C.Referencia, C.Observaciones,
D.Renglon, D.RenglonSub, D.Serie, ISNULL(D.Importe,0.0)
FROM Monedero  C
JOIN MonederoD D ON C.ID = D.ID
WHERE C.ID = @ID
ORDER BY C.ID, D.Renglon
OPEN crDisminuirSaldoME
FETCH NEXT FROM crDisminuirSaldoME INTO @Mov, @MovID, @Fecha, @EjercicioAfectacion, @PeriodoAfectacion, @Aplica, @AplicaID, @UEN, @Referencia, @Observaciones,
@Renglon, @RenglonSub, @Cuenta, @Abono
WHILE @@FETCH_STATUS <> -1 AND @Cuenta IS NOT NULL AND @OK IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @RenglonID = @RenglonID + 1, @ImporteMov = ISNULL(@ImporteMov,0.0) + ISNULL(@Abono,0.0)
EXEC spSaldoPMon 0, @Accion, @Empresa, @Rama, @Moneda, @TipoCambio, @Cuenta, @SubCuenta, @Grupo, @Modulo, @ID, @Mov, @MovID, @Abono, @Cargo, @Fecha,
@EjercicioAfectacion, @PeriodoAfectacion,@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Aplica, @AplicaID,
@EsResultados, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @UEN = @UEN
END
FETCH NEXT FROM crDisminuirSaldoME INTO @Mov, @MovID, @Fecha, @EjercicioAfectacion, @PeriodoAfectacion, @Aplica, @AplicaID, @UEN, @Referencia, @Observaciones,
@Renglon, @RenglonSub, @Cuenta, @Abono
END
CLOSE crDisminuirSaldoME
DEALLOCATE crDisminuirSaldoME
UPDATE Monedero
SET UltimoCambio     = @FechaMov  ,
Estatus          = @EstatusN,
FechaCancelacion = @FechaMov
WHERE ID = @ID
IF NOT EXISTS(SELECT * FROM MovTiempo WHERE Modulo = @Modulo AND ID = @ID AND Estatus = @EstatusN)
INSERT MovTiempo
(Modulo , ID, FechaComenzo, FechaInicio, Estatus ,  Sucursal, Usuario)
VALUES (@Modulo,@ID, @FechaMov   , @FechaMov  ,@EstatusN, @Sucursal,@Usuario)
END
ELSE
SELECT @OK = 30100, @OKRef = D.Serie
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
WHERE M.ID = @ID
AND NULLIF(D.Importe,0.0) IS NULL
END
ELSE
SELECT @OK = 99001, @OKRef = T.Serie
FROM Monedero        M
JOIN MonederoD       D ON M.ID      = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.Serie = T.Serie
WHERE M.ID = @ID
AND T.Estatus IN ('ALTA','BAJA')
END
ELSE
SELECT @OK = 60010
END
IF @Mov = 'Traspaso Saldo' AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM MonederoD WHERE ID = @ID)
BEGIN
IF NOT EXISTS(SELECT *
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.Serie = T.Serie
WHERE M.ID = @ID
AND T.Estatus IN ('ALTA','BAJA'))
BEGIN
IF NOT EXISTS(SELECT *
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
LEFT OUTER JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.SerieDestino = T.Serie
WHERE M.ID = @ID
AND T.Serie IS NULL)
BEGIN
IF NOT EXISTS(SELECT *
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.SerieDestino = T.Serie
WHERE M.ID = @ID
AND T.Estatus IN ('ALTA','BAJA'))
BEGIN
IF NOT EXISTS(SELECT *
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
WHERE M.ID = @ID
AND NULLIF(D.Importe,0.0) IS NULL)
BEGIN
SELECT @RenglonID = 0
DECLARE crTraspasarSaldoME CURSOR LOCAL FOR
SELECT C.Mov, C.MovID, C.FechaEmision, YEAR(C.FechaEmision), MONTH(C.FechaEmision), C.Mov, C.MovID, ISNULL(C.Uen,''), C.Referencia, C.Observaciones,
D.Renglon, D.RenglonSub, D.Serie, D.SerieDestino, ISNULL(D.Importe,0.0), ISNULL(D.Importe,0.0)
FROM Monedero  C
JOIN MonederoD D ON C.ID = D.ID
WHERE C.ID = @ID
ORDER BY C.ID, D.Renglon
OPEN crTraspasarSaldoME
FETCH NEXT FROM crTraspasarSaldoME INTO @Mov, @MovID, @Fecha, @EjercicioAfectacion, @PeriodoAfectacion, @Aplica, @AplicaID, @UEN, @Referencia, @Observaciones,
@Renglon, @RenglonSub, @Cuenta, @CuentaDestino, @Cargo, @Abono
WHILE @@FETCH_STATUS <> -1 AND @Cuenta IS NOT NULL AND @OK IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @RenglonID = @RenglonID + 1, @ImporteMov = ISNULL(@ImporteMov,0.0) + ISNULL(@Abono,0.0)
IF (SELECT SUM(ISNULL(Saldo,0.0)) FROM SaldoPMon WHERE Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @CuentaDestino AND UEN = ISNULL(NULLIF(@UEN,''),'0')) >= @Abono
BEGIN
EXEC spSaldoPMon 0, @Accion, @Empresa, @Rama, @Moneda, @TipoCambio, @Cuenta, @SubCuenta, @Grupo, @Modulo, @ID, @Mov, @MovID, @Cargo, NULL, @Fecha,
@EjercicioAfectacion, @PeriodoAfectacion,@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Aplica, @AplicaID,
@EsResultados, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @UEN = @UEN
IF @OK IS NULL
EXEC spSaldoPMon 0, @Accion, @Empresa, @Rama, @Moneda, @TipoCambio, @CuentaDestino, @SubCuenta, @Grupo, @Modulo, @ID, @Mov, @MovID, NULL, @Abono, @Fecha,
@EjercicioAfectacion, @PeriodoAfectacion,@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Aplica, @AplicaID,
@EsResultados, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @UEN = @UEN
END
ELSE
SELECT @OK = 99002, @OKRef = @CuentaDestino
END
FETCH NEXT FROM crTraspasarSaldoME INTO @Mov, @MovID, @Fecha, @EjercicioAfectacion, @PeriodoAfectacion, @Aplica, @AplicaID, @UEN, @Referencia, @Observaciones,
@Renglon, @RenglonSub, @Cuenta, @CuentaDestino, @Cargo, @Abono
END
CLOSE crTraspasarSaldoME
DEALLOCATE crTraspasarSaldoME
IF @OK IS NULL
BEGIN
UPDATE Monedero
SET UltimoCambio     = @FechaMov  ,
Estatus          = @EstatusN,
FechaCancelacion = @FechaMov
WHERE ID = @ID
IF NOT EXISTS(SELECT * FROM MovTiempo WHERE Modulo = @Modulo AND ID = @ID AND Estatus = @EstatusN)
INSERT MovTiempo
(Modulo , ID, FechaComenzo, FechaInicio, Estatus ,  Sucursal, Usuario)
VALUES (@Modulo,@ID, @FechaMov   , @FechaMov  ,@EstatusN, @Sucursal,@Usuario)
END
END
ELSE
SELECT @OK = 30100, @OKRef = D.Serie
FROM Monedero M
JOIN MonederoD D ON M.ID = D.ID
WHERE M.ID = @ID
AND NULLIF(D.Importe,0.0) IS NULL
END
ELSE
SELECT @OK = 99001, @OKRef = T.Serie
FROM Monedero        M
JOIN MonederoD       D ON M.ID      = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.SerieDestino = T.Serie
WHERE M.ID = @ID
AND T.Estatus IN ('ALTA','BAJA')
END
ELSE
SELECT @OK = 99003, @OKRef = D.SerieDestino
FROM Monedero        M
JOIN MonederoD       D ON M.ID      = D.ID
LEFT OUTER JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.SerieDestino = T.Serie
WHERE M.ID = @ID
AND T.Serie IS NULL
END
ELSE
SELECT @OK = 99001, @OKRef = T.Serie
FROM Monedero        M
JOIN MonederoD       D ON M.ID      = D.ID
JOIN TarjetaMonedero T ON M.Empresa = T.Empresa AND D.Serie = T.Serie
WHERE M.ID = @ID
AND T.Estatus IN ('ALTA','BAJA')
END
ELSE
SELECT @OK = 60010
END
END
END
END
IF @OK IS NULL
BEGIN
COMMIT TRANSACTION
SELECT NULL
END
ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT Descripcion + ' <BR><BR>' + ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
END
RETURN
END

