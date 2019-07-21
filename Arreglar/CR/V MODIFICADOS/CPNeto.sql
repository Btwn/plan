SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CPNeto

AS
SELECT e.Empresa,
e.Proyecto,
d.ClavePresupuestal,
'Presupuesto' = CONVERT(money,ISNULL(SUM(d.Presupuesto*e.TipoCambio), 0.0)),
'Comprometido' = CONVERT(money,ISNULL(SUM(d.Comprometido*e.TipoCambio), 0.0)),
'Comprometido2' = CONVERT(money,ISNULL(SUM(d.Comprometido2*e.TipoCambio), 0.0)),
'Devengado' = CONVERT(money,ISNULL(SUM(d.Devengado*e.TipoCambio), 0.0)),
'Devengado2' = CONVERT(money,ISNULL(SUM(d.Devengado2*e.TipoCambio), 0.0)),
'Ejercido' = CONVERT(money,ISNULL(SUM(d.Ejercido*e.TipoCambio), 0.0)),
'EjercidoPagado' = CONVERT(money,ISNULL(SUM(d.EjercidoPagado), 0.0)),
'RemanenteDisponible' = CONVERT(money,ISNULL(SUM(d.RemanenteDisponible*e.TipoCambio), 0.0)),
'Anticipos' = CONVERT(money,ISNULL(SUM(d.Anticipos*e.TipoCambio), 0.0)),
'Sobrante' = CONVERT(money,ISNULL(SUM(d.Sobrante*e.TipoCambio), 0.0)),
'Disponible' = CONVERT(money,ISNULL(SUM(d.Disponible), 0.0))
FROM CPD d WITH (NOLOCK)
JOIN CP e WITH (NOLOCK) ON e.ID = d.ID AND e.Estatus = 'CONCLUIDO'
JOIN MovTipo mt WITH (NOLOCK) ON mt.Modulo = 'CP' AND mt.Mov = e.Mov AND mt.Clave IN ('CP.AS', 'CP.TA', 'CP.TR', 'CP.OP')
GROUP BY e.Empresa, e.Proyecto, d.ClavePresupuestal

