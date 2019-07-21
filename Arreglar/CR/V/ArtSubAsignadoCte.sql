SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtSubAsignadoCte

AS
SELECT
c.Empresa,
d.Cliente,
d.Articulo,
d.SubCuenta,
d.Almacen,
"Asignado" = SUM(d.CantidadPendiente*ISNULL(d.Factor, 1.0))
FROM Compra c
JOIN CompraD d ON c.ID = d.ID
WHERE
c.Estatus = 'PENDIENTE'
GROUP BY
c.Empresa, d.Cliente, d.Articulo, d.SubCuenta, d.Almacen

