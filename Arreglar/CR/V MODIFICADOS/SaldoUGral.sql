SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW SaldoUGral

AS
SELECT Sucursal, Empresa, Rama, Moneda, Grupo,
Cuenta, SubCuenta, Saldo, SaldoU, PorConciliar,
PorConciliarU, UltimoCambio, SubGrupo
FROM SaldoU WITH(NOLOCK)
UNION ALL
SELECT Sucursal, Empresa, Rama, Moneda, Grupo,
Cuenta, SubCuenta, Saldo, SaldoU, PorConciliar,
PorConciliarU, UltimoCambio, SubGrupo
FROM SaldoUWMS WITH(NOLOCK)

