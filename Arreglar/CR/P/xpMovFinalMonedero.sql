SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.xpMovFinalMonedero
@Empresa              char   ( 5),
@Sucursal             int        ,
@Modulo               char   ( 5),
@ID                   int        ,
@Estatus              char   (15),
@EstatusNuevo         char   (15),
@Usuario              char   (10),
@FechaEmision         datetime   ,
@FechaRegistro        datetime   ,
@Mov                  char   (20),
@MovID                varchar(20),
@MovTipo              char   (20),
@Ok                   int          OUTPUT,
@OkRef                varchar(255) OUTPUT
AS
BEGIN
DECLARE
@Accion               varchar(20),
@Moneda               varchar(10),
@TipoCambio           float      ,
@UEN                  int        ,
@Puntos               money      ,
@SaldoPMonuntos       money      ,
@DiferenciaPuntos     money      ,
@Rama                 varchar( 5),
@Cuenta               varchar(50),
@SubCuenta            varchar(50),
@Grupo                varchar(10),
@EjercicioAfectacion  int        ,
@PeriodoAfectacion    int        ,
@AcumulaSinDetalles   bit        ,
@AcumulaEnLinea       bit        ,
@GeneraAuxiliar       bit        ,
@GeneraSaldo	        bit        ,
@Conciliar            bit        ,
@EsResultados         bit        ,
@Renglon              float      ,
@RenglonSub           int        ,
@RenglonID            int        ,
@Bandera				int			,
@CobroAutomatico		bit
SELECT @CobroAutomatico = CobroAutomatico FROM MonederoCfg WHERE Empresa = @Empresa
IF @Modulo = 'VTAS' AND @MovTipo IN ('VTAS.N', 'VTAS.D','VTAS.F')
BEGIN
SELECT @Rama = 'MONEL', @SubCuenta = '', @Grupo = 'ME', @AcumulaSinDetalles = 1, @AcumulaEnLinea = 1, @GeneraAuxiliar = 1, @GeneraSaldo = 1, @Conciliar = 0, @EsResultados = 0
IF @MovTipo IN ('VTAS.N','VTAS.F') 
BEGIN
IF @EstatusNuevo IN ('PROCESAR','CONCLUIDO')
BEGIN
SELECT @Accion =  'AFECTAR'
EXEC  xpVerificarMovMonedero @ID , @Bandera OUTPUT
IF @Bandera = 1 
BEGIN
SELECT @Moneda = V.Moneda, @TipoCambio = V.TipoCambio, @UEN = V.Uen, @EjercicioAfectacion = V.Ejercicio, @PeriodoAfectacion = V.Periodo, @Cuenta = NULLIF(V.Monedero,''), @Puntos = SUM(ISNULL(D.Puntos,0.0))
FROM Venta               V
JOIN VentaD              D ON V.ID = D.ID
WHERE V.ID = @ID
GROUP BY V.Moneda, V.TipoCambio, V.Uen, V.Ejercicio, V.Periodo, V.Monedero
IF @Cuenta IS NOT NULL AND ISNULL(@Puntos,0.0) > 0.0
BEGIN
IF EXISTS(SELECT *
FROM TarjetaMonedero T
WHERE T.Serie = @Cuenta AND T.Estatus IN ('ACTIVA'))
BEGIN
EXEC spSaldoPMon @Sucursal, @Accion, @Empresa, @Rama, @Moneda, @TipoCambio, @Cuenta, @SubCuenta, @Grupo, @Modulo, @ID, @Mov, @MovID,NULL,@Puntos, @FechaEmision,
@EjercicioAfectacion, @PeriodoAfectacion,@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Mov, @MovID,
@EsResultados, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @UEN = @UEN
END
ELSE
SELECT @OK = 99005, @OKRef = @Cuenta
END
END
END
IF @EstatusNuevo = 'CANCELADO'
BEGIN
SELECT @Accion =  'CANCELAR'
EXEC  xpVerificarMovMonedero @ID , @Bandera OUTPUT   
IF @Bandera = 1
BEGIN
SELECT @Moneda = V.Moneda, @TipoCambio = V.TipoCambio, @UEN = V.Uen, @EjercicioAfectacion = V.Ejercicio, @PeriodoAfectacion = V.Periodo, @Cuenta = NULLIF(V.Monedero,''), @Puntos = SUM(ISNULL(D.Puntos,0.0))
FROM Venta               V
JOIN VentaD              D ON V.ID = D.ID
WHERE V.ID = @ID
GROUP BY V.Moneda, V.TipoCambio, V.Uen, V.Ejercicio, V.Periodo, V.Monedero
IF @Cuenta IS NOT NULL AND ISNULL(@Puntos,0.0) > 0.0
BEGIN
IF EXISTS(SELECT *
FROM TarjetaMonedero T
WHERE T.Serie = @Cuenta AND T.Estatus IN ('ACTIVA'))
BEGIN
SELECT @SaldoPMonuntos = SUM(ISNULL(Saldo,0.0))
FROM SaldoPMon
WHERE Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta 
IF @SaldoPMonuntos >= @Puntos
BEGIN
EXEC spSaldoPMon @Sucursal, @Accion, @Empresa, @Rama, @Moneda, @TipoCambio, @Cuenta, @SubCuenta, @Grupo, @Modulo, @ID, @Mov, @MovID, @Puntos, NULL, @FechaEmision,
@EjercicioAfectacion, @PeriodoAfectacion,@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Mov, @MovID,
@EsResultados, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @UEN = @UEN
END
ELSE
BEGIN
SELECT @DiferenciaPuntos = @Puntos - @SaldoPMonuntos
EXEC spSaldoPMon @Sucursal, @Accion, @Empresa, @Rama, @Moneda, @TipoCambio, @Cuenta, @SubCuenta, @Grupo, @Modulo, @ID, @Mov, @MovID,  @SaldoPMonuntos, NULL, @FechaEmision,
@EjercicioAfectacion, @PeriodoAfectacion,@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Mov, @MovID,
@EsResultados, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @UEN = @UEN
END
END
END
END
END
END
IF @MovTipo IN ('VTAS.D') 
BEGIN
IF @EstatusNuevo = 'CONCLUIDO'
BEGIN
SELECT @Accion =  'AFECTAR'
IF EXISTS(SELECT * FROM SerieTarjetaMovM WHERE Modulo = @Modulo AND ID = @ID)
BEGIN
SELECT @Moneda = V.Moneda, @TipoCambio = V.TipoCambio, @UEN = V.Uen, @EjercicioAfectacion = V.Ejercicio, @PeriodoAfectacion = V.Periodo, @Cuenta = NULLIF(T.Serie,''),
@Puntos = ISNULL(SUM(D.Puntos),0.0)
FROM Venta               V
JOIN VentaD              D ON V.ID = D.ID
JOIN SerieTarjetaMovM T ON V.ID = T.ID
WHERE V.ID = @ID
GROUP BY V.Moneda, V.TipoCambio, V.Uen, V.Ejercicio,  V.Periodo, T.Serie
IF @Cuenta IS NOT NULL AND ISNULL(@Puntos,0.0) > 0.0
BEGIN
IF EXISTS(SELECT *
FROM TarjetaMonedero T
WHERE T.Serie = @Cuenta AND T.Estatus IN ('ACTIVA'))
BEGIN
EXEC spSaldoPMon @Sucursal, @Accion, @Empresa, @Rama, @Moneda, @TipoCambio, @Cuenta, @SubCuenta, @Grupo, @Modulo, @ID, @Mov, @MovID, @Puntos, NULL, @FechaEmision,
@EjercicioAfectacion, @PeriodoAfectacion,@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Mov, @MovID,
@EsResultados, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @UEN = @UEN
IF @CobroAutomatico = 1
BEGIN
EXEC spCobroAutomaticoMonedero @ID, @Puntos
END
END
END
END
END
END
END
RETURN
END

