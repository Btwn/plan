SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spSaldoPMon
@Sucursal                int        ,
@Accion                  varchar(20),
@Empresa                 varchar( 5),
@Rama                    varchar( 5),
@Moneda                  varchar(10),
@TipoCambio              float      ,
@Cuenta                  varchar(20),
@SubCuenta               varchar(50),
@Grupo                   varchar(10),
@Modulo                  varchar( 5),
@ID                      int        ,
@Mov                     varchar(20),
@MovID                   varchar(20),
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
@Ok                      int          OUTPUT,
@OkRef                   varchar(255) OUTPUT,
@Renglon                 float      = NULL  ,
@RenglonSub              int        = NULL  ,
@RenglonID               int        = NULL  ,
@SubCuenta2              varchar(50)= ''    ,
@SubCuenta3              varchar(50)= ''    ,
@Proyecto                varchar(50)= ''    ,
@UEN                     int        = 0
AS
BEGIN
DECLARE
@FechaSinHora            datetime   ,
@SubCuentaAcum           varchar(50),
@SubCuenta2Acum          varchar(50),
@SubCuenta3Acum          varchar(50),
@ImporteConciliar        money      ,
@Temp                    money      ,
@CargoAux                money      ,
@AbonoAux                money      ,
@EsCancelacion           bit
SELECT @Cargo          = ISNULL(@Cargo          , 0.0),
@Abono          = ISNULL(@Abono          , 0.0)
SET @Sucursal = 0
IF @EjercicioAfectacion IS NULL SELECT @EjercicioAfectacion = YEAR(GETDATE())
IF @PeriodoAfectacion IS NULL SELECT @PeriodoAfectacion = MONTH(GETDATE())
IF @Accion IN ('CANCELAR', 'DESAFECTAR')
BEGIN
SELECT @EsCancelacion = 1
END
ELSE
SELECT @EsCancelacion = 0
IF @GeneraSaldo = 1 AND @Ok IS NULL
BEGIN
IF @AcumulaSinDetalles = 1
SELECT @SubCuentaAcum = '', @SubCuenta2Acum = '', @SubCuenta3Acum = ''
ELSE
SELECT @SubCuentaAcum = @SubCuenta, @SubCuenta2Acum = @SubCuenta2, @SubCuenta3Acum = @SubCuenta3
IF @Conciliar = 1
SELECT @ImporteConciliar = @Cargo - @Abono
ELSE SELECT @ImporteConciliar = 0.0
IF @EsResultados = 0
BEGIN
UPDATE SaldoPMon WITH (ROWLOCK)
SET Saldo           = ISNULL(Saldo, 0.0) - @Cargo + @Abono,
PorConciliar    = ISNULL(PorConciliar, 0.0)    + @ImporteConciliar,
UltimoCambio    = @Fecha
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND SubCuenta = @SubCuentaAcum
AND SubCuenta2 = @SubCuenta2Acum AND SubCuenta3 = @SubCuenta3Acum AND Proyecto = @Proyecto 
IF @@ROWCOUNT = 0
INSERT SaldoPMon 
( Sucursal,  Empresa,  Rama,  Moneda,  Grupo,  Cuenta,  SubCuenta,      SubCuenta2,      SubCuenta3,      Proyecto,  UEN,  Saldo         , PorConciliar     ,  UltimoCambio)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @Grupo, @Cuenta, @SubCuentaAcum, @SubCuenta2Acum, @SubCuenta3Acum, @Proyecto, NULL, (@Cargo+@Abono), @ImporteConciliar, @Fecha)
IF @@ERROR <> 0
SELECT @Ok = 1
END
END
IF @GeneraAuxiliar = 1 AND @Ok IS NULL
BEGIN
IF @Accion = 'DESAFECTAR'
BEGIN
IF (SELECT Sucursal FROM Version) <> 0
SELECT @Ok = 60290
IF @EsResultados = 0
DELETE AuxiliarPMon WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta
AND SubCuenta = @SubCuenta AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @EjercicioAfectacion AND Periodo = @PeriodoAfectacion
IF @@ROWCOUNT = 0 SELECT @Ok = 60100, @OkRef = 'Movimiento: '+RTRIM(@Mov) + ' ' +LTRIM(Convert(varchar, @MovID))
END
ELSE
BEGIN
SELECT @FechaSinHora       = @Fecha                      ,
@CargoAux           = NULLIF(@Cargo         , 0.0),
@AbonoAux           = NULLIF(@Abono         , 0.0)
EXEC spExtraerFecha @FechaSinHora OUTPUT
IF @EsResultados = 0
INSERT AuxiliarPMon (Sucursal, Empresa, Rama, Moneda, TipoCambio, Cuenta, SubCuenta, Ejercicio, Periodo, Fecha,
Grupo, Modulo, ModuloID, Mov, MovID, Cargo, Abono, Aplica, AplicaID, Acumulado, Conciliado, EsCancelacion,
Renglon, RenglonSub)
VALUES  (@Sucursal, @Empresa, @Rama, @Moneda, @TipoCambio, @Cuenta, @SubCuenta, @EjercicioAfectacion, @PeriodoAfectacion, @FechaSinHora,
@Grupo, @Modulo, @ID, @Mov, @MovID,@CargoAux,@AbonoAux,@Aplica, @AplicaID, @AcumulaEnLinea, 0, @EsCancelacion,
@Renglon, @RenglonSub)
IF @@ERROR <> 0
SELECT @Ok = 1
END
END
IF @AcumulaEnLinea = 1 AND @Ok IS NULL
BEGIN
IF @AcumulaSinDetalles = 1 SELECT @SubCuentaAcum = '' ELSE SELECT @SubCuentaAcum = @SubCuenta
IF @EsResultados = 0
BEGIN
UPDATE AcumPMon WITH (ROWLOCK)
SET Cargos           = ISNULL(Cargos          , 0.0) + @Cargo         ,
Abonos           = ISNULL(Abonos          , 0.0) + @Abono         ,
UltimoCambio     = @Fecha
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta
AND SubCuenta = @SubCuentaAcum AND Periodo = @PeriodoAfectacion AND Ejercicio = @EjercicioAfectacion
AND SubCuenta2 = @SubCuenta2Acum AND SubCuenta3 = @SubCuenta3Acum AND Proyecto = @Proyecto 
IF @@ROWCOUNT = 0
INSERT AcumPMon (Sucursal,  Empresa,  Rama,  Moneda,  Cuenta,  SubCuenta,      SubCuenta2,      SubCuenta3,      Proyecto,  UEN,  Grupo,  Ejercicio,            Periodo,
Cargos,  Abonos, UltimoCambio)
VALUES  (@Sucursal, @Empresa, @Rama, @Moneda, @Cuenta, @SubCuentaAcum, @SubCuenta2Acum, @SubCuenta3Acum, @Proyecto, @UEN, @Grupo, @EjercicioAfectacion, @PeriodoAfectacion,
@Cargo,  @Abono, @Fecha)
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
IF @Ok IS NULL
EXEC xpSaldoPMon @Sucursal, @Accion, @Empresa, @Rama, @Moneda, @TipoCambio, @Cuenta, @SubCuenta, @Grupo,
@Modulo, @ID, @Mov, @MovID, @Cargo, @Abono, @Fecha, @EjercicioAfectacion, @PeriodoAfectacion, @AcumulaSinDetalles, @AcumulaEnLinea,
@GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Aplica, @AplicaID, @EsResultados, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon,
@RenglonSub = @RenglonSub, @RenglonID = @RenglonID
RETURN
END

