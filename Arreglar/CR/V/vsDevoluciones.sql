SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW vsDevoluciones
AS
SELECT mt.Clave,
c.FechaEmision 'FechaTransaccion',
cd.Articulo 'SKU',
c.Almacen 'Almacen',
sum(cd.Cantidad * cd.Factor) 'InventarioUnidades'
FROM Compra c
LEFT JOIN CompraD cd on cd.ID = c.ID
LEFT JOIN MovTipo mt on mt.Mov = c.Mov
WHERE c.Estatus = 'CONCLUIDO' and mt.Clave = 'COMS.D' 
GROUP BY mt.Clave, c.FechaEmision, cd.Articulo, c.Almacen

