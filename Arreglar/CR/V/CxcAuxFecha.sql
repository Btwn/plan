SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CxcAuxFecha

AS
SELECT a.Empresa, m.Moneda, a.Ejercicio, a.Periodo, a.Fecha, "Cargos" = SUM(a.Cargo), "Abonos" = SUM(a.Abono)
FROM Auxiliar a
LEFT OUTER JOIN Mon m ON m.Moneda = a.Moneda
WHERE a.Rama IN ('CXC', 'CEFE', 'CNO', 'CVALE')
GROUP BY a.Empresa, m.Moneda, a.Ejercicio, a.Periodo, a.Fecha

