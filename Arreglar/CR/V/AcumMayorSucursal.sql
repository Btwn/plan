SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW AcumMayorSucursal

AS
SELECT
a.Empresa,
a.Sucursal,
r.Mayor,
a.Cuenta,
a.SubCuenta,
a.Grupo,
a.Ejercicio,
a.Periodo,
a.Moneda,
"Cargos" = CONVERT(money, SUM(a.Cargos*r.Factor)),
"Abonos" = CONVERT(money, SUM(a.Abonos*r.Factor))
FROM Acum a
JOIN Rama r ON a.Rama = r.Rama
GROUP BY a.Empresa, a.Sucursal, r.Mayor, a.Cuenta, a.SubCuenta, a.Grupo, a.Ejercicio, a.Periodo, a.Moneda

