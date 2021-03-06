SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gNota
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
ContUso2,
ContUso3,
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
ContratoID,
ContratoMov,
ContratoMovID
FROM Nota
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
ContUso2,
ContUso3,
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
ContratoID,
ContratoMov,
ContratoMovID
FROM hNota
;

