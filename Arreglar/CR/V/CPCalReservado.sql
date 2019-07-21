SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CPCalReservado

AS
SELECT e.Empresa,
e.Proyecto,
d.ClavePresupuestal,
cal.Ejercicio,
cal.Periodo,
'Presupuesto' = ISNULL(CONVERT(money, SUM((cal.Importe*e.TipoCambio)*CASE WHEN UPPER(d.Tipo) = 'REDUCCION' THEN -1.0 ELSE 1.0 END)), 0.0)
FROM CPD d
JOIN CP e ON e.ID = d.ID AND e.Estatus = 'CONCLUIDO'
JOIN CPCal cal ON cal.ID = e.ID AND cal.ClavePresupuestal = d.ClavePresupuestal AND cal.Tipo = d.Tipo
JOIN MovTipo mt ON mt.Modulo = 'CP' AND mt.Mov = e.Mov AND mt.Clave = 'CP.RF'
GROUP BY e.Empresa, e.Proyecto, d.ClavePresupuestal, cal.Ejercicio, cal.Periodo

