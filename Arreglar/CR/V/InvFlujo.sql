SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW InvFlujo

AS
SELECT p.Articulo, "Modulo" = 'VTAS', p.SubCuenta, "PorRecibir" = NULL, "PorSurtir" = p.CantidadPendiente, "Disponible" = NULL, p.DescripcionExtra, p.ID, p.Empresa, p.Mov, p.MovID, p.Almacen, p.FechaEmision, p.FechaRequerida, "FechaEntrega" = NULL, "Cuenta" = c.Cliente, c.Nombre
FROM VentaPendienteD p
JOIN Cte c ON p.Cliente = c.Cliente
WHERE p.Estatus = 'PENDIENTE'
AND ISNULL(p.CantidadPendiente, 0) > 0
UNION
SELECT p.Articulo, "Modulo" = 'INV', p.SubCuenta, "PorRecibir" = NULL, "PorSurtir" = p.CantidadPendiente, "Disponible" = NULL, "DescripcionExtra" = NULL, p.ID, p.Empresa, p.Mov, p.MovID, p.Almacen, p.FechaEmision, "FechaRequerida" = NULL, "FechaEntrega" = NULL, "Cuenta" = NULL, "Nombre" = NULL
FROM InvSolicitudPendienteD p
WHERE p.Estatus = 'PENDIENTE'
AND ISNULL(p.CantidadPendiente, 0) > 0
UNION
SELECT p.Articulo, "Modulo" = 'COMS', p.SubCuenta, "PorRecibir" = p.CantidadPendiente, "PorSurtir" = NULL, "Disponible" = NULL, p.DescripcionExtra, p.ID, p.Empresa, p.Mov, p.MovID, p.Almacen, p.FechaEmision, p.FechaRequerida, p.FechaEntrega, "Cuenta"= Prov.Proveedor, Prov.Nombre
FROM CompraPendienteD p
JOIN Prov ON p.Proveedor = Prov.Proveedor
WHERE NULLIF(RTRIM(p.DestinoID), '') IS NULL
AND ISNULL(p.CantidadPendiente, 0) > 0
UNION
SELECT d.Articulo, "Modulo" = NULL, d.SubCuenta, "PorRecibir" = NULL, "PorSurtir" = NULL, "Disponible" = d.Disponible, "DescripcionExtra" = NULL, "ID" = NULL, d.Empresa, "Mov" = NULL, "MovID" = NULL, d.Almacen, GETDATE(), "FechaRequerida"=NULL, "FechaEntrega" = NULL, "Cuenta"= NULL, "Nombre" = NULL
FROM ArtSubDisponible d
JOIN Version v ON 1 = 1
WHERE d.Almacen IS NOT NULL AND ISNULL(d.Disponible, 0) > 0

