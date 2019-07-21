SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.WMSTarimasSurtidoPendientes
AS
SELECT
'VTAS' AS Modulo,
Venta.ID,
Venta.Empresa,
Venta.Sucursal,
Venta.Mov,
Venta.MovID,
Venta.FechaEmision,
Venta.Estatus,
VentaD.Renglon,
VentaD.RenglonID,
VentaD.RenglonSub,
VentaD.RenglonTipo,
VentaD.Articulo,
VentaD.SubCuenta,
VentaD.Cantidad,
VentaD.CantidadCancelada,
VentaD.CantidadPendiente,
VentaD.Tarima
FROM Venta
JOIN VentaD ON Venta.ID=VentaD.ID
JOIN Alm ON VentaD.Almacen=Alm.Almacen
JOIN Art ON VentaD.Articulo=Art.Articulo
JOIN Tarima ON VentaD.Tarima=Tarima.Tarima
JOIN AlmPos ON Tarima.Posicion=AlmPos.Posicion AND AlmPos.Almacen=Alm.Almacen
WHERE
Alm.WMS=1
AND Venta.Estatus='PENDIENTE'
AND VentaD.Tarima IS NOT NULL
AND AlmPos.Tipo='Surtido'
UNION ALL
SELECT
'INV' AS Modulo,
Inv.ID,
Inv.Empresa,
Inv.Sucursal,
Inv.Mov,
Inv.MovID,
Inv.FechaEmision,
Inv.Estatus,
InvD.Renglon,
InvD.RenglonID,
InvD.RenglonSub,
InvD.RenglonTipo,
InvD.Articulo,
InvD.SubCuenta,
InvD.Cantidad,
InvD.CantidadCancelada,
InvD.CantidadPendiente,
InvD.Tarima
FROM Inv
JOIN InvD ON Inv.ID=InvD.ID
JOIN Alm ON InvD.Almacen=Alm.Almacen
JOIN Art ON InvD.Articulo=Art.Articulo
JOIN Tarima ON InvD.Tarima=Tarima.Tarima
JOIN AlmPos ON Tarima.Posicion=AlmPos.Posicion AND AlmPos.Almacen=Alm.Almacen
WHERE
Alm.WMS=1
AND Inv.Estatus='PENDIENTE'
AND InvD.Tarima IS NOT NULL
AND AlmPos.Tipo='Surtido'

