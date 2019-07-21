SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW InvSolicitudPendienteD

AS
SELECT
Inv.ID,
InvD.Renglon,
InvD.RenglonSub,
Inv.Empresa,
Inv.Mov,
Inv.MovID,
Inv.Moneda,
Inv.FechaEmision,
"FechaRequerida" = ISNULL(InvD.FechaRequerida, Inv.FechaRequerida),
Inv.Referencia,
Inv.Estatus,
Inv.AlmacenDestino,
InvD.Almacen,
InvD.Articulo,
InvD.SubCuenta,
"Cantidad" = InvD.Cantidad-ISNULL(InvD.CantidadCancelada, 0.0),
InvD.CantidadReservada,
InvD.CantidadOrdenada,
InvD.CantidadPendiente,
InvD.Unidad,
InvD.Factor,
InvD.CantidadInventario,
InvD.Paquete,
"CantidadFactor"  = (InvD.Cantidad-ISNULL(InvD.CantidadCancelada, 0.0))*InvD.Factor,
"ReservadaFactor" = InvD.CantidadReservada*InvD.Factor,
"OrdenadaFactor"  = InvD.CantidadOrdenada*InvD.Factor,
"PendienteFactor" = InvD.CantidadPendiente*InvD.Factor,
Art.Descripcion1 ArtDescripcion,
Art.SeProduce ArtSeProduce,
Art.SeCompra ArtSeCompra,
Inv.Proyecto,
Inv.UEN
FROM Inv
JOIN InvD ON Inv.ID = InvD.ID
JOIN Art ON InvD.Articulo = Art.Articulo
JOIN MovTipo mt ON Inv.Mov = mt.Mov AND mt.Modulo = 'INV'
WHERE
Inv.Estatus = 'PENDIENTE' AND (InvD.CantidadReservada > 0.0 OR InvD.CantidadOrdenada > 0.0 OR InvD.CantidadPendiente > 0.0) AND
mt.Clave IN ('INV.SOL', 'INV.OT', 'INV.OI', 'INV.SM')

