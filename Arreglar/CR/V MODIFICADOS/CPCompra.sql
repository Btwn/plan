SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CPCompra
AS
SELECT d.ID, d.ClavePresupuestal, Importe = SUM(d.SubTotal)
FROM CompraTCalc d WITH (NOLOCK)
JOIN Art a WITH (NOLOCK) ON a.Articulo = d.Articulo AND NULLIF(RTRIM(a.ClavePresupuestalImpuesto1), '') IS NOT NULL
GROUP BY d.ID, d.ClavePresupuestal
UNION ALL
SELECT d.ID, ClavePresupuestal = a.ClavePresupuestalImpuesto1, Importe = SUM(d.Impuesto1Total)
FROM CompraTCalc d WITH (NOLOCK)
JOIN Art a WITH (NOLOCK) ON a.Articulo = d.Articulo AND NULLIF(RTRIM(a.ClavePresupuestalImpuesto1), '') IS NOT NULL
GROUP BY d.ID, a.ClavePresupuestalImpuesto1
UNION ALL
SELECT d.ID, d.ClavePresupuestal, Importe = SUM(d.ImporteTotal)
FROM CompraTCalc d WITH (NOLOCK)
JOIN Art a WITH (NOLOCK) ON a.Articulo = d.Articulo AND NULLIF(RTRIM(a.ClavePresupuestalImpuesto1), '') IS NULL
GROUP BY d.ID, d.ClavePresupuestal

