SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW TransitoExistenciaD
AS
SELECT
i.Empresa Empresa,
id.Articulo Articulo,
ISNULL(id.SubCuenta,'') Opcion,
i.Almacen AlmacenOrigen,
i.AlmacenDestino AlmacenDestino,
i.ID ID,
ISNULL(i.Mov,'') + ' ' + ISNULL(i.MovID,'') Movimiento,
i.FechaEmision FechaEmision,
ISNULL(id.Cantidad,0.0) Cantidad,
id.Unidad Unidad,
(ISNULL(id.Costo,0.0)*ISNULL(i.TipoCambio,1)) Costo,
(ISNULL(id.Costo,0.0)*ISNULL(i.TipoCambio,1))*ISNULL(id.Cantidad,0.0) CostoTotal,
ISNULL(id.CantidadInventario,0.0) CantidadInventario
FROM InvD id JOIN Inv i
ON i.ID = id.ID JOIN MovTipo mt
ON mt.Mov = i.Mov AND mt.Modulo = 'INV'
WHERE mt.Clave = 'INV.TI'
AND i.Estatus = 'PENDIENTE'

