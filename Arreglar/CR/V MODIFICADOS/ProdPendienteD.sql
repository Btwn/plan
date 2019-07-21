SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ProdPendienteD

AS
SELECT
Prod.ID,
ProdD.Renglon,
ProdD.RenglonSub,
Prod.Empresa,
Prod.Mov,
Prod.MovID,
Prod.Moneda,
Prod.FechaEmision,
ProdD.FechaRequerida,
Prod.FechaEntrega,
Prod.Referencia,
Prod.Estatus,
Prod.Proyecto,
Prod.UEN,
ProdD.Ruta,
ProdD.Centro,
ProdD.Almacen,
ProdD.Articulo,
ProdD.SubCuenta,
"Cantidad" = ProdD.Cantidad-ISNULL(ProdD.CantidadCancelada, 0.0),
ProdD.CantidadReservada,
ProdD.CantidadOrdenada,
ProdD.CantidadPendiente,
ProdD.Unidad,
ProdD.Factor,
ProdD.CantidadInventario,
ProdD.Paquete,
"CantidadFactor"  = (ProdD.Cantidad-ISNULL(ProdD.CantidadCancelada, 0.0))*ProdD.Factor,
"ReservadaFactor" = ProdD.CantidadReservada*ProdD.Factor,
"OrdenadaFactor"  = ProdD.CantidadOrdenada*ProdD.Factor,
"PendienteFactor" = ProdD.CantidadPendiente*ProdD.Factor,
Art.Descripcion1 ArtDescripcion,
Art.SeProduce ArtSeProduce,
Art.SeCompra ArtSeCompra,
"MovTipo" = mt.Clave,
"Semana" = DATEDIFF(week, GETDATE(), ProdD.FechaEntrega),
ProdD.DestinoTipo,
ProdD.Destino,
ProdD.DestinoID
FROM Prod WITH(NOLOCK)
JOIN ProdD WITH(NOLOCK) ON Prod.ID = ProdD.ID
JOIN Art WITH(NOLOCK) ON ProdD.Articulo = Art.Articulo
JOIN MovTipo mt WITH(NOLOCK) ON Prod.Mov = mt.Mov
WHERE
Prod.Estatus = 'PENDIENTE' AND (ProdD.CantidadReservada > 0.0 OR ProdD.CantidadOrdenada > 0.0 OR ProdD.CantidadPendiente > 0.0) AND
mt.Modulo = 'PROD'

