SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gVenta
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
Prioridad,
RenglonID,
FechaOriginal,
Codigo,
Cliente,
EnviarA,
Almacen,
AlmacenDestino,
Agente,
AgenteServicio,
AgenteComision,
FormaEnvio,
FechaRequerida,
HoraRequerida,
FechaProgramadaEnvio,
FechaOrdenCompra,
ReferenciaOrdenCompra,
OrdenCompra,
Condicion,
Vencimiento,
CtaDinero,
Descuento,
DescuentoGlobal,
Importe,
Impuestos,
Saldo,
AnticiposFacturados,
AnticiposImpuestos,
Retencion,
DescuentoLineal,
ComisionTotal,
CostoTotal,
PrecioTotal,
Paquetes,
ServicioTipo,
ServicioArticulo,
ServicioSerie,
ServicioContrato,
ServicioContratoID,
ServicioContratoTipo,
ServicioGarantia,
ServicioDescripcion,
ServicioFecha,
ServicioFlotilla,
ServicioRampa,
ServicioIdentificador,
ServicioPlacas,
ServicioKms,
ServicioTipoOrden,
ServicioTipoOperacion,
ServicioSiniestro,
ServicioExpress,
ServicioDemerito,
ServicioDeducible,
ServicioDeducibleImporte,
ServicioNumero,
ServicioNumeroEconomico,
ServicioAseguradora,
ServicioPuntual,
ServicioPoliza,
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
FechaEntrega,
EmbarqueEstado,
EmbarqueGastos,
Peso,
Volumen,
Causa,
Atencion,
AtencionTelefono,
ListaPreciosEsp,
ZonaImpuesto,
Extra,
CancelacionID,
Mensaje,
Departamento,
Sucursal,
GenerarOP,
DesglosarImpuestos,
DesglosarImpuesto2,
ExcluirPlaneacion,
ConVigencia,
VigenciaDesde,
VigenciaHasta,
Enganche,
Bonificacion,
IVAFiscal,
IEPSFiscal,
EstaImpreso,
Periodicidad,
SubModulo,
ContUso,
Espacio,
AutoCorrida,
AutoCorridaHora,
AutoCorridaServicio,
AutoCorridaRol,
AutoCorridaOrigen,
AutoCorridaDestino,
AutoCorridaKms,
AutoCorridaLts,
AutoCorridaRuta,
AutoOperador2,
AutoBoleto,
AutoKms,
AutoKmsActuales,
AutoBomba,
AutoBombaContador,
Logico1,
Logico2,
Logico3,
Logico4,
DifCredito,
EspacioResultado,
Clase,
Subclase,
GastoAcreedor,
GastoConcepto,
Comentarios,
Pagado,
GenerarDinero,
Dinero,
DineroID,
DineroCtaDinero,
DineroConciliado,
DineroFechaConciliacion,
Extra1,
Extra2,
Extra3,
Reabastecido,
SucursalVenta,
AF,
AFArticulo,
AFSerie,
ContratoTipo,
ContratoDescripcion,
ContratoSerie,
ContratoValor,
ContratoValorMoneda,
ContratoSeguro,
ContratoVencimiento,
ContratoResponsable,
Incentivo,
IncentivoConcepto,
EndosarA,
InteresTasa,
InteresIVA,
AnexoID,
FordVisitoOASIS,
LineaCredito,
TipoAmortizacion,
TipoTasa,
Comisiones,
ComisionesIVA,
CompraID,
OperacionRelevante,
TieneTasaEsp,
TasaEsp,
FormaPagoTipo,
SobrePrecio,
SucursalOrigen,
SucursalDestino,
MaviTipoVenta,
EsCredilana,
Mayor12Meses,
IDIngresoMAVI,
AfectaComisionMavi,
SucJuego,
OrigenSucursal,
FacDesgloseIVA,
EsModVenta,
ContImpSimp,
ContImpCiego,
ContImpCFD,
FormaCobro,
NoCtaPago,
RedimePtos,
ComLibera,
CteFinal,
Band402,
FechaEnvioSID,
Liberado,
Autoriza,
ArtQ,
HuellaLiberacion,
IDEcommerce,
ReporteServicio,
PagoDie,
FolioFIADE,
AgenteVtaCruzada,
ReporteDescuento,
VtaDIMANuevo,
CRCFDSerie,
CRCFDFolio,
ContUso2,
ContUso3,
Actividad,
ContratoID,
ContratoMov,
ContratoMovID,
MAFCiclo,
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
AnticipoFacturadoTipoServicio,
Retencion1,
Retencion2,
Retencion3,
CFDFlexEstatus,
CFDTimbrado,
RecargaTelefono,
EmidaControlNo,
EmidaTransactionId,
EmidaResponseMessage,
EmidaTransactionDateTime,
EmidaResponseCode,
EmidaCarrierControlNo,
PosicionWMS,
CRMID,
OpportunityId,
IDOPORT,
PedidoReferencia,
POSDescuento,
PedidoReferenciaID,
Refacturado,
Monedero,
EmidaTelefono,
Ubicacion,
MapaLatitud,
MapaLongitud,
IDProyecto,
CrossDocking,
NombreDF,
ApellidosDF,
PasaporteDF,
NacionalidadDF,
NoVueloDF,
AerolineaDF,
OrigenDF,
DestinoDF,
POSRedondeoVerif,
MesLanzamiento,
FolioCRM,
CRMObjectId,
RedimePuntos,
Posicion
FROM Venta
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
Prioridad,
RenglonID,
FechaOriginal,
Codigo,
Cliente,
EnviarA,
Almacen,
AlmacenDestino,
Agente,
AgenteServicio,
AgenteComision,
FormaEnvio,
FechaRequerida,
HoraRequerida,
FechaProgramadaEnvio,
FechaOrdenCompra,
ReferenciaOrdenCompra,
OrdenCompra,
Condicion,
Vencimiento,
CtaDinero,
Descuento,
DescuentoGlobal,
Importe,
Impuestos,
Saldo,
AnticiposFacturados,
AnticiposImpuestos,
Retencion,
DescuentoLineal,
ComisionTotal,
CostoTotal,
PrecioTotal,
Paquetes,
ServicioTipo,
ServicioArticulo,
ServicioSerie,
ServicioContrato,
ServicioContratoID,
ServicioContratoTipo,
ServicioGarantia,
ServicioDescripcion,
ServicioFecha,
ServicioFlotilla,
ServicioRampa,
ServicioIdentificador,
ServicioPlacas,
ServicioKms,
ServicioTipoOrden,
ServicioTipoOperacion,
ServicioSiniestro,
ServicioExpress,
ServicioDemerito,
ServicioDeducible,
ServicioDeducibleImporte,
ServicioNumero,
ServicioNumeroEconomico,
ServicioAseguradora,
ServicioPuntual,
ServicioPoliza,
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
FechaEntrega,
EmbarqueEstado,
EmbarqueGastos,
Peso,
Volumen,
Causa,
Atencion,
AtencionTelefono,
ListaPreciosEsp,
ZonaImpuesto,
Extra,
CancelacionID,
Mensaje,
Departamento,
Sucursal,
GenerarOP,
DesglosarImpuestos,
DesglosarImpuesto2,
ExcluirPlaneacion,
ConVigencia,
VigenciaDesde,
VigenciaHasta,
Enganche,
Bonificacion,
IVAFiscal,
IEPSFiscal,
EstaImpreso,
Periodicidad,
SubModulo,
ContUso,
Espacio,
AutoCorrida,
AutoCorridaHora,
AutoCorridaServicio,
AutoCorridaRol,
AutoCorridaOrigen,
AutoCorridaDestino,
AutoCorridaKms,
AutoCorridaLts,
AutoCorridaRuta,
AutoOperador2,
AutoBoleto,
AutoKms,
AutoKmsActuales,
AutoBomba,
AutoBombaContador,
Logico1,
Logico2,
Logico3,
Logico4,
DifCredito,
EspacioResultado,
Clase,
Subclase,
GastoAcreedor,
GastoConcepto,
Comentarios,
Pagado,
GenerarDinero,
Dinero,
DineroID,
DineroCtaDinero,
DineroConciliado,
DineroFechaConciliacion,
Extra1,
Extra2,
Extra3,
Reabastecido,
SucursalVenta,
AF,
AFArticulo,
AFSerie,
ContratoTipo,
ContratoDescripcion,
ContratoSerie,
ContratoValor,
ContratoValorMoneda,
ContratoSeguro,
ContratoVencimiento,
ContratoResponsable,
Incentivo,
IncentivoConcepto,
EndosarA,
InteresTasa,
InteresIVA,
AnexoID,
FordVisitoOASIS,
LineaCredito,
TipoAmortizacion,
TipoTasa,
Comisiones,
ComisionesIVA,
CompraID,
OperacionRelevante,
TieneTasaEsp,
TasaEsp,
FormaPagoTipo,
SobrePrecio,
SucursalOrigen,
SucursalDestino,
MaviTipoVenta,
EsCredilana,
Mayor12Meses,
IDIngresoMAVI,
AfectaComisionMavi,
SucJuego,
OrigenSucursal,
FacDesgloseIVA,
EsModVenta,
ContImpSimp,
ContImpCiego,
ContImpCFD,
FormaCobro,
NoCtaPago,
RedimePtos,
ComLibera,
CteFinal,
Band402,
FechaEnvioSID,
Liberado,
Autoriza,
ArtQ,
HuellaLiberacion,
IDEcommerce,
ReporteServicio,
PagoDie,
FolioFIADE,
AgenteVtaCruzada,
ReporteDescuento,
VtaDIMANuevo,
CRCFDSerie,
CRCFDFolio,
ContUso2,
ContUso3,
Actividad,
ContratoID,
ContratoMov,
ContratoMovID,
MAFCiclo,
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
AnticipoFacturadoTipoServicio,
Retencion1,
Retencion2,
Retencion3,
CFDFlexEstatus,
CFDTimbrado,
RecargaTelefono,
EmidaControlNo,
EmidaTransactionId,
EmidaResponseMessage,
EmidaTransactionDateTime,
EmidaResponseCode,
EmidaCarrierControlNo,
PosicionWMS,
CRMID,
OpportunityId,
IDOPORT,
PedidoReferencia,
POSDescuento,
PedidoReferenciaID,
Refacturado,
Monedero,
EmidaTelefono,
Ubicacion,
MapaLatitud,
MapaLongitud,
IDProyecto,
CrossDocking,
NombreDF,
ApellidosDF,
PasaporteDF,
NacionalidadDF,
NoVueloDF,
AerolineaDF,
OrigenDF,
DestinoDF,
POSRedondeoVerif,
MesLanzamiento,
FolioCRM,
CRMObjectId,
RedimePuntos,
Posicion
FROM hVenta
;

