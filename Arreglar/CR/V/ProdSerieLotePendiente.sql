SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ProdSerieLotePendiente

AS
SELECT
e.ID,
e.Empresa,
e.Mov,
e.MovID,
d.ProdSerieLote,
d.Articulo,
d.SubCuenta,
d.Ruta,
d.Orden,
d.Centro,
d.Unidad,
"Factor" = AVG(d.Factor),
"CantidadPendiente" = SUM(d.CantidadPendiente)
FROM Prod e
JOIN ProdD d ON e.ID = d.ID
JOIN MovTipo mt ON e.Mov = mt.Mov AND mt.Modulo = 'PROD'
WHERE
mt.Clave = 'PROD.O' AND e.Estatus = 'PENDIENTE'
GROUP BY
e.ID, e.Empresa, e.Mov, e.MovID, d.ProdSerieLote, d.Articulo, d.SubCuenta, d.Ruta, d.Orden, d.Centro, d.Unidad

