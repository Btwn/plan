SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.vwPNETSaldoVacaciones
AS
SELECT A.Sucursal, A.Empresa, A.Rama, A.Ejercicio, A.Periodo, A.Moneda, A.Cuenta, A.Cargos, A.Abonos, A.CargosU, A.AbonosU, A.UltimoCambio, P.FechaAlta,
P.FechaAntiguedad, P.Personal, CONVERT(VARCHAR(10), A.UltimoCambio, 105) AS UltimoCambioString, CONVERT(VARCHAR(10), P.FechaAlta, 105) AS FechaAltaString,
CONVERT(VARCHAR(10), P.FechaAntiguedad, 105) AS FechaAntiguedadString
FROM dbo.AcumU AS A INNER JOIN
dbo.Personal AS P ON A.Cuenta = P.Personal
WHERE (A.Rama = 'VAC')

