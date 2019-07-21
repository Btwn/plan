SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CPArtNeto

AS
SELECT e.Empresa,
e.Proyecto,
d.ClavePresupuestal,
cpa.Articulo,
'Cantidad' = SUM(cpa.Cantidad*CASE WHEN UPPER(d.Tipo) = 'REDUCCION' THEN -1.0 ELSE 1.0 END),
'Importe' = CONVERT(money, SUM(cpa.Cantidad*cpa.Precio*CASE WHEN UPPER(d.Tipo) = 'REDUCCION' THEN -1.0 ELSE 1.0 END))
FROM CPD d
JOIN CP e ON e.ID = d.ID AND e.Estatus = 'CONCLUIDO'
JOIN CPArt cpa ON cpa.ID = e.ID AND cpa.ClavePresupuestal = d.ClavePresupuestal AND cpa.Tipo = d.Tipo
JOIN MovTipo mt ON mt.Modulo = 'CP' AND mt.Mov = e.Mov AND mt.Clave IN ('CP.AS', 'CP.TA', 'CP.TR')
GROUP BY e.Empresa, e.Proyecto, d.ClavePresupuestal, cpa.Articulo

