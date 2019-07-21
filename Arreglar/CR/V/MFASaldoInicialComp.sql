SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFASaldoInicialComp AS
SELECT c.Cuenta,
layout_cuentas.cuenta_contable,
layout_cuentas.Moneda,
saldo_inicial_cargos,
saldo_inicial_abonos
FROM Cta c
JOIN MFACuentaComplementaria ON c.Cuenta = MFACuentaComplementaria.Cuenta
JOIN layout_cuentas ON c.Cuenta = layout_cuentas.cuenta_control
WHERE UPPER(c.Tipo) IN ('MAYOR','SUBCUENTA','AUXILIAR')
AND layout_cuentas.EsComplementaria = 1

