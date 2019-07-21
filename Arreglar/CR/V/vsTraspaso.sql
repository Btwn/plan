SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW vsTraspaso
AS
SELECT mt.Clave,
i.FechaEmision 'FechaTransaccion',
id.Articulo 'SKU',
i.Almacen 'Almacen',
SUM(id.CantidadPendiente * id.Factor) 'InventarioUnidades'
FROM Inv i
JOIN InvD id ON id.ID = i.ID
JOIN MovTipo mt ON mt.Mov = i.Mov
WHERE mt.Clave IN ('INV.OT', 'INV.OI') AND i.Estatus = 'PENDIENTE' AND id.CantidadPendiente IS NOT NULL
GROUP BY mt.Clave, i.FechaEmision, id.Articulo, i.Almacen

