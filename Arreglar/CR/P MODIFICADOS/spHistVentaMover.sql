SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spHistVentaMover
@ID     int,
@Ok     int          OUTPUT,
@OkRef  varchar(255) OUTPUT

AS BEGIN
INSERT hCFDVentaDCte
(ID, Renglon, RenglonSub, Articulo, Cliente)
SELECT ID, Renglon, RenglonSub, Articulo, Cliente
FROM CFDVentaDCte WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCFDVentaDCte'
DELETE CFDVentaDCte WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'CFDVentaDCte'
INSERT hCFDVentaDProv
(ID, Renglon, RenglonSub, Articulo, Proveedor)
SELECT ID, Renglon, RenglonSub, Articulo, Proveedor
FROM CFDVentaDProv WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCFDVentaDProv'
DELETE CFDVentaDProv WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'CFDVentaDProv'
INSERT hNota
(ID, Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, Actividad, UEN, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Directo, Prioridad, RenglonID, FechaOriginal, Codigo, Cliente, EnviarA, Almacen, AlmacenDestino, Agente, AgenteServicio, AgenteComision, FormaEnvio, FechaRequerida, HoraRequerida, FechaProgramadaEnvio, FechaOrdenCompra, ReferenciaOrdenCompra, OrdenCompra, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Importe, Impuestos, Saldo, AnticiposFacturados, AnticiposImpuestos, Retencion, DescuentoLineal, ComisionTotal, CostoTotal, PrecioTotal, Paquetes, ServicioTipo, ServicioArticulo, ServicioSerie, ServicioContrato, ServicioContratoID, ServicioContratoTipo, ServicioGarantia, ServicioDescripcion, ServicioFecha, ServicioFlotilla, ServicioRampa, ServicioIdentificador, ServicioPlacas, ServicioKms, ServicioTipoOrden, ServicioTipoOperacion, ServicioSiniestro, ServicioExpress, ServicioDemerito, ServicioDeducible, ServicioDeducibleImporte, ServicioNumero, ServicioNumeroEconomico, ServicioAseguradora, ServicioPuntual, ServicioPoliza, OrigenTipo, Origen, OrigenID, Poliza, PolizaID, GenerarPoliza, ContID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, FechaEntrega, EmbarqueEstado, EmbarqueGastos, Peso, Volumen, Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Extra, CancelacionID, Mensaje, Departamento, Sucursal, GenerarOP, DesglosarImpuestos, DesglosarImpuesto2, ExcluirPlaneacion, ConVigencia, VigenciaDesde, VigenciaHasta, Enganche, Bonificacion, IVAFiscal, IEPSFiscal, EstaImpreso, Periodicidad, SubModulo, ContUso, ContUso2, ContUso3, Espacio, AutoCorrida, AutoCorridaHora, AutoCorridaServicio, AutoCorridaRol, AutoCorridaOrigen, AutoCorridaDestino, AutoCorridaKms, AutoCorridaLts, AutoCorridaRuta, AutoOperador2, AutoBoleto, AutoKms, AutoKmsActuales, AutoBomba, AutoBombaContador, Logico1, Logico2, Logico3, Logico4, DifCredito, EspacioResultado, Clase, Subclase, GastoAcreedor, GastoConcepto, Comentarios, Pagado, GenerarDinero, Dinero, DineroID, DineroCtaDinero, DineroConciliado, DineroFechaConciliacion, Extra1, Extra2, Extra3, Reabastecido, SucursalVenta, AF, AFArticulo, AFSerie, ContratoTipo, ContratoDescripcion, ContratoSerie, ContratoValor, ContratoValorMoneda, ContratoSeguro, ContratoVencimiento, ContratoResponsable, Incentivo, IncentivoConcepto, EndosarA, InteresTasa, InteresIVA, AnexoID, FordVisitoOASIS, LineaCredito, TipoAmortizacion, TipoTasa, Comisiones, ComisionesIVA, CompraID, OperacionRelevante, TieneTasaEsp, TasaEsp, FormaPagoTipo, SobrePrecio, ContratoID, ContratoMov, ContratoMovID)
SELECT ID, Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, Actividad, UEN, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Directo, Prioridad, RenglonID, FechaOriginal, Codigo, Cliente, EnviarA, Almacen, AlmacenDestino, Agente, AgenteServicio, AgenteComision, FormaEnvio, FechaRequerida, HoraRequerida, FechaProgramadaEnvio, FechaOrdenCompra, ReferenciaOrdenCompra, OrdenCompra, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Importe, Impuestos, Saldo, AnticiposFacturados, AnticiposImpuestos, Retencion, DescuentoLineal, ComisionTotal, CostoTotal, PrecioTotal, Paquetes, ServicioTipo, ServicioArticulo, ServicioSerie, ServicioContrato, ServicioContratoID, ServicioContratoTipo, ServicioGarantia, ServicioDescripcion, ServicioFecha, ServicioFlotilla, ServicioRampa, ServicioIdentificador, ServicioPlacas, ServicioKms, ServicioTipoOrden, ServicioTipoOperacion, ServicioSiniestro, ServicioExpress, ServicioDemerito, ServicioDeducible, ServicioDeducibleImporte, ServicioNumero, ServicioNumeroEconomico, ServicioAseguradora, ServicioPuntual, ServicioPoliza, OrigenTipo, Origen, OrigenID, Poliza, PolizaID, GenerarPoliza, ContID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, FechaEntrega, EmbarqueEstado, EmbarqueGastos, Peso, Volumen, Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Extra, CancelacionID, Mensaje, Departamento, Sucursal, GenerarOP, DesglosarImpuestos, DesglosarImpuesto2, ExcluirPlaneacion, ConVigencia, VigenciaDesde, VigenciaHasta, Enganche, Bonificacion, IVAFiscal, IEPSFiscal, EstaImpreso, Periodicidad, SubModulo, ContUso, ContUso2, ContUso3, Espacio, AutoCorrida, AutoCorridaHora, AutoCorridaServicio, AutoCorridaRol, AutoCorridaOrigen, AutoCorridaDestino, AutoCorridaKms, AutoCorridaLts, AutoCorridaRuta, AutoOperador2, AutoBoleto, AutoKms, AutoKmsActuales, AutoBomba, AutoBombaContador, Logico1, Logico2, Logico3, Logico4, DifCredito, EspacioResultado, Clase, Subclase, GastoAcreedor, GastoConcepto, Comentarios, Pagado, GenerarDinero, Dinero, DineroID, DineroCtaDinero, DineroConciliado, DineroFechaConciliacion, Extra1, Extra2, Extra3, Reabastecido, SucursalVenta, AF, AFArticulo, AFSerie, ContratoTipo, ContratoDescripcion, ContratoSerie, ContratoValor, ContratoValorMoneda, ContratoSeguro, ContratoVencimiento, ContratoResponsable, Incentivo, IncentivoConcepto, EndosarA, InteresTasa, InteresIVA, AnexoID, FordVisitoOASIS, LineaCredito, TipoAmortizacion, TipoTasa, Comisiones, ComisionesIVA, CompraID, OperacionRelevante, TieneTasaEsp, TasaEsp, FormaPagoTipo, SobrePrecio, ContratoID, ContratoMov, ContratoMovID
FROM Nota
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hNota'
DELETE Nota WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'Nota'
INSERT hNotaCobro
(ID, Importe1, Importe2, Importe3, Importe4, Importe5, FormaCobro1, FormaCobro2, FormaCobro3, FormaCobro4, FormaCobro5, Referencia1, Referencia2, Referencia3, Referencia4, Referencia5, Observaciones1, Observaciones2, Observaciones3, Observaciones4, Observaciones5, Cambio, Redondeo, DelEfectivo, Sucursal, CtaDinero, Cajero, Condicion, Vencimiento, Actualizado, SucursalOrigen)
SELECT ID, Importe1, Importe2, Importe3, Importe4, Importe5, FormaCobro1, FormaCobro2, FormaCobro3, FormaCobro4, FormaCobro5, Referencia1, Referencia2, Referencia3, Referencia4, Referencia5, Observaciones1, Observaciones2, Observaciones3, Observaciones4, Observaciones5, Cambio, Redondeo, DelEfectivo, Sucursal, CtaDinero, Cajero, Condicion, Vencimiento, Actualizado, SucursalOrigen
FROM NotaCobro
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hNotaCobro'
DELETE NotaCobro WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'NotaCobro'
INSERT hNotaCobroD
(ID, RenglonID, Importe, Moneda, TipoCambio, FormaCobro, Referencia, Sucursal, SucursalOrigen)
SELECT ID, RenglonID, Importe, Moneda, TipoCambio, FormaCobro, Referencia, Sucursal, SucursalOrigen
FROM NotaCobroD WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hNotaCobroD'
DELETE NotaCobroD WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'NotaCobroD'
INSERT hNotaD
(ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad, Almacen, EnviarA, Codigo, Articulo, SubCuenta, Precio, PrecioSugerido, DescuentoTipo, DescuentoLinea, DescuentoImporte, Impuesto1, Impuesto2, Impuesto3, DescripcionExtra, Costo, CostoActividad, Paquete, ContUso, ContUso2, ContUso3, Comision, Aplica, AplicaID, CantidadPendiente, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadEmbarcada, CantidadA, Unidad, Factor, CantidadInventario, SustitutoArticulo, SustitutoSubCuenta, FechaRequerida, HoraRequerida, Instruccion, Agente, Departamento, UltimoReservadoCantidad, UltimoReservadoFecha, Sucursal, PoliticaPrecios, SucursalOrigen, AutoLocalidad, UEN, Espacio, CantidadAlterna, PrecioMoneda, PrecioTipoCambio, Estado, ServicioNumero, AgentesAsignados, AFArticulo, AFSerie, ExcluirPlaneacion, Anexo, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, CostoEstandar, PrecioLista, DepartamentoDetallista, PresupuestoEsp, Posicion, Puntos, CantidadObsequio, OfertaID, ProveedorRef, TransferirA, ArtEstatus, ArtSituacion, Tarima, ABC, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3)
SELECT ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad, Almacen, EnviarA, Codigo, Articulo, SubCuenta, Precio, PrecioSugerido, DescuentoTipo, DescuentoLinea, DescuentoImporte, Impuesto1, Impuesto2, Impuesto3, DescripcionExtra, Costo, CostoActividad, Paquete, ContUso, ContUso2, ContUso3, Comision, Aplica, AplicaID, CantidadPendiente, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadEmbarcada, CantidadA, Unidad, Factor, CantidadInventario, SustitutoArticulo, SustitutoSubCuenta, FechaRequerida, HoraRequerida, Instruccion, Agente, Departamento, UltimoReservadoCantidad, UltimoReservadoFecha, Sucursal, PoliticaPrecios, SucursalOrigen, AutoLocalidad, UEN, Espacio, CantidadAlterna, PrecioMoneda, PrecioTipoCambio, Estado, ServicioNumero, AgentesAsignados, AFArticulo, AFSerie, ExcluirPlaneacion, Anexo, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, CostoEstandar, PrecioLista, DepartamentoDetallista, PresupuestoEsp, Posicion, Puntos, CantidadObsequio, OfertaID, ProveedorRef, TransferirA, ArtEstatus, ArtSituacion, Tarima, ABC, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3
FROM NotaD
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hNotaD'
DELETE NotaD WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'NotaD'
INSERT hNotaDAgente
(ID, Renglon, RenglonSub, RID, Agente, Fecha, HoraD, HoraA, Minutos, Actividad, Estado, Comentarios, CantidadEstandar, FechaConclusion, CostoActividad, Avance, Sucursal, SucursalOrigen)
SELECT ID, Renglon, RenglonSub, RID, Agente, Fecha, HoraD, HoraA, Minutos, Actividad, Estado, Comentarios, CantidadEstandar, FechaConclusion, CostoActividad, Avance, Sucursal, SucursalOrigen
FROM NotaDAgente WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hNotaDAgente'
DELETE NotaDAgente WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'NotaDAgente'
INSERT hServicioAccesorios
(ID, RenglonID, Articulo, Serie, Observaciones, Sucursal, SucursalOrigen)
SELECT ID, RenglonID, Articulo, Serie, Observaciones, Sucursal, SucursalOrigen
FROM ServicioAccesorios WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hServicioAccesorios'
DELETE ServicioAccesorios WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'ServicioAccesorios'
INSERT hServicioTarea
(ID, RenglonID, Tarea, Problema, Solucion, Estado, Fecha, Responsable, FechaEstimada, FechaConclusion, Sucursal, Tiempo, Usuario, Logico1, Logico2, Logico3, Orden, Comentarios, SucursalOrigen)
SELECT ID, RenglonID, Tarea, Problema, Solucion, Estado, Fecha, Responsable, FechaEstimada, FechaConclusion, Sucursal, Tiempo, Usuario, Logico1, Logico2, Logico3, Orden, Comentarios, SucursalOrigen
FROM ServicioTarea WITH(NOLOCK)
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hServicioTarea'
DELETE ServicioTarea WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'ServicioTarea'
INSERT hSorianaArtCajaTarima
(ID, Proveedor, Remision, FolioPedido, NumeroCajaTarima, SucursalDistribuir, Codigo, CantidadUnidadCompra)
SELECT ID, Proveedor, Remision, FolioPedido, NumeroCajaTarima, SucursalDistribuir, Codigo, CantidadUnidadCompra
FROM SorianaArtCajaTarima WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hSorianaArtCajaTarima'
DELETE SorianaArtCajaTarima WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'SorianaArtCajaTarima'
INSERT hSorianaArticulos
(ID, Proveedor, Remision, FolioPedido, Tienda, Codigo, CantidadUnidadCompra, CostoNetoUnidadCompra, PorcentajeIEPS, PorcentajeIVA)
SELECT ID, Proveedor, Remision, FolioPedido, Tienda, Codigo, CantidadUnidadCompra, CostoNetoUnidadCompra, PorcentajeIEPS, PorcentajeIVA
FROM SorianaArticulos WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hSorianaArticulos'
DELETE SorianaArticulos WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'SorianaArticulos'
INSERT hSorianaCajasTarimas
(ID, Proveedor, Remision, NumeroCajaTarima, CodigoBarraCajaTarima, SucursalDistribuir, CantidadArticulos)
SELECT ID, Proveedor, Remision, NumeroCajaTarima, CodigoBarraCajaTarima, SucursalDistribuir, CantidadArticulos
FROM SorianaCajasTarimas WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hSorianaCajasTarimas'
DELETE SorianaCajasTarimas WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'SorianaCajasTarimas'
INSERT hSorianaPedidos
(ID, Proveedor, Remision, FolioPedido, Tienda, CantidadArticulos)
SELECT ID, Proveedor, Remision, FolioPedido, Tienda, CantidadArticulos
FROM SorianaPedidos WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hSorianaPedidos'
DELETE SorianaPedidos WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'SorianaPedidos'
INSERT hSorianaPedimento
(ID, Proveedor, Remision, Pedimento, Aduana, AgenteAduanal, TipoPedimento, FechaPedimento, FechaReciboLaredo, FechaBillOfLading)
SELECT ID, Proveedor, Remision, Pedimento, Aduana, AgenteAduanal, TipoPedimento, FechaPedimento, FechaReciboLaredo, FechaBillOfLading
FROM SorianaPedimento WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hSorianaPedimento'
DELETE SorianaPedimento WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'SorianaPedimento'
INSERT hSorianaRemision
(ID, Proveedor, Remision, Consecutivo, FechaRemision, Tienda, TipoMoneda, TipoBulto, EntregaMercancia, CumpleReqFiscales, CantidadBultos, Subtotal, Descuentos, IEPS, IVA, OtrosImpuestos, Total, CantidadPedidos, FechaEntregaMercancia, EmpaqueEnCajas, EmpaqueEnTarimas, CantidadCajasTarimas)
SELECT ID, Proveedor, Remision, Consecutivo, FechaRemision, Tienda, TipoMoneda, TipoBulto, EntregaMercancia, CumpleReqFiscales, CantidadBultos, Subtotal, Descuentos, IEPS, IVA, OtrosImpuestos, Total, CantidadPedidos, FechaEntregaMercancia, EmpaqueEnCajas, EmpaqueEnTarimas, CantidadCajasTarimas
FROM SorianaRemision WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hSorianaRemision'
DELETE SorianaRemision WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'SorianaRemision'
INSERT hVenta
(ID, Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Directo, Prioridad, RenglonID, FechaOriginal, Codigo, Cliente, EnviarA, Almacen, AlmacenDestino, Agente, AgenteServicio, AgenteComision, FormaEnvio, FechaRequerida, HoraRequerida, FechaProgramadaEnvio, FechaOrdenCompra, ReferenciaOrdenCompra, OrdenCompra, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Importe, Impuestos, Saldo, AnticiposFacturados, AnticiposImpuestos, Retencion, DescuentoLineal, ComisionTotal, CostoTotal, PrecioTotal, Paquetes, ServicioTipo, ServicioArticulo, ServicioSerie, ServicioContrato, ServicioContratoID, ServicioContratoTipo, ServicioGarantia, ServicioDescripcion, ServicioFecha, ServicioFlotilla, ServicioRampa, ServicioIdentificador, ServicioPlacas, ServicioKms, ServicioTipoOrden, ServicioTipoOperacion, ServicioSiniestro, ServicioExpress, ServicioDemerito, ServicioDeducible, ServicioDeducibleImporte, ServicioNumero, ServicioNumeroEconomico, ServicioAseguradora, ServicioPuntual, ServicioPoliza, OrigenTipo, Origen, OrigenID, Poliza, PolizaID, GenerarPoliza, ContID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, FechaEntrega, EmbarqueEstado, EmbarqueGastos, Peso, Volumen, Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Extra, CancelacionID, Mensaje, Departamento, Sucursal, GenerarOP, DesglosarImpuestos, DesglosarImpuesto2, ExcluirPlaneacion, ConVigencia, VigenciaDesde, VigenciaHasta, Enganche, Bonificacion, IVAFiscal, IEPSFiscal, EstaImpreso, Periodicidad, SubModulo, ContUso, Espacio, AutoCorrida, AutoCorridaHora, AutoCorridaServicio, AutoCorridaRol, AutoCorridaOrigen, AutoCorridaDestino, AutoCorridaKms, AutoCorridaLts, AutoCorridaRuta, AutoOperador2, AutoBoleto, AutoKms, AutoKmsActuales, AutoBomba, AutoBombaContador, Logico1, Logico2, Logico3, Logico4, DifCredito, EspacioResultado, Clase, Subclase, GastoAcreedor, GastoConcepto, Comentarios, Pagado, GenerarDinero, Dinero, DineroID, DineroCtaDinero, DineroConciliado, DineroFechaConciliacion, Extra1, Extra2, Extra3, Reabastecido, SucursalVenta, AF, AFArticulo, AFSerie, ContratoTipo, ContratoDescripcion, ContratoSerie, ContratoValor, ContratoValorMoneda, ContratoSeguro, ContratoVencimiento, ContratoResponsable, Incentivo, IncentivoConcepto, EndosarA, InteresTasa, InteresIVA, AnexoID, FordVisitoOASIS, LineaCredito, TipoAmortizacion, TipoTasa, Comisiones, ComisionesIVA, CompraID, OperacionRelevante, TieneTasaEsp, TasaEsp, FormaPagoTipo, SobrePrecio, SucursalOrigen, SucursalDestino, MaviTipoVenta, EsCredilana, Mayor12Meses, IDIngresoMAVI, AfectaComisionMavi, SucJuego, OrigenSucursal, FacDesgloseIVA, EsModVenta, ContImpSimp, ContImpCiego, ContImpCFD, FormaCobro, NoCtaPago, RedimePtos, ComLibera, CteFinal, Band402, FechaEnvioSID, Liberado, Autoriza, ArtQ, HuellaLiberacion, IDEcommerce, ReporteServicio, PagoDie, FolioFIADE, AgenteVtaCruzada, ReporteDescuento, VtaDIMANuevo, CRCFDSerie, CRCFDFolio, ContUso2, ContUso3, Actividad, ContratoID, ContratoMov, ContratoMovID, MAFCiclo, AnticipoFacturadoTipoServicio, Retencion1, Retencion2, Retencion3, CFDFlexEstatus, CFDTimbrado, RecargaTelefono, EmidaControlNo, EmidaTransactionId, EmidaResponseMessage, EmidaTransactionDateTime, EmidaResponseCode, EmidaCarrierControlNo, PosicionWMS, CRMID, OpportunityId, IDOPORT, PedidoReferencia, POSDescuento, PedidoReferenciaID, Refacturado, Monedero, EmidaTelefono, Ubicacion, MapaLatitud, MapaLongitud, IDProyecto, CrossDocking, NombreDF, ApellidosDF, PasaporteDF, NacionalidadDF, NoVueloDF, AerolineaDF, OrigenDF, DestinoDF, POSRedondeoVerif, MesLanzamiento, FolioCRM, CRMObjectId, RedimePuntos, Posicion)
SELECT ID, Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Directo, Prioridad, RenglonID, FechaOriginal, Codigo, Cliente, EnviarA, Almacen, AlmacenDestino, Agente, AgenteServicio, AgenteComision, FormaEnvio, FechaRequerida, HoraRequerida, FechaProgramadaEnvio, FechaOrdenCompra, ReferenciaOrdenCompra, OrdenCompra, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Importe, Impuestos, Saldo, AnticiposFacturados, AnticiposImpuestos, Retencion, DescuentoLineal, ComisionTotal, CostoTotal, PrecioTotal, Paquetes, ServicioTipo, ServicioArticulo, ServicioSerie, ServicioContrato, ServicioContratoID, ServicioContratoTipo, ServicioGarantia, ServicioDescripcion, ServicioFecha, ServicioFlotilla, ServicioRampa, ServicioIdentificador, ServicioPlacas, ServicioKms, ServicioTipoOrden, ServicioTipoOperacion, ServicioSiniestro, ServicioExpress, ServicioDemerito, ServicioDeducible, ServicioDeducibleImporte, ServicioNumero, ServicioNumeroEconomico, ServicioAseguradora, ServicioPuntual, ServicioPoliza, OrigenTipo, Origen, OrigenID, Poliza, PolizaID, GenerarPoliza, ContID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, FechaEntrega, EmbarqueEstado, EmbarqueGastos, Peso, Volumen, Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Extra, CancelacionID, Mensaje, Departamento, Sucursal, GenerarOP, DesglosarImpuestos, DesglosarImpuesto2, ExcluirPlaneacion, ConVigencia, VigenciaDesde, VigenciaHasta, Enganche, Bonificacion, IVAFiscal, IEPSFiscal, EstaImpreso, Periodicidad, SubModulo, ContUso, Espacio, AutoCorrida, AutoCorridaHora, AutoCorridaServicio, AutoCorridaRol, AutoCorridaOrigen, AutoCorridaDestino, AutoCorridaKms, AutoCorridaLts, AutoCorridaRuta, AutoOperador2, AutoBoleto, AutoKms, AutoKmsActuales, AutoBomba, AutoBombaContador, Logico1, Logico2, Logico3, Logico4, DifCredito, EspacioResultado, Clase, Subclase, GastoAcreedor, GastoConcepto, Comentarios, Pagado, GenerarDinero, Dinero, DineroID, DineroCtaDinero, DineroConciliado, DineroFechaConciliacion, Extra1, Extra2, Extra3, Reabastecido, SucursalVenta, AF, AFArticulo, AFSerie, ContratoTipo, ContratoDescripcion, ContratoSerie, ContratoValor, ContratoValorMoneda, ContratoSeguro, ContratoVencimiento, ContratoResponsable, Incentivo, IncentivoConcepto, EndosarA, InteresTasa, InteresIVA, AnexoID, FordVisitoOASIS, LineaCredito, TipoAmortizacion, TipoTasa, Comisiones, ComisionesIVA, CompraID, OperacionRelevante, TieneTasaEsp, TasaEsp, FormaPagoTipo, SobrePrecio, SucursalOrigen, SucursalDestino, MaviTipoVenta, EsCredilana, Mayor12Meses, IDIngresoMAVI, AfectaComisionMavi, SucJuego, OrigenSucursal, FacDesgloseIVA, EsModVenta, ContImpSimp, ContImpCiego, ContImpCFD, FormaCobro, NoCtaPago, RedimePtos, ComLibera, CteFinal, Band402, FechaEnvioSID, Liberado, Autoriza, ArtQ, HuellaLiberacion, IDEcommerce, ReporteServicio, PagoDie, FolioFIADE, AgenteVtaCruzada, ReporteDescuento, VtaDIMANuevo, CRCFDSerie, CRCFDFolio, ContUso2, ContUso3, Actividad, ContratoID, ContratoMov, ContratoMovID, MAFCiclo, AnticipoFacturadoTipoServicio, Retencion1, Retencion2, Retencion3, CFDFlexEstatus, CFDTimbrado, RecargaTelefono, EmidaControlNo, EmidaTransactionId, EmidaResponseMessage, EmidaTransactionDateTime, EmidaResponseCode, EmidaCarrierControlNo, PosicionWMS, CRMID, OpportunityId, IDOPORT, PedidoReferencia, POSDescuento, PedidoReferenciaID, Refacturado, Monedero, EmidaTelefono, Ubicacion, MapaLatitud, MapaLongitud, IDProyecto, CrossDocking, NombreDF, ApellidosDF, PasaporteDF, NacionalidadDF, NoVueloDF, AerolineaDF, OrigenDF, DestinoDF, POSRedondeoVerif, MesLanzamiento, FolioCRM, CRMObjectId, RedimePuntos, Posicion
FROM Venta
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVenta'
DELETE Venta WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'Venta'
INSERT hVentaAdenda
(ID, Adenda, Sucursal, SucursalOrigen)
SELECT ID, Adenda, Sucursal, SucursalOrigen
FROM VentaAdenda WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaAdenda'
DELETE VentaAdenda WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaAdenda'
INSERT hVentaCalcularPropEconomica
(ID, Renglon, MaterialServicio, Costo, Descripcion, RenglonID)
SELECT ID, Renglon, MaterialServicio, Costo, Descripcion, RenglonID
FROM VentaCalcularPropEconomica WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaCalcularPropEconomica'
DELETE VentaCalcularPropEconomica WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaCalcularPropEconomica'
INSERT hVentaCB
(ID, RenglonID, Codigo, Cantidad, Articulo, SubCuenta, Sucursal, SucursalOrigen)
SELECT ID, RenglonID, Codigo, Cantidad, Articulo, SubCuenta, Sucursal, SucursalOrigen
FROM VentaCB WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaCB'
DELETE VentaCB WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaCB'
INSERT hVentaCobro
(ID, Importe1, Importe2, Importe3, Importe4, Importe5, FormaCobro1, FormaCobro2, FormaCobro3, FormaCobro4, FormaCobro5, Referencia1, Referencia2, Referencia3, Referencia4, Referencia5, Observaciones1, Observaciones2, Observaciones3, Observaciones4, Observaciones5, Cambio, Redondeo, DelEfectivo, Sucursal, CtaDinero, Cajero, Condicion, Vencimiento, Actualizado, SucursalOrigen, FormaCobroCambio, POSTipoCambio1, POSTipoCambio2, POSTipoCambio3, POSTipoCambio4, POSTipoCambio5, TCProcesado1, TCProcesado2, TCProcesado3, TCProcesado4, TCProcesado5, TCDelEfectivo, TCCxcIDAplicacion)
SELECT ID, Importe1, Importe2, Importe3, Importe4, Importe5, FormaCobro1, FormaCobro2, FormaCobro3, FormaCobro4, FormaCobro5, Referencia1, Referencia2, Referencia3, Referencia4, Referencia5, Observaciones1, Observaciones2, Observaciones3, Observaciones4, Observaciones5, Cambio, Redondeo, DelEfectivo, Sucursal, CtaDinero, Cajero, Condicion, Vencimiento, Actualizado, SucursalOrigen, FormaCobroCambio, POSTipoCambio1, POSTipoCambio2, POSTipoCambio3, POSTipoCambio4, POSTipoCambio5, TCProcesado1, TCProcesado2, TCProcesado3, TCProcesado4, TCProcesado5, TCDelEfectivo, TCCxcIDAplicacion
FROM VentaCobro
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaCobro'
DELETE VentaCobro WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaCobro'
INSERT hVentaCobroD
(ID, RenglonID, Importe, Moneda, TipoCambio, FormaCobro, Referencia, Sucursal, SucursalOrigen)
SELECT ID, RenglonID, Importe, Moneda, TipoCambio, FormaCobro, Referencia, Sucursal, SucursalOrigen
FROM VentaCobroD WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaCobroD'
DELETE VentaCobroD WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaCobroD'
INSERT hVentaCompetidor
(ID, Competidor, Producto, Orden, Importe, Moneda, Situacion, Fecha, Observaciones, Sucursal, SucursalOrigen)
SELECT ID, Competidor, Producto, Orden, Importe, Moneda, Situacion, Fecha, Observaciones, Sucursal, SucursalOrigen
FROM VentaCompetidor WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaCompetidor'
DELETE VentaCompetidor WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaCompetidor'
INSERT hVentaD
(ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad, Almacen, EnviarA, Codigo, Articulo, SubCuenta, Precio, PrecioSugerido, DescuentoTipo, DescuentoLinea, DescuentoImporte, Impuesto1, Impuesto2, Impuesto3, DescripcionExtra, Costo, CostoActividad, Paquete, ContUso, Comision, Aplica, AplicaID, CantidadPendiente, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadEmbarcada, CantidadA, Unidad, Factor, CantidadInventario, SustitutoArticulo, SustitutoSubCuenta, FechaRequerida, HoraRequerida, Instruccion, Agente, Departamento, UltimoReservadoCantidad, UltimoReservadoFecha, Sucursal, PoliticaPrecios, SucursalOrigen, AutoLocalidad, UEN, Espacio, CantidadAlterna, PrecioMoneda, PrecioTipoCambio, Estado, ServicioNumero, AgentesAsignados, AFArticulo, AFSerie, ExcluirPlaneacion, Anexo, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, DepartamentoDetallista, PresupuestoEsp, Posicion, Puntos, CantidadObsequio, OfertaID, ProveedorRef, TransferirA, ArtEstatus, ArtSituacion, ExcluirISAN, Financiamiento, PropreListaID, IDCopiaMAVI, UsuarioDescuento, PrecioAnterior, MonxRedN1, MonxRedN2, MonxRedN3, MonxRedN4, MonxRedN5, MonxRedApli, ContUso2, ContUso3, CostoEstandar, Tarima, OrdenCompra, ABC, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, CostoPromedio, CostoReposicion, TipoRetencion1, TipoRetencion2, TipoRetencion3, Retencion1, Retencion2, Retencion3, AnticipoFacturado, AnticipoMoneda, AnticipoTipoCambio, AnticipoRetencion, AplicaRenglon, RecargaTelefono, RecargaConfirmarTelefono, POSDesGlobal, POSDesLinea, ProcesadoID, LDICuenta, LDIReferencia, OfertaIDP1, OfertaIDP2, OfertaIDP3, OfertaIDG1, OfertaIDG2, OfertaIDG3, DescuentoP1, DescuentoP2, DescuentoP3, DescuentoG1, DescuentoG2, DescuentoG3, PorcentajeUtilidad, EmidaTelefono, EmidaConfirmarTelefono, MesLanzamiento, CRMObjectId, ArtCambioClave)
SELECT ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad, Almacen, EnviarA, Codigo, Articulo, SubCuenta, Precio, PrecioSugerido, DescuentoTipo, DescuentoLinea, DescuentoImporte, Impuesto1, Impuesto2, Impuesto3, DescripcionExtra, Costo, CostoActividad, Paquete, ContUso, Comision, Aplica, AplicaID, CantidadPendiente, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadEmbarcada, CantidadA, Unidad, Factor, CantidadInventario, SustitutoArticulo, SustitutoSubCuenta, FechaRequerida, HoraRequerida, Instruccion, Agente, Departamento, UltimoReservadoCantidad, UltimoReservadoFecha, Sucursal, PoliticaPrecios, SucursalOrigen, AutoLocalidad, UEN, Espacio, CantidadAlterna, PrecioMoneda, PrecioTipoCambio, Estado, ServicioNumero, AgentesAsignados, AFArticulo, AFSerie, ExcluirPlaneacion, Anexo, AjusteCosteo, CostoUEPS, CostoPEPS, UltimoCosto, PrecioLista, DepartamentoDetallista, PresupuestoEsp, Posicion, Puntos, CantidadObsequio, OfertaID, ProveedorRef, TransferirA, ArtEstatus, ArtSituacion, ExcluirISAN, Financiamiento, PropreListaID, IDCopiaMAVI, UsuarioDescuento, PrecioAnterior, MonxRedN1, MonxRedN2, MonxRedN3, MonxRedN4, MonxRedN5, MonxRedApli, ContUso2, ContUso3, CostoEstandar, Tarima, OrdenCompra, ABC, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, CostoPromedio, CostoReposicion, TipoRetencion1, TipoRetencion2, TipoRetencion3, Retencion1, Retencion2, Retencion3, AnticipoFacturado, AnticipoMoneda, AnticipoTipoCambio, AnticipoRetencion, AplicaRenglon, RecargaTelefono, RecargaConfirmarTelefono, POSDesGlobal, POSDesLinea, ProcesadoID, LDICuenta, LDIReferencia, OfertaIDP1, OfertaIDP2, OfertaIDP3, OfertaIDG1, OfertaIDG2, OfertaIDG3, DescuentoP1, DescuentoP2, DescuentoP3, DescuentoG1, DescuentoG2, DescuentoG3, PorcentajeUtilidad, EmidaTelefono, EmidaConfirmarTelefono, MesLanzamiento, CRMObjectId, ArtCambioClave
FROM VentaD
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaD'
DELETE VentaD WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaD'
INSERT hVentaDAgente
(ID, Renglon, RenglonSub, RID, Agente, Fecha, HoraD, HoraA, Minutos, Actividad, Estado, Comentarios, CantidadEstandar, FechaConclusion, CostoActividad, Sucursal, SucursalOrigen, Avance)
SELECT ID, Renglon, RenglonSub, RID, Agente, Fecha, HoraD, HoraA, Minutos, Actividad, Estado, Comentarios, CantidadEstandar, FechaConclusion, CostoActividad, Sucursal, SucursalOrigen, Avance
FROM VentaDAgente WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaDAgente'
DELETE VentaDAgente WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaDAgente'
INSERT hVentaDLogPicos
(ID, Renglon, RenglonSub, CantidadCancelada, FechaCancelacion, Sucursal, SucursalOrigen)
SELECT ID, Renglon, RenglonSub, CantidadCancelada, FechaCancelacion, Sucursal, SucursalOrigen
FROM VentaDLogPicos WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaDLogPicos'
DELETE VentaDLogPicos WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaDLogPicos'
INSERT hVentaEntrega
(ID, Embarque, EmbarqueFecha, EmbarqueReferencia, Recibo, ReciboFecha, ReciboReferencia, EntregaMercancia, Sucursal, SucursalOrigen, Direccion, DireccionNumero, DireccionNumeroInt, CodigoPostal, Delegacion, Colonia, Poblacion, Estado, TotalCajas, Telefono, TelefonoMovil)
SELECT ID, Embarque, EmbarqueFecha, EmbarqueReferencia, Recibo, ReciboFecha, ReciboReferencia, EntregaMercancia, Sucursal, SucursalOrigen, Direccion, DireccionNumero, DireccionNumeroInt, CodigoPostal, Delegacion, Colonia, Poblacion, Estado, TotalCajas, Telefono, TelefonoMovil
FROM VentaEntrega WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaEntrega'
DELETE VentaEntrega WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaEntrega'
INSERT hVentaFacturaAnticipo
(ID, CxcID, Importe, Sucursal, SucursalOrigen)
SELECT ID, CxcID, Importe, Sucursal, SucursalOrigen
FROM VentaFacturaAnticipo WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaFacturaAnticipo'
DELETE VentaFacturaAnticipo WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaFacturaAnticipo'
INSERT hVentaFEA
(ID, Serie, Folio, Aprobacion, Procesar, Cancelar, Cancelada, Error, Firmada, Sello, Certificado, CadenaOriginal, Documento, Mensaje, Sucursal, SucursalOrigen)
SELECT ID, Serie, Folio, Aprobacion, Procesar, Cancelar, Cancelada, Error, Firmada, Sello, Certificado, CadenaOriginal, Documento, Mensaje, Sucursal, SucursalOrigen
FROM VentaFEA WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaFEA'
DELETE VentaFEA WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaFEA'
INSERT hVentaFlexibleD
(ID, Renglon, Articulo, Cantidad, Precio, Importe, Cliente)
SELECT ID, Renglon, Articulo, Cantidad, Precio, Importe, Cliente
FROM VentaFlexibleD WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaFlexibleD'
DELETE VentaFlexibleD WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaFlexibleD'
INSERT hVentaIntelisis
(ID, Descripcion, Problema, SolucionActual, SolucionSugerida, Layout, Ejemplos, Filtros, Ubicacion, Respaldo, Version, ContactoSolicitante, ContactoDudas, ContactoAutorizacion, ContactoFacturacion, FechaSolicitud, FechaRequerida, FechaAutorizacion, Solucion, Requerimientos, Instrucciones, FechaEntregaPrometida, FechaEntregaReal, VersionEntrega, AgenteProgramador, AgenteCalidad, Sucursal, SucursalOrigen)
SELECT ID, Descripcion, Problema, SolucionActual, SolucionSugerida, Layout, Ejemplos, Filtros, Ubicacion, Respaldo, Version, ContactoSolicitante, ContactoDudas, ContactoAutorizacion, ContactoFacturacion, FechaSolicitud, FechaRequerida, FechaAutorizacion, Solucion, Requerimientos, Instrucciones, FechaEntregaPrometida, FechaEntregaReal, VersionEntrega, AgenteProgramador, AgenteCalidad, Sucursal, SucursalOrigen
FROM VentaIntelisis
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaIntelisis'
DELETE VentaIntelisis WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaIntelisis'
INSERT hVentaOportunidad
(ID, ImporteEstimado, Etapa, Avance, ProbabilidadCierre, FechaEstimadaCierre, PresupuestoAsignado, Observaciones, Sucursal, SucursalOrigen)
SELECT ID, ImporteEstimado, Etapa, Avance, ProbabilidadCierre, FechaEstimadaCierre, PresupuestoAsignado, Observaciones, Sucursal, SucursalOrigen
FROM VentaOportunidad WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaOportunidad'
DELETE VentaOportunidad WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaOportunidad'
INSERT hVentaOrigen
(ID, RenglonID, OrigenID, Sucursal, SucursalOrigen)
SELECT ID, RenglonID, OrigenID, Sucursal, SucursalOrigen
FROM VentaOrigen WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaOrigen'
DELETE VentaOrigen WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaOrigen'
INSERT hVentaOrigenRedondeo
(ID, RenglonID, OrigenID, Sucursal)
SELECT ID, RenglonID, OrigenID, Sucursal
FROM VentaOrigenRedondeo WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaOrigenRedondeo'
DELETE VentaOrigenRedondeo WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaOrigenRedondeo'
INSERT hVentaOtros
(ID, Tapones, Tapetes, Espejos, FarosAlojeno, RadioCassette, Cenicero, LlantaRefaccion, Gato, Encendedor, Antena, Herramienta, Limpiadores, Gasolina, RayonesGolpes, ObjetosUnidad, Observaciones, Sucursal, Logico1, Logico2, Logico3, Logico4, Coordenadas, SucursalOrigen)
SELECT ID, Tapones, Tapetes, Espejos, FarosAlojeno, RadioCassette, Cenicero, LlantaRefaccion, Gato, Encendedor, Antena, Herramienta, Limpiadores, Gasolina, RayonesGolpes, ObjetosUnidad, Observaciones, Sucursal, Logico1, Logico2, Logico3, Logico4, Coordenadas, SucursalOrigen
FROM VentaOtros WITH(NOLOCK)
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaOtros'
DELETE VentaOtros WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaOtros'
INSERT hVentaParticipacion
(ID, RID, Concepto, Acreedor, Importe, Automatica, Sucursal, SucursalOrigen)
SELECT ID, RID, Concepto, Acreedor, Importe, Automatica, Sucursal, SucursalOrigen
FROM VentaParticipacion WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaParticipacion'
DELETE VentaParticipacion WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaParticipacion'
INSERT hVentaResumen
(ID, RenglonID, Sucursal, Mov, MovID, FechaEmision, Cliente, Agente, Importe, Impuestos, SucursalOrigen)
SELECT ID, RenglonID, Sucursal, Mov, MovID, FechaEmision, Cliente, Agente, Importe, Impuestos, SucursalOrigen
FROM VentaResumen WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hVentaResumen'
DELETE VentaResumen WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'VentaResumen'
RETURN
END
;

