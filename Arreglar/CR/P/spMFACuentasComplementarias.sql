SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMFACuentasComplementarias
@Usuario				varchar(20),
@Empresa				varchar(5),
@Ejercicio			int,
@Periodo				int

AS BEGIN
DECLARE @Cuenta			varchar(20),
@CuentaAnt		varchar(20),
@Cuenta2			varchar(50),
@Cuenta3			varchar(50),
@CuentaComp		varchar(50),
@ContMoneda		varchar(10),
@Moneda			varchar(10),
@EjercicioAnt		int,
@EjercicioResp	int,
@Cargos			float,
@Abonos			float,
@Cargos2			float,
@Abonos2			float,
@Cargos3			float,
@Abonos3			float,
@SI2				float,
@SI3				float,
@SIC2				float,
@SIC3				float,
@SID2				float,
@SID3				float
SELECT @EjercicioResp = @Ejercicio
SELECT @ContMoneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @CuentaAnt = ''
WHILE(1=1)
BEGIN
SELECT @Cuenta = MIN(Cuenta)
FROM MFACuentaComplementaria
WHERE Cuenta > @CuentaAnt
AND Empresa = @Empresa
IF @Cuenta IS NULL BREAK
SELECT @CuentaAnt = @Cuenta, @Moneda = NULL
SELECT @Cuenta2 = @Cuenta + '-001', @CuentaComp = @Cuenta + '-002', @Cuenta3 = @Cuenta + '-003'
SELECT @Moneda = Moneda FROM MFACuentaComplementaria WHERE Cuenta = @Cuenta
EXEC spMFAContAcum @Cuenta = @Cuenta
END
SELECT @EjercicioAnt = MIN(Ejercicio) - 2 FROM Acum
WHILE(1=1)
BEGIN
SELECT @Ejercicio = MIN(Ejercicio)
FROM Acum
WHERE Ejercicio > @EjercicioAnt
IF @Ejercicio IS NULL BREAK
SELECT @EjercicioAnt = @Ejercicio
SELECT @Ejercicio = @Ejercicio + 1
EXEC spMFAContTraspasarSaldos @Empresa, @Ejercicio
END
SELECT @Ejercicio = @EjercicioResp
SELECT @CuentaAnt = ''
WHILE(1=1)
BEGIN
SELECT @Cuenta = MIN(Cuenta)
FROM MFACuentaComplementaria
WHERE Cuenta > @CuentaAnt
AND Empresa = @Empresa
IF @Cuenta IS NULL BREAK
SELECT @CuentaAnt = @Cuenta, @Moneda = NULL
SELECT @Cuenta2 = @Cuenta + '-001', @CuentaComp = @Cuenta + '-002', @Cuenta3 = @Cuenta + '-003'
SELECT @Moneda = Moneda FROM MFACuentaComplementaria WHERE Cuenta = @Cuenta
DELETE layout_polizas WHERE cuenta_contable IN(@Cuenta2, @CuentaComp, @Cuenta3) AND Empresa = @Empresa
DELETE layout_cuentas WHERE cuenta_contable IN(@Cuenta2, @CuentaComp, @Cuenta3) AND Empresa = @Empresa
SELECT @Cargos = 0, @Abonos = 0
SELECT @Cargos = SUM(Cargos1), @Abonos = SUM(Abonos1)
FROM MFAPolizaComp
WHERE ejercicio = @ejercicio
AND periodo   = @periodo
AND cuenta_contable = @Cuenta
AND empresa = @Empresa
SELECT @Cargos2 = 0, @Abonos2 = 0
SELECT @Cargos2 = SUM(Cargos), @Abonos2 = SUM(Abonos)
FROM MFAPolizaComp
WHERE ejercicio = @ejercicio
AND periodo   = @periodo
AND cuenta_contable = @Cuenta
AND OrigenMoneda = @Moneda
AND empresa = @Empresa
INSERT layout_polizas (
empresa,  ejercicio,  periodo,  cuenta_contable, cargos,              abonos,              EsComplementaria)
SELECT @empresa, @ejercicio, @periodo, @Cuenta2,         ISNULL(@cargos2, 0), ISNULL(@abonos2, 0), 1
SELECT @Cargos3 = 0, @Abonos3 = 0
SELECT @Cargos3 = SUM(Cargos), @Abonos3 = SUM(Abonos)
FROM MFAPolizaComp
WHERE ejercicio = @ejercicio
AND periodo   = @periodo
AND cuenta_contable = @Cuenta
AND OrigenMoneda = @ContMoneda
AND empresa = @Empresa
INSERT layout_polizas (
empresa,  ejercicio,  periodo,  cuenta_contable, cargos,              abonos,              EsComplementaria)
SELECT @empresa, @ejercicio, @periodo, @Cuenta3,         ISNULL(@cargos3, 0), ISNULL(@Abonos3, 0), 1
SELECT @SI2  = dbo.fnMFACuentaSaldoInicialComp(@Empresa,@Ejercicio,@Periodo,@Cuenta, @Moneda, ''),
@SI3  = dbo.fnMFACuentaSaldoInicialComp(@Empresa,@Ejercicio,@Periodo,@Cuenta, @ContMoneda, ''),
@SIC2 = dbo.fnMFACuentaSaldoInicialComp(@Empresa,@Ejercicio,@Periodo,@Cuenta, @Moneda, 'Cargos'),
@SID2 = dbo.fnMFACuentaSaldoInicialComp(@Empresa,@Ejercicio,@Periodo,@Cuenta, @Moneda, 'Abonos'),
@SIC3 = dbo.fnMFACuentaSaldoInicialComp(@Empresa,@Ejercicio,@Periodo,@Cuenta, @ContMoneda, 'Cargos'),
@SID3 = dbo.fnMFACuentaSaldoInicialComp(@Empresa,@Ejercicio,@Periodo,@Cuenta, @ContMoneda, 'Abonos')
INSERT layout_cuentas (
empresa,  cuenta_contable,  cuenta_control, descripcion, nivel, clase_cuenta, tipo_cuenta, ejercicio,  saldo_inicial,  moneda, EsComplementaria,  saldo_inicial_cargos,  saldo_inicial_abonos)
SELECT @empresa, @Cuenta2,         @Cuenta,         descripcion, 4,     clase_cuenta, tipo_cuenta, @ejercicio, @SI2,          @Moneda, 1,                @SIC2,                 @SID2
FROM layout_cuentas a
WHERE cuenta_contable = @Cuenta
AND empresa = @Empresa
INSERT layout_cuentas (
empresa,  cuenta_contable,  cuenta_control, descripcion, nivel, clase_cuenta, tipo_cuenta, ejercicio,  saldo_inicial,  moneda,     EsComplementaria,  saldo_inicial_cargos,  saldo_inicial_abonos)
SELECT @empresa, @Cuenta3,         @Cuenta,         descripcion, 4,     clase_cuenta, tipo_cuenta, @ejercicio, @SI3,          @ContMoneda, 1,                @SIC3,                 @SID3
FROM layout_cuentas a
WHERE cuenta_contable = @Cuenta
AND empresa = @Empresa
INSERT layout_polizas (
empresa,   ejercicio,   periodo,  cuenta_contable, cargos,                                                         abonos,                                                           fecha, EsComplementaria)
SELECT a.empresa, a.ejercicio, a.periodo, @CuentaComp,      ISNULL(@Cargos, 0) - ISNULL(@Cargos2, 0) - ISNULL(@Cargos3, 0), ISNULL(@Abonos, 0) - ISNULL(@Abonos2, 0) - ISNULL(@Abonos3, 0), a.fecha, 1
FROM layout_polizas a
WHERE a.ejercicio = @ejercicio
AND a.periodo   = @periodo
AND a.cuenta_contable = @Cuenta
AND a.empresa = @Empresa
INSERT layout_cuentas(
empresa,  cuenta_contable,  cuenta_control,   descripcion, nivel,   clase_cuenta,   tipo_cuenta,  ejercicio, saldo_inicial,                                                   moneda,     EsComplementaria,  saldo_inicial_cargos,                                                    saldo_inicial_abonos)
SELECT @empresa, @CuentaComp,      @Cuenta,         a.descripcion, 4,     a.clase_cuenta, a.tipo_cuenta, @ejercicio, ISNULL(a.saldo_inicial, 0) - ISNULL(@SI2, 0) - ISNULL(@SI3, 0), @ContMoneda, 1,                 ISNULL(a.saldo_inicial_cargos, 0) - ISNULL(@SIC2, 0) - ISNULL(@SIC3, 0), ISNULL(a.saldo_inicial_abonos, 0) - ISNULL(@SID2, 0) - ISNULL(@SID3, 0)
FROM layout_cuentas a
WHERE a.ejercicio = @ejercicio
AND a.cuenta_contable = @Cuenta
AND a.empresa = @Empresa
UPDATE layout_cuentas SET clase_cuenta = 'control' WHERE cuenta_contable = @cuenta AND empresa = @Empresa
END
RETURN
END

