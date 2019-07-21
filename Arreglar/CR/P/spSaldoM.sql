SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSaldoM
@Sucursal		int,
@Accion		char(20),
@Empresa		char(5),
@Rama		char(5),
@Moneda		char(10),
@TipoCambio		float,
@Cuenta		char(20),
@SubCuenta		varchar(50),
@Grupo		char(10),
@Modulo		char(5),
@ID			int,
@Mov			char(20),
@MovID		varchar(20),
@Cargo		money,
@Abono		money,
@Fecha		datetime,
@EjercicioAfectacion int,
@PeriodoAfectacion   int,
@AcumulaSinDetalles	bit,
@AcumulaEnLinea	bit,
@GeneraAuxiliar	bit,
@GeneraSaldo	        bit,
@Conciliar		bit,
@Aplica		char(20),
@AplicaID		varchar(20),
@EsResultados	bit,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT,
@Renglon		float	= NULL,
@RenglonSub		int	= NULL,
@RenglonID		int	= NULL,
@SubCuenta2		varchar(50) = '',
@SubCuenta3		varchar(50) = '',
@Proyecto		varchar(50) = '',
@UEN			int = 0

AS BEGIN
DECLARE
@FechaSinHora	datetime,
@SubCuentaAcum	varchar(50),
@SubCuenta2Acum	varchar(50),
@SubCuenta3Acum	varchar(50),
@ImporteConciliar	money,
@Temp   	   	money,
@CargoAux		money,
@AbonoAux		money,
@EsCancelacion 	bit
SELECT @Cargo = ISNULL(@Cargo, 0.0),
@Abono = ISNULL(@Abono, 0.0)
IF @Accion IN ('CANCELAR', 'DESAFECTAR')
BEGIN
SELECT @EsCancelacion = 1, @Temp = @Cargo
SELECT @Cargo = -@Abono, @Abono = -@Temp
END ELSE SELECT @EsCancelacion = 0
IF @GeneraSaldo = 1 AND @Ok IS NULL
BEGIN
IF @AcumulaSinDetalles = 1 SELECT @SubCuentaAcum = '', @SubCuenta2Acum = '', @SubCuenta3Acum = '' ELSE SELECT @SubCuentaAcum = @SubCuenta, @SubCuenta2Acum = @SubCuenta2, @SubCuenta3Acum = @SubCuenta3
IF @Conciliar = 1
SELECT @ImporteConciliar = @Cargo - @Abono
ELSE SELECT @ImporteConciliar = 0.0
IF @EsResultados = 0
BEGIN
UPDATE Saldo WITH (ROWLOCK)
SET Saldo        = ISNULL(Saldo, 0.0) + @Cargo - @Abono,
PorConciliar = ISNULL(PorConciliar, 0.0) + @ImporteConciliar
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND SubCuenta = @SubCuentaAcum
AND SubCuenta2 = @SubCuenta2Acum AND SubCuenta3 = @SubCuenta3Acum AND Proyecto = @Proyecto AND UEN = @UEN
IF @@ROWCOUNT = 0
INSERT Saldo (Sucursal,  Empresa,  Rama,  Moneda,  Grupo,  Cuenta,  SubCuenta,      SubCuenta2,      SubCuenta3,      Proyecto,  UEN,  Saldo,            PorConciliar,      UltimoCambio)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @Grupo, @Cuenta, @SubCuentaAcum, @SubCuenta2Acum, @SubCuenta3Acum, @Proyecto, @UEN, (@Cargo-@Abono), @ImporteConciliar, @Fecha)
IF @@ERROR <> 0 SELECT @Ok = 1
END
ELSE BEGIN
UPDATE SaldoR WITH (ROWLOCK)
SET Saldo        = ISNULL(Saldo, 0.0) + @Cargo - @Abono,
PorConciliar = ISNULL(PorConciliar, 0.0) + @ImporteConciliar
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND SubCuenta = @SubCuentaAcum
IF @@ROWCOUNT = 0
INSERT SaldoR (Sucursal,  Empresa, Rama, Moneda, Grupo, Cuenta, SubCuenta, Saldo, PorConciliar, UltimoCambio)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @Grupo, @Cuenta, @SubCuentaAcum, (@Cargo-@Abono), @ImporteConciliar, @Fecha)
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
IF @GeneraAuxiliar = 1 AND @Ok IS NULL
BEGIN
IF @Accion = 'DESAFECTAR'
BEGIN
IF (SELECT Sucursal FROM Version) <> 0
SELECT @Ok = 60290
IF @EsResultados = 0
DELETE Auxiliar WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta
AND SubCuenta = @SubCuenta AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @EjercicioAfectacion AND Periodo = @PeriodoAfectacion
ELSE
DELETE AuxiliarR WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta
AND SubCuenta = @SubCuenta AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @EjercicioAfectacion AND Periodo = @PeriodoAfectacion
IF @@ROWCOUNT = 0 SELECT @Ok = 60100, @OkRef = 'Movimiento: '+RTRIM(@Mov) + ' ' +LTRIM(Convert(Char, @MovID))
END ELSE
BEGIN
SELECT @FechaSinHora = @Fecha,
@CargoAux = NULLIF(@Cargo, 0.0),
@AbonoAux = NULLIF(@Abono, 0.0)
EXEC spExtraerFecha @FechaSinHora OUTPUT
IF @EsResultados = 0
INSERT Auxiliar (Sucursal, Empresa, Rama, Moneda, TipoCambio, Cuenta, SubCuenta, Ejercicio, Periodo, Fecha,
Grupo, Modulo, ModuloID, Mov, MovID, Cargo, Abono, Aplica, AplicaID, Acumulado, Conciliado, EsCancelacion,
Renglon, RenglonSub)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @TipoCambio, @Cuenta, @SubCuenta, @EjercicioAfectacion, @PeriodoAfectacion, @FechaSinHora,
@Grupo, @Modulo, @ID, @Mov, @MovID, @CargoAux, @AbonoAux, @Aplica, @AplicaID, @AcumulaEnLinea, 0, @EsCancelacion,
@Renglon, @RenglonSub)
ELSE
INSERT AuxiliarR (Sucursal, Empresa, Rama, Moneda, TipoCambio, Cuenta, SubCuenta, Ejercicio, Periodo, Fecha,
Grupo, Modulo, ModuloID, Mov, MovID, Cargo, Abono, Aplica, AplicaID, Acumulado, Conciliado, EsCancelacion,
Renglon, RenglonSub)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @TipoCambio, @Cuenta, @SubCuenta, @EjercicioAfectacion, @PeriodoAfectacion, @FechaSinHora,
@Grupo, @Modulo, @ID, @Mov, @MovID, @CargoAux, @AbonoAux, @Aplica, @AplicaID, @AcumulaEnLinea, 0, @EsCancelacion,
@Renglon, @RenglonSub)
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
IF @AcumulaEnLinea = 1 AND @Ok IS NULL
BEGIN
IF @AcumulaSinDetalles = 1 SELECT @SubCuentaAcum = '' ELSE SELECT @SubCuentaAcum = @SubCuenta
IF @EsResultados = 0
BEGIN
UPDATE Acum WITH (ROWLOCK)
SET Cargos = ISNULL(Cargos, 0.0) + @Cargo,
Abonos = ISNULL(Abonos, 0.0) + @Abono,
UltimoCambio = @Fecha
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta
AND SubCuenta = @SubCuentaAcum AND Periodo = @PeriodoAfectacion AND Ejercicio = @EjercicioAfectacion
AND SubCuenta2 = @SubCuenta2Acum AND SubCuenta3 = @SubCuenta3Acum AND Proyecto = @Proyecto AND UEN = @UEN
IF @@ROWCOUNT = 0
INSERT Acum (Sucursal,  Empresa,  Rama,  Moneda,  Cuenta,  SubCuenta,      SubCuenta2,      SubCuenta3,      Proyecto,  UEN,  Grupo,  Ejercicio,            Periodo,            Cargos,  Abonos, UltimoCambio)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @Cuenta, @SubCuentaAcum, @SubCuenta2Acum, @SubCuenta3Acum, @Proyecto, @UEN, @Grupo, @EjercicioAfectacion, @PeriodoAfectacion, @Cargo,  @Abono, @Fecha)
IF @@ERROR <> 0 SELECT @Ok = 1
END ELSE
BEGIN
UPDATE AcumR WITH (ROWLOCK)
SET Cargos = ISNULL(Cargos, 0.0) + @Cargo,
Abonos = ISNULL(Abonos, 0.0) + @Abono,
UltimoCambio = @Fecha
WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta
AND SubCuenta = @SubCuentaAcum AND Periodo = @PeriodoAfectacion AND Ejercicio = @EjercicioAfectacion
IF @@ROWCOUNT = 0
INSERT AcumR (Sucursal,  Empresa,  Rama,  Moneda,  Cuenta,  SubCuenta,      Grupo,  Ejercicio,            Periodo,            Cargos,  Abonos, UltimoCambio)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @Cuenta, @SubCuentaAcum, @Grupo, @EjercicioAfectacion, @PeriodoAfectacion, @Cargo,  @Abono, @Fecha)
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
IF @Ok IS NULL
EXEC xpSaldoM @Sucursal, @Accion, @Empresa, @Rama, @Moneda, @TipoCambio, @Cuenta, @SubCuenta, @Grupo,
@Modulo, @ID, @Mov, @MovID, @Cargo, @Abono, @Fecha, @EjercicioAfectacion, @PeriodoAfectacion,
@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Aplica, @AplicaID, @EsResultados,
@Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID
RETURN
END

