SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CPArtNetoDisponible

AS
SELECT n.Empresa,
n.Proyecto,
n.ClavePresupuestal,
n.Articulo,
n.Cantidad,
n.Importe,
c.CantidadComprometida,
c.ImporteComprometido,
'CantidadDisponible' = n.Cantidad-ISNULL(c.CantidadComprometida, 0.0),
'ImporteDisponible' = n.Importe-ISNULL(c.ImporteComprometido, 0.0)
FROM CPArtNeto n WITH (NOLOCK)
LEFT OUTER JOIN CPArtComprometido c WITH (NOLOCK) ON c.Empresa = n.Empresa AND c.Proyecto = n.Proyecto AND c.ClavePresupuestal = n.ClavePresupuestal AND c.Articulo = n.Articulo

