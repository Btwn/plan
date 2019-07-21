SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CPArtComprometido

AS
SELECT t.Empresa,
t.Proyecto,
t.ClavePresupuestal,
t.Articulo,
'CantidadComprometida' = SUM(t.CantidadNeta),
'ImporteComprometido' = SUM(t.ImporteTotal)
FROM CompraTCalc t WITH (NOLOCK)
JOIN MovTipo mt WITH (NOLOCK) ON mt.Modulo = 'COMS' AND mt.Mov = t.Mov AND mt.AfectarCP = 'Comprometido'
WHERE t.Estatus IN ('PENDIENTE', 'CONCLUIDO')
GROUP BY t.Empresa, t.Proyecto, t.ClavePresupuestal, t.Articulo

