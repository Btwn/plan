SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW cInvDWMS

AS
SELECT
ID,
Renglon,
RenglonSub,
RenglonID,
RenglonTipo,
Cantidad,
Almacen,
Codigo,
Articulo,
SubCuenta,
ArticuloDestino,
SubCuentaDestino,
Costo,
CostoInv,
ContUso,
Espacio,
CantidadReservada,
CantidadCancelada,
CantidadOrdenada,
CantidadPendiente,
CantidadA,
Paquete,
FechaRequerida,
Aplica,
AplicaID,
DestinoTipo,
Destino,
DestinoID,
Cliente,
Unidad,
Factor,
CantidadInventario,
UltimoReservadoCantidad,
UltimoReservadoFecha,
ProdSerieLote,
Merma,
Desperdicio,
Producto,
SubProducto,
Tipo,
Sucursal,
SucursalOrigen,
Precio,
DescripcionExtra,
Posicion,
Tarima,
Seccion,
FechaCaducidad
FROM
InvD

