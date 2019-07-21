SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW PendienteSurtirD

AS
SELECT
mt.Modulo,
Venta.ID,
Venta.Empresa,
Venta.Mov,
Venta.MovID,
Venta.Moneda,
Venta.FechaEmision,
Venta.Referencia,
Venta.Estatus,
VentaD.Almacen,
VentaD.Articulo,
VentaD.SubCuenta,
"CantidadNeta" = (VentaD.Cantidad-ISNULL(VentaD.CantidadCancelada, 0)),
VentaD.CantidadReservada,
VentaD.CantidadOrdenada,
VentaD.CantidadPendiente,
VentaD.Unidad,
VentaD.Factor,
VentaD.FechaRequerida
FROM Venta
JOIN VentaD ON Venta.ID = VentaD.ID
JOIN MovTipo mt ON Venta.Mov = mt.Mov AND mt.Modulo = 'VTAS'
WHERE
Venta.Estatus = 'PENDIENTE' AND (VentaD.CantidadReservada > 0.0 OR VentaD.CantidadOrdenada > 0.0 OR VentaD.CantidadPendiente > 0.0) AND
mt.Clave = 'VTAS.P'
UNION
SELECT
mt.Modulo,
Inv.ID,
Inv.Empresa,
Inv.Mov,
Inv.MovID,
Inv.Moneda,
Inv.FechaEmision,
Inv.Referencia,
Inv.Estatus,
InvD.Almacen,
InvD.Articulo,
InvD.SubCuenta,
"CantidadNeta" = (InvD.Cantidad-ISNULL(InvD.CantidadCancelada, 0)),
InvD.CantidadReservada,
InvD.CantidadOrdenada,
InvD.CantidadPendiente,
InvD.Unidad,
InvD.Factor,
"FechaRequerida" = convert(datetime, NULL)
FROM Inv
JOIN InvD ON Inv.ID = InvD.ID
JOIN MovTipo mt ON Inv.Mov = mt.Mov AND mt.Modulo = 'INV'
WHERE
Inv.Estatus = 'PENDIENTE' AND (InvD.CantidadReservada > 0.0 OR InvD.CantidadOrdenada > 0.0 OR InvD.CantidadPendiente > 0.0) AND
mt.Clave IN ('INV.SOL', 'INV.OT', 'INV.OI', 'INV.SM')

