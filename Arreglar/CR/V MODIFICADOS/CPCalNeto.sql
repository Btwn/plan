SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CPCalNeto

AS
SELECT e.Empresa,
e.Proyecto,
d.ClavePresupuestal,
cal.Ejercicio,
cal.Periodo,
'Presupuesto' = ISNULL(CONVERT(money, SUM((cal.Importe*e.TipoCambio)*CASE WHEN UPPER(d.Tipo) = 'REDUCCION' THEN -1.0 ELSE 1.0 END)), 0.0)/*,
'EjercidoAcumulado' = (SELECT ISNULL(SUM(n.Ejercido), 0.0)+ISNULL(SUM(n.EjercidoPagado), 0.0) FROM CPEjercicioPeriodoNeto n WITH (NOLOCK) WHERE n.Empresa = e.Empresa AND n.Proyecto = e.Proyecto AND n.ClavePresupuestal = d.ClavePresupuestal AND (dbo.fnEjercicioPeriodoEnValor(cal.Ejercicio, cal.Periodo) <= dbo.fnEjercicioPeriodoEnValor(n.Ejercicio, n.Periodo)))*/
FROM CPD d WITH (NOLOCK)
JOIN CP e WITH (NOLOCK) ON e.ID = d.ID AND e.Estatus = 'CONCLUIDO'
JOIN CPCal cal WITH (NOLOCK) ON cal.ID = e.ID AND cal.ClavePresupuestal = d.ClavePresupuestal AND cal.Tipo = d.Tipo
JOIN MovTipo mt WITH (NOLOCK) ON mt.Modulo = 'CP' AND mt.Mov = e.Mov AND mt.Clave IN ('CP.AS', 'CP.TA', 'CP.TR')
GROUP BY e.Empresa, e.Proyecto, d.ClavePresupuestal, cal.Ejercicio, cal.Periodo

