SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW cProdD

AS
SELECT
ID,
Renglon,
RenglonSub,
RenglonID,
RenglonTipo,
AutoGenerado,
Almacen,
Codigo,
Articulo,
SubCuenta,
Cantidad,
Costo,
ProdSerieLote,
CantidadPendiente,
CantidadReservada,
CantidadCancelada,
CantidadOrdenada,
CantidadA,
Paquete,
DestinoTipo,
Destino,
DestinoID,
Aplica,
AplicaID,
Cliente,
Centro,
CentroDestino,
Orden,
OrdenDestino,
Estacion,
EstacionDestino,
Unidad,
Factor,
CantidadInventario,
Ruta,
Volumen,
SustitutoArticulo,
SustitutoSubCuenta,
FechaRequerida,
FechaEntrega,
DescripcionExtra,
Merma,
Desperdicio,
Tipo,
Comision,
ManoObra,
Indirectos,
Maquila,
Personal,
Turno,
TiempoMuerto,
Causa,
Posicion,
Tarima,
UltimoReservadoCantidad,
UltimoReservadoFecha,
Sucursal,
SucursalOrigen,
Logico1,
Logico2,
Logico3,
AplicaRenglon
FROM
ProdD WITH (NOLOCK)

