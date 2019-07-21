SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CPEjercicioPeriodoNeto

AS
SELECT e.Empresa,
e.Proyecto,
e.Ejercicio,
e.Periodo,
d.ClavePresupuestal,
'Presupuesto' = ISNULL(SUM(d.Presupuesto*e.TipoCambio), 0.0),
'Comprometido' = ISNULL(SUM(d.Comprometido*e.TipoCambio), 0.0),
'Comprometido2' = ISNULL(SUM(d.Comprometido2*e.TipoCambio), 0.0),
'Devengado' = ISNULL(SUM(d.Devengado*e.TipoCambio), 0.0),
'Devengado2' = ISNULL(SUM(d.Devengado2*e.TipoCambio), 0.0),
'Ejercido' = ISNULL(SUM(d.Ejercido*e.TipoCambio), 0.0),
'EjercidoPagado' = ISNULL(SUM(d.EjercidoPagado*e.TipoCambio), 0.0),
'RemanenteDisponible' = ISNULL(SUM(d.RemanenteDisponible*e.TipoCambio), 0.0),
'Anticipos' = ISNULL(SUM(d.Anticipos*e.TipoCambio), 0.0),
'Sobrante' = ISNULL(SUM(d.Sobrante*e.TipoCambio), 0.0),
'Disponible' = ISNULL(SUM(d.Disponible*e.TipoCambio), 0.0)
FROM CPD d
JOIN CP e ON e.ID = d.ID AND e.Estatus = 'CONCLUIDO'
JOIN MovTipo mt ON mt.Modulo = 'CP' AND mt.Mov = e.Mov AND mt.Clave IN ('CP.AS', 'CP.TA', 'CP.TR', 'CP.OP')
GROUP BY e.Empresa, e.Proyecto, e.Ejercicio, e.Periodo, d.ClavePresupuestal

