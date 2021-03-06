SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gCompra
 AS
SELECT
ID,
Empresa,
Mov,
MovID,
FechaEmision,
UltimoCambio,
Concepto,
Proyecto,
Actividad,
UEN,
Moneda,
TipoCambio,
Usuario,
Autorizacion,
Referencia,
DocFuente,
Observaciones,
Estatus,
Situacion,
SituacionFecha,
SituacionUsuario,
SituacionNota,
Directo,
VerDestino,
Prioridad,
RenglonID,
Proveedor,
FormaEnvio,
FechaRequerida,
Almacen,
Condicion,
Vencimiento,
Manejo,
Fletes,
ActivoFijo,
Instruccion,
Agente,
Descuento,
DescuentoGlobal,
Importe,
Impuestos,
Saldo,
DescuentoLineal,
OrigenTipo,
Origen,
OrigenID,
Poliza,
PolizaID,
GenerarPoliza,
ContID,
Ejercicio,
Periodo,
FechaRegistro,
FechaConclusion,
FechaCancelacion,
Peso,
Volumen,
Conciliado,
Causa,
Atencion,
FechaEntrega,
EmbarqueEstado,
Sucursal,
ZonaImpuesto,
Paquetes,
Idioma,
IVAFiscal,
IEPSFiscal,
ListaPreciosEsp,
EstaImpreso,
Mensaje,
Logico1,
Logico2,
Logico3,
Logico4,
Logico5,
Logico6,
Logico7,
Pagado,
ProrrateoAplicaID,
FormaEntrega,
CancelarPendiente,
LineaCredito,
TipoAmortizacion,
TipoTasa,
Comisiones,
ComisionesIVA,
OperacionRelevante,
VIN,
SubModulo,
AutoCargos,
TieneTasaEsp,
TasaEsp,
Cliente,
SucursalOrigen,
SucursalDestino,
Planeador,
ContUso,
ContUso2,
ContUso3,
ContratoID,
ContratoMov,
ContratoMovID,
Entidad,
TipoComprobante,
SustentoComprobante,
TipoIdentificacion,
DerechoDevolucion,
Establecimiento,
PuntoEmision,
SecuencialSRI,
AutorizacionSRI,
VigenteA,
SecuenciaRetencion,
Comprobante,
FechaContableMov,
PuntoEmisionRetencion,
SecuencialSRIRetencion,
FechaProveedor,
CFDFlexEstatus,
Retencion,
ReferenciaMES,
MovIntelisisMES,
PosicionWMS,
Posicion,
CrossDocking,
MesLanzamiento,
CFDRetencionTimbrado
FROM Compra WITH(NOLOCK)
UNION ALL
SELECT
ID,
Empresa,
Mov,
MovID,
FechaEmision,
UltimoCambio,
Concepto,
Proyecto,
Actividad,
UEN,
Moneda,
TipoCambio,
Usuario,
Autorizacion,
Referencia,
DocFuente,
Observaciones,
Estatus,
Situacion,
SituacionFecha,
SituacionUsuario,
SituacionNota,
Directo,
VerDestino,
Prioridad,
RenglonID,
Proveedor,
FormaEnvio,
FechaRequerida,
Almacen,
Condicion,
Vencimiento,
Manejo,
Fletes,
ActivoFijo,
Instruccion,
Agente,
Descuento,
DescuentoGlobal,
Importe,
Impuestos,
Saldo,
DescuentoLineal,
OrigenTipo,
Origen,
OrigenID,
Poliza,
PolizaID,
GenerarPoliza,
ContID,
Ejercicio,
Periodo,
FechaRegistro,
FechaConclusion,
FechaCancelacion,
Peso,
Volumen,
Conciliado,
Causa,
Atencion,
FechaEntrega,
EmbarqueEstado,
Sucursal,
ZonaImpuesto,
Paquetes,
Idioma,
IVAFiscal,
IEPSFiscal,
ListaPreciosEsp,
EstaImpreso,
Mensaje,
Logico1,
Logico2,
Logico3,
Logico4,
Logico5,
Logico6,
Logico7,
Pagado,
ProrrateoAplicaID,
FormaEntrega,
CancelarPendiente,
LineaCredito,
TipoAmortizacion,
TipoTasa,
Comisiones,
ComisionesIVA,
OperacionRelevante,
VIN,
SubModulo,
AutoCargos,
TieneTasaEsp,
TasaEsp,
Cliente,
SucursalOrigen,
SucursalDestino,
Planeador,
ContUso,
ContUso2,
ContUso3,
ContratoID,
ContratoMov,
ContratoMovID,
Entidad,
TipoComprobante,
SustentoComprobante,
TipoIdentificacion,
DerechoDevolucion,
Establecimiento,
PuntoEmision,
SecuencialSRI,
AutorizacionSRI,
VigenteA,
SecuenciaRetencion,
Comprobante,
FechaContableMov,
PuntoEmisionRetencion,
SecuencialSRIRetencion,
FechaProveedor,
CFDFlexEstatus,
Retencion,
ReferenciaMES,
MovIntelisisMES,
PosicionWMS,
Posicion,
CrossDocking,
MesLanzamiento,
CFDRetencionTimbrado
FROM hCompra WITH(NOLOCK)
;

