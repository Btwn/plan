SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CPGasto
AS
SELECT d.ID, d.ClavePresupuestal, Importe = SUM(d.ImporteLinea)
FROM GastoT d WITH (NOLOCK)
JOIN Concepto c WITH (NOLOCK) ON c.Modulo = 'GAS' AND c.Concepto = d.Concepto AND NULLIF(RTRIM(c.ClavePresupuestalImpuesto1), '') IS NOT NULL
GROUP BY d.ID, d.ClavePresupuestal
UNION ALL
SELECT d.ID, ClavePresupuestal = c.ClavePresupuestalImpuesto1, Importe = SUM(d.ImpuestosLinea)
FROM GastoT d WITH (NOLOCK)
JOIN Concepto c WITH (NOLOCK) ON c.Modulo = 'GAS' AND c.Concepto = d.Concepto AND NULLIF(RTRIM(c.ClavePresupuestalImpuesto1), '') IS NOT NULL
GROUP BY d.ID, c.ClavePresupuestalImpuesto1
UNION ALL
SELECT d.ID, d.ClavePresupuestal, Importe = SUM(d.TotalLinea+ISNULL(d.RetencionLinea, 0))
FROM GastoT d WITH (NOLOCK)
JOIN Concepto c WITH (NOLOCK) ON c.Modulo = 'GAS' AND c.Concepto = d.Concepto AND NULLIF(RTRIM(c.ClavePresupuestalImpuesto1), '') IS NULL
GROUP BY d.ID, d.ClavePresupuestal

