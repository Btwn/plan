SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMFACuentasContablesSaldo
@Empresa						varchar(5),
@Ejercicio					int,
@Periodo						int,
@Moneda						varchar(10)

AS BEGIN
DECLARE
@ContMoneda				varchar(10)
TRUNCATE TABLE layout_cuentas
SELECT @ContMoneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
INSERT layout_cuentas (empresa,  cuenta_contable, cuenta_control, descripcion, nivel, clase_cuenta, tipo_cuenta, ejercicio, saldo_inicial,                                                                           moneda, saldo_inicial_cargos,                                                                         saldo_inicial_abonos)
SELECT @empresa, cuenta_contable, cuenta_control, descripcion, nivel, clase_cuenta, tipo_cuenta, @ejercicio, dbo.fnMFACuentaSaldoInicial(@Empresa,@Ejercicio,@Periodo,cuenta_contable, @Moneda, ''), @Moneda, dbo.fnMFACuentaSaldoInicial(@Empresa,@Ejercicio,@Periodo,cuenta_contable, @Moneda, 'Cargos'), dbo.fnMFACuentaSaldoInicial(@Empresa,@Ejercicio,@Periodo,cuenta_contable, @Moneda, 'Abonos')
FROM MFACuentasContablesSaldo
END

