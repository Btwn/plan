SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gMovDReg
 AS
SELECT
Modulo,
ID,
Renglon,
RenglonSub,
RenglonID,
RenglonTipo,
UEN,
Concepto,
Personal,
Almacen,
Codigo,
Articulo,
SubCuenta,
Cantidad,
Unidad,
Factor,
CantidadInventario,
Costo,
CostoInv,
CostoActividad,
Precio,
DescuentoTipo,
DescuentoLinea,
DescuentoImporte,
Impuesto1,
Impuesto2,
Impuesto3,
Retencion1,
Retencion2,
Retencion3,
DescripcionExtra,
Paquete,
ContUso,
Comision,
Aplica,
AplicaID,
DestinoTipo,
Destino,
DestinoID,
Cliente,
Agente,
Departamento,
Espacio,
Estado,
AFArticulo,
AFSerie,
CostoUEPS,
CostoPEPS,
UltimoCosto,
PrecioLista,
Posicion,
DepartamentoDetallista,
SerieLote,
Producto,
SubProducto,
Merma,
Desperdicio,
Tipo,
Ruta,
Fecha,
Importe,
Porcentaje,
Impuestos,
Provision,
Depreciacion,
DescuentoRecargos,
InteresesOrdinarios,
InteresesMoratorios,
FormaPago,
Referencia,
Proyecto,
Actividad,
Cuenta,
CtoTipo,
Contacto,
ObligacionFiscal,
Tasa,
ABC
FROM MovDReg
UNION ALL
SELECT
Modulo,
ID,
Renglon,
RenglonSub,
RenglonID,
RenglonTipo,
UEN,
Concepto,
Personal,
Almacen,
Codigo,
Articulo,
SubCuenta,
Cantidad,
Unidad,
Factor,
CantidadInventario,
Costo,
CostoInv,
CostoActividad,
Precio,
DescuentoTipo,
DescuentoLinea,
DescuentoImporte,
Impuesto1,
Impuesto2,
Impuesto3,
Retencion1,
Retencion2,
Retencion3,
DescripcionExtra,
Paquete,
ContUso,
Comision,
Aplica,
AplicaID,
DestinoTipo,
Destino,
DestinoID,
Cliente,
Agente,
Departamento,
Espacio,
Estado,
AFArticulo,
AFSerie,
CostoUEPS,
CostoPEPS,
UltimoCosto,
PrecioLista,
Posicion,
DepartamentoDetallista,
SerieLote,
Producto,
SubProducto,
Merma,
Desperdicio,
Tipo,
Ruta,
Fecha,
Importe,
Porcentaje,
Impuestos,
Provision,
Depreciacion,
DescuentoRecargos,
InteresesOrdinarios,
InteresesMoratorios,
FormaPago,
Referencia,
Proyecto,
Actividad,
Cuenta,
CtoTipo,
Contacto,
ObligacionFiscal,
Tasa,
ABC
FROM hMovDReg
;

