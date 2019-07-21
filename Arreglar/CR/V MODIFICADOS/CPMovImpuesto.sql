SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CPMovImpuesto
AS
SELECT Modulo, ModuloID, ClavePresupuestal, Importe = SUM(SubTotal)
FROM MovImpuesto WITH (NOLOCK)
WHERE NULLIF(RTRIM(ClavePresupuestalImpuesto1), '') IS NOT NULL
GROUP BY Modulo, ModuloID, ClavePresupuestal
UNION ALL
SELECT Modulo, ModuloID, ClavePresupuestal = ClavePresupuestalImpuesto1, Importe = SUM(Importe1)
FROM MovImpuesto WITH (NOLOCK)
WHERE NULLIF(RTRIM(ClavePresupuestalImpuesto1), '') IS NOT NULL
GROUP BY Modulo, ModuloID, ClavePresupuestalImpuesto1
UNION ALL
SELECT Modulo, ModuloID, ClavePresupuestal, Importe = SUM(ISNULL(SubTotal, 0.0)+ISNULL(Importe1, 0.0))
FROM MovImpuesto WITH (NOLOCK)
WHERE NULLIF(RTRIM(ClavePresupuestalImpuesto1), '') IS NULL
GROUP BY Modulo, ModuloID, ClavePresupuestal

