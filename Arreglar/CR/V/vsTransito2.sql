SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW vsTransito2
AS
SELECT mt.Clave,
c.FechaEmision 'FechaTransaccion',
cd.Articulo 'SKU',
c.Almacen 'Almacen',
sum(cd.CantidadPendiente * cd.Factor) 'InventarioUnidades'
FROM Compra c
LEFT JOIN CompraD cd on cd.ID = c.ID
LEFT JOIN MovTipo mt on mt.Mov = c.Mov
WHERE c.Estatus = 'PENDIENTE' and mt.Clave = 'COMS.O' AND cd.CantidadPendiente IS NOT NULL
GROUP BY mt.Clave, c.FechaEmision, cd.Articulo, c.Almacen
UNION ALL
SELECT mt.Clave,
i.FechaEmision 'FechaTransaccion',
id.Articulo 'SKU',
i.Almacen 'Almacen',
SUM(id.CantidadPendiente * id.Factor) 'InventarioUnidades'
FROM Inv i
JOIN InvD id ON id.ID = i.ID
JOIN MovTipo mt ON mt.Mov = i.Mov
WHERE mt.Clave = 'INV.TI' AND i.Estatus = 'PENDIENTE' AND id.CantidadPendiente IS NOT NULL
GROUP BY mt.Clave, i.FechaEmision, id.Articulo, i.Almacen

