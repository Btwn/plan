USE [IntelisisTmp]
GO

/****** Object:  View [dbo].[cVentaD]    Script Date: 21/05/2019 03:03:36 p. m. ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

ALTER VIEW [dbo].[cVentaD]

AS
SELECT
ID,
Renglon,
RenglonSub,
RenglonID,
RenglonTipo,
Cantidad,
Almacen,
EnviarA,
Codigo,
Articulo,
SubCuenta,
Precio,
PrecioSugerido,
DescuentoTipo,
DescuentoLinea,
DescuentoImporte,
Impuesto1,
Impuesto2,
Impuesto3,
DescripcionExtra,
Costo,
CostoActividad,
Paquete,
ContUso,
ContUso2,
ContUso3,
Aplica,
AplicaID,
CantidadPendiente,
CantidadReservada,
CantidadCancelada,
CantidadOrdenada,
CantidadObsequio,
CantidadA,
Unidad,
Factor,
CantidadInventario,
SustitutoArticulo,
SustitutoSubCuenta,
FechaRequerida,
HoraRequerida,
Instruccion,
UltimoReservadoCantidad,
UltimoReservadoFecha,
Agente,
Departamento,
Sucursal,
SucursalOrigen,
AutoLocalidad,
UEN,
Espacio,
CantidadAlterna,
PoliticaPrecios,
PrecioMoneda,
PrecioTipoCambio,
AFArticulo,
AFSerie,
ExcluirPlaneacion,
Anexo,
Estado,
ExcluirISAN,
Posicion,
PresupuestoEsp,
ProveedorRef,
TransferirA,
IDCopiaMAVI,
UsuarioDescuento,
PrecioAnterior,
Tarima,
ABC,
TipoImpuesto1,
TipoImpuesto2,
TipoImpuesto3,
OrdenCompra,
TipoRetencion1,
TipoRetencion2,
TipoRetencion3,
Retencion1,
Retencion2,
Retencion3,
AnticipoFacturado,
AnticipoMoneda,
AnticipoTipoCambio,
AnticipoRetencion,
RecargaTelefono,			
RecargaConfirmarTelefono,	
AplicaRenglon,
MesLanzamiento,
Puntos						
FROM
VentaD

GO


