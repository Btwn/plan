SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spInvAfectar]
 @ID INT
,@Accion CHAR(20)
,@Base CHAR(20)
,@Empresa CHAR(5)
,@Modulo CHAR(5)
,@Mov CHAR(20)
,@MovID VARCHAR(20) OUTPUT
,@MovTipo CHAR(20)
,@MovMoneda CHAR(10)
,@MovTipoCambio FLOAT
,@FechaEmision DATETIME
,@FechaAfectacion DATETIME
,@FechaConclusion DATETIME
,@Concepto VARCHAR(50)
,@Proyecto VARCHAR(50)
,@Usuario CHAR(10)
,@Autorizacion CHAR(10)
,@Referencia VARCHAR(50)
,@DocFuente INT
,@Observaciones VARCHAR(255)
,@Estatus CHAR(15)
,@EstatusNuevo CHAR(15)
,@FechaRegistro DATETIME
,@Ejercicio INT
,@Periodo INT
,@Almacen CHAR(10)
,@AlmacenTipo CHAR(15)
,@AlmacenDestino CHAR(10)
,@AlmacenDestinoTipo CHAR(15)
,@VoltearAlmacen BIT
,@AlmacenEspecifico CHAR(10)
,@Largo BIT
,@Condicion VARCHAR(50)
,@Vencimiento DATETIME
,@Periodicidad VARCHAR(20)
,@EndosarA VARCHAR(10)
,@ClienteProv CHAR(10)
,@EnviarA INT
,@DescuentoGlobal FLOAT
,@SobrePrecio FLOAT
,@Agente CHAR(10)
,@AnticiposFacturados MONEY
,@ServicioArticulo CHAR(20)
,@ServicioSerie CHAR(20)
,@FechaRequerida DATETIME
,@ZonaImpuesto VARCHAR(50)
,@OrigenTipo VARCHAR(10)
,@Origen VARCHAR(20)
,@OrigenID VARCHAR(20)
,@OrigenMovTipo VARCHAR(20)
,@CfgFormaCosteo CHAR(20)
,@CfgTipoCosteo CHAR(20)
,@CfgCosteoActividades VARCHAR(20)
,@CfgCosteoNivelSubCuenta BIT
,@CfgCosteoMultipleSimultaneo BIT
,@CfgPosiciones BIT
,@CfgExistenciaAlterna BIT
,@CfgExistenciaAlternaSerieLote BIT
,@CfgSeriesLotesMayoreo BIT
,@CfgSeriesLotesAutoCampo CHAR(20)
,@CfgSeriesLotesAutoOrden CHAR(20)
,@CfgCosteoSeries BIT
,@CfgCosteoLotes BIT
,@CfgValidarLotesCostoDif BIT
,@CfgVentaSurtirDemas BIT
,@CfgCompraRecibirDemas BIT
,@CfgTransferirDemas BIT
,@CfgBackOrders BIT
,@CfgContX BIT
,@CfgContXGenerar CHAR(20)
,@CfgContXFacturasPendientes BIT
,@CfgEmbarcar BIT
,@CfgImpInc BIT
,@CfgVentaContratosArticulo CHAR(20)
,@CfgVentaContratosImpuesto FLOAT
,@CfgVentaComisionesCobradas BIT
,@CfgAnticiposFacturados BIT
,@CfgMultiUnidades BIT
,@CfgMultiUnidadesNivel CHAR(20)
,@CfgCompraFactorDinamico BIT
,@CfgInvFactorDinamico BIT
,@CfgProdFactorDinamico BIT
,@CfgVentaFactorDinamico BIT
,@CfgCompraAutoCargos BIT
,@CfgVentaAutoBonif BIT
,@CfgVINAccesorioArt BIT
,@CfgVINCostoSumaAccesorios BIT
,@SeguimientoMatriz BIT
,@CobroIntegrado BIT
,@CobroIntegradoCxc BIT
,@CobroIntegradoParcial BIT
,@CobrarPedido BIT
,@AfectarDetalle BIT
,@AfectarMatando BIT
,@AfectarVtasMostrador BIT
,@FacturarVtasMostrador BIT
,@AfectarConsignacion BIT
,@AfectarAlmacenRenglon BIT
,@CfgVentaMultiAgente BIT
,@CfgVentaMultiAlmacen BIT
,@CfgVentaArtAlmacenEspecifico BIT
,@CfgTipoMerma CHAR(1)
,@CfgComisionBase CHAR(20)
,@CfgLimiteRenFacturas INT
,@CfgVentaRedondeoDecimales INT
,@CfgCompraCostosImpuestoIncluido BIT
,@AfectarConsecutivo BIT
,@EsTransferencia BIT
,@Conexion BIT
,@SincroFinal BIT
,@Sucursal INT
,@SucursalDestino INT
,@SucursalOrigen INT
,@Utilizar BIT
,@UtilizarID INT
,@UtilizarMov CHAR(20)
,@UtilizarSerie CHAR(20)
,@UtilizarMovTipo CHAR(20)
,@UtilizarMovID VARCHAR(20)
,@Generar BIT
,@GenerarMov CHAR(20)
,@GenerarSerie CHAR(20)
,@GenerarAfectado BIT
,@GenerarCopia BIT
,@GenerarPoliza BIT
,@GenerarOP BIT
,@GenerarGasto BIT
,@FacturacionRapidaAgrupada BIT
,@IDTransito INT OUTPUT
,@IDGenerar INT OUTPUT
,@GenerarMovID VARCHAR(20) OUTPUT
,@ContID INT OUTPUT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
,@CfgPrecioMoneda BIT = 0
,@EstacionTrabajo INT = NULL
AS
BEGIN
	DECLARE
		@Dias INT
	   ,@Renglon FLOAT
	   ,@RenglonSub INT
	   ,@RenglonID INT
	   ,@RenglonTipo CHAR(1)
	   ,@Articulo CHAR(20)
	   ,@Posicion CHAR(10)
	   ,@AuxiliarAlternoSucursal INT
	   ,@AuxiliarAlternoAlmacen CHAR(10)
	   ,@AuxiliarAlternoFactorEntrada FLOAT
	   ,@AuxiliarAlternoFactorSalida FLOAT
	   ,@ArtTipo VARCHAR(20)
	   ,@ArtSerieLoteInfo BIT
	   ,@ArtTipoOpcion VARCHAR(20)
	   ,@ArtComision VARCHAR(50)
	   ,@Peso FLOAT
	   ,@Volumen FLOAT
	   ,@Subcuenta VARCHAR(50)
	   ,@AcumularSinDetalles BIT
	   ,@AcumCantidad FLOAT
	   ,@Cantidad FLOAT
	   ,@Factor FLOAT
	   ,@MovUnidad VARCHAR(50)
	   ,@CantidadOriginal FLOAT
	   ,@CantidadObsequio FLOAT
	   ,@CantidadInventario FLOAT
	   ,@CantidadReservada FLOAT
	   ,@CantidadOrdenada FLOAT
	   ,@CantidadOrdenadaA FLOAT
	   ,@CantidadPendiente FLOAT
	   ,@CantidadPendienteA FLOAT
	   ,@CantidadA FLOAT
	   ,@IDSalidaTraspaso INT
	   ,@IDAplica INT
	   ,@AplicaMov CHAR(20)
	   ,@AplicaMovID VARCHAR(20)
	   ,@AplicaMovTipo CHAR(20)
	   ,@AlmacenRenglon CHAR(10)
	   ,@AgenteRenglon CHAR(10)
	   ,@AlmacenOrigen CHAR(10)
	   ,@Costo FLOAT
	   ,@CostoInv FLOAT
	   ,@CostoInvTotal FLOAT
	   ,@Precio FLOAT
	   ,@PrecioN FLOAT
	   ,@PrecioTipoCambio FLOAT
	   ,@DescuentoTipo CHAR(1)
	   ,@DescuentoLinea FLOAT
	   ,@Impuesto1 FLOAT
	   ,@Impuesto1N FLOAT
	   ,@Impuesto2 FLOAT
	   ,@Impuesto2N FLOAT
	   ,@Impuesto3 MONEY
	   ,@Impuesto3N MONEY
	   ,@Impuesto5 MONEY
	   ,@Impuesto5N MONEY
	   ,@Importe MONEY
	   ,@ImporteNeto MONEY
	   ,@Impuestos MONEY
	   ,@ImpuestosNetos MONEY
	   ,@Impuesto1Neto MONEY
	   ,@Impuesto2Neto MONEY
	   ,@Impuesto3Neto MONEY
	   ,@Impuesto5Neto MONEY
	   ,@ImporteComision MONEY
	   ,@DescuentoLineaImporte MONEY
	   ,@DescuentoGlobalImporte MONEY
	   ,@SobrePrecioImporte MONEY
	   ,@AnticipoImporte MONEY
	   ,@AnticipoImpuestos MONEY
	   ,@ImporteCx MONEY
	   ,@ImpuestosCx MONEY
	   ,@RetencionCx MONEY
	   ,@Retencion2Cx MONEY
	   ,@Retencion3Cx MONEY
	   ,@ImporteTotalCx MONEY
	   ,@CondicionCx VARCHAR(50)
	   ,@VencimientoCx DATETIME
	   ,@FacturandoRemision BIT
	   ,@TienePendientes BIT
	   ,@SumaPendiente FLOAT
	   ,@SumaReservada FLOAT
	   ,@SumaOrdenada FLOAT
	   ,@SumaImporte MONEY
	   ,@SumaImporteNeto MONEY
	   ,@SumaImpuestos MONEY
	   ,@SumaImpuestosNetos MONEY
	   ,@SumaImpuesto1Neto MONEY
	   ,@SumaImpuesto2Neto MONEY
	   ,@SumaImpuesto3Neto MONEY
	   ,@SumaImpuesto5Neto MONEY
	   ,@SumaDescuentoLinea MONEY
	   ,@SumaPrecioLinea MONEY
	   ,@SumaCostoLinea MONEY
	   ,@SumaPeso FLOAT
	   ,@SumaVolumen FLOAT
	   ,@SumaComision MONEY
	   ,@SumaRetencion MONEY
	   ,@SumaRetencion2 MONEY
	   ,@SumaRetencion3 MONEY
	   ,@SumaRetenciones MONEY
	   ,@SumaAnticiposFacturados MONEY
	   ,@ImporteRetencion MONEY
	   ,@ImporteRetencion2 MONEY
	   ,@ImporteRetencion3 MONEY
	   ,@Paquetes INT
	   ,@ImporteTotal FLOAT
	   ,@MovImpuesoSubTotal MONEY
	   ,@ImporteMatar MONEY
	   ,@FechaCancelacion DATETIME
	   ,@ArtUnidad VARCHAR(50)
	   ,@ArtCantidad FLOAT
	   ,@ArtCosto FLOAT
	   ,@ArtCostoInv FLOAT
	   ,@ArtAjusteCosteo FLOAT
	   ,@ArtCostoUEPS FLOAT
	   ,@ArtCostoPEPS FLOAT
	   ,@ArtUltimoCosto FLOAT
	   ,@ArtCostoEstandar FLOAT
	   ,@ArtPrecioLista FLOAT
	   ,@ArtDepartamentoDetallista INT
	   ,@ArtMoneda CHAR(10)
	   ,@ArtFactor FLOAT
	   ,@ArtTipoCambio FLOAT
	   ,@ArtCostoIdentificado BIT
	   ,@AjustePrecioLista MONEY
	   ,@MovRetencion1 FLOAT
	   ,@MovRetencion2 FLOAT
	   ,@MovRetencion3 FLOAT
	   ,@ReservadoParcial FLOAT
	   ,@ExplotandoRenglon FLOAT
	   ,@ExplotandoSubCuenta BIT
	   ,@EsEntrada BIT
	   ,@EsSalida BIT
	   ,@EsCargo BIT
	   ,@AfectarCantidad FLOAT
	   ,@AfectarAlmacen CHAR(10)
	   ,@AfectarAlmacenDestino CHAR(10)
	   ,@AfectarSerieLote BIT
	   ,@AfectarCostos BIT
	   ,@AfectarUnidades BIT
	   ,@AfectarPiezas BIT
	   ,@AfectarRama CHAR(5)
	   ,@UtilizarBase CHAR(20)
	   ,@UtilizarEstatus CHAR(15)
	   ,@GenerarAlmacen CHAR(10)
	   ,@GenerarAlmacenDestino CHAR(10)
	   ,@GenerarEstatus CHAR(15)
	   ,@GenerarDirecto BIT
	   ,@GenerarMovTipo CHAR(20)
	   ,@GenerarPeriodo INT
	   ,@GenerarEjercicio INT
	   ,@GenerarPolizaTemp BIT
	   ,@YaGeneroConsecutivo BIT
	   ,@CxModulo CHAR(5)
	   ,@CxID INT
	   ,@CxMov CHAR(20)
	   ,@CxMovID VARCHAR(20)
	   ,@CxMovEspecifico VARCHAR(20)
	   ,@CxAgente CHAR(10)
	   ,@CxMovTipo VARCHAR(20)
	   ,@CxImporte MONEY
	   ,@CxAjusteID INT
	   ,@CxAjusteMov CHAR(20)
	   ,@CxAjusteMovID VARCHAR(20)
	   ,@CxAjusteImporte MONEY
	   ,@CxConcepto VARCHAR(50)
	   ,@CompraID INT
	   ,@Cliente CHAR(10)
	   ,@DetalleTipo VARCHAR(20)
	   ,@Merma FLOAT
	   ,@Desperdicio FLOAT
	   ,@CantidadCalcularImporte FLOAT
	   ,@DestinoTipo VARCHAR(10)
	   ,@Destino VARCHAR(20)
	   ,@DestinoID VARCHAR(20)
	   ,@CobroDesglosado MONEY
	   ,@CobroCambio MONEY
	   ,@CobroRedondeo MONEY
	   ,@CobroSumaEfectivo MONEY
	   ,@CobroDelEfectivo MONEY
	   ,@ValesCobrados MONEY
	   ,@TarjetasCobradas MONEY
	   ,@DineroImporte MONEY
	   ,@DineroModulo CHAR(5)
	   ,@DineroMov CHAR(20)
	   ,@DineroMovID VARCHAR(20)
	   ,@MovImpuesto BIT
	   ,@Importe1 MONEY
	   ,@Importe2 MONEY
	   ,@Importe3 MONEY
	   ,@Importe4 MONEY
	   ,@Importe5 MONEY
	   ,@ImporteCambio MONEY
	   ,@FormaCobro1 VARCHAR(50)
	   ,@FormaCobro2 VARCHAR(50)
	   ,@FormaCobro3 VARCHAR(50)
	   ,@FormaCobro4 VARCHAR(50)
	   ,@FormaCobro5 VARCHAR(50)
	   ,@FormaCobroVales VARCHAR(50)
	   ,@FormaCobroCambio VARCHAR(50)
	   ,@FormaCobroTarjetas VARCHAR(50)
	   ,@IncrementaSaldoTarjeta BIT
	   ,@FormaPagoCambio VARCHAR(50)
	   ,@Referencia1 VARCHAR(50)
	   ,@Referencia2 VARCHAR(50)
	   ,@Referencia3 VARCHAR(50)
	   ,@Referencia4 VARCHAR(50)
	   ,@Referencia5 VARCHAR(50)
	   ,@CtaDinero CHAR(10)
	   ,@Cajero CHAR(10)
	   ,@FormaMoneda CHAR(10)
	   ,@FormaTipoCambio FLOAT
	   ,@AlmacenEspecificoVenta CHAR(10)
	   ,@MatarAntes BIT
	   ,@UltRenglonIDJuego INT
	   ,@CantidadJuego FLOAT
	   ,@CantidadMinimaJuego INT
	   ,@AlmacenTemp CHAR(10)
	   ,@AlmacenOriginal CHAR(10)
	   ,@AlmacenDestinoOriginal CHAR(10)
	   ,@ProdSerieLote VARCHAR(50)
	   ,@VIN VARCHAR(20)
	   ,@UltReservadoCantidad FLOAT
	   ,@UltReservadoFecha DATETIME
	   ,@UltAgente CHAR(10)
	   ,@ComisionAcum MONEY
	   ,@ComisionImporteNeto FLOAT
	   ,@ComisionFactor FLOAT
	   ,@Producto VARCHAR(20)
	   ,@SubProducto VARCHAR(50)
	   ,@IVAFiscal FLOAT
	   ,@IEPSFiscal FLOAT
	   ,@AfectandoNotasSinCobro BIT
	   ,@Continuar BIT
	   ,@ArtProvCosto FLOAT
	   ,@ProveedorRef VARCHAR(10)
	   ,@CfgRetencionAlPago BIT
	   ,@CfgRetencionMov CHAR(20)
	   ,@CfgRetencionAcreedor CHAR(10)
	   ,@CfgRetencionConcepto VARCHAR(50)
	   ,@CfgRetencion2Acreedor CHAR(10)
	   ,@CfgRetencion2Concepto VARCHAR(50)
	   ,@CfgRetencion3Acreedor CHAR(10)
	   ,@CfgRetencion3Concepto VARCHAR(50)
	   ,@CfgIngresoMov CHAR(20)
	   ,@CfgEstadisticaAjusteMerma CHAR(20)
	   ,@CfgInvAjusteCargoAgente VARCHAR(20)
	   ,@CfgVentaDMultiAgenteSugerir BIT
	   ,@CfgVentaMonedero BIT
	   ,@CfgVentaMonederoA BIT
	   ,@CfgVentaPuntosEnVales BIT
	   ,@EspacioD VARCHAR(10)
	   ,@EspacioDAnterior VARCHAR(10)
	   ,@Ruta CHAR(20)
	   ,@Orden INT
	   ,@OrdenDestino INT
	   ,@Centro CHAR(10)
	   ,@CentroDestino CHAR(10)
	   ,@Estacion CHAR(10)
	   ,@EstacionDestino CHAR(10)
	   ,@TiempoEstandarFijo FLOAT
	   ,@TiempoEstandarVariable FLOAT
	   ,@DescuentoInverso FLOAT
	   ,@SucursalAlmacen INT
	   ,@SucursalAlmacenDestino INT
	   ,@ProrrateoAplicaID INT
	   ,@ProrrateoAplicaIDMov VARCHAR(20)
	   ,@ProrrateoAplicaIDMovID VARCHAR(20)
	   ,@ArtLotesFijos BIT
	   ,@ArtActividades BIT
	   ,@SeriesLotesAutoOrden VARCHAR(50)
	   ,@CostoActividad FLOAT
	   ,@CotizacionID INT
	   ,@CotizacionEstatusNuevo CHAR(15)
	   ,@Hoy DATETIME
	   ,@RedondeoMonetarios INT
	   ,@CfgDiasHabiles VARCHAR(20)
	   ,@CfgABCDiasHabiles BIT
	   ,@CostosImpuestoIncluido BIT
	   ,@BorrarRetencionCx BIT
	   ,@MovImpuestoFactor FLOAT
	   ,@PrecioSinImpuestos FLOAT
	   ,@ModificarCosto FLOAT
	   ,@ModificarPrecio FLOAT
	   ,@CfgAC BIT
	   ,@LCMetodo INT
	   ,@LCPorcentajeResidual FLOAT
	   ,@CP BIT
	   ,@PPTO BIT
	   ,@PPTOVentas BIT
	   ,@WMS BIT
	   ,@WMSAlmacen BIT
	   ,@WMSMov VARCHAR(20)
	   ,@TransitoSucursal INT
	   ,@TransitoMov VARCHAR(20)
	   ,@TransitoMovID VARCHAR(20)
	   ,@TransitoEstatus VARCHAR(15)
	   ,@TraspasoExpressMov VARCHAR(20)
	   ,@TraspasoExpressMovID VARCHAR(20)
	   ,@FEA BIT
	   ,@FEAConsecutivo VARCHAR(20)
	   ,@FEAReferencia VARCHAR(50)
	   ,@FEASerie VARCHAR(20)
	   ,@FEAFolio INT
	   ,@MovTipoConsecutivoFEA VARCHAR(20)
	   ,@CantidadDif FLOAT
	   ,@CfgArrastrarSerieLote BIT
	   ,@CfgNotasBorrador BIT
	   ,@NoValidarDisponible BIT
	   ,@IDOrigen INT
	   ,@CfgVentaArtEstatus BIT
	   ,@CfgVentaArtSituacion BIT
	   ,@CfgCostearTransferencias BIT
	   ,@ArtEstatus VARCHAR(15)
	   ,@ArtSituacion VARCHAR(50)
	   ,@ArtExcento1 BIT
	   ,@ArtExcento2 BIT
	   ,@ArtExcento3 BIT
	   ,@Fiscal BIT
	   ,@FiscalGenerarRetenciones BIT
	   ,@ReferenciaAplicacionAnticipo VARCHAR(50)
	   ,@CxEndosoMov VARCHAR(20)
	   ,@CxEndosoMovID VARCHAR(20)
	   ,@CxEndosoID INT
	   ,@AutoEndosar VARCHAR(20)
	   ,@Proveedor VARCHAR(20)
	   ,@CfgMovCxpEndoso VARCHAR(20)
	   ,@CfgCompraAutoEndosoAutoCargos BIT
	   ,@Tarima VARCHAR(20)
	   ,@Seccion INT
	   ,@ContUso VARCHAR(20)
	   ,@ContUso2 VARCHAR(20)
	   ,@ContUso3 VARCHAR(20)
	   ,@ClavePresupuestal VARCHAR(50)
	   ,@ClavePresupuestalImpuesto1 VARCHAR(50)
	   ,@FactorMovImpto FLOAT
	   ,@FechaCaducidad DATETIME
	   ,@GenerarOrden BIT
	   ,@TipoImpuesto1 VARCHAR(10)
	   ,@TipoImpuesto2 VARCHAR(10)
	   ,@TipoImpuesto3 VARCHAR(10)
	   ,@TipoImpuesto5 VARCHAR(10)
	   ,@TipoRetencion1 VARCHAR(10)
	   ,@TipoRetencion2 VARCHAR(10)
	   ,@TipoRetencion3 VARCHAR(10)
	   ,@CfgRetencion2BaseImpuesto1 BIT
	   ,@Retencion1 FLOAT
	   ,@Retencion2 FLOAT
	   ,@Retencion3 FLOAT
	   ,@SubClave VARCHAR(20)
	   ,@EsEcuador BIT
	   ,@EmbarqueSumaArtJuego VARCHAR(20)
	   ,@ArtCostoPromedio MONEY
	   ,@ArtCostoReposicion MONEY
	   ,@VentaMovImpuestoDesdeRemision BIT
	   ,@ArrastrarMovImpuestoRemision BIT
	   ,@AplicaConcepto VARCHAR(50)
	   ,@AplicaFechaEmision DATETIME
	   ,@MovImpuestoAplicaID INT
	   ,@SubCuentaExplotarInformacion BIT
	   ,@SAUX BIT
	   ,@ValuacionOtraMoneda VARCHAR(10)
	   ,@ValuacionOtraMonedaTC FLOAT
	   ,@ValuacionOtraMonedaTCV FLOAT
	   ,@ValuacionOtraMonedaTCC FLOAT
	   ,@AnticipoFacturado BIT
	   ,@AnticipoFacturadoTipoServicio BIT
	   ,@LDI BIT
	   ,@CFDFlex BIT
	   ,@LDITarjeta BIT
	   ,@InterfazTC BIT
	   ,@TCDelEfectivo FLOAT
	   ,@TCProcesado1 BIT
	   ,@TCProcesado2 BIT
	   ,@TCProcesado3 BIT
	   ,@TCProcesado4 BIT
	   ,@TCProcesado5 BIT
	   ,@TipoCambio1 FLOAT
	   ,@TipoCambio2 FLOAT
	   ,@TipoCambio3 FLOAT
	   ,@TipoCambio4 FLOAT
	   ,@TipoCambio5 FLOAT
	   ,@ReferenciaTarjetas VARCHAR(50)
	   ,@OPORT BIT
	   ,@GenerarNCAlProcesar BIT
	   ,@PosicionDestino VARCHAR(10)
	   ,@CFGProdInterfazInfor BIT
	   ,@CfgEspacios BIT
	   ,@SubMovTipo VARCHAR(20)
	   ,@PosicionActual VARCHAR(10)
	   ,@PosicionReal VARCHAR(10)
	   ,@IDGenerarTransito INT
	   ,@CfgCostearDC BIT
	   ,@CrossDocking BIT
	   ,@Escrossdocking VARCHAR(2)
	   ,@PosicionWMS VARCHAR(10)
	   ,@posicioncrossdocking VARCHAR(10)
	   ,@IDN INT
	   ,@OrigenP VARCHAR(20)
	   ,@OrigenIdP VARCHAR(20)
	   ,@CrMov VARCHAR(20)
	   ,@CrMovID VARCHAR(20)
	   ,@CrRenglon FLOAT
	   ,@CrRenglonID INT
	   ,@CrRenglonAnt FLOAT
	   ,@CrRenglonIDAnt INT
	   ,@CrArticulo VARCHAR(20)
	   ,@CrArticuloAnt VARCHAR(20)
	   ,@CrAlmacen VARCHAR(10)
	   ,@CrCantidad FLOAT
	   ,@CrSerieLote VARCHAR(50)
	   ,@CrCantidadSL FLOAT
	   ,@CrCantidadAplicada FLOAT
	   ,@CrCantidadDispSL FLOAT
	   ,@CrSLMArticulo VARCHAR(20)
	   ,@CrSLMSerieLote VARCHAR(50)
	   ,@CrSLMCantidad FLOAT
	   ,@Serielote VARCHAR(50)
	   ,@Disponible FLOAT
	   ,@BanderaDesentarimado BIT
		 ,@CorteDias INT
	   ,@MenosDias INT
	   ,@Dia INT
	   ,@EsQuince BIT
	   ,@DAPeriodo CHAR(15)
	SET @CorteDias = 2
	SET @EsQuince = 0
	DECLARE
		@LDILog TABLE (
			IDModulo VARCHAR(36)
		   ,Modulo VARCHAR(5)
		   ,Servicio VARCHAR(50)
		   ,Fecha VARCHAR(20)
		   ,TipoTransaccion VARCHAR(50)
		   ,TipoSubservicio VARCHAR(50)
		   ,CodigoRespuesta VARCHAR(50)
		   ,DescripcionRespuesta VARCHAR(255)
		   ,OrigenRespuesta VARCHAR(50)
		   ,InfoAdicional VARCHAR(50)
		   ,IDTransaccion VARCHAR(50)
		   ,CodigoAutorizacion VARCHAR(50)
		   ,Importe FLOAT
		   ,Comprobante VARCHAR(MAX)
		   ,Cadena VARCHAR(MAX)
		   ,CadenaRespuesta VARCHAR(MAX)
		   ,RIDCobro INT
		)
	DECLARE
		@Bandera TABLE (
			Id INT IDENTITY (1, 1)
		   ,Articulo VARCHAR(20) NULL
		   ,SerieLote VARCHAR(50) NULL
		   ,CantidadDispSL FLOAT NULL
		   ,SLMCantidad FLOAT NULL
		   ,CantidadS FLOAT NULL
		   ,Cantidad FLOAT NULL
		)
	DECLARE
		@BanderaF TABLE (
			Id INT IDENTITY (1, 1)
		   ,Articulo VARCHAR(20) NULL
		   ,SerieLote VARCHAR(50) NULL
		   ,Cantidad FLOAT NULL
		   ,CantidadDispSL FLOAT NULL
		)
	DECLARE
		@BanderaFinal TABLE (
			Id INT IDENTITY (1, 1)
		   ,Articulo VARCHAR(20) NULL
		   ,SerieLote VARCHAR(50) NULL
		   ,Cantidad FLOAT NULL
		   ,CantidadDispSL FLOAT NULL
		)
	SELECT @CFDFlex = CFDFlex
	FROM MovTipo WITH(NOLOCK)
	WHERE Mov = @Mov
	AND Modulo = @Modulo
	SELECT @SubMovTipo = ISNULL(SubClave, '')
	FROM MovTipo WITH(NOLOCK)
	WHERE Modulo = @Modulo
	AND Mov = @Mov
	SELECT @EsEcuador = EsEcuador
	FROM Empresa WITH(NOLOCK)
	WHERE Empresa = @Empresa
	SELECT @SubClave = SubClave
	FROM MovTipo WITH(NOLOCK)
	WHERE Mov = @Mov
	AND Modulo = @Modulo
	SELECT @RedondeoMonetarios = RedondeoMonetarios
		  ,@CfgRetencion2BaseImpuesto1 = ISNULL(Retencion2BaseImpuesto1, 0)
	FROM Version

	IF @MovTipo = 'INV.EI'
		UPDATE InvD WITH(ROWLOCK)
		SET Tarima = NULL
		WHERE ID = @ID

	SELECT @ArtMoneda = NULL
		  ,@SumaPendiente = 0.0
		  ,@SumaReservada = 0.0
		  ,@SumaOrdenada = 0.0
		  ,@SumaImporte = 0.0
		  ,@SumaImporteNeto = 0.0
		  ,@SumaImpuestos = 0.0
		  ,@SumaImpuestosNetos = 0.0
		  ,@SumaImpuesto1Neto = 0.0
		  ,@SumaImpuesto2Neto = 0.0
		  ,@SumaImpuesto3Neto = 0.0
		  ,@SumaImpuesto5Neto = 0.0
		  ,@SumaDescuentoLinea = 0.0
		  ,@SumaComision = 0.0
		  ,@SumaPrecioLinea = 0.0
		  ,@SumaCostoLinea = 0.0
		  ,@SumaPeso = 0.0
		  ,@SumaVolumen = 0.0
		  ,@SumaRetencion = 0.0
		  ,@SumaRetencion2 = 0.0
		  ,@SumaRetencion3 = 0.0
		  ,@ComisionAcum = 0.0
		  ,@ComisionImporteNeto = 0.0
		  ,@ExplotandoRenglon = NULL
		  ,@YaGeneroConsecutivo = 0
		  ,@MatarAntes = 0
		  ,@UltRenglonIDJuego = NULL
		  ,@DetalleTipo = NULL
		  ,@Merma = NULL
		  ,@Desperdicio = NULL
		  ,@VIN = NULL
		  ,@UltAgente = NULL
		  ,@Producto = NULL
		  ,@SubProducto = NULL
		  ,@ComisionFactor = 1.0
		  ,@IVAFiscal = NULL
		  ,@IEPSFiscal = NULL
		  ,@SucursalAlmacen = NULL
		  ,@SucursalAlmacenDestino = NULL
		  ,@ArtLotesFijos = 0
		  ,@ArtActividades = 0
		  ,@MovImpuesto = 0
		  ,@CostosImpuestoIncluido = 0
		  ,@BorrarRetencionCx = 0
		  ,@FacturandoRemision = 0
		  ,@NoValidarDisponible = 0
		  ,@Seccion = NULL
		  ,@ClavePresupuestal = NULL
		  ,@ClavePresupuestalImpuesto1 = NULL
		  ,@ArrastrarMovImpuestoRemision = 0
		  ,@MovImpuestoAplicaID = NULL
		  ,@AplicaConcepto = NULL
		  ,@AplicaFechaEmision = NULL
		  ,@AnticipoFacturadoTipoServicio = NULL
	SELECT @AlmacenOriginal = @Almacen
		  ,@AlmacenDestinoOriginal = @AlmacenDestino
	SELECT @GenerarAlmacen = @Almacen
		  ,@GenerarAlmacenDestino = @AlmacenDestino
	SELECT @Hoy = @FechaRegistro
	EXEC spExtraerFecha @Hoy OUTPUT
	SELECT @CfgDiasHabiles = DiasHabiles
		  ,@CP = ISNULL(CP, 0)
		  ,@PPTO = ISNULL(PPTO, 0)
		  ,@PPTOVentas = ISNULL(PPTOVentas, 0)
		  ,@WMS = ISNULL(WMS, 0)
		  ,@CfgAC = ISNULL(AC, 0)
		  ,@FEA = ISNULL(FEA, 0)
		  ,@Fiscal = ISNULL(Fiscal, 0)
		  ,@SubCuentaExplotarInformacion = ISNULL(SubCuentaExplotarInformacion, 0)
		  ,@SAUX = ISNULL(SAUX, 0)
		  ,@LDI = ISNULL(InterfazLDI, 0)
		  ,@InterfazTC = ISNULL(InterfazTC, 0)
		  ,@OPORT = ISNULL(OPORT, 0)
		  ,@CFGProdInterfazInfor = ISNULL(ProdInterfazInfor, 0)
		  ,@CfgEspacios = Espacios
	FROM EmpresaGral WITH(NOLOCK)
	WHERE Empresa = @Empresa
	SELECT @CfgRetencionMov =
		   CASE
			   WHEN @MovTipo = 'COMS.D' THEN CxpDevRetencion
			   ELSE CxpRetencion
		   END
		  ,@CfgIngresoMov = VentaIngreso
		  ,@CfgEstadisticaAjusteMerma = InvEstadisticaAjusteMerma
	FROM EmpresaCfgMov WITH(NOLOCK)
	WHERE Empresa = @Empresa
	SELECT @CfgArrastrarSerieLote = ISNULL(VentaArrastrarSerieLote, 0)
		  ,@CfgNotasBorrador = NotasBorrador
		  ,@CfgCompraAutoEndosoAutoCargos = ISNULL(CompraAutoEndosoAutoCargos, 0)
		  ,@VentaMovImpuestoDesdeRemision = ISNULL(VentaMovImpuestoDesdeRemision, 0)
		  ,@GenerarNCAlProcesar = ISNULL(GenerarNCAlProcesar, 0)
		  ,@CfgCostearDC = ISNULL(CompraCostearDCporMovimiento, 0)
	FROM EmpresaCfg WITH(NOLOCK)
	WHERE Empresa = @Empresa

	IF @WMS = 1
		AND @MovTipo = 'INV.EI'
		UPDATE InvD WITH(ROWLOCK)
		SET Tarima = NULL
		WHERE ID = @ID

	IF @WMS = 1
		AND @MovTipo = 'COMS.F'
		AND EXISTS (SELECT PosicionWMS FROM Compra WITH(NOLOCK) WHERE ID = @ID AND NULLIF(PosicionWMS, '') IS NULL)
		AND EXISTS (SELECT * FROM Alm WITH(NOLOCK) WHERE Almacen = @Almacen AND WMS = 1)
		SELECT @Ok = 20922
			  ,@OkRef = 'Especifique una Posici_n (Anden)'

	IF @MovTipo IN ('VTAS.N', 'VTAS.NO', 'VTAS.NR', 'VTAS.FM')
		AND @CfgNotasBorrador = 1
		AND (@Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') OR @Accion = 'CANCELAR')
		SELECT @NoValidarDisponible = 1

	IF @Modulo = 'VTAS'
		SELECT @AnticipoFacturadoTipoServicio = ISNULL(AnticipoFacturadoTipoServicio, 0)
		FROM Venta WITH(NOLOCK)
		WHERE ID = @ID

	SELECT @CfgRetencionAlPago = ISNULL(RetencionAlPago, 0)
		  ,@CfgRetencionAcreedor = NULLIF(RTRIM(GastoRetencionAcreedor), '')
		  ,@CfgRetencionConcepto = ISNULL(NULLIF(NULLIF(RTRIM(GastoRetencionConcepto), ''), '(Concepto Gasto)'), @Concepto)
		  ,@CfgRetencion2Acreedor = NULLIF(RTRIM(GastoRetencion2Acreedor), '')
		  ,@CfgRetencion2Concepto = ISNULL(NULLIF(NULLIF(RTRIM(GastoRetencion2Concepto), ''), '(Concepto Gasto)'), @Concepto)
		  ,@CfgRetencion3Acreedor = NULLIF(RTRIM(GastoRetencion3Acreedor), '')
		  ,@CfgRetencion3Concepto = ISNULL(NULLIF(NULLIF(RTRIM(GastoRetencion3Concepto), ''), '(Concepto Gasto)'), @Concepto)
		  ,@CfgABCDiasHabiles = ISNULL(InvFrecuenciaABCDiasHabiles, 0)
		  ,@CfgInvAjusteCargoAgente = UPPER(InvAjusteCargoAgente)
		  ,@CfgVentaDMultiAgenteSugerir = ISNULL(VentaDMultiAgenteSugerir, 0)
		  ,@CfgVentaPuntosEnVales = ISNULL(VentaPuntosEnVales, 0)
		  ,@CfgVentaMonedero = ISNULL(VentaMonedero, 0)
		  ,@CfgVentaMonederoA = ISNULL(VentaMonederoA, 0)
		  ,@CfgVentaArtEstatus = ISNULL(VentaArtEstatus, 0)
		  ,@CfgVentaArtSituacion = ISNULL(VentaArtSituacion, 0)
		  ,@CfgCostearTransferencias = ISNULL(InvCostearTransferencias, 0)
		  ,@FiscalGenerarRetenciones = ISNULL(FiscalGenerarRetenciones, 0)
		  ,@EmbarqueSumaArtJuego = ISNULL(EmbarqueSumaArtJuego, 'Articulo Juego')
		  ,@ValuacionOtraMoneda = NULLIF(InvValuacionOtraMoneda, '')
		  ,@ValuacionOtraMonedaTC =
		   CASE
			   WHEN InvValuacionOtraMoneda = @MovMoneda THEN @MovTipoCambio
			   ELSE dbo.fnTipoCambio(InvValuacionOtraMoneda)
		   END
		  ,@ValuacionOtraMonedaTCV = dbo.fnTipoCambioVenta(InvValuacionOtraMoneda)
		  ,@ValuacionOtraMonedaTCC = dbo.fnTipoCambioCompra(InvValuacionOtraMoneda)
	FROM EmpresaCfg2 WITH(NOLOCK)
	WHERE Empresa = @Empresa

	IF @SubClave = 'COMS.CE/GT'
		SELECT @CfgRetencionAlPago = 0

	EXEC spInvAfectarInit @Accion
						 ,@Empresa
						 ,@Sucursal
						 ,@MovTipo
						 ,@OrigenTipo
						 ,@Origen
						 ,@OrigenID
						 ,@IDOrigen OUTPUT
						 ,@Ok OUTPUT
						 ,@OkRef OUTPUT

	IF @OrigenMovTipo = 'VTAS.OP'
		AND @IDOrigen IS NOT NULL
		AND @Accion <> 'CANCELAR'
		UPDATE Venta WITH(ROWLOCK)
		SET Estatus = 'CONCLUIDO'
		WHERE ID = @IDOrigen

	IF @Utilizar = 1
	BEGIN

		IF @Utilizar = 1
			AND @MovTipo IN ('VTAS.DC', 'VTAS.DCR')
			SELECT @GenerarAlmacen = @AlmacenDestino
				  ,@GenerarAlmacenDestino = @Almacen

		IF @Accion = 'GENERAR'
			SELECT @GenerarEstatus = 'SINAFECTAR'
		ELSE
			SELECT @GenerarEstatus = 'CANCELADO'

		IF @UtilizarMovTipo IN ('VTAS.C', 'VTAS.CS', 'VTAS.FR', 'VTAS.CTO', 'COMS.C')
			SELECT @GenerarDirecto = 1
		ELSE
			SELECT @GenerarDirecto = 0

		IF @UtilizarMovTipo = 'VTAS.CO'
			AND @CfgVentaContratosArticulo IS NULL
			SELECT @Ok = 20470

		IF @VoltearAlmacen = 1
			SELECT @AlmacenTemp = @GenerarAlmacen
				  ,@GenerarAlmacen = @GenerarAlmacenDestino
				  ,@GenerarAlmacenDestino = @AlmacenTemp

		IF @Ok IS NULL
		BEGIN
			EXEC spMovGenerar @Sucursal
							 ,@Empresa
							 ,@Modulo
							 ,@Ejercicio
							 ,@Periodo
							 ,@Usuario
							 ,@FechaRegistro
							 ,@GenerarEstatus
							 ,@GenerarAlmacen
							 ,@GenerarAlmacenDestino
							 ,@UtilizarMov
							 ,@UtilizarMovID
							 ,@GenerarDirecto
							 ,@Mov
							 ,@UtilizarSerie
							 ,@MovID OUTPUT
							 ,@ID OUTPUT
							 ,@Ok OUTPUT
							 ,@OkRef OUTPUT

			IF @Ok IS NULL
				AND (@MovTipo IN ('INV.EI', 'INV.DTI', 'INV.SI', 'INV.TMA') OR (@UtilizarMovTipo IN ('VTAS.VCR', 'VTAS.P', 'VTAS.R', 'VTAS.C') AND @CfgArrastrarSerieLote = 1))
				EXEC spMovCopiarSerieLote @Sucursal
										 ,@Modulo
										 ,@UtilizarID
										 ,@ID
										 ,1

			IF @MovTipo = 'INV.TMAZ'
				AND @Modulo = 'INV'
			BEGIN
				DECLARE
					CrArticuloCantidad
					CURSOR FOR
					SELECT A.Mov
						  ,A.MovID
						  ,B.Renglon
						  ,B.RenglonID
						  ,B.Articulo
						  ,A.Almacen
						  ,CASE @BASE
							   WHEN 'Seleccion' THEN B.CantidadA
							   WHEN 'Reservado' THEN B.CantidadReservada
							   WHEN 'Pendiente' THEN B.CantidadPendiente
						   END
						  ,C.SerieLote
						  ,C.Cantidad
					FROM Inv A WITH(NOLOCK)
					JOIN InvD B WITH(NOLOCK)
						ON A.ID = B.ID
					JOIN SerieLoteMov C WITH(NOLOCK)
						ON A.ID = C.ID
						AND A.Empresa = C.Empresa
						AND C.Modulo = 'INV'
						AND B.RenglonID = C.RenglonID
					WHERE A.ID = @UtilizarID
					ORDER BY B.Articulo
				OPEN CrArticuloCantidad
				FETCH NEXT FROM CrArticuloCantidad INTO @CrMov, @CrMovID, @CrRenglon, @CrRenglonID, @CrArticulo, @CrAlmacen, @CrCantidad, @CrSerieLote, @CrCantidadSL
				SET @CrCantidadAplicada = 0
				WHILE @@FETCH_STATUS = 0
				BEGIN

				IF @CrArticuloAnt <> @CrArticulo
					OR @CrRenglonID <> @CrRenglonIDAnt
					SELECT @CrCantidadAplicada = 0
						  ,@CrCantidadDispSL = 0

				SELECT @CrSLMArticulo = NULL
					  ,@CrSLMSerieLote = NULL
					  ,@CrSLMCantidad = NULL
				DECLARE
					CrSerieLoteMov
					CURSOR FOR
					SELECT A.Articulo
						  ,A.SerieLote
						  ,SUM(A.Cantidad) Cantidad
					FROM SerieLoteMov A 
					JOIN Inv B WITH(NOLOCK)
						ON A.ID = B.ID
						AND A.Modulo = B.OrigenTipo
					WHERE A.Empresa = @Empresa
					AND B.Origen = @CrMov
					AND B.OrigenID = @CrMovID
					AND A.Articulo = @CrArticulo
					AND A.SerieLote = @CrSerieLote
					AND A.Modulo = 'INV'
					AND B.Estatus <> 'CANCELADO'
					AND A.ID <> @UtilizarID
					AND A.ID <> @ID
					AND ISNULL(A.Tarima, '') <> ''
					AND ISNULL(a.Cantidad, 0) > 0
					GROUP BY A.Articulo
							,A.SerieLote
				OPEN CrSerieLoteMov
				FETCH NEXT FROM CrSerieLoteMov INTO @CrSLMArticulo, @CrSLMSerieLote, @CrSLMCantidad

				IF @CrSLMArticulo IS NULL
				BEGIN
					SELECT @CrCantidad =
					 CASE
						 WHEN @CrCantidadAplicada = 0 THEN @CrCantidad
						 ELSE @CrCantidad - @CrCantidadAplicada
					 END

					IF @CrCantidad <= 0
						DELETE SerieLoteMov
						WHERE Empresa = @Empresa
							AND Modulo = 'INV'
							AND ID = @ID
							AND Articulo = @CrArticulo
							AND SerieLote = @CrSerieLote

					IF (@CrRenglonAnt <> @CrRenglon OR @CrRenglonIDAnt <> @CrRenglonID OR @CrCantidad > 0)
					BEGIN
						SELECT @CrRenglonAnt = @CrRenglon
							  ,@CrRenglonIDAnt = @CrRenglonID
							  ,@CrArticuloAnt = @CrArticulo
						UPDATE SerieLoteMov WITH(ROWLOCK)
						SET Cantidad =
						CASE
							WHEN Cantidad <= @CrCantidad THEN Cantidad
							ELSE @CrCantidad
						END
						FROM SerieLoteMov WITH(NOLOCK)
						WHERE Empresa = @Empresa
						AND Modulo = 'INV'
						AND ID = @ID
						AND Articulo = @CrArticulo
						AND SerieLote = @CrSerieLote
						SELECT @CrCantidadAplicada = @CrCantidadAplicada +
							   CASE
								   WHEN Cantidad <= @CrCantidad THEN Cantidad
								   ELSE @CrCantidad
							   END
							  ,@CrCantidadDispSL = @CrCantidadDispSL +
							   CASE
								   WHEN Cantidad <= @CrCantidad THEN Cantidad
								   ELSE @CrCantidad
							   END
						FROM SerieLoteMov WITH(NOLOCK)
						WHERE Empresa = @Empresa
						AND Modulo = 'INV'
						AND ID = @ID
						AND Articulo = @CrArticulo
						AND SerieLote = @CrSerieLote
					END

					INSERT @Bandera (Articulo, SerieLote, CantidadDispSL, SLMCantidad, CantidadS, Cantidad)
						VALUES (@CrArticulo, @CrSerieLote, @CrCantidadDispSL, @CrSLMCantidad, @CrCantidadSL, @CrCantidad)
					INSERT @BanderaF (SerieLote, Articulo, Cantidad)
						SELECT SerieLote
							  ,Articulo
							  ,Cantidad
						FROM @Bandera
						WHERE Articulo = @CrArticulo
						AND SerieLote = @CrSerieLote
						GROUP BY SerieLote
								,Articulo
								,Cantidad

					IF EXISTS (SELECT * FROM @BanderaF WHERE Articulo = @CrArticulo)
						UPDATE @BanderaF
						SET CantidadDispSL = (
							SELECT SUM(ISNULL(CantidadDispSL, 0)) CantidadDispSL
							FROM @Bandera
							WHERE Articulo = @CrArticulo
							AND SerieLote = @CrSerieLote
							GROUP BY Articulo
						)
						WHERE Articulo = @CrArticulo
						AND SerieLote = @CrSerieLote

				END

				IF @CrSLMArticulo IS NOT NULL
				BEGIN
					SET @CrCantidadAplicada = ISNULL(@CrCantidadAplicada, 0)
					SET @CrCantidadDispSL = ISNULL(@CrCantidadDispSL, 0)
				END

				WHILE @@FETCH_STATUS = 0
				BEGIN
				SET @CrCantidadDispSL = (@CrCantidadDispSL + (@CrCantidadSL - @CrSLMCantidad))
				INSERT @Bandera (Articulo, SerieLote, CantidadDispSL, SLMCantidad, CantidadS, Cantidad)
					VALUES (@CrArticulo, @CrSerieLote, @CrCantidadDispSL, @CrSLMCantidad, @CrCantidadSL, @CrCantidad)
				INSERT @BanderaF (SerieLote, Articulo, Cantidad)
					SELECT SerieLote
						  ,Articulo
						  ,Cantidad
					FROM @Bandera
					WHERE Articulo = @CrArticulo
					AND SerieLote = @CrSerieLote
					GROUP BY SerieLote
							,Articulo
							,Cantidad

				IF EXISTS (SELECT * FROM @BanderaF WHERE Articulo = @CrArticulo)
					UPDATE @BanderaF
					SET CantidadDispSL = (
						SELECT SUM(ISNULL(CantidadDispSL, 0)) CantidadDispSL
						FROM @Bandera
						WHERE Articulo = @CrArticulo
						AND SerieLote = @CrSerieLote
						GROUP BY Articulo
					)
					WHERE Articulo = @CrArticulo
					AND SerieLote = @CrSerieLote

				IF @CrArticulo = @CrSLMArticulo
					AND @CrSerieLote = @CrSLMSerieLote
					AND @CrSLMCantidad <= @CrCantidadSL
				BEGIN
					UPDATE SerieLoteMov WITH(NOLOCK)
					SET Cantidad =
					CASE
						WHEN @CrCantidadDispSL > @CrCantidad THEN @CrCantidad
						ELSE @CrCantidadDispSL
					END
					WHERE Empresa = @Empresa
					AND Modulo = 'INV'
					AND ID = @ID
					AND Articulo = @CrArticulo
					AND SerieLote = @CrSLMSerieLote
					SELECT @CrCantidadAplicada = @CrCantidadAplicada +
					 CASE
						 WHEN @CrCantidadDispSL > @CrCantidad THEN @CrCantidad
						 ELSE @CrCantidadDispSL
					 END
				END

				FETCH NEXT FROM CrSerieLoteMov INTO @CrSLMArticulo, @CrSLMSerieLote, @CrSLMCantidad
				END
				CLOSE CrSerieLoteMov
				DEALLOCATE CrSerieLoteMov
				FETCH NEXT FROM CrArticuloCantidad INTO @CrMov, @CrMovID, @CrRenglon, @CrRenglonID, @CrArticulo, @CrAlmacen, @CrCantidad, @CrSerieLote, @CrCantidadSL
				END
				CLOSE CrArticuloCantidad
				DEALLOCATE CrArticuloCantidad
				DELETE SerieLoteMov
				WHERE Empresa = @Empresa
					AND Modulo = 'INV'
					AND ID = @ID
					AND Cantidad = 0

				IF @Ok IS NOT NULL
				BEGIN
					DELETE SerieLoteMov
					WHERE Empresa = @Empresa
						AND Modulo = 'INV'
						AND ID = @ID
					EXEC spEliminarMov @Modulo
									  ,@ID
				END

			END

		END

		INSERT @BanderaFinal (Articulo, Cantidad, CantidadDispSL)
			SELECT Articulo
				  ,(SUM(Cantidad) / COUNT(Serielote))
				  ,SUM(CantidadDispSL)
			FROM @BanderaF
			GROUP BY Articulo

		IF EXISTS (SELECT * FROM @BanderaFinal WHERE Cantidad > CantidadDispSL)
		BEGIN
			SELECT @Ok = 20025
				  ,@OkRef = 'Articulo: ' + (
					   SELECT TOP 1 Articulo
					   FROM @BanderaFinal
					   WHERE Cantidad > CantidadDispSL
				   )
			EXEC spEliminarMov 'INV'
							  ,@ID
			RETURN
		END

		IF @Ok IS NULL
			SELECT @YaGeneroConsecutivo = 1

		IF @Ok IS NULL
		BEGIN

			IF @MovTipo = 'VTAS.EG'
				UPDATE Venta WITH(ROWLOCK)
				SET AlmacenDestino = (
					SELECT AlmacenDestinoEntregaGarantia
					FROM EmpresaCfg WITH(NOLOCK) 
					WHERE Empresa = @Empresa
				)
				WHERE ID = @ID

			IF @UtilizarMovTipo = 'VTAS.CO'
			BEGIN
				UPDATE Venta WITH(ROWLOCK)
				SET Condicion = NULL
				   ,Vencimiento = NULL
				   ,Referencia = RTRIM(@UtilizarMov) + ' ' + LTRIM(CONVERT(CHAR, @UtilizarMovID))
				WHERE ID = @ID
				SELECT @Precio = SUM(Precio * (Cantidad - ISNULL(CantidadCancelada, 0)) * (1 - (CASE DescuentoTipo
					 WHEN '$' THEN (ISNULL(DescuentoLinea, 0.0) / precio) * 100
					 ELSE ISNULL(DescuentoLinea, 0.0)
				 END) / 100))
				FROM VentaD WITH(ROWLOCK)
				WHERE ID = @UtilizarID
				INSERT INTO VentaD (Sucursal, ID, Renglon, Aplica, AplicaID, Articulo, Cantidad, Precio, Impuesto1, Almacen)
					VALUES (@Sucursal, @ID, 2048, @UtilizarMov, @UtilizarMovID, @CfgVentaContratosArticulo, 1, @Precio, @CfgVentaContratosImpuesto, @Almacen)
			END
			ELSE
			BEGIN
				EXEC spInvUtilizarTodoDetalle @Sucursal
											 ,@Modulo
											 ,@Base
											 ,@UtilizarID
											 ,@UtilizarMov
											 ,@UtilizarMovID
											 ,@UtilizarMovTipo
											 ,@ID
											 ,@GenerarDirecto
											 ,@Ok OUTPUT
											 ,@Empresa = @Empresa
											 ,@MovTipo = @MovTipo
				DELETE SerieLoteMov
				WHERE Empresa = @Empresa
					AND Modulo = 'INV'
					AND ID = @ID
					AND Articulo NOT IN (SELECT Articulo FROM INVD WITH(NOLOCK) WHERE ID = @Id)

				IF @MovTipo IN ('COMS.EG', 'COMS.EI', 'COMS.OI', 'INV.EI')
					EXEC spMovCopiarGastoDiverso @Modulo
												,@Sucursal
												,@UtilizarID
												,@ID

				IF @MovTipo IN ('VTAS.F', 'VTAS.FAR')
					AND @CfgLimiteRenFacturas > 0

					IF @FacturacionRapidaAgrupada = 1
						EXEC spInvLimiteRenFacturasAgrupada @ID
														   ,@CfgLimiteRenFacturas
					ELSE
						EXEC spInvLimiteRenFacturas @ID
												   ,@CfgLimiteRenFacturas

				IF @UtilizarMovTipo IN ('VTAS.VC', 'VTAS.VCR')
					AND @MovTipo NOT IN ('VTAS.DC', 'VTAS.DCR')
					UPDATE VentaD WITH(ROWLOCK)
					SET Almacen = @GenerarAlmacen
					WHERE ID = @ID
				ELSE

				IF @UtilizarMovTipo = 'INV.P'
					UPDATE InvD WITH(ROWLOCK)
					SET Almacen = @GenerarAlmacenDestino
					WHERE ID = @ID
				ELSE

				IF @UtilizarMovTipo = 'INV.SM'
					AND @MovTipo = 'INV.CM'
					UPDATE InvD WITH(ROWLOCK)
					SET Tipo = 'Salida'
					WHERE ID = @ID
				ELSE

				IF @UtilizarMovTipo = 'PROD.O'
					AND @MovTipo IN ('PROD.E', 'PROD.CO')
				BEGIN

					IF @CfgTipoMerma = '#'
						UPDATE ProdD WITH(ROWLOCK)
						SET Tipo = 'Entrada'
						   ,Cantidad = Cantidad - ISNULL(a.Merma, 0) - ISNULL(a.Desperdicio, 0)
						   ,Merma = a.Merma
						   ,Desperdicio = a.Desperdicio
						FROM ProdD d WITH(NOLOCK), Art a WITH(NOLOCK)
						WHERE d.Articulo = a.Articulo
						AND d.ID = @ID
					ELSE
						UPDATE ProdD WITH(ROWLOCK)
						SET Tipo = 'Entrada'
						   ,Cantidad = Cantidad - ISNULL(ROUND(d.Cantidad * (a.Merma / 100), 10), 0) - ISNULL(ROUND(d.Cantidad * (a.Desperdicio / 100), 10), 0)
						   ,Merma = ROUND(d.Cantidad * (a.Merma / 100), 10)
						   ,Desperdicio = ROUND(d.Cantidad * (a.Desperdicio / 100), 10)
						FROM ProdD d WITH(NOLOCK), Art a WITH(NOLOCK)
						WHERE d.Articulo = a.Articulo
						AND d.ID = @ID

					UPDATE ProdD WITH(ROWLOCK)
					SET CantidadInventario = Cantidad * Factor
					WHERE ID = @ID
				END

			END

			SELECT @UtilizarBase = @Base
				  ,@Base = 'TODO'
				  ,@IDGenerar = @ID
		END

	END
	ELSE

	IF @VoltearAlmacen = 1
		SELECT @AlmacenTemp = @GenerarAlmacen
			  ,@GenerarAlmacen = @GenerarAlmacenDestino
			  ,@GenerarAlmacenDestino = @AlmacenTemp

	IF @Modulo = 'VTAS'
		AND @Accion <> 'CANCELAR'
		AND @Estatus = 'SINAFECTAR'

		IF EXISTS (SELECT ConVigencia FROM Venta WITH(NOLOCK) WHERE ID = @ID AND ConVigencia = 1)
			UPDATE Cte WITH(ROWLOCK)
			SET VigenciaDesde = v.VigenciaDesde
			   ,VigenciaHasta = v.VigenciaHasta
			FROM Venta v WITH(NOLOCK)
			WHERE v.ID = @ID
			AND v.Cliente = Cte.Cliente

	IF @Accion = 'GENERAR'
		AND @Ok IS NULL
	BEGIN

		IF @Utilizar = 1
		BEGIN
			EXEC spMovTipo @Modulo
						  ,@Mov
						  ,@FechaAfectacion
						  ,@Empresa
						  ,NULL
						  ,NULL
						  ,@GenerarMovTipo OUTPUT
						  ,@GenerarPeriodo OUTPUT
						  ,@GenerarEjercicio OUTPUT
						  ,@Ok OUTPUT
			BEGIN TRANSACTION

			IF @UtilizarMovTipo IN ('VTAS.C', 'VTAS.CS', 'COMS.C')
			BEGIN
				EXEC spValidarTareas @Empresa
									,@Modulo
									,@UtilizarID
									,'CONCLUIDO'
									,@Ok OUTPUT
									,@OkRef OUTPUT

				IF @UtilizarMovTipo IN ('VTAS.C', 'VTAS.CS')
					UPDATE Venta WITH(ROWLOCK)
					SET Estatus = 'CONCLUIDO'
					WHERE ID = @UtilizarID
				ELSE

				IF @UtilizarMovTipo = 'COMS.C'
					UPDATE Compra WITH(ROWLOCK)
					SET Estatus = 'CONCLUIDO'
					WHERE ID = @UtilizarID

				IF @@ERROR <> 0
					SELECT @Ok = 1

			END

			IF @UtilizarBase = 'SELECCION'
				EXEC spInvAfectarUtilizarSeleccion @Modulo
												  ,@UtilizarID
												  ,@Ok OUTPUT
												  ,@OkRef OUTPUT

			IF @CfgVentaArtAlmacenEspecifico = 1
				AND @Modulo = 'VTAS'
			BEGIN

				IF @CfgVentaMultiAlmacen = 0
				BEGIN
					SELECT @AlmacenEspecificoVenta = NULL
					SELECT @AlmacenEspecificoVenta = MIN(NULLIF(RTRIM(AlmacenEspecificoVenta), ''))
					FROM Art a WITH(NOLOCK)
						,VentaD d WITH(NOLOCK)
					WHERE d.ID = @ID
					AND d.Articulo = a.Articulo
					AND a.AlmacenEspecificoVentaMov = @Mov
					AND NULLIF(RTRIM(a.AlmacenEspecificoVenta), '') IS NOT NULL

					IF @AlmacenEspecificoVenta IS NOT NULL
						UPDATE Venta WITH(ROWLOCK)
						SET Almacen = @AlmacenEspecificoVenta
						WHERE ID = @ID

				END
				ELSE
					UPDATE VentaD WITH(ROWLOCK)
					SET Almacen = NULLIF(RTRIM(AlmacenEspecificoVenta), '')
					FROM VentaD d WITH(NOLOCK), Art a WITH(NOLOCK)
					WHERE d.ID = @ID
					AND d.Articulo = a.Articulo
					AND a.AlmacenEspecificoVentaMov = @Mov
					AND NULLIF(RTRIM(a.AlmacenEspecificoVenta), '') IS NOT NULL

			END

			IF @UtilizarMovTipo IN ('VTAS.N', 'VTAS.NO', 'VTAS.NR', 'VTAS.FM')
				AND @MovTipo IN ('VTAS.N', 'VTAS.NO', 'VTAS.NR', 'VTAS.FM')
			BEGIN
				UPDATE VentaD WITH(ROWLOCK)
				SET Cantidad = -ABS(Cantidad)
				   ,CantidadInventario = -ABS(CantidadInventario)
				   ,Aplica = NULL
				   ,AplicaID = NULL
				WHERE ID = @ID
				UPDATE Venta WITH(ROWLOCK)
				SET Directo = 1
				   ,Referencia = RTRIM(@UtilizarMov) + ' ' + RTRIM(@UtilizarMovID)
				WHERE ID = @ID
			END

			IF @UtilizarMovTipo IN ('VTAS.N', 'VTAS.NO', 'VTAS.NR', 'VTAS.FM')
				AND @MovTipo = 'VTAS.SD'
			BEGIN
				UPDATE VentaD WITH(ROWLOCK)
				SET Aplica = NULL
				   ,AplicaID = NULL
				WHERE ID = @ID
				UPDATE Venta WITH(ROWLOCK)
				SET Directo = 1
				   ,Referencia = RTRIM(@UtilizarMov) + ' ' + RTRIM(@UtilizarMovID)
				WHERE ID = @ID
			END

			IF @Modulo = 'VTAS'
			BEGIN

				IF @MovTipo IN ('VTAS.N', 'VTAS.FM')
					UPDATE Venta WITH(ROWLOCK)
					SET Condicion = NULL
					   ,Vencimiento = NULL
					WHERE ID = @ID
				ELSE

				IF @MovTipo <> 'VTAS.FR'
				BEGIN
					EXEC spCalcularVencimiento @Modulo
											  ,@Empresa
											  ,@ClienteProv
											  ,@Condicion
											  ,@Hoy
											  ,@Vencimiento OUTPUT
											  ,NULL
											  ,@Ok OUTPUT
					UPDATE Venta WITH(ROWLOCK)
					SET Vencimiento = @Vencimiento
					WHERE ID = @ID
					AND Vencimiento <> @Vencimiento
				END

			END

			IF @UtilizarMovTipo = 'INV.P'
				UPDATE Inv WITH(ROWLOCK)
				SET Almacen = AlmacenDestino
				   ,AlmacenDestino = Almacen
				WHERE ID = @ID

			IF @MovTipo IN ('PROD.A', 'PROD.R', 'PROD.E')
				EXEC spProdAvanceTiempoCentro @ID
											 ,@MovTipo
											 ,@MovMoneda
											 ,@MovTipoCambio

			IF @GenerarMovTipo = 'INV.TMA'
				AND (
					SELECT WMSSugerirEntarimado
					FROM EmpresaCfg WITH(NOLOCK)
					WHERE Empresa = @Empresa
				)
				= 1
			BEGIN
				SELECT @OrigenP = Origen
					  ,@OrigenIDP = OrigenID
				FROM INV WITH(NOLOCK)
				WHERE ID = @ID
				SELECT @IDN = ID
				FROM INV WITH(NOLOCK)
				WHERE MOV = @OrigenP
				AND MOVID = @OrigenIDP
				SELECT @CrossDocking = CrossDocking
					  ,@Almacen = Almacen
					  ,@PosicionWMS = PosicionWMS
				FROM INV WITH(NOLOCK)
				WHERE ID = @IDN
				SELECT @EsCrossDocking = RTRIM(LTRIM(ISNULL(EsCrossDocking, '')))
					  ,@posicioncrossdocking = ISNULL(defposicioncrossdocking, '')
				FROM ALM WITH(NOLOCK)
				WHERE Almacen = @Almacen

				IF @posicioncrossdocking = ''
					AND @CrossDocking = 1
				BEGIN
					SELECT @Ok = Mensaje
						  ,@OkRef = Descripcion
					FROM MensajeLista WITH(NOLOCK)
					WHERE Mensaje = 20028
					SELECT @OkRef
					ROLLBACK TRANSACTION
					EXEC spEliminarMov @Modulo
									  ,@ID
					RETURN
				END

				IF @EsCrossDocking = ''
					AND @CrossDocking = 1
				BEGIN
					SELECT @Ok = Mensaje
						  ,@OkRef = Descripcion
					FROM MensajeLista WITH(NOLOCK)
					WHERE Mensaje = 20027
					SELECT @OkRef
					ROLLBACK TRANSACTION
					EXEC spEliminarMov @Modulo
									  ,@ID
					RETURN
				END

				IF @CrossDocking = 1
					AND @EsCrossDocking IN ('Si', 'No')
				BEGIN
					EXEC spEntarimarCrossDoking @Modulo
											   ,@IDGenerar
											   ,@Empresa
											   ,@ID
											   ,@Almacen
											   ,@PosicionWMS
				END
				ELSE
					EXEC spSugerirEntarimado @Modulo
											,@IDGenerar
											,@Empresa
											,@Sucursal
											,@Usuario
											,@Ok OUTPUT
											,@OkRef OUTPUT

			END

			IF @Ok IS NULL
				EXEC xpInvAfectar @ID
								 ,@Accion
								 ,@Base
								 ,@Empresa
								 ,@Usuario
								 ,@Modulo
								 ,@Mov
								 ,@MovID
								 ,@MovTipo
								 ,@MovMoneda
								 ,@MovTipoCambio
								 ,@Estatus
								 ,@EstatusNuevo
								 ,@FechaEmision
								 ,@FechaRegistro
								 ,@FechaAfectacion
								 ,@Conexion
								 ,@SincroFinal
								 ,@Sucursal
								 ,@UtilizarID
								 ,@UtilizarMovTipo
								 ,@Ok OUTPUT
								 ,@OkRef OUTPUT

			EXEC spInvProdSerieLoteDesdeOrden @Sucursal
											 ,@Modulo
											 ,@UtilizarID
											 ,@ID
											 ,1
											 ,@Accion
											 ,@Ok OUTPUT
											 ,@OkRef OUTPUT

			IF @LDI = 1
				AND @Ok IS NOT NULL
				AND EXISTS (SELECT * FROM LDIIDTemp WITH(NOLOCK) WHERE Estacion = @@SPID AND Modulo = @Modulo)
			BEGIN
				INSERT @LDILog (IDModulo, Modulo, Servicio, Fecha, TipoTransaccion, TipoSubservicio, CodigoRespuesta, DescripcionRespuesta, OrigenRespuesta, InfoAdicional, IDTransaccion, CodigoAutorizacion, Comprobante, Cadena, CadenaRespuesta, Importe, RIDCobro)
					SELECT IDModulo
						  ,Modulo
						  ,Servicio
						  ,Fecha
						  ,TipoTransaccion
						  ,TipoSubservicio
						  ,CodigoRespuesta
						  ,DescripcionRespuesta
						  ,OrigenRespuesta
						  ,InfoAdicional
						  ,IDTransaccion
						  ,CodigoAutorizacion
						  ,Comprobante
						  ,Cadena
						  ,CadenaRespuesta
						  ,Importe
						  ,RIDCobro
					FROM LDIMovLog WITH(NOLOCK)
					WHERE IDModulo = @ID
					AND ID IN (SELECT ID FROM LDIIDTemp WITH(NOLOCK) WHERE Estacion = @@SPID AND Modulo = @Modulo)
			END

			IF @Ok IS NULL
				COMMIT TRANSACTION
			ELSE
			BEGIN
				ROLLBACK TRANSACTION
				EXEC spEliminarMov @Modulo
								  ,@ID

				IF EXISTS (SELECT * FROM @LDILog)
				BEGIN
					INSERT LDIMovLog (IDModulo, Modulo, Servicio, Fecha, TipoTransaccion, TipoSubservicio, CodigoRespuesta, DescripcionRespuesta, OrigenRespuesta, InfoAdicional, IDTransaccion, CodigoAutorizacion, Comprobante, Cadena, CadenaRespuesta, Importe, RIDCobro)
						SELECT IDModulo
							  ,Modulo
							  ,Servicio
							  ,Fecha
							  ,TipoTransaccion
							  ,TipoSubservicio
							  ,CodigoRespuesta
							  ,DescripcionRespuesta
							  ,OrigenRespuesta
							  ,InfoAdicional
							  ,IDTransaccion
							  ,CodigoAutorizacion
							  ,Comprobante
							  ,Cadena
							  ,CadenaRespuesta
							  ,Importe
							  ,RIDCobro
						FROM @LDILog
				END

			END

		END

		RETURN
	END

	IF @MovTipo IN ('VTAS.N', 'VTAS.NO', 'VTAS.NR')
		AND @Accion = 'CANCELAR'
		AND @Estatus = 'CONCLUIDO'
		SELECT @Ok = 60060

	IF (@EstatusNuevo IN ('PENDIENTE', 'CONCLUIDO') AND @Modulo IN ('VTAS', 'COMS') AND @MovTipo IN ('VTAS.N', 'VTAS.NO', 'VTAS.NR', 'VTAS.FM', 'VTAS.F', 'VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX', 'VTAS.FB', 'VTAS.D', 'VTAS.DF', 'VTAS.B', 'COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI', 'COMS.D', 'COMS.B', 'COMS.CC', 'COMS.DC', 'COMS.CA', 'COMS.O'))
		OR (@EstatusNuevo = 'PROCESAR' AND @MovTipo IN ('VTAS.N', 'VTAS.NO', 'VTAS.NR'))
		OR (@EstatusNuevo = 'PENDIENTE' AND @MovTipo IN ('VTAS.VCR', 'VTAS.R') AND @VentaMovImpuestoDesdeRemision = 1)
		OR (@MovTipo IN ('VTAS.DCR') AND @EstatusNuevo IN ('PENDIENTE', 'CONCLUIDO') AND @Modulo = 'VTAS' AND @VentaMovImpuestoDesdeRemision = 1)
	BEGIN
		SELECT @MovImpuesto = 1
		CREATE TABLE #MovImpuesto (
			Renglon FLOAT NOT NULL
		   ,RenglonSub INT NOT NULL
		   ,Impuesto1 FLOAT NULL
		   ,Impuesto2 FLOAT NULL
		   ,Impuesto3 FLOAT NULL
		   ,Impuesto5 FLOAT NULL
		   ,Importe1 MONEY NULL
		   ,Importe2 MONEY NULL
		   ,Importe3 MONEY NULL
		   ,Importe5 MONEY NULL
		   ,Retencion1 FLOAT NULL
		   ,Retencion2 FLOAT NULL
		   ,Retencion3 FLOAT NULL
		   ,Excento1 BIT NULL DEFAULT 0
		   ,Excento2 BIT NULL DEFAULT 0
		   ,Excento3 BIT NULL DEFAULT 0
		   ,TipoImpuesto1 VARCHAR(10) COLLATE Database_Default NULL
		   ,TipoImpuesto2 VARCHAR(10) COLLATE Database_Default NULL
		   ,TipoImpuesto3 VARCHAR(10) COLLATE Database_Default NULL
		   ,TipoImpuesto5 VARCHAR(10) COLLATE Database_Default NULL
		   ,TipoRetencion1 VARCHAR(10) COLLATE Database_Default NULL
		   ,TipoRetencion2 VARCHAR(10) COLLATE Database_Default NULL
		   ,TipoRetencion3 VARCHAR(10) COLLATE Database_Default NULL
		   ,SubTotal MONEY NULL
		   ,ContUso VARCHAR(20) COLLATE Database_Default NULL
		   ,ContUso2 VARCHAR(20) COLLATE Database_Default NULL
		   ,ContUso3 VARCHAR(20) COLLATE Database_Default NULL
		   ,ClavePresupuestal VARCHAR(50) COLLATE Database_Default NULL
		   ,ClavePresupuestalImpuesto1 VARCHAR(50) COLLATE Database_Default NULL
		   ,DescuentoGlobal FLOAT NULL
		   ,LoteFijo VARCHAR(20) COLLATE Database_Default NULL
		   ,ImporteBruto MONEY NULL
		   ,OrigenModulo VARCHAR(5) COLLATE Database_Default NULL
		   ,OrigenModuloID INT NULL
		   ,OrigenConcepto VARCHAR(50) COLLATE Database_Default NULL
		   ,OrigenFecha DATETIME NULL
		)
	END

	IF @CobroIntegrado = 1
		AND @CfgVentaComisionesCobradas = 1
		AND @CfgComisionBase = 'COBRO'
	BEGIN
		SELECT @ComisionFactor = 1 - ABS(ISNULL(DelEfectivo / NULLIF((ISNULL(Importe1, 0) + ISNULL(Importe2, 0) + ISNULL(Importe3, 0) + ISNULL(Importe4, 0) + ISNULL(Importe5, 0) - ISNULL(Cambio, 0) + ISNULL(DelEfectivo, 0)), 0), 0.0))
		FROM VentaCobro WITH(NOLOCK)
		WHERE ID = @ID
	END

	IF @MovTipo = 'INV.CP'
		AND @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR')
		AND @Accion = 'AFECTAR'
		EXEC spAfectarCambioPresentacion @Sucursal
										,@ID
										,@Empresa
										,@MovMoneda
										,@MovTipoCambio
										,@CfgMultiUnidades
										,@CfgMultiUnidadesNivel
										,@CfgFormaCosteo
										,@CfgTipoCosteo
										,@Ok OUTPUT
										,@OkRef OUTPUT

	IF @Ok IS NULL
		AND @YaGeneroConsecutivo = 0
		EXEC spMovConsecutivo @Sucursal
							 ,@SucursalOrigen
							 ,@SucursalDestino
							 ,@Empresa
							 ,@Usuario
							 ,@Modulo
							 ,@Ejercicio
							 ,@Periodo
							 ,@ID
							 ,@Mov
							 ,NULL
							 ,@Estatus
							 ,@Concepto
							 ,@Accion
							 ,@Conexion
							 ,@SincroFinal
							 ,@MovID OUTPUT
							 ,@Ok OUTPUT
							 ,@OkRef OUTPUT

	IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR')
		AND @Accion <> 'CANCELAR'
		AND @Ok IS NULL
		EXEC spMovChecarConsecutivo @Empresa
								   ,@Modulo
								   ,@Mov
								   ,@MovID
								   ,NULL
								   ,@Ejercicio
								   ,@Periodo
								   ,@Ok OUTPUT
								   ,@OkRef OUTPUT

	IF @EstatusNuevo = 'CONFIRMAR'
		AND @MovTipo IN ('VTAS.N', 'VTAS.NO', 'VTAS.NR', 'VTAS.FM')
		RETURN

	IF @Accion IN ('CONSECUTIVO', 'SINCRO')
		AND @Ok IS NULL
	BEGIN

		IF @Accion = 'SINCRO'
			EXEC spAsignarSucursalEstatus @ID
										 ,@Modulo
										 ,@SucursalDestino
										 ,@Accion

		SELECT @Ok = 80060
			  ,@OkRef = @MovID
			  ,@Sucursal = @SucursalDestino
		RETURN
	END

	IF @Generar = 1
		AND @Ok IS NULL
	BEGIN

		IF @MovTipo = 'INV.IF'
			SELECT @GenerarEstatus = 'SINAFECTAR'
		ELSE
			SELECT @GenerarEstatus = 'CANCELADO'

		IF @MovTipo IN ('VTAS.C', 'VTAS.CS', 'VTAS.FR')
			SELECT @GenerarDirecto = 1
		ELSE
			SELECT @GenerarDirecto = 0

		EXEC spMovGenerar @Sucursal
						 ,@Empresa
						 ,@Modulo
						 ,@Ejercicio
						 ,@Periodo
						 ,@Usuario
						 ,@FechaRegistro
						 ,@GenerarEstatus
						 ,@Almacen
						 ,@AlmacenDestino
						 ,@Mov
						 ,@MovID
						 ,@GenerarDirecto
						 ,@GenerarMov
						 ,@GenerarSerie
						 ,@GenerarMovID OUTPUT
						 ,@IDGenerar OUTPUT
						 ,@Ok OUTPUT
						 ,@OkRef OUTPUT
	END

	IF @Ok IS NOT NULL
		OR @AfectarConsecutivo = 1
		RETURN

	IF @Conexion = 0
		BEGIN TRANSACTION

	EXEC spMovEstatus @Modulo
					 ,'AFECTANDO'
					 ,@ID
					 ,@Generar
					 ,@IDGenerar
					 ,@GenerarAfectado
					 ,@Ok OUTPUT

	IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
	BEGIN

		IF (
				SELECT Sincro
				FROM Version WITH(NOLOCK)
			)
			= 1
		BEGIN

			IF @Modulo = 'INV'
				EXEC sp_executesql N'UPDATE InvD WITH(ROWLOCK) SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)'
								  ,N'@Sucursal int, @ID int'
								  ,@Sucursal
								  ,@ID
			ELSE

			IF @Modulo = 'VTAS'
				EXEC sp_executesql N'UPDATE VentaD WITH(ROWLOCK) SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)'
								  ,N'@Sucursal int, @ID int'
								  ,@Sucursal
								  ,@ID
			ELSE

			IF @Modulo = 'COMS'
				EXEC sp_executesql N'UPDATE CompraD WITH(ROWLOCK) SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)'
								  ,N'@Sucursal int, @ID int'
								  ,@Sucursal
								  ,@ID
			ELSE

			IF @Modulo = 'PROD'
				EXEC sp_executesql N'UPDATE ProdD WITH(ROWLOCK) SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)'
								  ,N'@Sucursal int, @ID int'
								  ,@Sucursal
								  ,@ID

		END

	END

	IF @Modulo = 'INV'
		AND @WMS = 1
		AND @Accion = 'AFECTAR'
		AND @MovTipo = 'INV.A'
		AND @OrigenMovTipo = 'INV.IF'
	BEGIN
		UPDATE Tarima WITH(ROWLOCK)
		SET Estatus = 'BAJA'
		   ,Baja = GETDATE()
		FROM Tarima WITH(NOLOCK)
		JOIN InvD WITH(NOLOCK)
			ON Tarima.Posicion = InvD.PosicionReal
		JOIN Inv WITH(NOLOCK)
			ON InvD.ID = Inv.ID
		JOIN AlmPos WITH(NOLOCK)
			ON Inv.Almacen = AlmPos.Almacen
			AND InvD.PosicionReal = AlmPos.Posicion
		WHERE InvD.ID = @ID
		AND AlmPos.Tipo <> 'DOMICILIO'
	END

	IF @Ok IS NULL
		OR @Ok BETWEEN 80030 AND 81000
		EXEC xpInvAfectarAntes @ID
							  ,@Accion
							  ,@Base
							  ,@Empresa
							  ,@Usuario
							  ,@Modulo
							  ,@Mov
							  ,@MovID
							  ,@MovTipo
							  ,@MovMoneda
							  ,@MovTipoCambio
							  ,@Estatus
							  ,@EstatusNuevo
							  ,@FechaEmision
							  ,@FechaRegistro
							  ,@FechaAfectacion
							  ,@Conexion
							  ,@SincroFinal
							  ,@Sucursal
							  ,NULL
							  ,NULL
							  ,@Ok OUTPUT
							  ,@OkRef OUTPUT

	IF @Accion <> 'CANCELAR'
		AND @Estatus <> 'PENDIENTE'
	BEGIN
		EXEC spRegistrarMovimiento @Sucursal
								  ,@Empresa
								  ,@Modulo
								  ,@Mov
								  ,@MovID
								  ,@ID
								  ,@Ejercicio
								  ,@Periodo
								  ,@FechaRegistro
								  ,@FechaEmision
								  ,@Concepto
								  ,@Proyecto
								  ,@MovMoneda
								  ,@MovTipoCambio
								  ,@Usuario
								  ,@Autorizacion
								  ,@Referencia
								  ,@DocFuente
								  ,@Observaciones
								  ,@Generar
								  ,@GenerarMov
								  ,@GenerarMovID
								  ,@IDGenerar
								  ,@Ok OUTPUT
	END

	IF @MovTipo IN ('PROD.A', 'PROD.R', 'PROD.E')
		AND @Ok IS NULL
	BEGIN
		EXEC spProdCostearAvance @Sucursal
								,@Accion
								,@Empresa
								,@Modulo
								,@ID
								,@Mov
								,@MovID
								,@MovTipo
								,@MovMoneda
								,@MovTipoCambio
								,@FechaEmision
								,@FechaRegistro
								,@Usuario
								,@Proyecto
								,@Ejercicio
								,@Periodo
								,@Referencia
								,@Observaciones
								,@Ok OUTPUT
								,@OkRef OUTPUT

		IF @Estatus = 'SINAFECTAR'
			OR @Accion = 'CANCELAR'
			EXEC spProdAvance @Sucursal
							 ,@Accion
							 ,@Empresa
							 ,@FechaEmision
							 ,@FechaRegistro
							 ,@Usuario
							 ,@ID
							 ,@Mov
							 ,@MovID
							 ,@MovTipo
							 ,@Ok OUTPUT
							 ,@OkRef OUTPUT

	END

	IF @MovTipo = 'PROD.E'
		AND @EstatusNuevo = 'CONCLUIDO'
		AND @Accion <> 'CANCELAR'
		AND @Ok IS NULL
		EXEC spProdCostearEntrada @Empresa
								 ,@ID
								 ,@MovMoneda
								 ,@MovTipoCambio
								 ,@Ok OUTPUT
								 ,@OkRef OUTPUT

	IF @MovTipo IN ('VTAS.F', 'VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX', 'VTAS.FB')
		AND @CobroIntegrado = 0
		AND @FacturarVtasMostrador = 0
		AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
		AND @Accion <> 'CANCELAR'
		AND @Ok IS NULL
		EXEC xpOtrosCargos @Empresa
						  ,@ID
						  ,@ClienteProv
						  ,@MovMoneda
						  ,@MovTipoCambio
						  ,@Ok OUTPUT
						  ,@OkRef OUTPUT

	IF @AfectarDetalle = 1
		AND @Ok IS NULL
	BEGIN

		IF @Accion = 'CANCELAR'
			OR (@MovTipo IN ('VTAS.F', 'VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX') AND @EstatusNuevo = 'PENDIENTE')
			SELECT @MatarAntes = 1
		ELSE
			SELECT @MatarAntes = 0

		IF @AfectarMatando = 1
			AND @Utilizar = 0
			AND @MatarAntes = 1
			AND @Ok IS NULL
			EXEC spInvMatar @Sucursal
						   ,@ID
						   ,@Accion
						   ,@Base
						   ,@Empresa
						   ,@Usuario
						   ,@Modulo
						   ,@Mov
						   ,@MovID
						   ,@MovTipo
						   ,@Estatus
						   ,@EstatusNuevo
						   ,@FechaEmision
						   ,@FechaRegistro
						   ,@FechaAfectacion
						   ,@Ejercicio
						   ,@Periodo
						   ,@AfectarConsignacion
						   ,@AlmacenTipo
						   ,@AlmacenDestinoTipo
						   ,@CfgVentaSurtirDemas
						   ,@CfgCompraRecibirDemas
						   ,@CfgTransferirDemas
						   ,@CfgBackOrders
						   ,@CfgContX
						   ,@CfgContXGenerar
						   ,@CfgEmbarcar
						   ,@CfgImpInc
						   ,@CfgMultiUnidades
						   ,@CfgMultiUnidadesNivel
						   ,@Ok OUTPUT
						   ,@OkRef OUTPUT
						   ,@CfgPrecioMoneda = @CfgPrecioMoneda

		IF @Modulo = 'VTAS'
		BEGIN
			DECLARE
				crVentaDetalle
				CURSOR FOR
				SELECT d.Renglon
					  ,d.RenglonSub
					  ,d.RenglonID
					  ,d.RenglonTipo
					  ,ISNULL(d.Cantidad, 0.0)
					  ,ISNULL(d.CantidadObsequio, 0.0)
					  ,ISNULL(d.CantidadInventario, 0.0)
					  ,ISNULL(d.CantidadReservada, 0.0)
					  ,ISNULL(d.CantidadOrdenada, 0.0)
					  ,ISNULL(d.CantidadPendiente, 0.0)
					  ,ISNULL(d.CantidadA, 0.0)
					  ,ISNULL(d.Factor, 0.0)
					  ,NULLIF(RTRIM(d.Unidad), '')
					  ,d.Articulo
					  ,NULLIF(RTRIM(d.Subcuenta), '')
					  ,ISNULL(d.Costo, 0.0)
					  ,ISNULL(d.Precio, 0.0)
					  ,NULLIF(RTRIM(d.DescuentoTipo), '')
					  ,ISNULL(d.DescuentoLinea, 0.0)
					  ,ISNULL(d.Impuesto1, 0.0)
					  ,ISNULL(d.Impuesto2, 0.0)
					  ,ISNULL(d.Impuesto3, 0.0)
					  ,NULLIF(RTRIM(d.Aplica), '')
					  ,NULLIF(RTRIM(d.AplicaID), '')
					  ,d.Almacen
					  ,d.Agente
					  ,NULLIF(RTRIM(UPPER(a.Tipo)), '')
					  ,a.SerieLoteInfo
					  ,NULLIF(RTRIM(UPPER(a.TipoOpcion)), '')
					  ,ISNULL(a.Peso, 0.0)
					  ,ISNULL(a.Volumen, 0.0)
					  ,a.Unidad
					  ,ISNULL(d.Retencion1, 0.0)
					  ,ISNULL(d.Retencion2, 0.0)
					  ,ISNULL(d.Retencion3, 0.0)
					  ,d.UltimoReservadoCantidad
					  ,d.UltimoReservadoFecha
					  ,NULLIF(RTRIM(a.Comision), '')
					  ,NULLIF(RTRIM(d.Espacio), '')
					  ,a.LotesFijos
					  ,a.Actividades
					  ,a.CostoIdentificado
					  ,d.CostoUEPS
					  ,d.CostoPEPS
					  ,d.UltimoCosto
					  ,d.CostoEstandar
					  ,d.PrecioLista
					  ,d.PrecioTipoCambio
					  ,NULLIF(RTRIM(d.Posicion), '')
					  ,NULLIF(RTRIM(d.Tarima), '')
					  ,a.DepartamentoDetallista
					  ,a.Estatus
					  ,a.Situacion
					  ,a.Impuesto1Excento
					  ,a.Excento2
					  ,a.Excento3
					  ,d.TipoImpuesto1
					  ,d.TipoImpuesto2
					  ,d.TipoImpuesto3
					  ,a.TipoRetencion1
					  ,a.TipoRetencion2
					  ,a.TipoRetencion3
					  ,d.ContUso
					  ,d.ContUso2
					  ,d.ContUso3
					  ,d.Retencion1
					  ,d.Retencion2
					  ,d.Retencion3
					  ,ISNULL(d.AnticipoFacturado, 0)
				FROM VentaD d WITH(NOLOCK)
					,Art a WITH(NOLOCK)
				WHERE d.ID = @ID
				AND d.Articulo = a.Articulo
			OPEN crVentaDetalle
			FETCH NEXT FROM crVentaDetalle INTO @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @CantidadOriginal, @CantidadObsequio, @CantidadInventario, @CantidadReservada, @CantidadOrdenada, @CantidadPendiente, @CantidadA, @Factor, @MovUnidad, @Articulo, @Subcuenta, @Costo, @Precio, @DescuentoTipo, @DescuentoLinea, @Impuesto1, @Impuesto2, @Impuesto3, @AplicaMov, @AplicaMovID, @AlmacenRenglon, @AgenteRenglon, @ArtTipo, @ArtSerieLoteInfo, @ArtTipoOpcion, @Peso, @Volumen, @ArtUnidad, @MovRetencion1, @MovRetencion2, @MovRetencion3, @UltReservadoCantidad, @UltReservadoFecha, @ArtComision, @EspacioD, @ArtLotesFijos, @ArtActividades, @ArtCostoIdentificado, @ArtCostoUEPS, @ArtCostoPEPS, @ArtUltimoCosto, @ArtCostoEstandar, @ArtPrecioLista, @PrecioTipoCambio, @Posicion, @Tarima, @ArtDepartamentoDetallista, @ArtEstatus, @ArtSituacion, @ArtExcento1, @ArtExcento2, @ArtExcento3, @TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3, @ContUso, @ContUso2, @ContUso3, @Retencion1, @Retencion2, @Retencion3, @AnticipoFacturado

			IF @@ERROR <> 0
				SELECT @Ok = 1

		END
		ELSE

		IF @Modulo = 'COMS'
		BEGIN
			DECLARE
				crCompraDetalle
				CURSOR FOR
				SELECT d.Renglon
					  ,d.RenglonSub
					  ,d.RenglonID
					  ,d.RenglonTipo
					  ,ISNULL(d.Cantidad, 0.0)
					  ,ISNULL(d.CantidadInventario, 0.0)
					  ,d.Cantidad
					  ,d.Cantidad
					  ,ISNULL(d.CantidadPendiente, 0.0)
					  ,ISNULL(d.CantidadA, 0.0)
					  ,d.Factor
					  ,NULLIF(RTRIM(d.Unidad), '')
					  ,d.Articulo
					  ,NULLIF(RTRIM(d.Subcuenta), '')
					  ,ISNULL(d.Costo, 0.0)
					  ,ISNULL(d.Costo, 0.0)
					  ,NULLIF(RTRIM(d.DescuentoTipo), '')
					  ,ISNULL(d.DescuentoLinea, 0.0)
					  ,ISNULL(d.Impuesto1, 0.0)
					  ,ISNULL(d.Impuesto2, 0.0)
					  ,ISNULL(d.Impuesto3, 0.0)
					  ,ISNULL(d.Impuesto5, 0.0)
					  ,NULLIF(RTRIM(d.Aplica), '')
					  ,NULLIF(RTRIM(d.AplicaID), '')
					  ,d.Almacen
					  ,d.ServicioArticulo
					  ,d.ServicioSerie
					  ,NULLIF(RTRIM(UPPER(a.Tipo)), '')
					  ,a.SerieLoteInfo
					  ,NULLIF(RTRIM(UPPER(a.TipoOpcion)), '')
					  ,ISNULL(a.Peso, 0.0)
					  ,ISNULL(a.Volumen, 0.0)
					  ,a.Unidad
					  ,ISNULL(d.Retencion1, 0.0)
					  ,ISNULL(d.Retencion2, 0.0)
					  ,ISNULL(d.Retencion3, 0.0)
					  ,a.LotesFijos
					  ,a.Actividades
					  ,a.CostoIdentificado
					  ,d.CostoUEPS
					  ,d.CostoPEPS
					  ,d.UltimoCosto
					  ,d.CostoEstandar
					  ,d.PrecioLista
					  ,NULLIF(RTRIM(d.Posicion), '')
					  ,NULLIF(RTRIM(d.Tarima), '')
					  ,a.DepartamentoDetallista
					  ,a.Estatus
					  ,a.Situacion
					  ,a.Impuesto1Excento
					  ,a.Excento2
					  ,a.Excento3
					  ,d.TipoImpuesto1
					  ,d.TipoImpuesto2
					  ,d.TipoImpuesto3
					  ,d.TipoImpuesto5
					  ,d.TipoRetencion1
					  ,d.TipoRetencion2
					  ,d.TipoRetencion3
					  ,d.ContUso
					  ,d.ContUso2
					  ,d.ContUso3
					  ,d.ClavePresupuestal
					  ,d.FechaCaducidad
					  ,d.Retencion1
					  ,d.Retencion2
					  ,d.Retencion3
					  ,ISNULL(d.PosicionActual, '')
					  ,ISNULL(PosicionReal, '')
				FROM CompraD d WITH(NOLOCK)
					,Art a
				WHERE d.ID = @ID
				AND d.Articulo = a.Articulo
			OPEN crCompraDetalle
			FETCH NEXT FROM crCompraDetalle INTO @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @CantidadOriginal, @CantidadInventario, @CantidadReservada, @CantidadOrdenada, @CantidadPendiente, @CantidadA, @Factor, @MovUnidad, @Articulo, @Subcuenta, @Costo, @Precio, @DescuentoTipo, @DescuentoLinea, @Impuesto1, @Impuesto2, @Impuesto3, @Impuesto5, @AplicaMov, @AplicaMovID, @AlmacenRenglon, @ServicioArticulo, @ServicioSerie, @ArtTipo, @ArtSerieLoteInfo, @ArtTipoOpcion, @Peso, @Volumen, @ArtUnidad, @MovRetencion1, @MovRetencion2, @MovRetencion3, @ArtLotesFijos, @ArtActividades, @ArtCostoIdentificado, @ArtCostoUEPS, @ArtCostoPEPS, @ArtUltimoCosto, @ArtCostoEstandar, @ArtPrecioLista, @Posicion, @Tarima, @ArtDepartamentoDetallista, @ArtEstatus, @ArtSituacion, @ArtExcento1, @ArtExcento2, @ArtExcento3, @TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoImpuesto5, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3, @ContUso, @ContUso2, @ContUso3, @ClavePresupuestal, @FechaCaducidad, @Retencion1, @Retencion2, @Retencion3, @PosicionActual, @PosicionReal

			IF @@ERROR <> 0
				SELECT @Ok = 1

		END
		ELSE

		IF @Modulo = 'INV'
		BEGIN
			DECLARE
				crInvDetalle
				CURSOR FOR
				SELECT d.Renglon
					  ,d.RenglonSub
					  ,d.RenglonID
					  ,d.RenglonTipo
					  ,ISNULL(d.Cantidad, 0.0)
					  ,ISNULL(d.CantidadInventario, 0.0)
					  ,ISNULL(d.CantidadReservada, 0.0)
					  ,ISNULL(d.CantidadOrdenada, 0.0)
					  ,ISNULL(d.CantidadPendiente, 0.0)
					  ,ISNULL(d.CantidadA, 0.0)
					  ,d.Factor
					  ,NULLIF(RTRIM(d.Unidad), '')
					  ,d.Articulo
					  ,NULLIF(RTRIM(d.Subcuenta), '')
					  ,ISNULL(d.Costo, 0.0)
					  ,CONVERT(MONEY, NULL)
					  ,'$'
					  ,CONVERT(MONEY, NULL)
					  ,CONVERT(FLOAT, NULL)
					  ,CONVERT(FLOAT, NULL)
					  ,CONVERT(MONEY, NULL)
					  ,NULLIF(RTRIM(d.Aplica), '')
					  ,NULLIF(RTRIM(d.AplicaID), '')
					  ,d.Almacen
					  ,d.ProdSerieLote
					  ,NULLIF(RTRIM(UPPER(a.Tipo)), '')
					  ,a.SerieLoteInfo
					  ,NULLIF(RTRIM(UPPER(a.TipoOpcion)), '')
					  ,ISNULL(a.Peso, 0.0)
					  ,ISNULL(a.Volumen, 0.0)
					  ,a.Unidad
					  ,d.UltimoReservadoCantidad
					  ,d.UltimoReservadoFecha
					  ,d.Tipo
					  ,d.Producto
					  ,d.SubProducto
					  ,a.LotesFijos
					  ,a.Actividades
					  ,a.CostoIdentificado
					  ,d.CostoUEPS
					  ,d.CostoPEPS
					  ,d.UltimoCosto
					  ,d.CostoEstandar
					  ,d.PrecioLista
					  ,NULLIF(RTRIM(d.Posicion), '')
					  ,NULLIF(RTRIM(d.Tarima), '')
					  ,a.DepartamentoDetallista
					  ,a.Estatus
					  ,a.Situacion
					  ,a.Impuesto1Excento
					  ,a.Excento2
					  ,a.Excento3
					  ,a.TipoImpuesto1
					  ,a.TipoImpuesto2
					  ,a.TipoImpuesto3
					  ,a.TipoRetencion1
					  ,a.TipoRetencion2
					  ,a.TipoRetencion3
					  ,d.Seccion
					  ,d.FechaCaducidad
					  ,d.PosicionDestino
					  ,ISNULL(d.PosicionActual, '')
					  ,ISNULL(PosicionReal, '')
				FROM InvD d WITH(NOLOCK)
					,Art a WITH(NOLOCK)
				WHERE d.ID = @ID
				AND d.Articulo = a.Articulo
			OPEN crInvDetalle
			FETCH NEXT FROM crInvDetalle INTO @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @CantidadOriginal, @CantidadInventario, @CantidadReservada, @CantidadOrdenada, @CantidadPendiente, @CantidadA, @Factor, @MovUnidad, @Articulo, @Subcuenta, @Costo, @Precio, @DescuentoTipo, @DescuentoLinea, @Impuesto1, @Impuesto2, @Impuesto3, @AplicaMov, @AplicaMovID, @AlmacenRenglon, @ProdSerieLote, @ArtTipo, @ArtSerieLoteInfo, @ArtTipoOpcion, @Peso, @Volumen, @ArtUnidad, @UltReservadoCantidad, @UltReservadoFecha, @DetalleTipo, @Producto, @SubProducto, @ArtLotesFijos, @ArtActividades, @ArtCostoIdentificado, @ArtCostoUEPS, @ArtCostoPEPS, @ArtUltimoCosto, @ArtCostoEstandar, @ArtPrecioLista, @Posicion, @Tarima, @ArtDepartamentoDetallista, @ArtEstatus, @ArtSituacion, @ArtExcento1, @ArtExcento2, @ArtExcento3, @TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3, @Seccion, @FechaCaducidad, @PosicionDestino, @PosicionActual, @PosicionReal

			IF @@ERROR <> 0
				SELECT @Ok = 1

		END
		ELSE

		IF @Modulo = 'PROD'
		BEGIN
			DECLARE
				crProdDetalle
				CURSOR FOR
				SELECT d.Renglon
					  ,d.RenglonSub
					  ,d.RenglonID
					  ,d.RenglonTipo
					  ,ISNULL(d.Cantidad, 0.0)
					  ,ISNULL(d.CantidadInventario, 0.0)
					  ,ISNULL(d.CantidadReservada, 0.0)
					  ,ISNULL(d.CantidadOrdenada, 0.0)
					  ,ISNULL(d.CantidadPendiente, 0.0)
					  ,ISNULL(d.CantidadA, 0.0)
					  ,d.Factor
					  ,NULLIF(RTRIM(d.Unidad), '')
					  ,d.Articulo
					  ,NULLIF(RTRIM(d.Subcuenta), '')
					  ,ISNULL(d.Costo, 0.0)
					  ,CONVERT(MONEY, NULL)
					  ,'$'
					  ,CONVERT(MONEY, NULL)
					  ,CONVERT(FLOAT, NULL)
					  ,CONVERT(FLOAT, NULL)
					  ,CONVERT(MONEY, NULL)
					  ,NULLIF(RTRIM(d.Aplica), '')
					  ,NULLIF(RTRIM(d.AplicaID), '')
					  ,d.Almacen
					  ,NULLIF(RTRIM(d.ProdSerieLote), '')
					  ,NULLIF(RTRIM(UPPER(a.Tipo)), '')
					  ,a.SerieLoteInfo
					  ,NULLIF(RTRIM(UPPER(a.TipoOpcion)), '')
					  ,ISNULL(a.Peso, 0.0)
					  ,ISNULL(a.Volumen, 0.0)
					  ,a.Unidad
					  ,d.UltimoReservadoCantidad
					  ,d.UltimoReservadoFecha
					  ,d.Tipo
					  ,d.Merma
					  ,d.Desperdicio
					  ,d.Ruta
					  ,d.Orden
					  ,d.Centro
					  ,a.LotesFijos
					  ,a.Actividades
					  ,a.CostoIdentificado
					  ,d.CostoUEPS
					  ,d.CostoPEPS
					  ,d.UltimoCosto
					  ,d.CostoEstandar
					  ,d.PrecioLista
					  ,NULLIF(RTRIM(d.Posicion), '')
					  ,NULLIF(RTRIM(d.Tarima), '')
					  ,a.DepartamentoDetallista
					  ,a.Estatus
					  ,a.Situacion
					  ,a.Impuesto1Excento
					  ,a.Excento2
					  ,a.Excento3
					  ,a.TipoImpuesto1
					  ,a.TipoImpuesto2
					  ,a.TipoImpuesto3
					  ,a.TipoRetencion1
					  ,a.TipoRetencion2
					  ,a.TipoRetencion3
				FROM ProdD d WITH(NOLOCK)
					,Art a
				WHERE d.ID = @ID
				AND d.Articulo = a.Articulo
			OPEN crProdDetalle
			FETCH NEXT FROM crProdDetalle INTO @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @CantidadOriginal, @CantidadInventario, @CantidadReservada, @CantidadOrdenada, @CantidadPendiente, @CantidadA, @Factor, @MovUnidad, @Articulo, @Subcuenta, @Costo, @Precio, @DescuentoTipo, @DescuentoLinea, @Impuesto1, @Impuesto2, @Impuesto3, @AplicaMov, @AplicaMovID, @AlmacenRenglon, @ProdSerieLote, @ArtTipo, @ArtSerieLoteInfo, @ArtTipoOpcion, @Peso, @Volumen, @ArtUnidad, @UltReservadoCantidad, @UltReservadoFecha, @DetalleTipo, @Merma, @Desperdicio, @Ruta, @Orden, @Centro, @ArtLotesFijos, @ArtActividades, @ArtCostoIdentificado, @ArtCostoUEPS, @ArtCostoPEPS, @ArtUltimoCosto, @ArtCostoEstandar, @ArtPrecioLista, @Posicion, @Tarima, @ArtDepartamentoDetallista, @ArtEstatus, @ArtSituacion, @ArtExcento1, @ArtExcento2, @ArtExcento3, @TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3

			IF @@ERROR <> 0
				SELECT @Ok = 1

		END

		WHILE @@FETCH_STATUS <> -1
		AND @Ok IS NULL
		BEGIN
		EXEC xpInvAfectarDetalleAntes @ID
									 ,@Accion
									 ,@Base
									 ,@Empresa
									 ,@Usuario
									 ,@Modulo
									 ,@Mov
									 ,@MovID
									 ,@MovTipo
									 ,@MovMoneda
									 ,@MovTipoCambio
									 ,@Estatus
									 ,@EstatusNuevo
									 ,@FechaEmision
									 ,@FechaRegistro
									 ,@FechaAfectacion
									 ,@Conexion
									 ,@SincroFinal
									 ,@Sucursal
									 ,@Renglon
									 ,@RenglonSub
									 ,@Articulo
									 ,@Cantidad
									 ,@Importe
									 ,@ImporteNeto
									 ,@Impuestos
									 ,@ImpuestosNetos
									 ,@Ok OUTPUT
									 ,@OkRef OUTPUT
		SELECT @CantidadPendienteA = @CantidadPendiente
			  ,@CantidadOrdenadaA = @CantidadOrdenada

		IF @CfgVentaMultiAgente = 1
			AND @Modulo = 'VTAS'
			SELECT @Agente = @AgenteRenglon

		IF @CP = 1
			SELECT @ClavePresupuestalImpuesto1 = ClavePresupuestalImpuesto1
			FROM Art WITH(NOLOCK)
			WHERE Articulo = @Articulo

		IF @CfgMultiUnidades = 0
		BEGIN

			IF @Modulo = 'COMS'
				SELECT @ArtUnidad = UnidadCompra
				FROM Art WITH(NOLOCK)
				WHERE Articulo = @Articulo

			SELECT @MovUnidad = @ArtUnidad
		END

		IF @Agente <> @UltAgente
			AND @UltAgente IS NOT NULL
			AND @ComisionAcum <> 0.0
			AND @Ok IS NULL
			AND (((@MovTipo IN ('VTAS.F', 'VTAS.FAR', 'VTAS.FB', 'VTAS.D', 'VTAS.DF', 'VTAS.B') AND (@Estatus = 'SINAFECTAR' OR @EstatusNuevo = 'CANCELADO')) AND (@CfgVentaComisionesCobradas = 0 OR @CobroIntegrado = 1 OR @CobrarPedido = 1)) OR @MovTipo IN ('VTAS.FM', 'VTAS.N', 'VTAS.NO', 'VTAS.NR'))
		BEGIN
			EXEC spGenerarCx @Sucursal
							,@SucursalOrigen
							,@SucursalDestino
							,@Accion
							,'AGENT'
							,@Empresa
							,@Modulo
							,@ID
							,@Mov
							,@MovID
							,@MovTipo
							,@MovMoneda
							,@MovTipoCambio
							,@FechaAfectacion
							,@Concepto
							,@Proyecto
							,@Usuario
							,@Autorizacion
							,@Referencia
							,@DocFuente
							,@Observaciones
							,@FechaRegistro
							,@Ejercicio
							,@Periodo
							,NULL
							,NULL
							,@ClienteProv
							,NULL
							,@UltAgente
							,NULL
							,NULL
							,NULL
							,@ComisionImporteNeto
							,NULL
							,NULL
							,@ComisionAcum
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,@CxModulo
							,@CxMov
							,@CxMovID
							,@Ok OUTPUT
							,@OkRef OUTPUT
			SELECT @ComisionAcum = 0.0
				  ,@ComisionImporteNeto = 0.0
		END

		SELECT @UltAgente = @Agente

		IF @Renglon = @ExplotandoRenglon
			SELECT @ExplotandoSubCuenta = 1
		ELSE
			SELECT @ExplotandoSubCuenta = 0

		SELECT @Almacen = @AlmacenOriginal
			  ,@AlmacenDestino = @AlmacenDestinoOriginal

		IF @AfectarAlmacenRenglon = 1
			SELECT @Almacen = NULLIF(RTRIM(@AlmacenRenglon), '')

		IF @AlmacenEspecifico IS NOT NULL
			SELECT @Almacen = @AlmacenEspecifico

		IF @VoltearAlmacen = 1
			SELECT @AlmacenTemp = @Almacen
				  ,@Almacen = @AlmacenDestino
				  ,@AlmacenDestino = @AlmacenTemp

		IF @EsTransferencia = 0
			SELECT @AlmacenDestino = NULL

		IF @Almacen IS NOT NULL
			SELECT @AlmacenTipo = UPPER(Tipo)
			FROM Alm WITH(NOLOCK)
			WHERE Almacen = @AlmacenRenglon

		IF @AlmacenDestino IS NOT NULL
			SELECT @AlmacenDestinoTipo = UPPER(Tipo)
			FROM Alm WITH(NOLOCK)
			WHERE Almacen = @AlmacenDestino

		SELECT @SucursalAlmacen = Sucursal
			  ,@WMSAlmacen = ISNULL(WMS, 0)
		FROM Alm WITH(NOLOCK)
		WHERE Almacen = @Almacen

		IF @AlmacenDestino IS NOT NULL
			SELECT @SucursalAlmacenDestino = Sucursal
			FROM Alm WITH(NOLOCK)
			WHERE Almacen = @AlmacenDestino

		IF @WMS = 1
			AND @WMSAlmacen = 1
			AND NULLIF(RTRIM(@Tarima), '') IS NOT NULL
		BEGIN
			EXEC spTarimaAlta @Empresa
							 ,@Sucursal
							 ,@Usuario
							 ,@Almacen
							 ,NULL
							 ,@FechaCaducidad
							 ,@Tarima
							 ,@Ok OUTPUT
							 ,@OkRef OUTPUT
							 ,@PosicionReal
		END

		IF @WMS = 1
			AND @WMSAlmacen = 1
			AND @Tarima IS NOT NULL
			AND @Modulo = 'INV'
			AND @Accion = 'CANCELAR'
			AND @MovTipo = 'INV.A'
			AND ISNULL(@CantidadInventario, 0) < 0
		BEGIN

			IF (
					SELECT Tipo
					FROM AlmPos WITH(NOLOCK)
					WHERE AlmPos.Almacen = @Almacen
					AND AlmPos.Posicion = @PosicionReal
				)
				NOT IN ('Domicilio', 'Recibo')

				IF dbo.fnAlmPosTieneCapacidad(@Empresa, @Almacen, @PosicionReal, @Tarima) = 0
					SELECT @Ok = 13220
						  ,@OkRef = @PosicionReal

		END

		IF @WMS = 1
			AND @WMSAlmacen = 1
			AND @Tarima IS NOT NULL
			AND @Modulo = 'INV'
			AND @Accion = 'AFECTAR'
			AND @MovTipo = 'INV.A'
			AND ISNULL(@CantidadInventario, 0) > 0
		BEGIN

			IF (
					SELECT Tipo
					FROM AlmPos WITH(NOLOCK)
					WHERE AlmPos.Almacen = @Almacen
					AND AlmPos.Posicion = @PosicionReal
				)
				NOT IN ('Domicilio', 'Recibo')

				IF dbo.fnAlmPosTieneCapacidad(@Empresa, @Almacen, @PosicionReal, @Tarima) = 0
					SELECT @Ok = 13220
						  ,@OkRef = @PosicionReal

		END

		SELECT @AplicaMovTipo = NULL
			  ,@IDAplica = NULL

		IF @AplicaMov <> NULL
		BEGIN
			SELECT @AplicaMovTipo = Clave
			FROM MovTipo WITH(NOLOCK)
			WHERE Modulo = @Modulo
			AND Mov = @AplicaMov

			IF @Modulo = 'VTAS'
				SELECT @IDAplica = ID
				FROM Venta WITH(NOLOCK)
				WHERE Empresa = @Empresa
				AND Mov = @AplicaMov
				AND MovID = @AplicaMovID
				AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR', 'CANCELADO')
			ELSE

			IF @Modulo = 'COMS'
				SELECT @IDAplica = ID
				FROM Compra WITH(NOLOCK)
				WHERE Empresa = @Empresa
				AND Mov = @AplicaMov
				AND MovID = @AplicaMovID
				AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR', 'CANCELADO')
			ELSE

			IF @Modulo = 'PROD'
				SELECT @IDAplica = ID
				FROM Prod WITH(NOLOCK)
				WHERE Empresa = @Empresa
				AND Mov = @AplicaMov
				AND MovID = @AplicaMovID
				AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR', 'CANCELADO')
			ELSE

			IF @Modulo = 'INV'
				SELECT @IDAplica = ID
				FROM Inv WITH(NOLOCK)
				WHERE Empresa = @Empresa
				AND Mov = @AplicaMov
				AND MovID = @AplicaMovID
				AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR', 'CANCELADO')

			IF @MovTipo = 'INV.EI'
				AND @IDAplica IS NOT NULL
			BEGIN
				SELECT @IDSalidaTraspaso = o.ID
				FROM Inv i WITH(NOLOCK)
				JOIN Inv o WITH(NOLOCK)
					ON o.Empresa = i.Empresa
					AND o.Mov = i.Origen
					AND o.MovID = i.OrigenID
					AND o.Estatus IN ('PENDIENTE', 'CONCLUIDO')
				WHERE i.ID = @IDAplica
			END

		END

		EXEC spInvInitRenglon @Empresa
							 ,0
							 ,@CfgMultiUnidades
							 ,@CfgMultiUnidadesNivel
							 ,@CfgCompraFactorDinamico
							 ,@CfgInvFactorDinamico
							 ,@CfgProdFactorDinamico
							 ,@CfgVentaFactorDinamico
							 ,0
							 ,0
							 ,0
							 ,@Accion
							 ,@Base
							 ,@Modulo
							 ,@ID
							 ,@Renglon
							 ,@RenglonSub
							 ,@Estatus
							 ,@EstatusNuevo
							 ,@MovTipo
							 ,@FacturarVtasMostrador
							 ,@EsTransferencia
							 ,@AfectarConsignacion
							 ,@ExplotandoSubCuenta
							 ,@AlmacenTipo
							 ,@AlmacenDestinoTipo
							 ,@Articulo
							 ,@MovUnidad
							 ,@ArtUnidad
							 ,@ArtTipo
							 ,@RenglonTipo
							 ,@AplicaMovTipo
							 ,@CantidadOriginal
							 ,@CantidadInventario
							 ,@CantidadPendiente
							 ,@CantidadA
							 ,@DetalleTipo
							 ,@Cantidad OUTPUT
							 ,@CantidadCalcularImporte OUTPUT
							 ,@CantidadReservada OUTPUT
							 ,@CantidadOrdenada OUTPUT
							 ,@EsEntrada OUTPUT
							 ,@EsSalida OUTPUT
							 ,@SubCuenta OUTPUT
							 ,@AfectarPiezas OUTPUT
							 ,@AfectarCostos OUTPUT
							 ,@AfectarUnidades OUTPUT
							 ,@Factor OUTPUT
							 ,@Ok OUTPUT
							 ,@OkRef OUTPUT
							 ,@Seccion = @Seccion
		SELECT @Importe = 0.0
			  ,@ImporteNeto = 0.0
			  ,@Impuestos = 0.0
			  ,@ImpuestosNetos = 0.0
			  ,@Impuesto1Neto = 0.0
			  ,@Impuesto2Neto = 0.0
			  ,@Impuesto3Neto = 0.0
			  ,@Impuesto5Neto = 0.0
			  ,@DescuentoLineaImporte = 0.0
			  ,@DescuentoGlobalImporte = 0.0
			  ,@SobrePrecioImporte = 0.0
			  ,@ImporteComision = 0.0
			  ,@CostoInvTotal = 0.0

		IF @@FETCH_STATUS <> -2
			AND @Cantidad <> 0.0
			AND @Ok IS NULL
		BEGIN
			SELECT @CostosImpuestoIncluido = 0

			IF @CfgCompraCostosImpuestoIncluido = 1
				AND @AlmacenTipo <> 'ACTIVOS FIJOS'
				SELECT @CostosImpuestoIncluido = 1

			SELECT @ArtMoneda = MonedaCosto
				  ,@SeriesLotesAutoOrden = ISNULL(NULLIF(NULLIF(RTRIM(UPPER(SeriesLotesAutoOrden)), ''), '(EMPRESA)'), @CfgSeriesLotesAutoOrden)
			FROM Art WITH(NOLOCK)
			WHERE Articulo = @Articulo

			IF @Generar = 0
				OR @GenerarAfectado = 1
			BEGIN

				IF @Modulo = 'COMS'
					AND @MovTipo IN ('COMS.OG', 'COMS.IG', 'COMS.DG')
				BEGIN
					SELECT @Costo = 0.0
						  ,@Precio = 0.0
					UPDATE CompraD WITH(ROWLOCK)
					SET Costo = NULL
					WHERE CURRENT OF crCompraDetalle
				END

				SELECT @AfectarSerieLote = 0

				IF @MovTipo IN ('VTAS.F', 'VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX')
					AND @AplicaMovTipo = 'VTAS.R'
					SELECT @FacturandoRemision = 1
				ELSE
					SELECT @FacturandoRemision = 0

				IF @ArtTipo IN ('SERIE', 'LOTE', 'VIN', 'PARTIDA')
					AND @CfgSeriesLotesMayoreo = 1
					AND (@EsEntrada = 1 OR @EsSalida = 1 OR @EsTransferencia = 1 OR @MovTipo IN ('COMS.B', 'COMS.CA', 'COMS.GX'))
					AND @FacturarVtasMostrador = 0
					AND @FacturandoRemision = 0
				BEGIN

					IF @MovTipo = 'INV.A'
					BEGIN
						SELECT @Tarima = ISNULL(dbo.fnAlmacenTarima(@Almacen, @Tarima), '')
						DECLARE
							crArtInv
							CURSOR FOR
							SELECT TOP 1 SerieLote
							FROM SerieLote WITH(NOLOCK)
							WHERE Empresa = @Empresa
							AND Articulo = @Articulo
							AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
							AND Almacen = @Almacen
							AND ISNULL(@Tarima, '') = ISNULL(@Tarima, '')
							AND Sucursal = @Sucursal
							AND (Existencia IS NULL OR ExistenciaAlterna IS NULL)
							AND @CantidadOriginal > 0
							ORDER BY SerieLote
						OPEN crArtInv
						FETCH NEXT FROM crArtInv INTO @SerieLote
						WHILE @@FETCH_STATUS = 0
						BEGIN

						IF NOT EXISTS (SELECT * FROM SerieLoteMov WITH(NOLOCK) WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID AND RenglonID = @RenglonID)
						BEGIN
							INSERT SerieLoteMov (Sucursal, Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad)
								VALUES (@Sucursal, @Empresa, @Modulo, @ID, @RenglonID, @Articulo, ISNULL(@SubCuenta, ''), @SerieLote, @CantidadOriginal)
						END

						FETCH NEXT FROM crArtInv INTO @SerieLote
						END
						CLOSE crArtInv
						DEALLOCATE crArtInv
					END

					SELECT @AfectarSerieLote = 1

					IF @ArtSerieLoteInfo = 0
						EXEC spSeriesLotesSurtidoAuto @Sucursal
													 ,@Empresa
													 ,@Modulo
													 ,@EsSalida
													 ,@EsTransferencia
													 ,@ID
													 ,@RenglonID
													 ,@Almacen
													 ,@Articulo
													 ,@SubCuenta
													 ,@Cantidad
													 ,@Factor
													 ,@AlmacenTipo
													 ,@SeriesLotesAutoOrden
													 ,@Ok OUTPUT
													 ,@OkRef OUTPUT

				END

				SELECT @PrecioN = @Precio
					  ,@Impuesto1N = @Impuesto1
					  ,@Impuesto2N = @Impuesto2
					  ,@Impuesto3N = @Impuesto3
					  ,@Impuesto5N = @Impuesto5

				IF @Modulo IN ('VTAS', 'COMS')
					AND @Accion <> 'CANCELAR'
				BEGIN
					EXEC xpMovDPrecioImpuestos @Empresa
											  ,@Modulo
											  ,@ID
											  ,@Mov
											  ,@MovID
											  ,@MovTipo
											  ,@Renglon
											  ,@RenglonSub
											  ,@RenglonID
											  ,@ArtTipo
											  ,@Articulo
											  ,@SubCuenta
											  ,@Almacen
											  ,@CantidadOriginal
											  ,@PrecioN OUTPUT
											  ,@Impuesto1N OUTPUT
											  ,@Impuesto2N OUTPUT
											  ,@Impuesto3N OUTPUT
											  ,@Impuesto5N OUTPUT
											  ,@Ok OUTPUT
											  ,@OkRef OUTPUT

					IF @MovImpuesto = 1
					BEGIN

						IF @ArtTipo = 'LOTE'
							AND @ArtLotesFijos = 1
							AND @NoValidarDisponible = 0
							EXEC spLotesFijos @Empresa
											 ,@Sucursal
											 ,@FechaEmision
											 ,@ClienteProv
											 ,@EnviarA
											 ,@Modulo
											 ,@ID
											 ,@Mov
											 ,@MovID
											 ,@MovTipo
											 ,@Renglon
											 ,@RenglonSub
											 ,@RenglonID
											 ,@ArtTipo
											 ,@Articulo
											 ,@SubCuenta
											 ,@Almacen
											 ,@ZonaImpuesto
											 ,@CantidadOriginal
											 ,@Factor
											 ,@CfgImpInc
											 ,@EsEntrada
											 ,@Precio
											 ,@DescuentoTipo
											 ,@DescuentoLinea
											 ,@DescuentoGlobal
											 ,@SobrePrecio
											 ,@TipoImpuesto1
											 ,@TipoImpuesto2
											 ,@TipoImpuesto3
											 ,@TipoImpuesto5
											 ,@Impuesto1N OUTPUT
											 ,@Impuesto2N OUTPUT
											 ,@Impuesto3N OUTPUT
											 ,@Impuesto5N OUTPUT
											 ,@Ok OUTPUT
											 ,@OkRef OUTPUT
											 ,@CfgPrecioMoneda = @CfgPrecioMoneda
											 ,@MovTipoCambio = @MovTipoCambio
											 ,@PrecioTipoCambio = @PrecioTipoCambio
											 ,@ContUso = @ContUso
											 ,@ContUso2 = @ContUso2
											 ,@ContUso3 = @ContUso3
											 ,@ClavePresupuestal = @ClavePresupuestal
											 ,@ClavePresupuestalImpuesto1 = @ClavePresupuestalImpuesto1
											 ,@Retencion1 = @Retencion1
											 ,@Retencion2 = @Retencion2
											 ,@Retencion3 = @Retencion3

					END

				END

				IF @PrecioN <> @Precio
					OR @Impuesto1N <> @Impuesto1
					OR @Impuesto2 <> @Impuesto2N
					OR @Impuesto3 <> @Impuesto3N
					OR @Impuesto5 <> @Impuesto5N
				BEGIN
					SELECT @Precio = @PrecioN
						  ,@Impuesto1 = @Impuesto1N
						  ,@Impuesto2 = @Impuesto2N
						  ,@Impuesto3 = @Impuesto3N
						  ,@Impuesto5 = @Impuesto5N

					IF @Modulo = 'VTAS'
						UPDATE VentaD WITH(NOLOCK)
						SET Precio = @Precio
						   ,Impuesto1 = @Impuesto1
						   ,Impuesto2 = @Impuesto2
						   ,Impuesto3 = @Impuesto3
						WHERE CURRENT OF crVentaDetalle
					ELSE

					IF @Modulo = 'COMS'
					BEGIN

						IF @ArtTipo <> 'LOTE'
							AND @ArtLotesFijos <> 1
							AND @NoValidarDisponible <> 0
						BEGIN
							SELECT @Costo = @Precio
							UPDATE CompraD WITH(ROWLOCK)
							SET Costo = @Costo
							   ,Impuesto1 = @Impuesto1
							   ,Impuesto2 = @Impuesto2
							   ,Impuesto3 = @Impuesto3
							   ,Impuesto5 = @Impuesto5
							WHERE CURRENT OF crCompraDetalle
						END

					END

				END

				IF @ArtActividades = 1
				BEGIN

					IF @MovTipo IN ('VTAS.P', 'VTAS.S')
						EXEC spSugerirArtActividad @Empresa
												  ,@Sucursal
												  ,@ID
												  ,@Renglon
												  ,@RenglonSub
												  ,@Articulo
												  ,@CantidadOriginal
												  ,@Agente

					IF @MovTipo IN ('VTAS.F', 'VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX', 'VTAS.FB')
					BEGIN
						UPDATE VentaDAgente WITH(NOLOCK)
						SET CostoActividad = a.Costo
						FROM VentaDAgente d WITH(NOLOCK), Actividad a WITH(NOLOCK)
						WHERE d.ID = @ID
						AND d.Renglon = @Renglon
						AND d.RenglonSub = @RenglonSub
						AND d.Actividad = a.Actividad

						IF @CfgCosteoActividades = 'TIEMPO ESTANDAR'
							SELECT @CostoActividad = SUM(CostoActividad * CantidadEstandar)
							FROM VentaDAgente WITH(NOLOCK)
							WHERE ID = @ID
							AND Renglon = @Renglon
							AND RenglonSub = @RenglonSub
						ELSE
							SELECT @CostoActividad = SUM(CostoActividad * (CONVERT(FLOAT, Minutos) / 60))
							FROM VentaDAgente WITH(NOLOCK)
							WHERE ID = @ID
							AND Renglon = @Renglon
							AND RenglonSub = @RenglonSub

						UPDATE VentaD WITH(NOLOCK)
						SET CostoActividad = @CostoActividad / NULLIF(@MovTipoCambio, 0) / NULLIF(@CantidadOriginal, 0)
						WHERE CURRENT OF crVentaDetalle
					END

				END

				IF @Modulo IN ('VTAS', 'COMS')
				BEGIN
					EXEC spCalculaImporte @Accion
										 ,@Modulo
										 ,@CfgImpInc
										 ,@MovTipo
										 ,@EsEntrada
										 ,@CantidadCalcularImporte
										 ,@Precio
										 ,@DescuentoTipo
										 ,@DescuentoLinea
										 ,@DescuentoGlobal
										 ,@SobrePrecio
										 ,@Impuesto1
										 ,@Impuesto2
										 ,@Impuesto3
										 ,@Impuesto5
										 ,@Importe OUTPUT
										 ,@ImporteNeto OUTPUT
										 ,@DescuentoLineaImporte OUTPUT
										 ,@DescuentoGlobalImporte OUTPUT
										 ,@SobrePrecioImporte OUTPUT
										 ,@Impuestos OUTPUT
										 ,@ImpuestosNetos OUTPUT
										 ,@Impuesto1Neto OUTPUT
										 ,@Impuesto2Neto OUTPUT
										 ,@Impuesto3Neto OUTPUT
										 ,@Impuesto5Neto OUTPUT
										 ,@Articulo = @Articulo
										 ,@CantidadObsequio = @CantidadObsequio
										 ,@CfgPrecioMoneda = @CfgPrecioMoneda
										 ,@MovTipoCambio = @MovTipoCambio
										 ,@PrecioTipoCambio = @PrecioTipoCambio
										 ,@Retencion1 = @Retencion1
										 ,@Retencion2 = @Retencion2
										 ,@Retencion3 = @Retencion3
										 ,@ID = @ID
										 ,@AnticipoFacturado = @AnticipoFacturado

					IF @MovImpuesto = 1
						AND NOT (@ArtTipo = 'LOTE' AND @ArtLotesFijos = 1)
					BEGIN

						IF @Modulo = 'VTAS'
						BEGIN

							IF EXISTS (SELECT * FROM Venta v WITH(NOLOCK) JOIN MovTipo mt WITH(NOLOCK) ON v.Mov = mt.Mov AND mt.Modulo = @Modulo WHERE v.Empresa = @Empresa AND v.Mov = @AplicaMov AND v.MovID = @AplicaMovID AND mt.Clave IN ('VTAS.VCR', 'VTAS.R'))
								AND @VentaMovImpuestoDesdeRemision = 1
								AND @MovTipo IN ('VTAS.F', 'VTAS.DCR')
							BEGIN
								SELECT @ArrastrarMovImpuestoRemision = 1
								SELECT @MovImpuestoAplicaID = ID
									  ,@AplicaConcepto = Concepto
									  ,@AplicaFechaEmision = FechaEmision
								FROM Venta WITH(NOLOCK)
								WHERE Empresa = @Empresa
								AND Mov = @AplicaMov
								AND MovID = @AplicaMovID
							END
							ELSE
							BEGIN
								SELECT @ArrastrarMovImpuestoRemision = 0
									  ,@MovImpuestoAplicaID = NULL
									  ,@AplicaConcepto = NULL
									  ,@AplicaFechaEmision = NULL
							END

						END

						IF @CantidadOriginal < 0.0
							AND @AnticipoFacturado = 0
							SELECT @MovImpuestoFactor = -1.0
						ELSE
							SELECT @MovImpuestoFactor = 1.0

						IF @ArrastrarMovImpuestoRemision = 0
						BEGIN
							INSERT #MovImpuesto (Renglon, RenglonSub, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoImpuesto5, TipoRetencion1, TipoRetencion2, TipoRetencion3, Impuesto1, Impuesto2, Impuesto3, Impuesto5, Importe1, Importe2, Importe3, Importe5, SubTotal, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal, ImporteBruto)
								SELECT @Renglon
									  ,@RenglonSub
									  ,@MovRetencion1
									  ,@MovRetencion2
									  ,@MovRetencion3
									  ,@ArtExcento1
									  ,@ArtExcento2
									  ,@ArtExcento3
									  ,@TipoImpuesto1
									  ,@TipoImpuesto2
									  ,@TipoImpuesto3
									  ,@TipoImpuesto5
									  ,@TipoRetencion1
									  ,@TipoRetencion2
									  ,@TipoRetencion3
									  ,@Impuesto1
									  ,@Impuesto2
									  ,@Impuesto3
									  ,@Impuesto5
									  ,@Impuesto1Neto * @MovImpuestoFactor
									  ,@Impuesto2Neto * @MovImpuestoFactor
									  ,@Impuesto3Neto * @MovImpuestoFactor
									  ,@Impuesto5Neto * @MovImpuestoFactor
									  ,@ImporteNeto * @MovImpuestoFactor
									  ,@ContUso
									  ,@ContUso2
									  ,@ContUso3
									  ,@ClavePresupuestal
									  ,@ClavePresupuestalImpuesto1
									  ,@DescuentoGlobal
									  ,@Importe
						END
						ELSE
						BEGIN

							IF @ArrastrarMovImpuestoRemision = 1
							BEGIN
								INSERT #MovImpuesto (OrigenModulo, OrigenModuloID, Renglon, RenglonSub, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoImpuesto5, TipoRetencion1, TipoRetencion2, TipoRetencion3, Impuesto1, Impuesto2, Impuesto3, Impuesto5, Importe1, Importe2, Importe3, Importe5, SubTotal, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal, ImporteBruto, OrigenConcepto, OrigenFecha)
									SELECT 'VTAS'
										  ,@MovImpuestoAplicaID
										  ,@Renglon
										  ,@RenglonSub
										  ,@MovRetencion1
										  ,@MovRetencion2
										  ,@MovRetencion3
										  ,@ArtExcento1
										  ,@ArtExcento2
										  ,@ArtExcento3
										  ,@TipoImpuesto1
										  ,@TipoImpuesto2
										  ,@TipoImpuesto3
										  ,@TipoImpuesto5
										  ,@TipoRetencion1
										  ,@TipoRetencion2
										  ,@TipoRetencion3
										  ,@Impuesto1
										  ,@Impuesto2
										  ,@Impuesto3
										  ,@Impuesto5
										  ,@Impuesto1Neto * @MovImpuestoFactor
										  ,@Impuesto2Neto * @MovImpuestoFactor
										  ,@Impuesto3Neto * @MovImpuestoFactor
										  ,@Impuesto5Neto * @MovImpuestoFactor
										  ,@ImporteNeto * @MovImpuestoFactor
										  ,@ContUso
										  ,@ContUso2
										  ,@ContUso3
										  ,@ClavePresupuestal
										  ,@ClavePresupuestalImpuesto1
										  ,@DescuentoGlobal
										  ,@Importe
										  ,@AplicaConcepto
										  ,@AplicaFechaEmision
							END

						END

					END

					IF @Modulo = 'COMS'
					BEGIN
						SELECT @Costo = @ImporteNeto / @Cantidad
					END

					IF @@ERROR <> 0
						SELECT @Ok = 1

				END

				SELECT @AfectarCantidad = NULL

				IF @AfectarUnidades = 1
					AND @Ok IS NULL
				BEGIN
					EXEC spInvAfectarUnidades @SucursalAlmacen
											 ,@Accion
											 ,@Base
											 ,@Empresa
											 ,@Usuario
											 ,@Modulo
											 ,@ID
											 ,@Mov
											 ,@MovID
											 ,@MovTipo
											 ,@MovMoneda
											 ,@MovTipoCambio
											 ,@Estatus
											 ,@Articulo
											 ,@ArtMoneda
											 ,@ArtTipoCambio
											 ,@ArtTipo
											 ,@SubCuenta
											 ,@Almacen
											 ,@AlmacenTipo
											 ,@AlmacenDestino
											 ,@AlmacenDestinoTipo
											 ,@EsEntrada
											 ,@CantidadOriginal
											 ,@Cantidad
											 ,@Factor
											 ,@Renglon
											 ,@RenglonSub
											 ,@RenglonID
											 ,@RenglonTipo
											 ,@FechaRegistro
											 ,@FechaAfectacion
											 ,@Ejercicio
											 ,@Periodo
											 ,@AplicaMov
											 ,@AplicaMovID
											 ,@OrigenTipo
											 ,@AfectarCostos
											 ,@AfectarPiezas
											 ,@AfectarVtasMostrador
											 ,@FacturarVtasMostrador
											 ,@AfectarConsignacion
											 ,@EsTransferencia
											 ,@CfgSeriesLotesMayoreo
											 ,@CfgFormaCosteo
											 ,@CfgTipoCosteo
											 ,@CantidadReservada
											 ,@ReservadoParcial OUTPUT
											 ,@UltRenglonIDJuego OUTPUT
											 ,@CantidadJuego OUTPUT
											 ,@CantidadMinimaJuego OUTPUT
											 ,@UltReservadoCantidad OUTPUT
											 ,@UltReservadoFecha OUTPUT
											 ,@AfectarCantidad OUTPUT
											 ,@AfectarAlmacen OUTPUT
											 ,@AfectarAlmacenDestino OUTPUT
											 ,@Ok OUTPUT
											 ,@OkRef OUTPUT
											 ,@Tarima = @Tarima
				END
				ELSE
					SELECT @ReservadoParcial = 0.0
						  ,@AfectarAlmacen = @Almacen
						  ,@AfectarAlmacenDestino = @AlmacenDestino

				IF @FacturandoRemision = 1
					AND @Accion <> 'CANCELAR'
					AND @ArtTipo NOT IN ('JUEGO', 'SERVICIO')
				BEGIN
					SELECT @Costo = ISNULL(SUM(Cantidad * Costo) / NULLIF(SUM(Cantidad), 0.0), 0.0)
					FROM VentaD WITH(NOLOCK)
					WHERE ID = @IDAplica
					AND Articulo = @Articulo
					AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')

					IF @Costo = 0.0
						SELECT @AfectarCostos = 1
					ELSE
						UPDATE VentaD WITH(ROWLOCK)
						SET Costo = @Costo
						WHERE CURRENT OF crVentaDetalle

				END

				IF @Modulo = 'VTAS'
					AND @AlmacenTipo = 'GARANTIAS'
					AND @Accion <> 'CANCELAR'
				BEGIN
					UPDATE VentaD WITH(ROWLOCK)
					SET Costo = NULL
					WHERE CURRENT OF crVentaDetalle
					SELECT @Costo = 0.0
				END

				IF @EsSalida = 1
					AND @Modulo IN ('VTAS', 'INV')
					AND @EsTransferencia = 0
					AND @AlmacenTipo <> 'ACTIVOS FIJOS'
					AND @Accion = 'AFECTAR'
					AND @FacturarVtasMostrador = 0
					EXEC spChecarConsignacion @Empresa
											 ,@SucursalAlmacen
											 ,@Usuario
											 ,@Modulo
											 ,@Mov
											 ,@MovID
											 ,@FechaAfectacion
											 ,@Ejercicio
											 ,@Periodo
											 ,@ArtMoneda
											 ,@Almacen
											 ,@Tarima
											 ,@Articulo
											 ,@SubCuenta
											 ,@AfectarCantidad
											 ,@Ok OUTPUT
											 ,@OkRef OUTPUT

				IF @AfectarCostos = 1
					OR @EsTransferencia = 1
					OR @MovTipo IN ('COMS.CC', 'COMS.DC')
					AND @Ok IS NULL
				BEGIN

					IF @MovTipo IN ('COMS.EG', 'COMS.EI')
						SELECT @CostoInv = CostoInv
						FROM CompraD WITH(NOLOCK)
						WHERE ID = @ID
						AND Renglon = @Renglon
						AND RenglonSub = @RenglonSub
					ELSE

					IF @MovTipo IN ('INV.EI')
						SELECT @CostoInv = CostoInv
						FROM InvD WITH(NOLOCK)
						WHERE ID = @ID
						AND Renglon = @Renglon
						AND RenglonSub = @RenglonSub
					ELSE
						SELECT @CostoInv = @Costo

					IF @CostosImpuestoIncluido = 1
						SELECT @CostoInv = @CostoInv + (@ImpuestosNetos / @Cantidad)

					EXEC spArtCosto @SucursalAlmacen
								   ,@Accion
								   ,@Empresa
								   ,@Modulo
								   ,@AfectarCostos
								   ,@EsEntrada
								   ,@EsSalida
								   ,@EsTransferencia
								   ,@AfectarSerieLote
								   ,@CfgFormaCosteo
								   ,@CfgTipoCosteo
								   ,@ArtTipo
								   ,@Articulo
								   ,@SubCuenta
								   ,@Cantidad
								   ,@MovUnidad
								   ,@Factor
								   ,@CostoInv
								   ,@Costo
								   ,@Mov
								   ,@MovID
								   ,@MovTipo
								   ,@AplicaMovTipo
								   ,@FechaAfectacion
								   ,@MovMoneda
								   ,@MovTipoCambio
								   ,@ID
								   ,@RenglonID
								   ,@Almacen
								   ,@AlmacenTipo
								   ,0
								   ,@CfgCosteoSeries
								   ,@CfgCosteoLotes
								   ,@CfgCosteoMultipleSimultaneo
								   ,@ArtCostoIdentificado
								   ,@ArtCosto OUTPUT
								   ,@ArtAjusteCosteo OUTPUT
								   ,@ArtCostoUEPS OUTPUT
								   ,@ArtCostoPEPS OUTPUT
								   ,@ArtUltimoCosto OUTPUT
								   ,@ArtCostoEstandar OUTPUT
								   ,@ArtCostoPromedio OUTPUT
								   ,@ArtCostoReposicion
								   ,@ArtPrecioLista OUTPUT
								   ,@ArtMoneda OUTPUT
								   ,@ArtFactor OUTPUT
								   ,@ArtTipoCambio OUTPUT
								   ,@Ok OUTPUT
								   ,@Renglon = @Renglon
								   ,@RenglonSub = @RenglonSub
								   ,@OtraMoneda = @ValuacionOtraMoneda
								   ,@OtraMonedaTipoCambio = @ValuacionOtraMonedaTC
								   ,@OtraMonedaTipoCambioVenta = @ValuacionOtraMonedaTCV
								   ,@OtraMonedaTipoCambioCompra = @ValuacionOtraMonedaTCC

					IF @CfgCosteoNivelSubCuenta = 1
						AND @ArtTipoOpcion <> 'NO'
						EXEC spArtCosto @SucursalAlmacen
									   ,@Accion
									   ,@Empresa
									   ,@Modulo
									   ,@AfectarCostos
									   ,@EsEntrada
									   ,@EsSalida
									   ,@EsTransferencia
									   ,@AfectarSerieLote
									   ,@CfgFormaCosteo
									   ,@CfgTipoCosteo
									   ,@ArtTipo
									   ,@Articulo
									   ,@SubCuenta
									   ,@Cantidad
									   ,@MovUnidad
									   ,@Factor
									   ,@CostoInv
									   ,@Costo
									   ,@Mov
									   ,@MovID
									   ,@MovTipo
									   ,@AplicaMovTipo
									   ,@FechaAfectacion
									   ,@MovMoneda
									   ,@MovTipoCambio
									   ,@ID
									   ,@RenglonID
									   ,@Almacen
									   ,@AlmacenTipo
									   ,1
									   ,@CfgCosteoSeries
									   ,@CfgCosteoLotes
									   ,@CfgCosteoMultipleSimultaneo
									   ,@ArtCostoIdentificado
									   ,@ArtCosto OUTPUT
									   ,@ArtAjusteCosteo OUTPUT
									   ,@ArtCostoUEPS OUTPUT
									   ,@ArtCostoPEPS OUTPUT
									   ,@ArtUltimoCosto OUTPUT
									   ,@ArtCostoEstandar OUTPUT
									   ,@ArtCostoPromedio OUTPUT
									   ,@ArtCostoReposicion
									   ,@ArtPrecioLista OUTPUT
									   ,@ArtMoneda OUTPUT
									   ,@ArtFactor OUTPUT
									   ,@ArtTipoCambio OUTPUT
									   ,@Ok OUTPUT
									   ,@Renglon = @Renglon
									   ,@RenglonSub = @RenglonSub
									   ,@OtraMoneda = @ValuacionOtraMoneda
									   ,@OtraMonedaTipoCambio = @ValuacionOtraMonedaTC
									   ,@OtraMonedaTipoCambioVenta = @ValuacionOtraMonedaTCV
									   ,@OtraMonedaTipoCambioCompra = @ValuacionOtraMonedaTCC

					SELECT @ModificarCosto = @ArtCosto * @ArtFactor
						  ,@ModificarPrecio = @Precio
					EXEC xpMovModificarCostoPrecio @Accion
												  ,@Empresa
												  ,@Modulo
												  ,@ID
												  ,@Mov
												  ,@MovID
												  ,@MovTipo
												  ,@AfectarCostos
												  ,@EsEntrada
												  ,@EsSalida
												  ,@EsTransferencia
												  ,@Renglon
												  ,@RenglonSub
												  ,@Articulo
												  ,@SubCuenta
												  ,@MovUnidad
												  ,@ArtCosto
												  ,@ArtFactor
												  ,@ModificarCosto OUTPUT
												  ,@ModificarPrecio OUTPUT
												  ,@Ok OUTPUT
												  ,@OkRef OUTPUT

					IF @ModificarCosto <> @ArtCosto * @ArtFactor
						OR @ModificarPrecio <> @Precio
					BEGIN
						SELECT @ArtCosto = @ModificarCosto / @ArtFactor
							  ,@Precio = @ModificarPrecio

						IF @Modulo = 'VTAS'
							UPDATE VentaD WITH(ROWLOCK)
							SET Precio = @Precio
							WHERE CURRENT OF crVentaDetalle
						ELSE

						IF @Modulo = 'INV'
							UPDATE InvD WITH(ROWLOCK)
							SET Precio = @Precio
							WHERE CURRENT OF crInvDetalle

						EXEC spCalculaImporte @Accion
											 ,@Modulo
											 ,@CfgImpInc
											 ,@MovTipo
											 ,@EsEntrada
											 ,@CantidadCalcularImporte
											 ,@Precio
											 ,@DescuentoTipo
											 ,@DescuentoLinea
											 ,@DescuentoGlobal
											 ,@SobrePrecio
											 ,@Impuesto1
											 ,@Impuesto2
											 ,@Impuesto3
											 ,@Impuesto5
											 ,@Importe OUTPUT
											 ,@ImporteNeto OUTPUT
											 ,@DescuentoLineaImporte OUTPUT
											 ,@DescuentoGlobalImporte OUTPUT
											 ,@SobrePrecioImporte OUTPUT
											 ,@Impuestos OUTPUT
											 ,@ImpuestosNetos OUTPUT
											 ,@Impuesto1Neto OUTPUT
											 ,@Impuesto2Neto OUTPUT
											 ,@Impuesto3Neto OUTPUT
											 ,@Impuesto5Neto OUTPUT
											 ,@Articulo = @Articulo
											 ,@CantidadObsequio = @CantidadObsequio
											 ,@CfgPrecioMoneda = @CfgPrecioMoneda
											 ,@MovTipoCambio = @MovTipoCambio
											 ,@PrecioTipoCambio = @PrecioTipoCambio
											 ,@Retencion1 = @Retencion1
											 ,@Retencion2 = @Retencion2
											 ,@Retencion3 = @Retencion3
											 ,@ID = @ID
											 ,@AnticipoFacturado = @AnticipoFacturado

						IF @MovImpuesto = 1
							AND NOT (@ArtTipo = 'LOTE' AND @ArtLotesFijos = 1)
						BEGIN

							IF @Modulo = 'VTAS'
							BEGIN

								IF EXISTS (SELECT * FROM Venta v WITH(NOLOCK) JOIN MovTipo mt WITH(NOLOCK) ON v.Mov = mt.Mov AND mt.Modulo = @Modulo WHERE v.Empresa = @Empresa AND v.Mov = @AplicaMov AND v.MovID = @AplicaMovID AND mt.Clave IN ('VTAS.VCR', 'VTAS.R'))
									AND @VentaMovImpuestoDesdeRemision = 1
									AND @MovTipo IN ('VTAS.F', 'VTAS.DCR')
								BEGIN
									SELECT @ArrastrarMovImpuestoRemision = 1
									SELECT @MovImpuestoAplicaID = ID
										  ,@AplicaConcepto = Concepto
										  ,@AplicaFechaEmision = FechaEmision
									FROM Venta WITH(NOLOCK)
									WHERE Empresa = @Empresa
									AND Mov = @AplicaMov
									AND MovID = @AplicaMovID
								END
								ELSE
								BEGIN
									SELECT @ArrastrarMovImpuestoRemision = 0
										  ,@MovImpuestoAplicaID = NULL
										  ,@AplicaConcepto = NULL
										  ,@AplicaFechaEmision = NULL
								END

							END

							DELETE #MovImpuesto
							WHERE Renglon = @Renglon
								AND RenglonSub = @RenglonSub

							IF @CantidadOriginal < 0.0
								SELECT @MovImpuestoFactor = -1.0
							ELSE
								SELECT @MovImpuestoFactor = 1.0

							IF @ArrastrarMovImpuestoRemision = 0
							BEGIN
								INSERT #MovImpuesto (Renglon, RenglonSub, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoImpuesto5, TipoRetencion1, TipoRetencion2, TipoRetencion3, Impuesto1, Impuesto2, Impuesto3, Impuesto5, Importe1, Importe2, Importe3, Importe5, SubTotal, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal, ImporteBruto)
									SELECT @Renglon
										  ,@RenglonSub
										  ,@MovRetencion1
										  ,@MovRetencion2
										  ,@MovRetencion3
										  ,@ArtExcento1
										  ,@ArtExcento2
										  ,@ArtExcento3
										  ,@TipoImpuesto1
										  ,@TipoImpuesto2
										  ,@TipoImpuesto3
										  ,@TipoImpuesto5
										  ,@TipoRetencion1
										  ,@TipoRetencion2
										  ,@TipoRetencion3
										  ,@Impuesto1
										  ,@Impuesto2
										  ,@Impuesto3
										  ,@Impuesto5
										  ,@Impuesto1Neto * @MovImpuestoFactor
										  ,@Impuesto2Neto * @MovImpuestoFactor
										  ,@Impuesto3Neto * @MovImpuestoFactor
										  ,@Impuesto5Neto * @MovImpuestoFactor
										  ,@ImporteNeto * @MovImpuestoFactor
										  ,@ContUso
										  ,@ContUso2
										  ,@ContUso3
										  ,@ClavePresupuestal
										  ,@ClavePresupuestalImpuesto1
										  ,@DescuentoGlobal
										  ,@Importe
							END
							ELSE
							BEGIN

								IF @ArrastrarMovImpuestoRemision = 1
								BEGIN
									INSERT #MovImpuesto (OrigenModulo, OrigenModuloID, Renglon, RenglonSub, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoImpuesto5, TipoRetencion1, TipoRetencion2, TipoRetencion3, Impuesto1, Impuesto2, Impuesto3, Impuesto5, Importe1, Importe2, Importe3, Importe5, SubTotal, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal, ImporteBruto, OrigenConcepto, OrigenFecha)
										SELECT 'VTAS'
											  ,@MovImpuestoAplicaID
											  ,@Renglon
											  ,@RenglonSub
											  ,@MovRetencion1
											  ,@MovRetencion2
											  ,@MovRetencion3
											  ,@ArtExcento1
											  ,@ArtExcento2
											  ,@ArtExcento3
											  ,@TipoImpuesto1
											  ,@TipoImpuesto2
											  ,@TipoImpuesto3
											  ,@TipoImpuesto5
											  ,@TipoRetencion1
											  ,@TipoRetencion2
											  ,@TipoRetencion3
											  ,@Impuesto1
											  ,@Impuesto2
											  ,@Impuesto3
											  ,@Impuesto5
											  ,@Impuesto1Neto * @MovImpuestoFactor
											  ,@Impuesto2Neto * @MovImpuestoFactor
											  ,@Impuesto3Neto * @MovImpuestoFactor
											  ,@Impuesto5Neto * @MovImpuestoFactor
											  ,@ImporteNeto * @MovImpuestoFactor
											  ,@ContUso
											  ,@ContUso2
											  ,@ContUso3
											  ,@ClavePresupuestal
											  ,@ClavePresupuestalImpuesto1
											  ,@DescuentoGlobal
											  ,@Importe
											  ,@AplicaConcepto
											  ,@AplicaFechaEmision
								END

							END

						END

					END

					SELECT @ArtCostoInv = @ArtCosto

					IF @CfgCostearDC = 1
						AND @MovTipo IN ('COMS.D')
						SELECT @CostoInvTotal = @Costo * @Cantidad
					ELSE
						SELECT @CostoInvTotal = @ArtCosto * @Cantidad

					SELECT @ArtCantidad = ISNULL(@Cantidad, 0.0) * ISNULL(@Factor, 1.0)

					IF @MovTipo IN ('COMS.EG', 'COMS.EI', 'INV.EI')
						SELECT @ArtCosto = @Costo / @ArtFactor

					SELECT @PrecioSinImpuestos = dbo.fnPrecioSinImpuestos(@Empresa, @Articulo, @ArtPrecioLista)

					IF (@EsSalida = 1 OR @EsTransferencia = 1)
						AND @Accion <> 'CANCELAR'
						AND @Ok IS NULL
					BEGIN

						IF @Modulo = 'VTAS'
							UPDATE VentaD WITH(ROWLOCK)
							SET Unidad = @MovUnidad
							   ,Costo = @ArtCosto * @ArtFactor
							   ,AjusteCosteo = @ArtAjusteCosteo * @ArtFactor
							   ,CostoUEPS = @ArtCostoUEPS * @ArtFactor
							   ,CostoPEPS = @ArtCostoPEPS * @ArtFactor
							   ,UltimoCosto = @ArtUltimoCosto * @ArtFactor
							   ,CostoEstandar = @ArtCostoEstandar * @ArtFactor
							   ,PrecioLista = @PrecioSinImpuestos
							   ,DepartamentoDetallista = @ArtDepartamentoDetallista
							WHERE CURRENT OF crVentaDetalle
						ELSE

						IF @Modulo = 'INV'
							UPDATE InvD WITH(ROWLOCK)
							SET Unidad = @MovUnidad
							   ,Costo = @ArtCosto * @ArtFactor
							   ,AjusteCosteo = @ArtAjusteCosteo * @ArtFactor
							   ,CostoUEPS = @ArtCostoUEPS * @ArtFactor
							   ,CostoPEPS = @ArtCostoPEPS * @ArtFactor
							   ,UltimoCosto = @ArtUltimoCosto * @ArtFactor
							   ,CostoEstandar = @ArtCostoEstandar * @ArtFactor
							   ,PrecioLista = @PrecioSinImpuestos
							   ,DepartamentoDetallista = @ArtDepartamentoDetallista
							WHERE CURRENT OF crInvDetalle
						ELSE

						IF @Modulo = 'PROD'
							UPDATE ProdD WITH(ROWLOCK)
							SET Unidad = @MovUnidad
							   ,Costo = @ArtCosto * @ArtFactor
							   ,AjusteCosteo = @ArtAjusteCosteo * @ArtFactor
							   ,CostoUEPS = @ArtCostoUEPS * @ArtFactor
							   ,CostoPEPS = @ArtCostoPEPS * @ArtFactor
							   ,UltimoCosto = @ArtUltimoCosto * @ArtFactor
							   ,CostoEstandar = @ArtCostoEstandar * @ArtFactor
							   ,PrecioLista = @PrecioSinImpuestos
							   ,DepartamentoDetallista = @ArtDepartamentoDetallista
							WHERE CURRENT OF crProdDetalle
						ELSE

						IF @Modulo = 'COMS'
							UPDATE CompraD WITH(ROWLOCK)
							SET Unidad = @MovUnidad
							   ,AjusteCosteo = @ArtAjusteCosteo * @ArtFactor
							   ,CostoUEPS = @ArtCostoUEPS * @ArtFactor
							   ,CostoPEPS = @ArtCostoPEPS * @ArtFactor
							   ,UltimoCosto = @ArtUltimoCosto * @ArtFactor
							   ,CostoEstandar = @ArtCostoEstandar * @ArtFactor
							   ,PrecioLista = @PrecioSinImpuestos
							   ,DepartamentoDetallista = @ArtDepartamentoDetallista
							WHERE CURRENT OF crCompraDetalle

						IF @@ERROR <> 0
							SELECT @Ok = 1

						IF @MovTipo = 'COMS.D'
							UPDATE CompraD WITH(ROWLOCK)
							SET CostoInv = @ArtCosto
							WHERE CURRENT OF crCompraDetalle

					END
					ELSE
					BEGIN
						SELECT @AjustePrecioLista = NULL

						IF @MovTipo = 'INV.EI'
							AND @IDSalidaTraspaso IS NOT NULL
							SELECT @AjustePrecioLista = @PrecioSinImpuestos - (
								 SELECT MIN(PrecioLista)
								 FROM InvD WITH(NOLOCK)
								 WHERE ID = @IDSalidaTraspaso
								 AND Articulo = @Articulo
								 AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
								 AND ISNULL(Unidad, '') = ISNULL(@MovUnidad, '')
							 )

						IF @Modulo = 'VTAS'
							UPDATE VentaD WITH(ROWLOCK)
							SET Unidad = @MovUnidad
							   ,AjusteCosteo = @ArtAjusteCosteo * @ArtFactor
							   ,CostoUEPS = @ArtCostoUEPS * @ArtFactor
							   ,CostoPEPS = @ArtCostoPEPS * @ArtFactor
							   ,UltimoCosto = @ArtUltimoCosto * @ArtFactor
							   ,CostoEstandar = @ArtCostoEstandar * @ArtFactor
							   ,PrecioLista = @PrecioSinImpuestos
							   ,DepartamentoDetallista = @ArtDepartamentoDetallista
							WHERE CURRENT OF crVentaDetalle
						ELSE

						IF @Modulo = 'INV'
							UPDATE InvD WITH(ROWLOCK)
							SET Unidad = @MovUnidad
							   ,AjusteCosteo = @ArtAjusteCosteo * @ArtFactor
							   ,CostoUEPS = @ArtCostoUEPS * @ArtFactor
							   ,CostoPEPS = @ArtCostoPEPS * @ArtFactor
							   ,UltimoCosto = @ArtUltimoCosto * @ArtFactor
							   ,CostoEstandar = @ArtCostoEstandar * @ArtFactor
							   ,PrecioLista = @PrecioSinImpuestos
							   ,DepartamentoDetallista = @ArtDepartamentoDetallista
							   ,AjustePrecioLista = @AjustePrecioLista
							WHERE CURRENT OF crInvDetalle
						ELSE

						IF @Modulo = 'PROD'
							UPDATE ProdD WITH(ROWLOCK)
							SET Unidad = @MovUnidad
							   ,AjusteCosteo = @ArtAjusteCosteo * @ArtFactor
							   ,CostoUEPS = @ArtCostoUEPS * @ArtFactor
							   ,CostoPEPS = @ArtCostoPEPS * @ArtFactor
							   ,UltimoCosto = @ArtUltimoCosto * @ArtFactor
							   ,CostoEstandar = @ArtCostoEstandar * @ArtFactor
							   ,PrecioLista = @PrecioSinImpuestos
							   ,DepartamentoDetallista = @ArtDepartamentoDetallista
							WHERE CURRENT OF crProdDetalle
						ELSE

						IF @Modulo = 'COMS'
							UPDATE CompraD WITH(ROWLOCK)
							SET Unidad = @MovUnidad
							   ,AjusteCosteo = @ArtAjusteCosteo * @ArtFactor
							   ,CostoUEPS = @ArtCostoUEPS * @ArtFactor
							   ,CostoPEPS = @ArtCostoPEPS * @ArtFactor
							   ,UltimoCosto = @ArtUltimoCosto * @ArtFactor
							   ,CostoEstandar = @ArtCostoEstandar * @ArtFactor
							   ,PrecioLista = @PrecioSinImpuestos
							   ,DepartamentoDetallista = @ArtDepartamentoDetallista
							WHERE CURRENT OF crCompraDetalle

					END

					IF @MovTipo = 'VTAS.FC'
						AND NULLIF(RTRIM(@ServicioSerie), '') IS NOT NULL
						AND @CfgVINAccesorioArt = 1
						AND @CfgVINCostoSumaAccesorios = 1
						INSERT VINAccesorio (VIN, Tipo, Accesorio, Descripcion, PrecioDistribuidor, PrecioPublico, PrecioContado, FechaAlta, Estatus)
							SELECT @ServicioSerie
								  ,@Mov
								  ,@Articulo
								  ,a.Descripcion1
								  ,@ArtCosto * @Cantidad
								  ,a.PrecioLista * @Cantidad
								  ,a.Precio2 * @Cantidad
								  ,@FechaEmision
								  ,'ALTA'
							FROM Art a WITH(NOLOCK)
							WHERE a.Articulo = @Articulo

					IF @Modulo <> 'COMS'
						SELECT @Costo = @ArtCosto * @ArtFactor

					IF @AfectarCostos = 1
						AND @ArtTipo NOT IN ('JUEGO', 'SERVICIO')
						AND @Ok IS NULL
					BEGIN

						IF @EsEntrada = 1
							OR (@EsSalida = 0 AND @EsTransferencia = 1 AND @Accion <> 'CANCELAR')
							SELECT @EsCargo = 1
						ELSE
							SELECT @EsCargo = 0

						IF @MovTipo = 'COMS.B'

							IF @Accion <> 'CANCELAR'
								SELECT @EsCargo = 0
							ELSE
								SELECT @EsCargo = 1

						IF @MovTipo IN ('COMS.CA', 'COMS.GX')

							IF @Accion <> 'CANCELAR'
								SELECT @EsCargo = 1
							ELSE
								SELECT @EsCargo = 0

						IF @AlmacenTipo = 'ACTIVOS FIJOS'
							SELECT @AfectarRama = 'AF'
						ELSE
							SELECT @AfectarRama = 'INV'

						IF @MovTipo = 'INV.TMA'
							AND @WMS = 1
							AND @WMSAlmacen = 1
							SELECT @AfectarRama = 'WMS'

						IF @MovTipo IN ('INV.TMA')
							AND @WMS = 1
							AND @WMSAlmacen = 1
							AND @Tarima IS NOT NULL
							EXEC spSaldo @SucursalAlmacen
										,@Accion
										,@Empresa
										,@Usuario
										,@AfectarRama
										,@ArtMoneda
										,@ArtTipoCambio
										,@Articulo
										,@SubCuenta
										,@AfectarAlmacen
										,@AfectarAlmacenDestino
										,@Modulo
										,@ID
										,@Mov
										,@MovID
										,@EsCargo
										,0
										,@AfectarCantidad
										,@Factor
										,@FechaAfectacion
										,@Ejercicio
										,@Periodo
										,@AplicaMov
										,@AplicaMovID
										,0
										,0
										,0
										,@Ok OUTPUT
										,@OkRef OUTPUT
										,@Renglon = @Renglon
										,@RenglonSub = @RenglonSub
										,@RenglonID = @RenglonID
										,@SubGrupo = @Tarima

						IF EXISTS (SELECT * FROM Movtipo WITH(NOLOCK) WHERE Modulo = 'VTAS' AND Clave = 'VTAS.VCR' AND Mov = @Origen)
							AND @MovTipo = 'VTAS.F'
							SET @CostoInvTotal = 0

						IF @MovTipo NOT IN ('INV.TMA')
							EXEC spSaldo @SucursalAlmacen
										,@Accion
										,@Empresa
										,@Usuario
										,@AfectarRama
										,@ArtMoneda
										,@ArtTipoCambio
										,@Articulo
										,@SubCuenta
										,@AfectarAlmacen
										,@AfectarAlmacenDestino
										,@Modulo
										,@ID
										,@Mov
										,@MovID
										,@EsCargo
										,@CostoInvTotal
										,@AfectarCantidad
										,@Factor
										,@FechaAfectacion
										,@Ejercicio
										,@Periodo
										,@AplicaMov
										,@AplicaMovID
										,0
										,0
										,0
										,@Ok OUTPUT
										,@OkRef OUTPUT
										,@Renglon = @Renglon
										,@RenglonSub = @RenglonSub
										,@RenglonID = @RenglonID

						IF NOT EXISTS (SELECT * FROM Movtipo WITH(NOLOCK) WHERE Modulo = 'VTAS' AND Clave = 'VTAS.VCR' AND Mov = @Origen)

							IF @MovTipo IN ('VTAS.F', 'VTAS.FM', 'VTAS.FR', 'INV.SI', 'INV.T', 'VTAS.VCR', 'VTAS.R', 'INV.A', 'INV.S')
								AND @WMS = 1
								AND @WMSAlmacen = 1
								EXEC spSaldo @SucursalAlmacen
											,@Accion
											,@Empresa
											,@Usuario
											,'WMS'
											,@ArtMoneda
											,@ArtTipoCambio
											,@Articulo
											,@SubCuenta
											,@AfectarAlmacen
											,@AfectarAlmacenDestino
											,@Modulo
											,@ID
											,@Mov
											,@MovID
											,@EsCargo
											,0
											,@AfectarCantidad
											,@Factor
											,@FechaAfectacion
											,@Ejercicio
											,@Periodo
											,@AplicaMov
											,@AplicaMovID
											,0
											,0
											,0
											,@Ok OUTPUT
											,@OkRef OUTPUT
											,@Renglon = @Renglon
											,@RenglonSub = @RenglonSub
											,@RenglonID = @RenglonID
											,@SubGrupo = @Tarima

						IF @WMS = 1
							AND @Modulo = 'INV'
							AND @MovTipo = 'INV.A'
						BEGIN

							IF (
									SELECT Tipo
									FROM AlmPos WITH(NOLOCK)
									WHERE Almacen = @AfectarAlmacen
									AND Posicion = @PosicionReal
								)
								<> 'Domicilio'
							BEGIN

								IF @Accion IN ('AFECTAR', 'CANCELAR')
									AND (
										SELECT Disponible
										FROM ArtDisponibleTarima WITH(NOLOCK)
										WHERE Tarima = @Tarima
										AND Almacen = @AfectarAlmacen
										AND Empresa = @Empresa
										AND Articulo = @Articulo
									)
									= 0
								BEGIN
									UPDATE Tarima WITH(ROWLOCK)
									SET Estatus = 'BAJA'
									   ,Baja = GETDATE()
									WHERE Tarima = @Tarima

									IF @OrigenMovTipo = 'INV.IF'
									BEGIN

										IF EXISTS (SELECT * FROM InvD WITH(NOLOCK) WHERE ID = @ID AND Articulo <> @Articulo AND Tarima = @Tarima)
										BEGIN
											DELETE SaldoUWMS
											WHERE Sucursal = @Sucursal
												AND Empresa = @Empresa
												AND Rama = 'INV'
												AND Grupo = @Almacen
												AND Cuenta = @Articulo
												AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
												AND SaldoU = 0
												AND SubGrupo = @Tarima
										END

									END

								END

								IF @OrigenMovTipo = 'INV.IF'
								BEGIN
									DELETE SaldoUWMS
									WHERE Sucursal = @Sucursal
										AND Empresa = @Empresa
										AND Rama = 'INV'
										AND Grupo = @Almacen
										AND Cuenta <> @Articulo
										AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
										AND SaldoU = 0
										AND SubGrupo = @Tarima
								END

								IF @Accion IN ('AFECTAR', 'CANCELAR')
									AND (
										SELECT Disponible
										FROM ArtDisponibleTarima WITH(NOLOCK)
										WHERE Tarima = @Tarima
										AND Almacen = @Almacen
										AND Empresa = @Empresa
										AND Articulo = @Articulo
									)
									> 0
									UPDATE Tarima WITH(ROWLOCK)
									SET Estatus = 'ALTA'
									   ,Baja = NULL
									WHERE Tarima = @Tarima

								IF @Accion = 'AFECTAR'
									AND @PosicionActual <> @PosicionReal
									AND ISNULL(@PosicionReal, '') <> ''
									UPDATE Tarima WITH(ROWLOCK)
									SET Posicion = @PosicionReal
									WHERE Tarima = @Tarima

								IF @Accion = 'CANCELAR'
									AND @PosicionActual <> @PosicionReal
									AND ISNULL(@PosicionActual, '') <> ''
									UPDATE Tarima WITH(ROWLOCK)
									SET Posicion = @PosicionActual
									WHERE Tarima = @Tarima

							END

						END

					END

				END

				IF @AfectarSerieLote = 1
					AND @Ok IS NULL
					AND @Tarima IS NOT NULL
					AND @AfectarRama = 'WMS'
				BEGIN
					EXEC spSeriesLotesWMS @Empresa
										 ,@Modulo
										 ,@Accion
										 ,@EsEntrada
										 ,@EsSalida
										 ,@ID
										 ,@RenglonID
										 ,@Articulo
										 ,@SubCuenta
										 ,@MovTipo
										 ,@AplicaMovTipo
										 ,@FechaEmision
										 ,0
										 ,@Tarima
										 ,@Cantidad
										 ,@Ok OUTPUT
										 ,@OkRef OUTPUT
				END

				IF @AfectarSerieLote = 1
					AND @Ok IS NULL
					AND @AfectarRama <> 'WMS'
				BEGIN
					EXEC spSeriesLotesMayoreo @Sucursal
											 ,@SucursalAlmacen
											 ,@SucursalAlmacenDestino
											 ,@Empresa
											 ,@Modulo
											 ,@Accion
											 ,@AfectarCostos
											 ,@EsEntrada
											 ,@EsSalida
											 ,@EsTransferencia
											 ,@ID
											 ,@RenglonID
											 ,@Almacen
											 ,@AlmacenDestino
											 ,@Articulo
											 ,@SubCuenta
											 ,@ArtTipo
											 ,@ArtSerieLoteInfo
											 ,@ArtLotesFijos
											 ,@ArtCosto
											 ,@ArtCostoInv
											 ,@Cantidad
											 ,@Factor
											 ,@MovTipo
											 ,@AplicaMovTipo
											 ,@AlmacenTipo
											 ,@FechaEmision
											 ,@CfgCosteoSeries
											 ,@CfgCosteoLotes
											 ,@ArtCostoIdentificado
											 ,@CfgValidarLotesCostoDif
											 ,@CfgVINAccesorioArt
											 ,@CfgVINCostoSumaAccesorios
											 ,@Ok OUTPUT
											 ,@OkRef OUTPUT

					IF @ArtTipo = 'VIN'
					BEGIN

						IF @Modulo = 'VTAS'
						BEGIN

							IF @VIN IS NOT NULL
								SELECT @Ok = 20630

							SELECT @VIN = MIN(SerieLote)
							FROM SerieLoteMov WITH(NOLOCK)
							WHERE Empresa = @Empresa
							AND Modulo = @Modulo
							AND ID = @ID
							AND RenglonID = @RenglonID
							AND Articulo = @Articulo

							IF @MovTipo = 'VTAS.F'
								UPDATE Venta WITH(ROWLOCK)
								SET ServicioArticulo = @Articulo
								   ,ServicioSerie = @VIN
								WHERE ID = @ID

						END

						IF @Accion = 'CANCELAR'
							AND @Ok IS NULL
							UPDATE VIN WITH(ROWLOCK)
							SET FechaMRS = NULL
							FROM VIN v WITH(NOLOCK), SerieLoteMov s WITH(NOLOCK)
							WHERE s.Empresa = @Empresa
							AND s.Modulo = @Modulo
							AND s.ID = @ID
							AND s.RenglonID = @RenglonID
							AND s.Articulo = @Articulo
							AND v.VIN = s.SerieLote
							AND v.TieneMovimientos = 0
						ELSE
						BEGIN

							IF EXISTS (SELECT v.VIN FROM VIN v WITH(NOLOCK), SerieLoteMov s WITH(NOLOCK) WHERE s.Empresa = @Empresa AND s.Modulo = @Modulo AND s.ID = @ID AND s.RenglonID = @RenglonID AND s.Articulo = @Articulo AND v.VIN = s.SerieLote AND v.TieneMovimientos = 0)
								UPDATE VIN WITH(ROWLOCK)
								SET TieneMovimientos = 1
								FROM VIN v WITH(NOLOCK), SerieLoteMov s WITH(NOLOCK)
								WHERE s.Empresa = @Empresa
								AND s.Modulo = @Modulo
								AND s.ID = @ID
								AND s.RenglonID = @RenglonID
								AND s.Articulo = @Articulo
								AND v.VIN = s.SerieLote
								AND v.TieneMovimientos = 0

							IF @MovTipo IN ('COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI')
								EXEC spVINEntrada @Empresa
												 ,@Modulo
												 ,@ID
												 ,@Mov
												 ,@RenglonID
												 ,@Articulo
												 ,@FechaEmision
												 ,@FechaRequerida
												 ,@ImporteNeto
												 ,@Impuesto1Neto
												 ,@VIN OUTPUT
												 ,@Ok OUTPUT
												 ,@OkRef OUTPUT

							IF @MovTipo IN ('VTAS.F', 'VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX', 'VTAS.FB')
								UPDATE VIN WITH(ROWLOCK)
								SET Cliente = @ClienteProv
								   ,FechaSalida = @FechaEmision
								   ,VentaID = @ID
								FROM VIN v WITH(NOLOCK), SerieLoteMov s WITH(NOLOCK)
								WHERE s.Empresa = @Empresa
								AND s.Modulo = @Modulo
								AND s.ID = @ID
								AND s.RenglonID = @RenglonID
								AND s.Articulo = @Articulo
								AND v.VIN = s.SerieLote

						END

					END

				END

				IF (@MovTipo = 'VTAS.FM' AND @FacturarVtasMostrador = 1 AND @ArtTipo IN ('SERIE', 'LOTE', 'VIN', 'PARTIDA') AND @Accion <> 'CANCELAR')
				BEGIN
					SELECT @CantidadDif = @Cantidad
					SELECT @CantidadDif = @Cantidad - ISNULL(SUM(Cantidad) / @Factor, 0.0)
					FROM SerieLoteMov WITH(NOLOCK)
					WHERE Empresa = @Empresa
					AND Modulo = @Modulo
					AND ID = @ID
					AND RenglonID = @RenglonID
					AND Articulo = @Articulo
					AND ISNULL(RTRIM(SubCuenta), '') = ISNULL(@SubCuenta, '')

					IF @CantidadDif <> 0.0
					BEGIN
						DECLARE
							@SerieLoteMov TABLE (
								Sucursal INT NULL
							   ,Empresa CHAR(5) COLLATE Database_Default NULL
							   ,Modulo CHAR(5) COLLATE Database_Default NULL
							   ,ID INT NULL
							   ,RenglonID INT NULL
							   ,Articulo VARCHAR(20) COLLATE Database_Default NULL
							   ,SubCuenta VARCHAR(50) COLLATE Database_Default NULL
							   ,SerieLote VARCHAR(20) COLLATE Database_Default NULL
							   ,Cantidad FLOAT NULL
							   ,CantidadAlterna FLOAT NULL
							   ,Propiedades VARCHAR(20) COLLATE Database_Default NULL
							   ,ArtCostoInv MONEY NULL
							   ,Cliente VARCHAR(10) COLLATE Database_Default NULL
							   ,Localizacion VARCHAR(10) COLLATE Database_Default NULL
							)
						EXEC spSeriesLotesSurtidoAuto @Sucursal
													 ,@Empresa
													 ,@Modulo
													 ,@EsSalida
													 ,@EsTransferencia
													 ,@ID
													 ,@RenglonID
													 ,@Almacen
													 ,@Articulo
													 ,@SubCuenta
													 ,@CantidadDif
													 ,@Factor
													 ,@AlmacenTipo
													 ,@SeriesLotesAutoOrden
													 ,@Ok OUTPUT
													 ,@OkRef OUTPUT
													 ,@Temp = 1
													 ,@Tarima = @Tarima
						EXEC spSeriesLotesMayoreo @Sucursal
												 ,@SucursalAlmacen
												 ,@SucursalAlmacenDestino
												 ,@Empresa
												 ,@Modulo
												 ,@Accion
												 ,@AfectarCostos
												 ,@EsEntrada
												 ,@EsSalida
												 ,@EsTransferencia
												 ,@ID
												 ,@RenglonID
												 ,@Almacen
												 ,@AlmacenDestino
												 ,@Articulo
												 ,@SubCuenta
												 ,@ArtTipo
												 ,@ArtSerieLoteInfo
												 ,@ArtLotesFijos
												 ,@ArtCosto
												 ,@ArtCostoInv
												 ,@CantidadDif
												 ,@Factor
												 ,@MovTipo
												 ,@AplicaMovTipo
												 ,@AlmacenTipo
												 ,@FechaEmision
												 ,@CfgCosteoSeries
												 ,@CfgCosteoLotes
												 ,@ArtCostoIdentificado
												 ,@CfgValidarLotesCostoDif
												 ,@CfgVINAccesorioArt
												 ,@CfgVINCostoSumaAccesorios
												 ,@Ok OUTPUT
												 ,@OkRef OUTPUT
												 ,@Temp = 1
						EXEC spSeriesLotesFusionarTemp @Ok OUTPUT
													  ,@OkRef OUTPUT
						SELECT @CantidadDif = @Cantidad
						SELECT @CantidadDif = @Cantidad - ISNULL(SUM(Cantidad) / @Factor, 0.0)
						FROM SerieLoteMov WITH(NOLOCK)
						WHERE Empresa = @Empresa
						AND Modulo = @Modulo
						AND ID = @ID
						AND RenglonID = @RenglonID
						AND Articulo = @Articulo
						AND ISNULL(RTRIM(SubCuenta), '') = ISNULL(@SubCuenta, '')

						IF @CantidadDif <> 0.0
							SELECT @Ok = 20330

					END

				END

				IF @AfectarCostos = 1
					AND @CfgMultiUnidades = 1
					AND @CfgMultiUnidadesNivel = 'ARTICULO'
					EXEC xpArtUnidadFactorRecalc @Empresa
												,@Accion
												,@Modulo
												,@ID
												,@Renglon
												,@RenglonSub
												,@MovTipo
												,@AlmacenTipo
												,@Articulo
												,@SubCuenta
												,@MovUnidad
												,@ArtTipo
												,@Factor
												,@Almacen
												,@Cantidad
												,@CantidadInventario
												,@EsEntrada
												,@EsSalida
												,@Ok OUTPUT
												,@OkRef OUTPUT

				IF @Modulo IN ('COMS', 'PROD', 'INV')
				BEGIN

					IF (@CfgBackOrders = 1 AND @MovTipo IN ('COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI', 'COMS.IG', 'INV.T', 'INV.T', 'INV.EI') OR (@MovTipo = 'PROD.E'))
						AND @Accion <> 'CANCELAR'
					BEGIN
						SELECT @Cliente = NULL
						SELECT @DestinoTipo = NULL
							  ,@Destino = NULL
							  ,@DestinoID = NULL

						IF @Modulo = 'COMS'
							SELECT @Cliente = Cliente
							FROM CompraD WITH(NOLOCK)
							WHERE ID = @ID
							AND Renglon = @Renglon
							AND RenglonSub = @RenglonSub
						ELSE

						IF @Modulo = 'INV'
							SELECT @Cliente = Cliente
								  ,@DestinoTipo = DestinoTipo
								  ,@Destino = Destino
								  ,@DestinoID = DestinoID
							FROM InvD WITH(NOLOCK)
							WHERE ID = @ID
							AND Renglon = @Renglon
							AND RenglonSub = @RenglonSub
						ELSE

						IF @Modulo = 'PROD'
							SELECT @Cliente = Cliente
							FROM ProdD WITH(NOLOCK)
							WHERE ID = @ID
							AND Renglon = @Renglon
							AND RenglonSub = @RenglonSub

						IF @Modulo = 'INV'
							AND @Largo = 1
							AND (@Cliente IS NOT NULL OR @DestinoTipo IS NOT NULL)
							SELECT @Ok = 20970

						IF @Cliente IS NOT NULL
							EXEC spInvBackOrderCliente @Sucursal
													  ,@Empresa
													  ,@Usuario
													  ,@Cliente
													  ,@Articulo
													  ,@SubCuenta
													  ,@Cantidad
													  ,@Factor
													  ,@ArtMoneda
													  ,@Almacen
													  ,@FechaAfectacion
													  ,@FechaRegistro
													  ,@Ejercicio
													  ,@Periodo
													  ,@Ok OUTPUT
													  ,@OkRef OUTPUT

					END

					IF @MovTipo IN ('COMS.D', 'COMS.B', 'COMS.CA', 'COMS.GX')
						AND @AfectarCostos = 1
					BEGIN
						SELECT @DescuentoInverso = 100 - ISNULL(@DescuentoGlobal, 0)
						EXEC spR3 @DescuentoInverso
								 ,@Costo
								 ,100
								 ,@Precio OUTPUT
						EXEC spCalculaImporte @Accion
											 ,@Modulo
											 ,@CfgImpInc
											 ,@MovTipo
											 ,@EsEntrada
											 ,@CantidadCalcularImporte
											 ,@Precio
											 ,NULL
											 ,NULL
											 ,@DescuentoGlobal
											 ,@SobrePrecio
											 ,@Impuesto1
											 ,@Impuesto2
											 ,@Impuesto3
											 ,@Impuesto5
											 ,@Importe OUTPUT
											 ,@ImporteNeto OUTPUT
											 ,@DescuentoLineaImporte OUTPUT
											 ,@DescuentoGlobalImporte OUTPUT
											 ,@SobrePrecioImporte OUTPUT
											 ,@Impuestos OUTPUT
											 ,@ImpuestosNetos OUTPUT
											 ,@Impuesto1Neto OUTPUT
											 ,@Impuesto2Neto OUTPUT
											 ,@Impuesto3Neto OUTPUT
											 ,@Impuesto5Neto OUTPUT
											 ,@Articulo = @Articulo
											 ,@CantidadObsequio = @CantidadObsequio
											 ,@CfgPrecioMoneda = @CfgPrecioMoneda
											 ,@MovTipoCambio = @MovTipoCambio
											 ,@PrecioTipoCambio = @PrecioTipoCambio
											 ,@Retencion1 = @Retencion1
											 ,@Retencion2 = @Retencion2
											 ,@Retencion3 = @Retencion3
											 ,@ID = @ID
											 ,@AnticipoFacturado = @AnticipoFacturado
					END
					ELSE
					BEGIN
						SELECT @ImporteNeto = @Costo * @Cantidad
					END

				END

				IF @Modulo = 'PROD'
					SELECT @Importe = @Cantidad * @Costo

				IF @MovTipo = 'PROD.O'
					AND @Accion = 'AFECTAR'
				BEGIN
					EXEC spProdCentroInicial @ID
											,@Articulo
											,@SubCuenta
											,@ProdSerieLote
											,@Orden OUTPUT
											,@OrdenDestino OUTPUT
											,@Centro OUTPUT
											,@CentroDestino OUTPUT
											,@Estacion OUTPUT
											,@EstacionDestino OUTPUT
					UPDATE ProdD WITH(ROWLOCK)
					SET Centro = @Centro
					   ,Orden = @Orden
					   ,CentroDestino = @CentroDestino
					   ,OrdenDestino = @OrdenDestino
					   ,Estacion = @Estacion
					   ,EstacionDestino = @EstacionDestino
					WHERE CURRENT OF crProdDetalle
				END

				IF @MovTipo IN ('PROD.O', 'PROD.CO', 'PROD.E')
					EXEC spProdSerieLote @Sucursal
										,@Accion
										,@Empresa
										,@MovTipo
										,@FechaEmision
										,@DetalleTipo
										,@ProdSerieLote
										,@Articulo
										,@SubCuenta
										,@Cantidad
										,@Merma
										,@Desperdicio
										,@Factor
										,@Ok OUTPUT
										,@OkRef OUTPUT

				IF @MovTipo = 'INV.CM'
					AND @SubClave <> 'INV.SAUX'
					EXEC spProdSerieLoteCosto @Sucursal
											 ,@Accion
											 ,@Empresa
											 ,@Modulo
											 ,@ID
											 ,@MovTipo
											 ,@DetalleTipo
											 ,@ProdSerieLote
											 ,@Producto
											 ,@SubProducto
											 ,@CostoInvTotal
											 ,@ArtMoneda
											 ,@Mov
											 ,0

				IF @MovTipo = 'PROD.E'
					EXEC spProdSerieLoteCosto @Sucursal
											 ,@Accion
											 ,@Empresa
											 ,@Modulo
											 ,@ID
											 ,@MovTipo
											 ,@DetalleTipo
											 ,@ProdSerieLote
											 ,@Articulo
											 ,@SubCuenta
											 ,@CostoInvTotal
											 ,@ArtMoneda
											 ,@Mov
											 ,0

				IF @AlmacenTipo = 'ACTIVOS FIJOS'
					AND @ArtTipo IN ('SERIE', 'VIN')
					AND @CfgSeriesLotesMayoreo = 1
					AND @Ok IS NULL
					AND (@EsEntrada = 1 OR @EsSalida = 1 OR @EsTransferencia = 1)
					AND @OrigenMovTipo <> 'COMS.CC'
					EXEC spActivoF @Sucursal
								  ,@Empresa
								  ,@Modulo
								  ,@Accion
								  ,@EsEntrada
								  ,@EsSalida
								  ,@EsTransferencia
								  ,@ID
								  ,@RenglonID
								  ,@Almacen
								  ,@AlmacenDestino
								  ,@Articulo
								  ,@ArtTipo
								  ,@Cantidad
								  ,@ArtCostoInv
								  ,@ArtMoneda
								  ,@FechaEmision
								  ,@Ok OUTPUT
								  ,@OkRef OUTPUT

				IF @Modulo = 'VTAS'
					AND (@EstatusNuevo = 'CONCLUIDO' OR (@EstatusNuevo = 'CANCELADO' AND @Estatus <> 'PENDIENTE'))
					AND (@MovTipo IN ('VTAS.F', 'VTAS.FAR', 'VTAS.FB', 'VTAS.D', 'VTAS.DF', 'VTAS.B') OR (@MovTipo = 'VTAS.FM' AND @FacturarVtasMostrador = 1 AND @Accion <> 'CANCELAR'))
					AND @Ok IS NULL
				BEGIN

					IF @ArtTipo IN ('SERIE', 'LOTE', 'VIN')
						AND @CfgSeriesLotesMayoreo = 0
						SELECT @AcumularSinDetalles = 1
					ELSE
						SELECT @AcumularSinDetalles = 0

					IF @MovTipo IN ('VTAS.F', 'VTAS.FAR', 'VTAS.FB', 'VTAS.FM')
						SELECT @EsCargo = 1
					ELSE
						SELECT @EsCargo = 0

					IF @CantidadOriginal < 0.0
						SELECT @EsCargo = ~@EsCargo

					IF @Accion = 'CANCELAR'
						SELECT @EsCargo = ~@EsCargo

					IF @MovTipo = 'VTAS.B'
						SELECT @AcumCantidad = NULL
					ELSE
						SELECT @AcumCantidad = @Cantidad

					EXEC spSaldo @Sucursal
								,@Accion
								,@Empresa
								,@Usuario
								,'VTAS'
								,@MovMoneda
								,NULL
								,@Articulo
								,@SubCuenta
								,@ClienteProv
								,NULL
								,@Modulo
								,@ID
								,@Mov
								,@MovID
								,@EsCargo
								,@ImporteNeto
								,@AcumCantidad
								,@Factor
								,@FechaAfectacion
								,@Ejercicio
								,@Periodo
								,NULL
								,NULL
								,0
								,@AcumularSinDetalles
								,0
								,@Ok OUTPUT
								,@OkRef OUTPUT
								,@Renglon = @Renglon
								,@RenglonSub = @RenglonSub
								,@RenglonID = @RenglonID
				END
				ELSE

				IF @Modulo = 'COMS'
					AND (@EstatusNuevo = 'CONCLUIDO' OR (@EstatusNuevo = 'CANCELADO' AND @Estatus <> 'PENDIENTE'))
					AND @MovTipo IN ('COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI', 'COMS.D', 'COMS.B', 'COMS.CA', 'COMS.GX')
					AND @Ok IS NULL
				BEGIN

					IF @ArtTipo IN ('SERIE', 'LOTE', 'VIN')
						AND @CfgSeriesLotesMayoreo = 0
						SELECT @AcumularSinDetalles = 1
					ELSE
						SELECT @AcumularSinDetalles = 0

					IF @MovTipo IN ('COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI', 'COMS.CA', 'COMS.GX')
						SELECT @EsCargo = 1
					ELSE
						SELECT @EsCargo = 0

					IF @Accion = 'CANCELAR'
						SELECT @EsCargo = ~@EsCargo

					IF @MovTipo IN ('COMS.B', 'COMS.CA', 'COMS.GX')
						SELECT @AcumCantidad = NULL
					ELSE
						SELECT @AcumCantidad = @Cantidad

					EXEC spSaldo @Sucursal
								,@Accion
								,@Empresa
								,@Usuario
								,'COMS'
								,@MovMoneda
								,NULL
								,@Articulo
								,@SubCuenta
								,@ClienteProv
								,NULL
								,@Modulo
								,@ID
								,@Mov
								,@MovID
								,@EsCargo
								,@ImporteNeto
								,@AcumCantidad
								,@Factor
								,@FechaAfectacion
								,@Ejercicio
								,@Periodo
								,NULL
								,NULL
								,0
								,@AcumularSinDetalles
								,0
								,@Ok OUTPUT
								,@OkRef OUTPUT
								,@Renglon = @Renglon
								,@RenglonSub = @RenglonSub
								,@RenglonID = @RenglonID

					IF @MovTipo IN ('COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI')
						AND @Accion <> 'CANCELAR'
					BEGIN

						IF @MovTipo = 'COMS.EI'
							SELECT @ProveedorRef = ISNULL(NULLIF(RTRIM(ImportacionProveedor), ''), @ClienteProv)
							FROM CompraD WITH(NOLOCK)
							WHERE ID = @ID
							AND Renglon = @Renglon
							AND RenglonSub = @RenglonSub
						ELSE
							SELECT @ProveedorRef = @ClienteProv

						IF @CostosImpuestoIncluido = 1
							SELECT @ArtProvCosto = @Costo
						ELSE
							SELECT @ArtProvCosto = @ArtCosto

						EXEC xpArtProv @Empresa
									  ,@Accion
									  ,@Modulo
									  ,@ID
									  ,@Renglon
									  ,@RenglonSub
									  ,@MovTipo
									  ,@AlmacenTipo
									  ,@Articulo
									  ,@SubCuenta
									  ,@MovUnidad
									  ,@ArtTipo
									  ,@Factor
									  ,@Almacen
									  ,@Cantidad
									  ,@CantidadInventario
									  ,@EsEntrada
									  ,@EsSalida
									  ,@ProveedorRef
									  ,@ArtProvCosto
									  ,@FechaEmision
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT
					END

				END

				IF (@CfgPosiciones = 1 OR @CfgExistenciaAlterna = 1)
					AND @OrigenTipo <> 'VMOS'
					AND @AlmacenTipo <> 'ACTIVOS FIJOS'
					AND @ArtTipo NOT IN ('JUEGO', 'SERVICIO')
					AND (@EsEntrada = 1 OR @EsSalida = 1 OR @EsTransferencia = 1 OR @MovTipo IN ('COMS.CC', 'INV.CPOS') OR @Mov = @CfgEstadisticaAjusteMerma)
					AND @Ok IS NULL
					AND (
						SELECT ISNULL(Ubicaciones, 0)
						FROM Alm WITH(NOLOCK)
						WHERE Almacen = @Almacen
					)
					= 1
				BEGIN

					IF @CfgPosiciones = 1
						AND @Posicion IS NULL
					BEGIN

						IF @WMS = 0
							SELECT @Ok = 13050

					END
					ELSE
					BEGIN

						IF @MovTipo NOT IN ('COMS.CC', 'INV.CPOS')
						BEGIN
							SELECT @AuxiliarAlternoSucursal = @SucursalAlmacen
								  ,@AuxiliarAlternoAlmacen = @Almacen

							IF @Accion = 'CANCELAR'
								SELECT @AuxiliarAlternoFactorEntrada = -1.0
									  ,@AuxiliarAlternoFactorSalida = NULL
							ELSE
								SELECT @AuxiliarAlternoFactorEntrada = NULL
									  ,@AuxiliarAlternoFactorSalida = 1.0

							IF @EsSalida = 1
								OR @EsTransferencia = 1
							BEGIN

								IF @CfgExistenciaAlternaSerieLote = 1
									AND @ArtTipo IN ('SERIE', 'LOTE', 'VIN', 'PARTIDA')
									INSERT AuxiliarAlterno (Empresa, Sucursal, Almacen, Posicion, SerieLote, Modulo, ID, Renglon, RenglonSub, Articulo, SubCuenta, Unidad, Factor, Entrada, Salida)
										SELECT @Empresa
											  ,@AuxiliarAlternoSucursal
											  ,@AuxiliarAlternoAlmacen
											  ,@Posicion
											  ,SerieLote
											  ,@Modulo
											  ,@ID
											  ,@Renglon
											  ,@RenglonSub
											  ,@Articulo
											  ,@SubCuenta
											  ,@MovUnidad
											  ,@Factor
											  ,Cantidad * @AuxiliarAlternoFactorEntrada
											  ,Cantidad * @AuxiliarAlternoFactorSalida
										FROM SerieLoteMov WITH(NOLOCK)
										WHERE Empresa = @Empresa
										AND Modulo = @Modulo
										AND ID = @ID
										AND RenglonID = @RenglonID
										AND Articulo = @Articulo
										AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
								ELSE
									INSERT AuxiliarAlterno (Empresa, Sucursal, Almacen, Posicion, Modulo, ID, Renglon, RenglonSub, Articulo, SubCuenta, Unidad, Factor, Entrada, Salida)
										SELECT @Empresa
											  ,@AuxiliarAlternoSucursal
											  ,@AuxiliarAlternoAlmacen
											  ,@Posicion
											  ,@Modulo
											  ,@ID
											  ,@Renglon
											  ,@RenglonSub
											  ,@Articulo
											  ,@SubCuenta
											  ,@MovUnidad
											  ,@Factor
											  ,@Cantidad * @AuxiliarAlternoFactorEntrada
											  ,@Cantidad * @AuxiliarAlternoFactorSalida

							END

							IF @EsTransferencia = 1
								SELECT @AuxiliarAlternoSucursal = @SucursalAlmacenDestino
									  ,@AuxiliarAlternoAlmacen = @AlmacenDestino

							IF @Accion = 'CANCELAR'
								SELECT @AuxiliarAlternoFactorEntrada = NULL
									  ,@AuxiliarAlternoFactorSalida = -1.0
							ELSE
								SELECT @AuxiliarAlternoFactorEntrada = 1.0
									  ,@AuxiliarAlternoFactorSalida = NULL

							IF @EsEntrada = 1
								OR @EsTransferencia = 1
								OR @Mov = @CfgEstadisticaAjusteMerma
							BEGIN

								IF @CfgExistenciaAlternaSerieLote = 1
									AND @ArtTipo IN ('SERIE', 'LOTE', 'VIN', 'PARTIDA')
									INSERT AuxiliarAlterno (Empresa, Sucursal, Almacen, Posicion, SerieLote, Modulo, ID, Renglon, RenglonSub, Articulo, SubCuenta, Unidad, Factor, Entrada, Salida)
										SELECT @Empresa
											  ,@AuxiliarAlternoSucursal
											  ,@AuxiliarAlternoAlmacen
											  ,ISNULL(@PosicionDestino, @Posicion)
											  ,SerieLote
											  ,@Modulo
											  ,@ID
											  ,@Renglon
											  ,@RenglonSub
											  ,@Articulo
											  ,@SubCuenta
											  ,@MovUnidad
											  ,@Factor
											  ,Cantidad * @AuxiliarAlternoFactorEntrada
											  ,Cantidad * @AuxiliarAlternoFactorSalida
										FROM SerieLoteMov WITH(NOLOCK)
										WHERE Empresa = @Empresa
										AND Modulo = @Modulo
										AND ID = @ID
										AND RenglonID = @RenglonID
										AND Articulo = @Articulo
										AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
								ELSE
									INSERT AuxiliarAlterno (Empresa, Sucursal, Almacen, Posicion, Modulo, ID, Renglon, RenglonSub, Articulo, SubCuenta, Unidad, Factor, Entrada, Salida)
										SELECT @Empresa
											  ,@AuxiliarAlternoSucursal
											  ,@AuxiliarAlternoAlmacen
											  ,ISNULL(@PosicionDestino, @Posicion)
											  ,@Modulo
											  ,@ID
											  ,@Renglon
											  ,@RenglonSub
											  ,@Articulo
											  ,@SubCuenta
											  ,@MovUnidad
											  ,@Factor
											  ,@Cantidad * @AuxiliarAlternoFactorEntrada
											  ,@Cantidad * @AuxiliarAlternoFactorSalida

							END

						END

						IF @MovTipo = 'INV.CPOS'
						BEGIN
							SELECT @AuxiliarAlternoSucursal = @SucursalAlmacen
								  ,@AuxiliarAlternoAlmacen = @Almacen

							IF @CfgExistenciaAlternaSerieLote = 1
								AND @ArtTipo IN ('SERIE', 'LOTE', 'VIN', 'PARTIDA')
							BEGIN
								INSERT AuxiliarAlterno (Empresa, Sucursal, Almacen, Posicion, SerieLote, Modulo, ID, Renglon, RenglonSub, Articulo, SubCuenta, Unidad, Factor, Entrada, Salida)
									SELECT @Empresa
										  ,@AuxiliarAlternoSucursal
										  ,@AuxiliarAlternoAlmacen
										  ,@Posicion
										  ,SerieLote
										  ,@Modulo
										  ,@ID
										  ,@Renglon
										  ,@RenglonSub
										  ,@Articulo
										  ,@SubCuenta
										  ,@MovUnidad
										  ,@Factor
										  ,0.0
										  ,CASE
											   WHEN @Accion = 'CANCELAR' THEN @Cantidad * -1
											   ELSE @Cantidad
										   END
									FROM SerieLoteMov WITH(NOLOCK)
									WHERE Empresa = @Empresa
									AND Modulo = @Modulo
									AND ID = @ID
									AND RenglonID = @RenglonID
									AND Articulo = @Articulo
									AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
								INSERT AuxiliarAlterno (Empresa, Sucursal, Almacen, Posicion, SerieLote, Modulo, ID, Renglon, RenglonSub, Articulo, SubCuenta, Unidad, Factor, Entrada, Salida)
									SELECT @Empresa
										  ,@AuxiliarAlternoSucursal
										  ,@AuxiliarAlternoAlmacen
										  ,@PosicionDestino
										  ,SerieLote
										  ,@Modulo
										  ,@ID
										  ,@Renglon
										  ,@RenglonSub
										  ,@Articulo
										  ,@SubCuenta
										  ,@MovUnidad
										  ,@Factor
										  ,CASE
											   WHEN @Accion = 'CANCELAR' THEN @Cantidad * -1
											   ELSE @Cantidad
										   END
										  ,0.0
									FROM SerieLoteMov WITH(NOLOCK)
									WHERE Empresa = @Empresa
									AND Modulo = @Modulo
									AND ID = @ID
									AND RenglonID = @RenglonID
									AND Articulo = @Articulo
									AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
							END
							ELSE
							BEGIN
								INSERT AuxiliarAlterno (Empresa, Sucursal, Almacen, Posicion, Modulo, ID, Renglon, RenglonSub, Articulo, SubCuenta, Unidad, Factor, Entrada, Salida)
									SELECT @Empresa
										  ,@AuxiliarAlternoSucursal
										  ,@AuxiliarAlternoAlmacen
										  ,@Posicion
										  ,@Modulo
										  ,@ID
										  ,@Renglon
										  ,@RenglonSub
										  ,@Articulo
										  ,@SubCuenta
										  ,@MovUnidad
										  ,@Factor
										  ,0.0
										  ,CASE
											   WHEN @Accion = 'CANCELAR' THEN @Cantidad * -1
											   ELSE @Cantidad
										   END
								INSERT AuxiliarAlterno (Empresa, Sucursal, Almacen, Posicion, Modulo, ID, Renglon, RenglonSub, Articulo, SubCuenta, Unidad, Factor, Entrada, Salida)
									SELECT @Empresa
										  ,@AuxiliarAlternoSucursal
										  ,@AuxiliarAlternoAlmacen
										  ,@PosicionDestino
										  ,@Modulo
										  ,@ID
										  ,@Renglon
										  ,@RenglonSub
										  ,@Articulo
										  ,@SubCuenta
										  ,@MovUnidad
										  ,@Factor
										  ,CASE
											   WHEN @Accion = 'CANCELAR' THEN @Cantidad * -1
											   ELSE @Cantidad
										   END
										  ,0.0
							END

						END

					END

				END

				IF @AfectarMatando = 1
					AND @Utilizar = 1
					AND @AplicaMov IS NOT NULL
					AND @AplicaMovID IS NOT NULL
					AND @Ok IS NULL
					SELECT @Ok = 71050

				IF (@Estatus = 'PENDIENTE' OR @EstatusNuevo = 'PENDIENTE')
					AND @Ok IS NULL
				BEGIN

					IF @EstatusNuevo = 'PENDIENTE'
					BEGIN

						IF @Accion IN ('ASIGNAR', 'DESASIGNAR')
							EXEC spInvAsignar @Sucursal
											 ,@Accion
											 ,@Empresa
											 ,@Modulo
											 ,@ID
											 ,@Mov
											 ,@MovID
											 ,@Almacen
											 ,@Articulo
											 ,@SubCuenta
											 ,@MovUnidad
											 ,@Cantidad OUTPUT
											 ,@Ok OUTPUT
											 ,@OkRef OUTPUT

						IF @Accion = 'RESERVARPARCIAL'
							SELECT @CantidadPendiente = @Cantidad - @ReservadoParcial
								  ,@CantidadReservada = @CantidadReservada + @ReservadoParcial
						ELSE

						IF @Accion = 'RESERVAR'
							SELECT @CantidadPendiente = @CantidadPendiente - @Cantidad
								  ,@CantidadReservada = @CantidadReservada + @Cantidad
						ELSE

						IF @Accion = 'DESRESERVAR'
							SELECT @CantidadPendiente = @CantidadPendiente + @Cantidad
								  ,@CantidadReservada = @CantidadReservada - @Cantidad
						ELSE

						IF @Accion = 'ASIGNAR'
							SELECT @CantidadPendiente = @CantidadPendiente - @Cantidad
								  ,@CantidadOrdenada = @CantidadOrdenada + @Cantidad
						ELSE

						IF @Accion = 'DESASIGNAR'
							SELECT @CantidadPendiente = @CantidadPendiente + @Cantidad
								  ,@CantidadOrdenada = @CantidadOrdenada - @Cantidad
						ELSE

						IF @Accion = 'CANCELAR'
						BEGIN
							SELECT @CantidadReservada = @CantidadReservada - @Cantidad

							IF @CantidadReservada < 0
								SELECT @CantidadPendiente = ROUND((@CantidadPendiente + @CantidadReservada), 8)
									  ,@CantidadReservada = 0.0

						END
						ELSE
							SELECT @CantidadPendiente = @Cantidad

					END
					ELSE

					IF @EstatusNuevo = 'CANCELADO'
						SELECT @CantidadReservada = 0.0
							  ,@CantidadPendiente = 0.0
					ELSE

					IF @Base IN ('SELECCION', 'PENDIENTE', 'TODO')
						SELECT @CantidadPendiente = @CantidadPendiente - @Cantidad

					IF @MovTipo IN ('VTAS.F', 'VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX', 'VTAS.FB')
						AND @EstatusNuevo = 'CONCLUIDO'
						AND @Accion = 'AFECTAR'
						SELECT @CantidadPendiente = 0.0
							  ,@CantidadReservada = 0.0

					IF @Modulo NOT IN ('VTAS', 'INV', 'PROD')
						SELECT @CantidadOrdenada = 0.0

					IF @CantidadPendiente = 0.0
						SELECT @CantidadPendiente = NULL

					IF @CantidadReservada = 0.0
						SELECT @CantidadReservada = NULL

					IF @CantidadOrdenada = 0.0
						SELECT @CantidadOrdenada = NULL

					IF @Modulo = 'VTAS'
						UPDATE VentaD WITH(ROWLOCK)
						SET CantidadCancelada =
							CASE
								WHEN @Accion = 'CANCELAR'
									AND @Base <> 'TODO' THEN ISNULL(CantidadCancelada, 0.0) + @Cantidad
								ELSE CantidadCancelada
							END
						   ,CantidadA = NULL
						   ,CantidadReservada = @CantidadReservada
						   ,UltimoReservadoCantidad = @UltReservadoCantidad
						   ,UltimoReservadoFecha = @UltReservadoFecha
						   ,CantidadOrdenada = @CantidadOrdenada
						   ,CantidadPendiente = @CantidadPendiente
						WHERE CURRENT OF crVentaDetalle
					ELSE

					IF @Modulo = 'INV'
						UPDATE InvD WITH(ROWLOCK)
						SET CantidadCancelada =
							CASE
								WHEN @Accion = 'CANCELAR'
									AND @Base <> 'TODO' THEN ISNULL(CantidadCancelada, 0.0) + @Cantidad
								ELSE CantidadCancelada
							END
						   ,CantidadA = NULL
						   ,CantidadReservada = @CantidadReservada
						   ,UltimoReservadoCantidad = @UltReservadoCantidad
						   ,UltimoReservadoFecha = @UltReservadoFecha
						   ,CantidadOrdenada = @CantidadOrdenada
						   ,CantidadPendiente = @CantidadPendiente
						WHERE CURRENT OF crInvDetalle
					ELSE

					IF @Modulo = 'PROD'
						UPDATE ProdD WITH(ROWLOCK)
						SET CantidadCancelada =
							CASE
								WHEN @Accion = 'CANCELAR'
									AND @Base <> 'TODO' THEN ISNULL(CantidadCancelada, 0.0) + @Cantidad
								ELSE CantidadCancelada
							END
						   ,CantidadA = NULL
						   ,CantidadReservada = @CantidadReservada
						   ,UltimoReservadoCantidad = @UltReservadoCantidad
						   ,UltimoReservadoFecha = @UltReservadoFecha
						   ,CantidadOrdenada = @CantidadOrdenada
						   ,CantidadPendiente = @CantidadPendiente
						WHERE CURRENT OF crProdDetalle
					ELSE

					IF @Modulo = 'COMS'
						UPDATE CompraD WITH(ROWLOCK)
						SET CantidadCancelada =
							CASE
								WHEN @Accion = 'CANCELAR'
									AND @Base <> 'TODO' THEN ISNULL(CantidadCancelada, 0.0) + @Cantidad
								ELSE CantidadCancelada
							END
						   ,CantidadA = NULL
						   ,CantidadPendiente = @CantidadPendiente
						WHERE CURRENT OF crCompraDetalle

					IF @@ERROR <> 0
						SELECT @Ok = 1

					EXEC spArtR @Empresa
							   ,@Modulo
							   ,@Articulo
							   ,@SubCuenta
							   ,@Almacen
							   ,@MovTipo
							   ,@Factor
							   ,NULL
							   ,@CantidadPendienteA
							   ,@CantidadPendiente
							   ,NULL
							   ,@CantidadOrdenadaA
							   ,@CantidadOrdenada

					IF @CfgBackOrders = 1
						AND @MovTipo IN ('COMS.O', 'COMS.OG', 'COMS.OI', 'PROD.O', 'INV.OT', 'INV.OI')
						AND @AplicaMovTipo IS NULL
					BEGIN
						SELECT @DestinoTipo = NULL
							  ,@Destino = NULL
							  ,@DestinoID = NULL

						IF @Modulo = 'COMS'
							SELECT @DestinoTipo = DestinoTipo
								  ,@Destino = Destino
								  ,@DestinoID = DestinoID
							FROM CompraD WITH(NOLOCK)
							WHERE ID = @ID
							AND Renglon = @Renglon
							AND RenglonSub = @RenglonSub
						ELSE

						IF @Modulo = 'INV'
							SELECT @DestinoTipo = DestinoTipo
								  ,@Destino = Destino
								  ,@DestinoID = DestinoID
							FROM InvD WITH(NOLOCK)
							WHERE ID = @ID
							AND Renglon = @Renglon
							AND RenglonSub = @RenglonSub
						ELSE

						IF @Modulo = 'PROD'
							SELECT @DestinoTipo = DestinoTipo
								  ,@Destino = Destino
								  ,@DestinoID = DestinoID
							FROM ProdD WITH(NOLOCK)
							WHERE ID = @ID
							AND Renglon = @Renglon
							AND RenglonSub = @RenglonSub

						IF @DestinoTipo IN (SELECT Modulo FROM Modulo WITH(NOLOCK))
							AND @Destino IS NOT NULL
							AND @DestinoID IS NOT NULL
							EXEC spInvBackOrder @Sucursal
											   ,@Accion
											   ,@Estatus
											   ,0
											   ,@Empresa
											   ,@Usuario
											   ,@Modulo
											   ,@ID
											   ,@Mov
											   ,@MovID
											   ,@DestinoTipo
											   ,@Destino
											   ,@DestinoID
											   ,@Articulo
											   ,@SubCuenta
											   ,@MovUnidad
											   ,@Cantidad
											   ,@Factor
											   ,@ArtMoneda
											   ,@Almacen
											   ,@FechaAfectacion
											   ,@FechaRegistro
											   ,@Ejercicio
											   ,@Periodo
											   ,@Ok OUTPUT
											   ,@OkRef OUTPUT
											   ,@MovTipo = @MovTipo

					END

				END

				IF @CfgBackOrders = 1
					AND @MovTipo = 'COMS.CP'
				BEGIN
					SELECT @DestinoTipo = NULL
						  ,@Destino = NULL
						  ,@DestinoID = NULL

					IF @Modulo = 'COMS'
						SELECT @DestinoTipo = DestinoTipo
							  ,@Destino = Destino
							  ,@DestinoID = DestinoID
						FROM CompraD WITH(NOLOCK)
						WHERE ID = @ID
						AND Renglon = @Renglon
						AND RenglonSub = @RenglonSub

					IF @DestinoTipo IN (SELECT Modulo FROM Modulo(NOLOCK))
						AND @Destino IS NOT NULL
						AND @DestinoID IS NOT NULL
						EXEC spInvBackOrder @Sucursal
										   ,@Accion
										   ,@Estatus
										   ,0
										   ,@Empresa
										   ,@Usuario
										   ,@Modulo
										   ,@ID
										   ,@Mov
										   ,@MovID
										   ,@DestinoTipo
										   ,@Destino
										   ,@DestinoID
										   ,@Articulo
										   ,@SubCuenta
										   ,@MovUnidad
										   ,@Cantidad
										   ,@Factor
										   ,@ArtMoneda
										   ,@Almacen
										   ,@FechaAfectacion
										   ,@FechaRegistro
										   ,@Ejercicio
										   ,@Periodo
										   ,@Ok OUTPUT
										   ,@OkRef OUTPUT
										   ,@MovTipo = @MovTipo

				END

			END

			IF @CfgBackOrders = 1
				AND @MovTipo = 'VTAS.P'
				AND @Accion NOT IN ('RESERVARPARCIAL', 'ASIGNAR')
			BEGIN
				SELECT @DestinoTipo = @Modulo
					  ,@Destino = @Mov
					  ,@DestinoID = @MovID
				SELECT @Cantidad = SUM(Cantidad)
				FROM VentaD WITH(NOLOCK)
				WHERE id = @ID
				EXEC spInvBackOrder @Sucursal
								   ,@Accion
								   ,@Estatus
								   ,0
								   ,@Empresa
								   ,@Usuario
								   ,@Modulo
								   ,@ID
								   ,@Mov
								   ,@MovID
								   ,@DestinoTipo
								   ,@Destino
								   ,@DestinoID
								   ,@Articulo
								   ,@SubCuenta
								   ,@MovUnidad
								   ,@Cantidad
								   ,@Factor
								   ,@ArtMoneda
								   ,@Almacen
								   ,@FechaAfectacion
								   ,@FechaRegistro
								   ,@Ejercicio
								   ,@Periodo
								   ,@Ok OUTPUT
								   ,@OkRef OUTPUT
								   ,@MovTipo = @MovTipo
			END

			IF @Generar = 1
				AND @GenerarCopia = 1
				AND @Ok IS NULL
			BEGIN

				IF @MovTipo IN ('VTAS.C', 'VTAS.CS', 'VTAS.FR')
					SELECT @GenerarDirecto = 1
				ELSE
					SELECT @GenerarDirecto = 0

				EXEC spInvGenerarDetalle @Sucursal
										,@Modulo
										,@ID
										,@Renglon
										,@RenglonSub
										,@IDGenerar
										,@GenerarDirecto
										,@Mov
										,@MovID
										,@Cantidad
										,@Ok OUTPUT

				IF @Base = 'SELECCION'
				BEGIN

					IF @Modulo = 'VTAS'
						UPDATE VentaD WITH(ROWLOCK)
						SET CantidadA = NULL
						WHERE CURRENT OF crVentaDetalle
					ELSE

					IF @Modulo = 'COMS'
						UPDATE CompraD WITH(ROWLOCK)
						SET CantidadA = NULL
						WHERE CURRENT OF crCompraDetalle
					ELSE

					IF @Modulo = 'INV'
						UPDATE InvD WITH(ROWLOCK)
						SET CantidadA = NULL
						WHERE CURRENT OF crInvDetalle
					ELSE

					IF @Modulo = 'PROD'
						UPDATE ProdD (ROWLOCK)
						SET CantidadA = NULL
						WHERE CURRENT OF crProdDetalle

					IF @@ERROR <> 0
						SELECT @Ok = 1

				END

			END

			IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
			BEGIN
				SELECT @TiempoEstandarFijo = NULL
					  ,@TiempoEstandarVariable = NULL

				IF @MovTipo IN ('PROD.A', 'PROD.E')
					SELECT @TiempoEstandarFijo = ISNULL(TiempoFijo, 0)
						  ,@TiempoEstandarVariable = ISNULL(TiempoVariable, 0) * @Cantidad
					FROM ProdRutaD WITH(NOLOCK)
					WHERE Ruta = @Ruta
					AND Orden = @Orden
					AND Centro = @Centro

				IF @Modulo = 'VTAS'
					UPDATE VentaD WITH(ROWLOCK)
					SET Unidad = @MovUnidad
					   ,Factor = @Factor
					   ,ArtEstatus =
						CASE
							WHEN @CfgVentaArtEstatus = 1 THEN @ArtEstatus
							ELSE NULL
						END
					   ,ArtSituacion =
						CASE
							WHEN @CfgVentaArtSituacion = 1 THEN @ArtSituacion
							ELSE NULL
						END
					WHERE CURRENT OF crVentaDetalle
				ELSE

				IF @Modulo = 'COMS'
					UPDATE CompraD WITH(ROWLOCK)
					SET Unidad = @MovUnidad
					   ,Factor = @Factor
					WHERE CURRENT OF crCompraDetalle
				ELSE

				IF @Modulo = 'INV'
					UPDATE InvD WITH(ROWLOCK)
					SET Unidad = @MovUnidad
					   ,Factor = @Factor
					WHERE CURRENT OF crInvDetalle
				ELSE

				IF @Modulo = 'PROD'
					UPDATE ProdD WITH(ROWLOCK)
					SET Unidad = @MovUnidad
					   ,Factor = @Factor
					   ,TiempoEstandarFijo = @TiempoEstandarFijo
					   ,TiempoEstandarVariable = @TiempoEstandarVariable
					WHERE CURRENT OF crProdDetalle

			END

			IF @MovTipo = 'COMS.R'
			BEGIN
				SELECT @CompraID = NULL
				SELECT @CompraID = MAX(c.ID)
				FROM Compra c WITH(NOLOCK)
					,CompraD d WITH(NOLOCK)
					,MovTipo mt WITH(NOLOCK)
				WHERE c.Empresa = @Empresa
				AND c.Estatus = 'CONCLUIDO'
				AND mt.Modulo = @Modulo
				AND mt.Mov = c.Mov
				AND mt.Clave IN ('COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI')
				AND d.ID = c.ID
				AND d.Articulo = @Articulo
				AND ISNULL(d.SubCuenta, '') = ISNULL(@SubCuenta, '')

				IF @CompraID IS NOT NULL
					SELECT @ProveedorRef = Proveedor
					FROM Compra WITH(NOLOCK)
					WHERE ID = @CompraID
				ELSE
				BEGIN
					SELECT @ProveedorRef = @ClienteProv
					SELECT @ProveedorRef = ISNULL(p.Proveedor, @ClienteProv)
					FROM Art a WITH(NOLOCK)
						,Prov p WITH(NOLOCK)
					WHERE a.Articulo = @Articulo
					AND p.Proveedor = a.Proveedor
				END

				UPDATE CompraD WITH(ROWLOCK)
				SET ProveedorRef = @ProveedorRef
				WHERE CURRENT OF crCompraDetalle
			END

			IF @Modulo = 'COMS'
				AND @Accion IN ('AFECTAR', 'CANCELAR')
				AND NULLIF(RTRIM(@ServicioSerie), '') IS NOT NULL
				EXEC spSerieLoteFlujo @Sucursal
									 ,@SucursalAlmacen
									 ,@SucursalAlmacenDestino
									 ,@Accion
									 ,@Empresa
									 ,@Modulo
									 ,@ID
									 ,@ServicioArticulo
									 ,NULL
									 ,@ServicioSerie
									 ,@Almacen
									 ,@RenglonID
									 ,@Tarima = @Tarima

			IF @MovTipo IN ('VTAS.P', 'VTAS.S', 'VTAS.SD', 'VTAS.F', 'VTAS.FAR', 'VTAS.FB', 'VTAS.D', 'VTAS.DF', 'VTAS.B', 'VTAS.FM', 'VTAS.N', 'VTAS.NO', 'VTAS.NR', 'PROD.A', 'PROD.R', 'PROD.E')
				AND @FacturarVtasMostrador = 0
				AND (@Estatus IN ('SINAFECTAR', 'BORRADOR') OR @Accion = 'CANCELAR')
				AND @Ok IS NULL
			BEGIN

				IF @Accion = 'CANCELAR'
				BEGIN

					IF @Modulo = 'VTAS'
						SELECT @ImporteComision = ISNULL(Comision, 0.0)
						FROM VentaD WITH(NOLOCK)
						WHERE ID = @ID
						AND Renglon = @Renglon
						AND RenglonSub = @RenglonSub
					ELSE

					IF @Modulo = 'PROD'
						SELECT @ImporteComision = ISNULL(Comision, 0.0)
						FROM ProdD WITH(NOLOCK)
						WHERE ID = @ID
						AND Renglon = @Renglon
						AND RenglonSub = @RenglonSub

				END
				ELSE
				BEGIN
					EXEC xpComisionCalcular @ID
										   ,@Accion
										   ,@Empresa
										   ,@Usuario
										   ,@Modulo
										   ,@Mov
										   ,@MovID
										   ,@MovTipo
										   ,@MovMoneda
										   ,@MovTipoCambio
										   ,@FechaEmision
										   ,@FechaRegistro
										   ,@FechaAfectacion
										   ,@Agente
										   ,@Conexion
										   ,@SincroFinal
										   ,@Sucursal
										   ,@Renglon
										   ,@RenglonSub
										   ,@Articulo
										   ,@Cantidad
										   ,@Importe
										   ,@ImporteNeto
										   ,@Impuestos
										   ,@ImpuestosNetos
										   ,@Costo
										   ,@ArtCosto
										   ,@ArtComision
										   ,@ImporteComision OUTPUT
										   ,@Ok OUTPUT
										   ,@OkRef OUTPUT

					IF ISNULL(@ImporteComision, 0.0) <> 0.0
						AND @Ok IS NULL
					BEGIN

						IF @Modulo = 'VTAS'
							UPDATE VentaD WITH(ROWLOCK)
							SET Comision = @ImporteComision
							WHERE CURRENT OF crVentaDetalle
						ELSE

						IF @Modulo = 'PROD'
							UPDATE ProdD WITH(ROWLOCK)
							SET Comision = @ImporteComision
							WHERE CURRENT OF crProdDetalle

					END

				END

			END

			IF @MovTipo NOT IN ('COMS.R', 'COMS.C', 'COMS.O', 'COMS.OP')
			BEGIN

				IF (
						SELECT TieneMovimientos
						FROM Art WITH(NOLOCK)
						WHERE Articulo = @Articulo
					)
					= 0
					UPDATE Art WITH(ROWLOCK)
					SET TieneMovimientos = 1
					WHERE Articulo = @Articulo

				IF NULLIF(RTRIM(@SubCuenta), '') IS NOT NULL
				BEGIN

					IF (
							SELECT TieneMovimientos
							FROM ArtSub WITH(NOLOCK)
							WHERE Articulo = @Articulo
							AND SubCuenta = @SubCuenta
						)
						= 0
						UPDATE ArtSub WITH(ROWLOCK)
						SET TieneMovimientos = 1
						WHERE Articulo = @Articulo
						AND SubCuenta = @SubCuenta

				END

				IF @MovTipo IN ('VTAS.N', 'VTAS.NO', 'VTAS.NR', 'VTAS.FM', 'VTAS.F', 'COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI')
					EXEC spArtUlt @Articulo
								 ,@FechaEmision
								 ,@Modulo
								 ,@MovTipo
								 ,@ID

			END

			IF @EsEntrada = 1
				OR @EsSalida = 1
				OR @EsTransferencia = 1
			BEGIN
				EXEC spRegistrarArtAlm @Empresa
									  ,@Articulo
									  ,@SubCuenta
									  ,@Almacen
									  ,@FechaEmision

				IF @AlmacenDestino IS NOT NULL
					EXEC spRegistrarArtAlm @Empresa
										  ,@Articulo
										  ,@SubCuenta
										  ,@AlmacenDestino
										  ,@FechaEmision

			END

			IF @MovTipo = 'PROD.O'
				AND @Centro IS NOT NULL
			BEGIN

				IF (
						SELECT TieneMovimientos
						FROM Centro WITH(NOLOCK)
						WHERE Centro = @Centro
					)
					= 0
					UPDATE Centro WITH(ROWLOCK)
					SET TieneMovimientos = 1
					WHERE Centro = @Centro

			END

			IF @Modulo = 'VTAS'
				AND @Mov = @CfgIngresoMov
				AND @CfgEspacios = 1
			BEGIN

				IF @Accion = 'CANCELAR'
				BEGIN
					SELECT @EspacioDAnterior = NULL

					IF @AplicaMov = @CfgIngresoMov
						SELECT @EspacioDAnterior = MIN(d.Espacio)
						FROM VentaD d WITH(NOLOCK)
							,Venta v WITH(NOLOCK)
						WHERE v.Empresa = @Empresa
						AND v.Mov = @AplicaMov
						AND v.MovID = @AplicaMovID
						AND v.Estatus IN ('CONCLUIDO', 'PENDIENTE')
						AND d.ID = v.ID
						AND d.Articulo = @Articulo
						AND d.SubCuenta = @SubCuenta
						AND d.Espacio IS NOT NULL

					UPDATE Cte WITH(ROWLOCK) 
					SET Espacio = NULLIF(RTRIM(@EspacioDAnterior), '')
					WHERE Cliente = @ClienteProv
				END
				ELSE

				IF @EspacioD IS NULL
					SELECT @Ok = 10210
				ELSE
					UPDATE Cte WITH(ROWLOCK)
					SET Espacio = @EspacioD
					WHERE Cliente = @ClienteProv

			END

			IF @MovTipo = 'INV.IF'
				AND @Accion = 'AFECTAR'
				AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
				EXEC spArtAlmABC @Articulo
								,@Almacen
								,@FechaEmision
								,@CfgDiasHabiles
								,@CfgABCDiasHabiles

			IF @Ok IS NULL
				EXEC xpInvAfectarDetalle @ID
										,@Accion
										,@Base
										,@Empresa
										,@Usuario
										,@Modulo
										,@Mov
										,@MovID
										,@MovTipo
										,@MovMoneda
										,@MovTipoCambio
										,@Estatus
										,@EstatusNuevo
										,@FechaEmision
										,@FechaRegistro
										,@FechaAfectacion
										,@Conexion
										,@SincroFinal
										,@Sucursal
										,@Renglon
										,@RenglonSub
										,@Articulo
										,@Cantidad
										,@Importe
										,@ImporteNeto
										,@Impuestos
										,@ImpuestosNetos
										,@Ok OUTPUT
										,@OkRef OUTPUT

			SELECT @ImporteRetencion = 0.0
				  ,@ImporteRetencion2 = 0.0
				  ,@ImporteRetencion3 = 0.0

			IF @Modulo = 'VTAS'
				AND @Ok IS NULL
			BEGIN
				SELECT @ImporteRetencion = (@ImporteNeto * (@MovRetencion1 / 100.0))
					  ,@ImporteRetencion2 = (@ImporteNeto * (@MovRetencion2 / 100.0))
					  ,@ImporteRetencion3 = (@ImporteNeto * (@MovRetencion3 / 100.0))

				IF @CfgRetencion2BaseImpuesto1 = 1
					SELECT @ImporteRetencion2 = (@Impuesto1Neto * (@MovRetencion2 / 100.0))

			END

			IF @MovTipo IN ('COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI', 'COMS.D')
			BEGIN
				SELECT @ImporteRetencion = (@ImporteNeto * (@MovRetencion1 / 100.0))
					  ,@ImporteRetencion2 = (@ImporteNeto * (@MovRetencion2 / 100.0))
					  ,@ImporteRetencion3 = (@ImporteNeto * (@MovRetencion3 / 100.0))

				IF @CfgRetencion2BaseImpuesto1 = 1
					SELECT @ImporteRetencion2 = (@Impuesto1Neto * (@MovRetencion2 / 100.0))

			END

			SELECT @SumaPendiente = @SumaPendiente + ISNULL(@CantidadPendiente, 0.0)
				  ,@SumaReservada = @SumaReservada + ISNULL(@CantidadReservada, 0.0)
				  ,@SumaOrdenada = @SumaOrdenada + ISNULL(@CantidadOrdenada, 0.0)
				  ,@SumaImporte = @SumaImporte + @Importe
				  ,@SumaImporteNeto = @SumaImporteNeto + @ImporteNeto
				  ,@ComisionImporteNeto = @ComisionImporteNeto + @ImporteNeto
				  ,@SumaImpuestos = @SumaImpuestos + @Impuestos
				  ,@SumaImpuestosNetos = @SumaImpuestosNetos + @ImpuestosNetos
				  ,@SumaImpuesto1Neto = @SumaImpuesto1Neto + @Impuesto1Neto
				  ,@SumaImpuesto2Neto = @SumaImpuesto2Neto + @Impuesto2Neto
				  ,@SumaImpuesto3Neto = @SumaImpuesto3Neto + @Impuesto3Neto
				  ,@SumaImpuesto5Neto = @SumaImpuesto5Neto + @Impuesto5Neto
				  ,@SumaCostoLinea = @SumaCostoLinea + ROUND(@Costo * @Cantidad, @RedondeoMonetarios)
				  ,@SumaPrecioLinea = @SumaPrecioLinea + ROUND(@Precio * @Cantidad, @RedondeoMonetarios)
				  ,@SumaDescuentoLinea = @SumaDescuentoLinea + @DescuentoLineaImporte
				  ,@SumaPeso = @SumaPeso + (@Cantidad * @Peso * @Factor)
				  ,@SumaVolumen = @SumaVolumen + (@Cantidad * @Volumen * @Factor)
				  ,@SumaComision = @SumaComision + ISNULL(@ImporteComision, 0.0)
				  ,@ComisionAcum = @ComisionAcum + ISNULL(@ImporteComision, 0.0) * @ComisionFactor
				  ,@SumaRetencion = @SumaRetencion + ISNULL(@ImporteRetencion, 0.0)
				  ,@SumaRetencion2 = @SumaRetencion2 + ISNULL(@ImporteRetencion2, 0.0)
				  ,@SumaRetencion3 = @SumaRetencion3 + ISNULL(@ImporteRetencion3, 0.0)
		END

		IF @Ok IS NOT NULL
			AND @OkRef IS NULL
		BEGIN
			SELECT @OkRef = 'Articulo: ' + @Articulo

			IF @SubCuenta IS NOT NULL
				SELECT @OkRef = @OkRef + ' (' + @SubCuenta + ')'

		END

		IF @Ok IS NULL
			AND @SubCuentaExplotarInformacion = 1
			EXEC spMovOpcion @Modulo
							,@ID
							,@Renglon
							,@RenglonSub
							,@Subcuenta
							,@Ok OUTPUT
							,@OkRef OUTPUT

		IF @Ok IS NULL
		BEGIN

			IF @Modulo = 'VTAS'
				FETCH NEXT FROM crVentaDetalle INTO @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @CantidadOriginal, @CantidadObsequio, @CantidadInventario, @CantidadReservada, @CantidadOrdenada, @CantidadPendiente, @CantidadA, @Factor, @MovUnidad, @Articulo, @Subcuenta, @Costo, @Precio, @DescuentoTipo, @DescuentoLinea, @Impuesto1, @Impuesto2, @Impuesto3, @AplicaMov, @AplicaMovID, @AlmacenRenglon, @AgenteRenglon, @ArtTipo, @ArtSerieLoteInfo, @ArtTipoOpcion, @Peso, @Volumen, @ArtUnidad, @MovRetencion1, @MovRetencion2, @MovRetencion3, @UltReservadoCantidad, @UltReservadoFecha, @ArtComision, @EspacioD, @ArtLotesFijos, @ArtActividades, @ArtCostoIdentificado, @ArtCostoUEPS, @ArtCostoPEPS, @ArtUltimoCosto, @ArtCostoEstandar, @ArtPrecioLista, @PrecioTipoCambio, @Posicion, @Tarima, @ArtDepartamentoDetallista, @ArtEstatus, @ArtSituacion, @ArtExcento1, @ArtExcento2, @ArtExcento3, @TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3, @ContUso, @ContUso2, @ContUso3, @Retencion1, @Retencion2, @Retencion3, @AnticipoFacturado
			ELSE

			IF @Modulo = 'COMS'
				FETCH NEXT FROM crCompraDetalle INTO @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @CantidadOriginal, @CantidadInventario, @CantidadReservada, @CantidadOrdenada, @CantidadPendiente, @CantidadA, @Factor, @MovUnidad, @Articulo, @Subcuenta, @Costo, @Precio, @DescuentoTipo, @DescuentoLinea, @Impuesto1, @Impuesto2, @Impuesto3, @Impuesto5, @AplicaMov, @AplicaMovID, @AlmacenRenglon, @ServicioArticulo, @ServicioSerie, @ArtTipo, @ArtSerieLoteInfo, @ArtTipoOpcion, @Peso, @Volumen, @ArtUnidad, @MovRetencion1, @MovRetencion2, @MovRetencion3, @ArtLotesFijos, @ArtActividades, @ArtCostoIdentificado, @ArtCostoUEPS, @ArtCostoPEPS, @ArtUltimoCosto, @ArtCostoEstandar, @ArtPrecioLista, @Posicion, @Tarima, @ArtDepartamentoDetallista, @ArtEstatus, @ArtSituacion, @ArtExcento1, @ArtExcento2, @ArtExcento3, @TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoImpuesto5, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3, @ContUso, @ContUso2, @ContUso3, @ClavePresupuestal, @FechaCaducidad, @Retencion1, @Retencion2, @Retencion3, @PosicionActual, @PosicionReal
			ELSE

			IF @Modulo = 'INV'
				FETCH NEXT FROM crInvDetalle INTO @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @CantidadOriginal, @CantidadInventario, @CantidadReservada, @CantidadOrdenada, @CantidadPendiente, @CantidadA, @Factor, @MovUnidad, @Articulo, @Subcuenta, @Costo, @Precio, @DescuentoTipo, @DescuentoLinea, @Impuesto1, @Impuesto2, @Impuesto3, @AplicaMov, @AplicaMovID, @AlmacenRenglon, @ProdSerieLote, @ArtTipo, @ArtSerieLoteInfo, @ArtTipoOpcion, @Peso, @Volumen, @ArtUnidad, @UltReservadoCantidad, @UltReservadoFecha, @DetalleTipo, @Producto, @SubProducto, @ArtLotesFijos, @ArtActividades, @ArtCostoIdentificado, @ArtCostoUEPS, @ArtCostoPEPS, @ArtUltimoCosto, @ArtCostoEstandar, @ArtPrecioLista, @Posicion, @Tarima, @ArtDepartamentoDetallista, @ArtEstatus, @ArtSituacion, @ArtExcento1, @ArtExcento2, @ArtExcento3, @TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3, @Seccion, @FechaCaducidad, @PosicionDestino, @PosicionActual, @PosicionReal
			ELSE

			IF @Modulo = 'PROD'
				FETCH NEXT FROM crProdDetalle INTO @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @CantidadOriginal, @CantidadInventario, @CantidadReservada, @CantidadOrdenada, @CantidadPendiente, @CantidadA, @Factor, @MovUnidad, @Articulo, @Subcuenta, @Costo, @Precio, @DescuentoTipo, @DescuentoLinea, @Impuesto1, @Impuesto2, @Impuesto3, @AplicaMov, @AplicaMovID, @AlmacenRenglon, @ProdSerieLote, @ArtTipo, @ArtSerieLoteInfo, @ArtTipoOpcion, @Peso, @Volumen, @ArtUnidad, @UltReservadoCantidad, @UltReservadoFecha, @DetalleTipo, @Merma, @Desperdicio, @Ruta, @Orden, @Centro, @ArtLotesFijos, @ArtActividades, @ArtCostoIdentificado, @ArtCostoUEPS, @ArtCostoPEPS, @ArtUltimoCosto, @ArtCostoEstandar, @ArtPrecioLista, @Posicion, @Tarima, @ArtDepartamentoDetallista, @ArtEstatus, @ArtSituacion, @ArtExcento1, @ArtExcento2, @ArtExcento3, @TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3

			IF @@ERROR <> 0
				SELECT @Ok = 1

		END

		END

		IF @Modulo = 'VTAS'
		BEGIN
			CLOSE crVentaDetalle
			DEALLOCATE crVentaDetalle
		END
		ELSE

		IF @Modulo = 'COMS'
		BEGIN
			CLOSE crCompraDetalle
			DEALLOCATE crCompraDetalle
		END
		ELSE

		IF @Modulo = 'INV'
		BEGIN
			CLOSE crInvDetalle
			DEALLOCATE crInvDetalle
		END
		ELSE

		IF @Modulo = 'PROD'
		BEGIN
			CLOSE crProdDetalle
			DEALLOCATE crProdDetalle
		END

	END

	IF @MovTipo = 'INV.T'
		AND @Ok IS NULL
		AND @CfgCostearTransferencias = 1
		EXEC spInvCostearTransferencias @Modulo
									   ,@ID
									   ,@MovTipo

	IF @Modulo = 'VTAS'
		AND @Ok IS NULL
		EXEC xpVentaRetencionTotalCalcular @ID
										  ,@Accion
										  ,@Empresa
										  ,@Usuario
										  ,@Modulo
										  ,@Mov
										  ,@MovID
										  ,@MovTipo
										  ,@MovMoneda
										  ,@MovTipoCambio
										  ,@ClienteProv
										  ,@SumaImpuesto1Neto
										  ,@SumaImpuesto2Neto
										  ,@SumaImpuesto3Neto
										  ,@SumaRetencion OUTPUT
										  ,@SumaRetencion2 OUTPUT
										  ,@Ok OUTPUT
										  ,@OkRef OUTPUT
										  ,@SumaRetencion3 = @SumaRetencion3 OUTPUT

	IF @PPTO = 1
		AND @Accion <> 'CANCELAR'
		AND (@Modulo = 'COMS' OR (@Modulo = 'VTAS' AND @PPTOVentas = 1))
		EXEC spModuloAgregarMovPresupuesto @Modulo
										  ,@ID
										  ,@Ok OUTPUT
										  ,@OkRef OUTPUT

	IF (@AfectarMatando = 1 AND @Utilizar = 0 AND @MatarAntes = 0 AND @Ok IS NULL)
		OR (@MovTipo = 'INV.TMA' AND @Accion <> 'CANCELAR' AND @Ok IS NULL)
		EXEC spInvMatar @Sucursal
					   ,@ID
					   ,@Accion
					   ,@Base
					   ,@Empresa
					   ,@Usuario
					   ,@Modulo
					   ,@Mov
					   ,@MovID
					   ,@MovTipo
					   ,@Estatus
					   ,@EstatusNuevo
					   ,@FechaEmision
					   ,@FechaRegistro
					   ,@FechaAfectacion
					   ,@Ejercicio
					   ,@Periodo
					   ,@AfectarConsignacion
					   ,@AlmacenTipo
					   ,@AlmacenDestinoTipo
					   ,@CfgVentaSurtirDemas
					   ,@CfgCompraRecibirDemas
					   ,@CfgTransferirDemas
					   ,@CfgBackOrders
					   ,@CfgContX
					   ,@CfgContXGenerar
					   ,@CfgEmbarcar
					   ,@CfgImpInc
					   ,@CfgMultiUnidades
					   ,@CfgMultiUnidadesNivel
					   ,@Ok OUTPUT
					   ,@OkRef OUTPUT
					   ,@CfgPrecioMoneda = @CfgPrecioMoneda

	IF @Accion IN ('AFECTAR', 'CANCELAR', 'RESERVARPARCIAL', 'RESERVAR')
		AND @OrigenMovTipo IN ('VTAS.C', 'VTAS.CS', 'COMS.C')
	BEGIN
		EXEC spMovFlujo @Sucursal
					   ,@Accion
					   ,@Empresa
					   ,@Modulo
					   ,@IDOrigen
					   ,@Origen
					   ,@OrigenID
					   ,@Modulo
					   ,@ID
					   ,@Mov
					   ,@MovID
					   ,@Ok OUTPUT
	END

	IF @Ok IS NULL
	BEGIN
		SELECT @ImporteTotal = @SumaImporteNeto + @SumaImpuestosNetos

		IF @Modulo = 'VTAS'
		BEGIN
			SELECT @SumaImporteNeto = @SumaImporteNeto - (@SumaImporteNeto + @SumaImpuestosNetos - @ImporteTotal)
		END

		IF @AnticiposFacturados > 0.0
		BEGIN
			SELECT @AnticipoImporte = @SumaImporteNeto * @AnticiposFacturados / @ImporteTotal
			SELECT @AnticipoImpuestos = @AnticiposFacturados - @AnticipoImporte
		END
		ELSE
			SELECT @AnticipoImporte = 0.0
				  ,@AnticipoImpuestos = 0.0

		SELECT @ImporteCx = @SumaImporteNeto - @AnticipoImporte
			  ,@ImpuestosCx = @SumaImpuestosNetos - @AnticipoImpuestos
			  ,@RetencionCx = @SumaRetencion
			  ,@Retencion2Cx = @SumaRetencion2
			  ,@Retencion3Cx = @SumaRetencion3
			  ,@ImporteTotalCx = @ImporteTotal - @AnticiposFacturados
		SELECT @SumaRetenciones = ISNULL(@SumaRetencion, 0.0) + ISNULL(@SumaRetencion2, 0.0) + ISNULL(@SumaRetencion3, 0.0)

		IF @ImporteTotal > 0
			SELECT @FactorMovImpto = @ImporteTotalCx / @ImporteTotal
		ELSE
			SELECT @FactorMovImpto = 0

		IF @SubClave = 'COMS.CE/GT'
		BEGIN
			DECLARE
				@GTImpuesto1Mov VARCHAR(20)
			   ,@GTImpuesto1Acreedor VARCHAR(10)
			SELECT @GTImpuesto1Mov = NULLIF(RTRIM(Impuesto1Mov), '')
				  ,@GTImpuesto1Acreedor = NULLIF(RTRIM(Impuesto1Acreedor), '')
			FROM EmpresaCfgGT WITH(NOLOCK)
			WHERE Empresa = @Empresa

			IF @GTImpuesto1Mov IS NULL
				OR @GTImpuesto1Acreedor IS NULL
				SELECT @Ok = 20500
					  ,@OkRef = 'EmpresaCfgGT'

			EXEC spGenerarCx @Sucursal
							,@SucursalOrigen
							,@SucursalDestino
							,@Accion
							,NULL
							,@Empresa
							,@Modulo
							,@ID
							,@Mov
							,@MovID
							,@MovTipo
							,@MovMoneda
							,@MovTipoCambio
							,@FechaEmision
							,@CfgRetencionConcepto
							,@Proyecto
							,@Usuario
							,@Autorizacion
							,@Referencia
							,@DocFuente
							,@Observaciones
							,@FechaRegistro
							,@Ejercicio
							,@Periodo
							,NULL
							,NULL
							,@GTImpuesto1Acreedor
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,@ImpuestosCx
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,@GTImpuesto1Mov
							,@CxModulo OUTPUT
							,@CxMov OUTPUT
							,@CxMovID OUTPUT
							,@Ok OUTPUT
							,@OkRef OUTPUT
			SELECT @ImporteCx = @ImporteCx - ISNULL(@RetencionCx, 0.0)
			SELECT @RetencionCx = NULL
				  ,@ImpuestosCx = NULL
		END

		IF @MovImpuesto = 1
		BEGIN
			DELETE MovImpuesto
			WHERE Modulo = @Modulo
				AND ModuloID = @ID
			INSERT MovImpuesto (Modulo, ModuloID, OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenFecha, Retencion1, Retencion2, Retencion3, Impuesto1, Impuesto2, Impuesto3, Excento1, Excento2, Excento3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, LoteFijo, Importe1, Importe2, Importe3, SubTotal, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal, ImporteBruto)
				SELECT @Modulo
					  ,@ID
					  ,ISNULL(OrigenModulo, @Modulo)
					  ,ISNULL(OrigenModuloID, @ID)
					  ,ISNULL(OrigenConcepto, @Concepto)
					  ,ISNULL(OrigenFecha, @FechaEmision)
					  ,Retencion1
					  ,Retencion2
					  ,Retencion3
					  ,Impuesto1
					  ,Impuesto2
					  ,Impuesto3
					  ,Excento1
					  ,Excento2
					  ,Excento3
					  ,TipoImpuesto1
					  ,TipoImpuesto2
					  ,TipoImpuesto3
					  ,TipoRetencion1
					  ,TipoRetencion2
					  ,TipoRetencion3
					  ,LoteFijo
					  ,SUM(Importe1 * @FactorMovImpto)
					  ,SUM(Importe2 * @FactorMovImpto)
					  ,SUM(Importe3 * @FactorMovImpto)
					  ,SUM(SubTotal * @FactorMovImpto)
					  ,ContUso
					  ,ContUso2
					  ,ContUso3
					  ,ClavePresupuestal
					  ,ClavePresupuestalImpuesto1
					  ,DescuentoGlobal
					  ,SUM(ImporteBruto * @FactorMovImpto)
				FROM #MovImpuesto
				GROUP BY Retencion1
						,Retencion2
						,Retencion3
						,Impuesto1
						,Impuesto2
						,Impuesto3
						,Excento1
						,Excento2
						,Excento3
						,TipoImpuesto1
						,TipoImpuesto2
						,TipoImpuesto3
						,TipoRetencion1
						,TipoRetencion2
						,TipoRetencion3
						,LoteFijo
						,ContUso
						,ContUso2
						,ContUso3
						,ClavePresupuestal
						,ClavePresupuestalImpuesto1
						,DescuentoGlobal
						,ISNULL(OrigenModulo, @Modulo)
						,ISNULL(OrigenModuloID, @ID)
						,ISNULL(OrigenConcepto, @Concepto)
						,ISNULL(OrigenFecha, @FechaEmision)
				ORDER BY Retencion1, Retencion2, Retencion3, Impuesto1, Impuesto2, Impuesto3, Excento1, Excento2, Excento3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, LoteFijo, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal, ISNULL(OrigenModulo, @Modulo), ISNULL(OrigenModuloID, @ID), ISNULL(OrigenConcepto, @Concepto), ISNULL(OrigenFecha, @FechaEmision)
		END

		IF @Utilizar = 1
			AND @ImporteTotal > 0.0
			AND @UtilizarMovTipo IN ('VTAS.P', 'VTAS.R', 'VTAS.S', 'VTAS.VC', 'VTAS.VCR', 'COMS.O', 'COMS.OP', 'COMS.CC')
		BEGIN

			IF @Modulo = 'VTAS'
				UPDATE Venta WITH(ROWLOCK)
				SET Saldo = Saldo - @ImporteTotal
				WHERE ID = @UtilizarID
			ELSE

			IF @Modulo = 'COMS'
				UPDATE Compra WITH(ROWLOCK)
				SET Saldo = Saldo - @ImporteTotal
				WHERE ID = @UtilizarID

			IF @@ERROR <> 0
				SELECT @Ok = 1

		END

		IF (@Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @AfectarDetalle = 1)
			OR (@MovTipo IN ('COMS.D', 'COMS.B', 'COMS.CA', 'COMS.GX'))
		BEGIN
			SELECT @Paquetes = NULL

			IF @Modulo = 'VTAS'
				AND @MovTipo NOT IN ('VTAS.PR', 'VTAS.EST', 'VTAS.C', 'VTAS.CS', 'VTAS.P', 'VTAS.S', 'VTAS.SD')
			BEGIN
				SELECT @Paquetes = ISNULL(COUNT(DISTINCT Paquete), 0)
				FROM VentaD WITH(NOLOCK)
				WHERE ID = @ID
				SELECT @Paquetes = @Paquetes + ISNULL(ROUND(SUM(Cantidad), 0), 0)
				FROM VentaD WITH(NOLOCK)
				WHERE ID = @ID
				AND NULLIF(Paquete, 0) IS NULL
				AND RenglonTipo <>
				CASE @EmbarqueSumaArtJuego
					WHEN 'Articulo Juego' THEN 'C'
					WHEN 'Componentes' THEN 'J'
					ELSE 'J'
				END
			END
			ELSE

			IF @Modulo = 'INV'
				AND @MovTipo NOT IN ('INV.SOL', 'INV.OT', 'INV.OT', 'INV.IF')
			BEGIN
				SELECT @Paquetes = ISNULL(COUNT(DISTINCT Paquete), 0)
				FROM InvD WITH(NOLOCK)
				WHERE ID = @ID
				SELECT @Paquetes = @Paquetes + ISNULL(ROUND(SUM(Cantidad), 0), 0)
				FROM InvD WITH(NOLOCK)
				WHERE ID = @ID
				AND NULLIF(Paquete, 0) IS NULL
				AND RenglonTipo <>
				CASE @EmbarqueSumaArtJuego
					WHEN 'Articulo Juego' THEN 'C'
					WHEN 'Componentes' THEN 'J'
					ELSE 'J'
				END
			END
			ELSE

			IF @Modulo = 'COMS'
				AND @MovTipo NOT IN ('COMS.R', 'COMS.C', 'COMS.O', 'COMS.OP', 'COMS.OG', 'COMS.OD', 'COMS.OI')
			BEGIN
				SELECT @Paquetes = ISNULL(COUNT(DISTINCT Paquete), 0)
				FROM InvD WITH(NOLOCK)
				WHERE ID = @ID
				SELECT @Paquetes = @Paquetes + ISNULL(ROUND(SUM(Cantidad), 0), 0)
				FROM CompraD WITH(NOLOCK)
				WHERE ID = @ID
				AND NULLIF(Paquete, 0) IS NULL
				AND RenglonTipo <>
				CASE @EmbarqueSumaArtJuego
					WHEN 'Articulo Juego' THEN 'C'
					WHEN 'Componentes' THEN 'J'
					ELSE 'J'
				END
			END

			SELECT @IVAFiscal = CONVERT(FLOAT, @SumaImpuesto1Neto) / NULLIF(@ImporteTotal - @SumaRetenciones, 0)
				  ,@IEPSFiscal = CONVERT(FLOAT, @SumaImpuesto2Neto) / NULLIF(@ImporteTotal - @SumaRetenciones, 0)

			IF @Modulo = 'VTAS'
				UPDATE Venta WITH(ROWLOCK)
				SET Peso = @SumaPeso
				   ,Volumen = @SumaVolumen
				   ,Paquetes = @Paquetes
				   ,Importe = @SumaImporte
				   ,Impuestos = @SumaImpuestosNetos
				   ,IVAFiscal = @IVAFiscal
				   ,IEPSFiscal = @IEPSFiscal
				   ,Saldo =
					CASE
						WHEN @EstatusNuevo IN ('PENDIENTE', 'PROCESAR') THEN @ImporteTotal
						ELSE NULL
					END
				   ,DescuentoLineal = @SumaDescuentoLinea
				   ,ComisionTotal = @SumaComision
				   ,PrecioTotal = @SumaPrecioLinea
				   ,CostoTotal = @SumaCostoLinea
				   ,Retencion = NULLIF(@SumaRetenciones, 0.0)
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'COMS'
				UPDATE Compra WITH(ROWLOCK)
				SET Peso = @SumaPeso
				   ,Volumen = @SumaVolumen
				   ,Paquetes = @Paquetes
				   ,Importe = @SumaImporte
				   ,Impuestos = @SumaImpuestosNetos
				   ,IVAFiscal = @IVAFiscal
				   ,IEPSFiscal = @IEPSFiscal
				   ,Saldo =
					CASE
						WHEN @EstatusNuevo IN ('PENDIENTE', 'PROCESAR') THEN @ImporteTotal
						ELSE NULL
					END
				   ,DescuentoLineal = @SumaDescuentoLinea
				   ,Retencion = NULLIF(@SumaRetenciones, 0.0)
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'INV'
				UPDATE Inv WITH(ROWLOCK)
				SET Peso = @SumaPeso
				   ,Volumen = @SumaVolumen
				   ,Paquetes = @Paquetes
				   ,Importe = @SumaCostoLinea
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PROD'
				UPDATE Prod WITH(ROWLOCK)
				SET Peso = @SumaPeso
				   ,Volumen = @SumaVolumen
				   ,Paquetes = @Paquetes
				   ,Importe = @SumaCostoLinea
				WHERE ID = @ID

			IF @@ERROR <> 0
				SELECT @Ok = 1

		END
		ELSE
			EXEC spInvReCalcEncabezado @ID
									  ,@Modulo
									  ,@CfgImpInc
									  ,@CfgMultiUnidades
									  ,@DescuentoGlobal
									  ,@SobrePrecio
									  ,@CfgPrecioMoneda = @CfgPrecioMoneda

		IF @MovTipo = 'INV.IF'
			AND @EstatusNuevo = 'CONCLUIDO'
			EXEC spInvInventarioFisico @Sucursal
									  ,@ID
									  ,@Empresa
									  ,@Almacen
									  ,@IDGenerar
									  ,@Base
									  ,@CfgSeriesLotesMayoreo
									  ,@Estatus
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT

		IF @MovTipo = 'VTAS.S'
			AND @Estatus = 'CONFIRMAR'
			AND @EstatusNuevo IN ('PENDIENTE', 'CANCELADO')
		BEGIN
			SELECT @CotizacionID = ID
			FROM Venta WITH(NOLOCK)
			WHERE Empresa = @Empresa
			AND OrigenTipo = 'VTAS'
			AND Origen = @Mov
			AND OrigenID = @MovID
			AND Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
			SELECT @CotizacionEstatusNuevo =
			 CASE
				 WHEN @Accion = 'CANCELAR' THEN 'CANCELADO'
				 ELSE 'CONCLUIDO'
			 END
			EXEC spValidarTareas @Empresa
								,@Modulo
								,@CotizacionID
								,@CotizacionEstatusNuevo
								,@Ok OUTPUT
								,@OkRef OUTPUT
			UPDATE Venta WITH(ROWLOCK)
			SET Estatus = @CotizacionEstatusNuevo
			WHERE ID = @CotizacionID
		END

		IF @@ERROR <> 0
			SELECT @Ok = 1

		IF @Estatus IN ('SINAFECTAR', 'AUTORIZARE', 'CONFIRMAR', 'BORRADOR')
			OR @Accion = 'CANCELAR'
		BEGIN

			IF @Accion <> 'CANCELAR'
			BEGIN

				IF @MovTipo = 'VTAS.FR'
					SELECT @Vencimiento = ISNULL(CASE
						 WHEN ConVigencia = 1 THEN VigenciaDesde
					 END, @FechaEmision)
					FROM Venta WITH(NOLOCK)
					WHERE ID = @ID
				ELSE
					EXEC spCalcularVencimiento @Modulo
											  ,@Empresa
											  ,@ClienteProv
											  ,@Condicion
											  ,@FechaEmision
											  ,@Vencimiento OUTPUT
											  ,@Dias OUTPUT
											  ,@Ok OUTPUT

				IF (@EnviarA = 76)
				BEGIN
					SELECT @DAPeriodo = DAPeriodo
					FROM Condicion WITH(NOLOCK)
					WHERE Condicion = @Condicion

					IF @DAPeriodo = 'QUINCENAL'
					BEGIN
						SET @Dia = DATEPART(dd, @Vencimiento)
						SET @MenosDias = DATEPART(dd, DATEADD(mm, 1, @Vencimiento))
						SET @MenosDias = (@Dia - @MenosDias) + 15

						IF @Dia <= 15
						BEGIN
							SELECT @EsQuince = 1
								  ,@Vencimiento = DATEADD(dd, 15 - @Dia, @Vencimiento)
							SET @Vencimiento = DATEADD(dd, @CorteDias, @Vencimiento)
						END
						ELSE
						BEGIN

							IF @Dia >= 16
								AND @Dia <= 30
							BEGIN
								SELECT @EsQuince = 0
									  ,@Vencimiento = DATEADD(dd, -DATEPART(dd, @Vencimiento), DATEADD(mm, 1, @Vencimiento))
								SET @Vencimiento = DATEADD(dd, @CorteDias, @Vencimiento)
							END
							ELSE
							BEGIN
								SELECT @EsQuince = 0
									  ,@Vencimiento = DATEADD(dd, -DATEPART(dd, @Vencimiento), DATEADD(mm, 1, @Vencimiento))
								SET @Vencimiento = DATEADD(dd, @CorteDias + @MenosDias, @Vencimiento)
							END

						END

					END

				END

				EXEC spExtraerFecha @Vencimiento OUTPUT
			END

			IF @MovTipo IN ('VTAS.P', 'VTAS.S', 'COMS.O')
				AND NULLIF(RTRIM(@Condicion), '') IS NOT NULL
				AND @EstatusNuevo <> 'CONFIRMAR'

				IF (
						SELECT UPPER(ControlAnticipos)
						FROM Condicion WITH(NOLOCK)
						WHERE Condicion = @Condicion
					)
					IN ('ABIERTO', 'PLAZOS', 'FECHA REQUERIDA')
					EXEC spGenerarAP @Sucursal
									,@Accion
									,@Empresa
									,@Modulo
									,@ID
									,@MovTipo
									,@FechaRegistro
									,@Mov
									,@MovID
									,@MovMoneda
									,@MovTipoCambio
									,@Proyecto
									,@ClienteProv
									,@Referencia
									,@Condicion
									,@Vencimiento
									,@ImporteTotal
									,@Ok OUTPUT
									,@OkRef OUTPUT

			IF @MovTipo = 'VTAS.NO'
			BEGIN
				SELECT @EsCargo = 1

				IF @Accion = 'CANCELAR'
					SELECT @EsCargo = ~@EsCargo

				EXEC spSaldo @Sucursal
							,@Accion
							,@Empresa
							,@Usuario
							,'CNO'
							,@MovMoneda
							,@MovTipoCambio
							,@ClienteProv
							,NULL
							,NULL
							,NULL
							,@Modulo
							,@ID
							,@Mov
							,@MovID
							,@EsCargo
							,@ImporteTotal
							,NULL
							,NULL
							,@FechaAfectacion
							,@Ejercicio
							,@Periodo
							,'Consumos'
							,NULL
							,0
							,0
							,0
							,@Ok OUTPUT
							,@OkRef OUTPUT
							,@Renglon = @Renglon
							,@RenglonSub = @RenglonSub
							,@RenglonID = @RenglonID
			END

		END

		IF (@Generar = 1 AND @GenerarAfectado = 1)
			OR (@Accion = 'CANCELAR' AND @Base <> 'TODO')
		BEGIN

			IF @Modulo = 'VTAS'
				SELECT @SumaPendiente = SUM(ROUND(ISNULL(CantidadPendiente, 0.0), 4))
					  ,@SumaReservada = SUM(ROUND(ISNULL(CantidadReservada, 0.0), 2))
					  ,@SumaOrdenada = SUM(ROUND(ISNULL(CantidadOrdenada, 0.0), 2))
				FROM VentaD WITH(NOLOCK)
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'COMS'
				SELECT @SumaPendiente = SUM(ROUND(ISNULL(CantidadPendiente, 0.0), 4))
				FROM CompraD WITH(NOLOCK)
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'INV'
				SELECT @SumaPendiente = SUM(ROUND(ISNULL(CantidadPendiente, 0.0), 4))
					  ,@SumaReservada = SUM(ROUND(ISNULL(CantidadReservada, 0.0), 2))
					  ,@SumaOrdenada = SUM(ROUND(ISNULL(CantidadOrdenada, 0.0), 2))
				FROM InvD WITH(NOLOCK)
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PROD'
				SELECT @SumaPendiente = SUM(ROUND(ISNULL(CantidadPendiente, 0.0), 4))
					  ,@SumaReservada = SUM(ROUND(ISNULL(CantidadReservada, 0.0), 2))
					  ,@SumaOrdenada = SUM(ROUND(ISNULL(CantidadOrdenada, 0.0), 2))
				FROM ProdD WITH(NOLOCK)
				WHERE ID = @ID

		END

		IF @MovTipo NOT IN ('INV.IF', 'PROD.A', 'PROD.R', 'PROD.E')
		BEGIN
			SELECT @TienePendientes = 0

			IF @Modulo = 'VTAS'
				AND EXISTS (SELECT * FROM VentaD WITH(NOLOCK) WHERE ID = @ID AND ((ISNULL(CantidadPendiente, 0.0) <> 0.0) OR (ISNULL(CantidadReservada, 0.0) <> 0.0) OR (ISNULL(CantidadOrdenada, 0.0) <> 0.0)))
				SELECT @TienePendientes = 1
			ELSE

			IF @Modulo = 'INV'
				AND EXISTS (SELECT * FROM InvD WITH(NOLOCK) WHERE ID = @ID AND ((ISNULL(CantidadPendiente, 0.0) <> 0.0) OR (ISNULL(CantidadReservada, 0.0) <> 0.0) OR (ISNULL(CantidadOrdenada, 0.0) <> 0.0)))
				SELECT @TienePendientes = 1
			ELSE

			IF @Modulo = 'PROD'
				AND EXISTS (SELECT * FROM ProdD WITH(NOLOCK) WHERE ID = @ID AND ((ISNULL(CantidadPendiente, 0.0) <> 0.0) OR (ISNULL(CantidadReservada, 0.0) <> 0.0) OR (ISNULL(CantidadOrdenada, 0.0) <> 0.0)))
				SELECT @TienePendientes = 1
			ELSE

			IF @Modulo = 'COMS'
				AND EXISTS (SELECT * FROM CompraD WITH(NOLOCK)  WHERE ID = @ID AND ISNULL(CantidadPendiente, 0.0) <> 0.0)
				SELECT @TienePendientes = 1

			IF @EstatusNuevo <> 'PENDIENTE'
				AND @TienePendientes = 1
				SELECT @EstatusNuevo = 'PENDIENTE'

			IF @EstatusNuevo = 'PENDIENTE'
				AND @TienePendientes = 0
				SELECT @EstatusNuevo = 'CONCLUIDO'

			IF @EstatusNuevo = 'PENDIENTE'
				AND @OrigenTipo = 'POS'
				AND @MovTipo = 'VTAS.C'
				SELECT @EstatusNuevo = 'CONFIRMAR'

		END

		IF @EstatusNuevo = 'CONCLUIDO'
			SELECT @FechaConclusion = @FechaEmision
		ELSE

		IF @EstatusNuevo <> 'CANCELADO'
			SELECT @FechaConclusion = NULL

		IF @EstatusNuevo = 'CANCELADO'
			SELECT @FechaCancelacion = @FechaRegistro
		ELSE
			SELECT @FechaCancelacion = NULL

		IF @CfgContX = 1
			AND @CfgContXGenerar <> 'NO'
		BEGIN

			IF @Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR')
				AND @EstatusNuevo = 'CANCELADO'
			BEGIN

				IF @GenerarPoliza = 1
					SELECT @GenerarPoliza = 0
				ELSE
					SELECT @GenerarPoliza = 1

				IF @MovTipo IN ('VTAS.F', 'VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX')
					AND @Estatus = 'PENDIENTE'
					AND @CfgContXFacturasPendientes = 0
					SELECT @GenerarPoliza = 0

			END
			ELSE
			BEGIN

				IF @MovTipo IN ('VTAS.F', 'VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX')
					AND @CfgContXFacturasPendientes = 0
				BEGIN

					IF @EstatusNuevo = 'CONCLUIDO'
						SELECT @GenerarPoliza = 1

				END
				ELSE

				IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR')
					AND @EstatusNuevo <> 'CANCELADO'
					SELECT @GenerarPoliza = 1

			END

		END

		EXEC spValidarTareas @Empresa
							,@Modulo
							,@ID
							,@EstatusNuevo
							,@Ok OUTPUT
							,@OkRef OUTPUT

		IF @Modulo = 'VTAS'
			UPDATE Venta WITH(ROWLOCK)
			SET Vencimiento = @Vencimiento
			   ,Concepto = @Concepto
			   ,FechaConclusion = @FechaConclusion
			   ,FechaCancelacion = @FechaCancelacion
			   ,UltimoCambio = @FechaRegistro
			   ,Estatus = @EstatusNuevo
			   ,Saldo =
				CASE
					WHEN @EstatusNuevo IN ('CONCLUIDO', 'CANCELADO') THEN NULL
					ELSE Saldo
				END
			   ,Situacion =
				CASE
					WHEN @Estatus <> @EstatusNuevo THEN NULL
					ELSE Situacion
				END
			   ,GenerarPoliza = @GenerarPoliza
			   ,Autorizacion = @Autorizacion
			   ,Mensaje = NULL
			WHERE ID = @ID
		ELSE

		IF @Modulo = 'COMS'
			UPDATE Compra WITH(ROWLOCK)
			SET Vencimiento = @Vencimiento
			   ,Concepto = @Concepto
			   ,FechaConclusion = @FechaConclusion
			   ,FechaCancelacion = @FechaCancelacion
			   ,UltimoCambio = @FechaRegistro
			   ,Estatus = @EstatusNuevo
			   ,Saldo =
				CASE
					WHEN @EstatusNuevo IN ('CONCLUIDO', 'CANCELADO') THEN NULL
					ELSE Saldo
				END
			   ,Situacion =
				CASE
					WHEN @Estatus <> @EstatusNuevo THEN NULL
					ELSE Situacion
				END
			   ,GenerarPoliza = @GenerarPoliza
			   ,Autorizacion = @Autorizacion
			   ,Mensaje = NULL
			WHERE ID = @ID
		ELSE

		IF @Modulo = 'INV'
			UPDATE Inv WITH(ROWLOCK)
			SET Vencimiento = @Vencimiento
			   ,Concepto = @Concepto
			   ,FechaConclusion = @FechaConclusion
			   ,FechaCancelacion = @FechaCancelacion
			   ,UltimoCambio = @FechaRegistro
			   ,Estatus = @EstatusNuevo
			   ,Situacion =
				CASE
					WHEN @Estatus <> @EstatusNuevo THEN NULL
					ELSE Situacion
				END
			   ,GenerarPoliza = @GenerarPoliza
			   ,Autorizacion = @Autorizacion
			WHERE ID = @ID
		ELSE

		IF @Modulo = 'PROD'
			UPDATE Prod WITH(ROWLOCK)
			SET Concepto = @Concepto
			   ,FechaConclusion = @FechaConclusion
			   ,FechaCancelacion = @FechaCancelacion
			   ,UltimoCambio = @FechaRegistro
			   ,Estatus = @EstatusNuevo
			   ,Situacion =
				CASE
					WHEN @Estatus <> @EstatusNuevo THEN NULL
					ELSE Situacion
				END
			   ,GenerarPoliza = @GenerarPoliza
			   ,Autorizacion = @Autorizacion
			WHERE ID = @ID

		IF @@ERROR <> 0
			SELECT @Ok = 1

		IF @MovTipo = 'INV.TMA'
			AND @WMS = 1
			AND @EstatusNuevo = 'CANCELADO'
		BEGIN
			UPDATE Tarima WITH(ROWLOCK)
			SET Tarima.Estatus = 'BAJA'
			   ,Tarima.Baja = @FechaCancelacion
			FROM InvD WITH(NOLOCK)
			JOIN Tarima WITH(NOLOCK)
				ON Tarima.Tarima = InvD.Tarima
				AND Tarima.Almacen = InvD.Almacen
			JOIN AlmPos WITH(NOLOCK)
				ON Tarima.Posicion = AlmPos.Posicion
				AND AlmPos.Almacen = InvD.Almacen
			WHERE InvD.ID = @ID
			AND ISNULL(InvD.Seccion, 0) = 1
			AND AlmPos.Tipo <> 'Domicilio'
		END

		EXEC spEmbarqueMov @Accion
						  ,@Empresa
						  ,@Modulo
						  ,@ID
						  ,@Mov
						  ,@MovID
						  ,@Estatus
						  ,@EstatusNuevo
						  ,@CfgEmbarcar
						  ,@Ok OUTPUT

		IF @Accion = 'CANCELAR'
		BEGIN

			IF @EstatusNuevo = 'PENDIENTE'
			BEGIN

				IF @Base <> 'SELECCION'

					IF @Modulo = 'VTAS'
						UPDATE Venta WITH(ROWLOCK)
						SET Saldo = Saldo - @ImporteTotal
						WHERE ID = @ID
					ELSE

					IF @Modulo = 'COMS'
						UPDATE Compra WITH(ROWLOCK)
						SET Saldo = Saldo - @ImporteTotal
						WHERE ID = @ID

			END
			ELSE
			BEGIN

				IF @Modulo = 'VTAS'
					UPDATE Venta WITH(ROWLOCK)
					SET Saldo = NULL
					WHERE ID = @ID
				ELSE

				IF @Modulo = 'COMS'
					UPDATE Compra WITH(ROWLOCK)
					SET Saldo = NULL
					WHERE ID = @ID

			END

			IF @@ERROR <> 0
				SELECT @Ok = 1

		END

		IF @MovTipo IN ('VTAS.VC', 'VTAS.VCR', 'VTAS.DC', 'VTAS.DCR')
			AND @Accion <> 'CANCELAR'
		BEGIN
			UPDATE Venta WITH(ROWLOCK)
			SET AlmacenDestino =
			CASE
				WHEN @MovTipo IN ('VTAS.VC', 'VTAS.VCR') THEN @GenerarAlmacenDestino
				ELSE @GenerarAlmacen
			END
			WHERE ID = @ID

			IF @@ERROR <> 0
				SELECT @Ok = 1

		END

		IF @Utilizar = 1
			AND @Ok IS NULL
			EXEC spInvAfectarUtilizarConcluido @Empresa
											  ,@Modulo
											  ,@FechaEmision
											  ,@UtilizarID
											  ,@AfectarMatando
											  ,@UtilizarEstatus
											  ,@SumaPendiente
											  ,@FechaConclusion
											  ,@Ok OUTPUT
											  ,@OkRef OUTPUT

		IF @Generar = 1
			AND @Ok IS NULL
		BEGIN

			IF @GenerarAfectado = 1
				SELECT @GenerarEstatus = 'CONCLUIDO'
			ELSE
				SELECT @GenerarEstatus = 'SINAFECTAR'

			IF @GenerarEstatus = 'CONCLUIDO'
				SELECT @FechaConclusion = @FechaEmision
			ELSE

			IF @GenerarEstatus <> 'CANCELADO'
				SELECT @FechaConclusion = NULL

			IF @UtilizarEstatus = 'CONCLUIDO'
				AND @CfgContX = 1
				AND @CfgContXGenerar <> 'NO'
				SELECT @GenerarPolizaTemp = 1
			ELSE
				SELECT @GenerarPolizaTemp = 0

			EXEC spValidarTareas @Empresa
								,@Modulo
								,@IDGenerar
								,@GenerarEstatus
								,@Ok OUTPUT
								,@OkRef OUTPUT

			IF @Modulo = 'VTAS'
				UPDATE Venta WITH(ROWLOCK)
				SET FechaConclusion = @FechaConclusion
				   ,Estatus = @GenerarEstatus
				   ,GenerarPoliza = @GenerarPolizaTemp
				WHERE ID = @IDGenerar
			ELSE

			IF @Modulo = 'COMS'
				UPDATE Compra WITH(ROWLOCK)
				SET FechaConclusion = @FechaConclusion
				   ,Estatus = @GenerarEstatus
				   ,GenerarPoliza = @GenerarPolizaTemp
				WHERE ID = @IDGenerar
			ELSE

			IF @Modulo = 'INV'
				UPDATE Inv WITH(ROWLOCK)
				SET FechaConclusion = @FechaConclusion
				   ,Estatus = @GenerarEstatus
				   ,GenerarPoliza = @GenerarPolizaTemp
				WHERE ID = @IDGenerar
			ELSE

			IF @Modulo = 'PROD'
				UPDATE Prod WITH(ROWLOCK)
				SET FechaConclusion = @FechaConclusion
				   ,Estatus = @GenerarEstatus
				   ,GenerarPoliza = @GenerarPolizaTemp
				WHERE ID = @IDGenerar

			IF @@ERROR <> 0
				SELECT @Ok = 1

			EXEC xpInvGenerarFinal @Empresa
								  ,@Usuario
								  ,@Accion
								  ,@Modulo
								  ,@ID
								  ,@IDGenerar
								  ,@GenerarEstatus
								  ,@Ok OUTPUT
								  ,@OkRef OUTPUT
		END

		IF @MovTipo = 'VTAS.S'
			AND NULLIF(RTRIM(@ServicioSerie), '') IS NOT NULL
		BEGIN
			EXEC spSerieLoteFlujo @Sucursal
								 ,@SucursalAlmacen
								 ,@SucursalAlmacenDestino
								 ,@Accion
								 ,@Empresa
								 ,@Modulo
								 ,@ID
								 ,@ServicioArticulo
								 ,NULL
								 ,@ServicioSerie
								 ,@Almacen
								 ,0
		END

		SELECT @Continuar = 1
			  ,@CxID = NULL
			  ,@CxMovTipo = NULL

		IF (@FacturarVtasMostrador = 1 AND @Accion <> 'CANCELAR')
			OR (@Accion = 'CANCELAR' AND @MovTipo IN ('VTAS.F', 'VTAS.FAR', 'VTAS.FB', 'VTAS.D') AND @OrigenTipo = 'VMOS')
		BEGIN
			SELECT @Continuar = 0
			EXEC spInvReCalcEncabezado @ID
									  ,@Modulo
									  ,@CfgImpInc
									  ,@CfgMultiUnidades
									  ,@DescuentoGlobal
									  ,@SobrePrecio
									  ,@CfgPrecioMoneda = @CfgPrecioMoneda

			IF @MovTipo IN ('VTAS.F', 'VTAS.FAR', 'VTAS.FB', 'VTAS.D')
				OR (@MovTipo IN ('VTAS.FM') AND @GenerarNCAlProcesar = 1)
			BEGIN
				EXEC spInvMatarNotas @Sucursal
									,@ID
									,@Accion
									,@Empresa
									,@Usuario
									,@Modulo
									,@Mov
									,@MovID
									,@FechaAfectacion
									,@Ejercicio
									,@Periodo
									,@Ok OUTPUT
									,@OkRef OUTPUT
									,@AfectandoNotasSinCobro OUTPUT
									,@MovTipo
				SELECT @Continuar = @AfectandoNotasSinCobro
			END

		END

		IF @MovTipo = 'VTAS.FB'
			AND @Accion IN ('AFECTAR', 'CANCELAR')
		BEGIN
			EXEC spMovTipoInstruccionBit @Modulo
										,@Mov
										,'IncrementaSaldoTarjeta'
										,@IncrementaSaldoTarjeta OUTPUT
										,@Ok OUTPUT
										,@OkRef OUTPUT

			IF @IncrementaSaldoTarjeta = 1
				EXEC spIncrementaSaldoTarjeta @Empresa
											 ,@ID
											 ,@Mov
											 ,@MovID
											 ,@Modulo
											 ,@Ejercicio
											 ,@Periodo
											 ,@Accion
											 ,@FechaEmision
											 ,@MovMoneda
											 ,@MovTipoCambio
											 ,@Ok OUTPUT
											 ,@OkRef OUTPUT

		END

		IF @Continuar = 1
			AND (@Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') OR @EstatusNuevo = 'CANCELADO')
			AND @Ok IS NULL
		BEGIN

			IF @Accion = 'CANCELAR'
			BEGIN

				IF @CfgCompraAutoCargos = 1
					AND @MovTipo IN ('COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI', 'COMS.D', 'COMS.B')
					AND @Ok IS NULL
					EXEC xpCompraAutoCargos @Sucursal
										   ,@SucursalOrigen
										   ,@SucursalDestino
										   ,@Accion
										   ,@Modulo
										   ,@Empresa
										   ,@ID
										   ,@Mov
										   ,@MovID
										   ,@MovTipo
										   ,@MovMoneda
										   ,@MovTipoCambio
										   ,@FechaEmision
										   ,@Concepto
										   ,@Proyecto
										   ,@Usuario
										   ,@Autorizacion
										   ,@Referencia
										   ,@DocFuente
										   ,@Observaciones
										   ,@FechaRegistro
										   ,@Ejercicio
										   ,@Periodo
										   ,@Condicion
										   ,@Vencimiento
										   ,@ClienteProv
										   ,@SumaImporteNeto
										   ,@SumaImpuestosNetos
										   ,@VIN
										   ,@Ok OUTPUT
										   ,@OkRef OUTPUT

				IF @CfgVentaAutoBonif = 1
					AND @MovTipo IN ('VTAS.F', 'VTAS.FAR', 'VTAS.D', 'VTAS.DF', 'VTAS.B')
					AND @Ok IS NULL
					EXEC xpVentaAutoBonif @Sucursal
										 ,@SucursalOrigen
										 ,@SucursalDestino
										 ,@Accion
										 ,@Modulo
										 ,@Empresa
										 ,@ID
										 ,@Mov
										 ,@MovID
										 ,@MovTipo
										 ,@MovMoneda
										 ,@MovTipoCambio
										 ,@FechaEmision
										 ,@Concepto
										 ,@Proyecto
										 ,@Usuario
										 ,@Autorizacion
										 ,@Referencia
										 ,@DocFuente
										 ,@Observaciones
										 ,@FechaRegistro
										 ,@Ejercicio
										 ,@Periodo
										 ,@Condicion
										 ,@Vencimiento
										 ,@ClienteProv
										 ,@CobroIntegrado
										 ,@SumaImporteNeto
										 ,@SumaImpuestosNetos
										 ,@VIN
										 ,@Ok OUTPUT
										 ,@OkRef OUTPUT
										 ,@Agente

				IF @MovTipo IN ('VTAS.F', 'VTAS.FAR', 'VTAS.N')
					AND (
						SELECT CxcAutoAplicarAnticiposPedidos
						FROM EmpresaCfg2 WITH(NOLOCK)
						WHERE Empresa = @Empresa
					)
					= 1
				BEGIN
					SELECT @ReferenciaAplicacionAnticipo = RTRIM(@Origen) + ' ' + RTRIM(@OrigenID)
					EXEC xpVentaAutoAplicarAnticiposPedidos @Sucursal
														   ,@SucursalOrigen
														   ,@SucursalDestino
														   ,@Accion
														   ,@Modulo
														   ,@Empresa
														   ,@ID
														   ,@Mov
														   ,@MovID
														   ,@MovTipo
														   ,@MovMoneda
														   ,@MovTipoCambio
														   ,@FechaEmision
														   ,@Concepto
														   ,@Proyecto
														   ,@Usuario
														   ,@Autorizacion
														   ,@ReferenciaAplicacionAnticipo
														   ,@DocFuente
														   ,@Observaciones
														   ,@FechaRegistro
														   ,@Ejercicio
														   ,@Periodo
														   ,@Condicion
														   ,@Vencimiento
														   ,@ClienteProv
														   ,@CobroIntegrado
														   ,@SumaImporteNeto
														   ,@SumaImpuestosNetos
														   ,@VIN
														   ,@Ok OUTPUT
														   ,@OkRef OUTPUT
				END

			END

			IF @Modulo = 'VTAS'
				AND @CobroIntegrado = 0
				EXEC spBorrarVentaCobro @ID

			IF @CobroIntegrado = 1
			BEGIN

				IF @OrigenTipo = 'POS'
				BEGIN
					SELECT @DineroImporte = 0.0
						  ,@CobroDesglosado = 0.0
						  ,@CobroDelEfectivo = 0.0
						  ,@CobroCambio = 0.0
						  ,@ValesCobrados = 0.0
						  ,@CobroRedondeo = 0.0
						  ,@TarjetasCobradas = 0.0
					SELECT @Importe1 = ISNULL(Importe1, 0.0)
						  ,@Importe2 = ISNULL(Importe2, 0.0)
						  ,@Importe3 = ISNULL(Importe3, 0.0)
						  ,@Importe4 = ISNULL(Importe4, 0.0)
						  ,@Importe5 = ISNULL(Importe5, 0.0)
						  ,@FormaCobro1 = RTRIM(FormaCobro1)
						  ,@FormaCobro2 = RTRIM(FormaCobro2)
						  ,@FormaCobro3 = RTRIM(FormaCobro3)
						  ,@FormaCobro4 = RTRIM(FormaCobro4)
						  ,@FormaCobro5 = RTRIM(FormaCobro5)
						  ,@Referencia1 = RTRIM(Referencia1)
						  ,@Referencia2 = RTRIM(Referencia2)
						  ,@Referencia3 = RTRIM(Referencia3)
						  ,@Referencia4 = RTRIM(Referencia4)
						  ,@Referencia5 = RTRIM(Referencia5)
						  ,@CobroDelEfectivo = ISNULL(DelEfectivo, 0.0)
						  ,@CtaDinero = NULLIF(RTRIM(CtaDinero), '')
						  ,@Cajero = NULLIF(RTRIM(Cajero), '')
						  ,@CobroRedondeo = ISNULL(Redondeo, 0.0)
						  ,@TipoCambio1 = POSTipoCambio1
						  ,@TipoCambio2 = POSTipoCambio2
						  ,@TipoCambio3 = POSTipoCambio3
						  ,@TipoCambio4 = POSTipoCambio4
						  ,@TipoCambio5 = POSTipoCambio5
					FROM VentaCobro WITH(NOLOCK)
					WHERE ID = @ID
					EXEC spVentaCobroTotalPOS @Empresa
											 ,@FormaCobro1
											 ,@FormaCobro2
											 ,@FormaCobro3
											 ,@FormaCobro4
											 ,@FormaCobro5
											 ,@Importe1
											 ,@Importe2
											 ,@Importe3
											 ,@Importe4
											 ,@Importe5
											 ,@CobroDesglosado OUTPUT
											 ,@Moneda = @MovMoneda
											 ,@TipoCambio1 = @TipoCambio1
											 ,@TipoCambio2 = @TipoCambio2
											 ,@TipoCambio3 = @TipoCambio3
											 ,@TipoCambio4 = @TipoCambio4
											 ,@TipoCambio5 = @TipoCambio5
				END
				ELSE
				BEGIN
					SELECT @DineroImporte = 0.0
						  ,@CobroDesglosado = 0.0
						  ,@CobroDelEfectivo = 0.0
						  ,@CobroCambio = 0.0
						  ,@ValesCobrados = 0.0
						  ,@CobroRedondeo = 0.0
						  ,@TarjetasCobradas = 0.0
					SELECT @Importe1 = ISNULL(Importe1, 0.0)
						  ,@Importe2 = ISNULL(Importe2, 0.0)
						  ,@Importe3 = ISNULL(Importe3, 0.0)
						  ,@Importe4 = ISNULL(Importe4, 0.0)
						  ,@Importe5 = ISNULL(Importe5, 0.0)
						  ,@FormaCobro1 = RTRIM(FormaCobro1)
						  ,@FormaCobro2 = RTRIM(FormaCobro2)
						  ,@FormaCobro3 = RTRIM(FormaCobro3)
						  ,@FormaCobro4 = RTRIM(FormaCobro4)
						  ,@FormaCobro5 = RTRIM(FormaCobro5)
						  ,@Referencia1 = RTRIM(Referencia1)
						  ,@Referencia2 = RTRIM(Referencia2)
						  ,@Referencia3 = RTRIM(Referencia3)
						  ,@Referencia4 = RTRIM(Referencia4)
						  ,@Referencia5 = RTRIM(Referencia5)
						  ,@CobroDelEfectivo = ISNULL(DelEfectivo, 0.0)
						  ,@CtaDinero = NULLIF(RTRIM(CtaDinero), '')
						  ,@Cajero = NULLIF(RTRIM(Cajero), '')
						  ,@CobroRedondeo = ISNULL(Redondeo, 0.0)
						  ,@FormaCobroCambio = RTRIM(FormaCobroCambio)
						  ,@TCDelEfectivo = ISNULL(TCDelEfectivo, 0)
						  ,@TCProcesado1 = ISNULL(TCProcesado1, 0)
						  ,@TCProcesado2 = ISNULL(TCProcesado2, 0)
						  ,@TCProcesado3 = ISNULL(TCProcesado3, 0)
						  ,@TCProcesado4 = ISNULL(TCProcesado4, 0)
						  ,@TCProcesado5 = ISNULL(TCProcesado5, 0)
					FROM VentaCobro WITH(NOLOCK)
					WHERE ID = @ID
					EXEC spVentaCobroTotal @FormaCobro1
										  ,@FormaCobro2
										  ,@FormaCobro3
										  ,@FormaCobro4
										  ,@FormaCobro5
										  ,@Importe1
										  ,@Importe2
										  ,@Importe3
										  ,@Importe4
										  ,@Importe5
										  ,@CobroDesglosado OUTPUT
										  ,@Moneda = @MovMoneda
										  ,@TipoCambio = @MovTipoCambio
				END

				SELECT @FormaCobroVales = CxcFormaCobroVales
					  ,@FormaCobroTarjetas = CxcFormaCobroTarjetas
				FROM EmpresaCfg WITH(NOLOCK)
				WHERE Empresa = @Empresa
				SELECT @LDITarjeta = ISNULL(LDI, 0)
				FROM FormaPago WITH(NOLOCK)
				WHERE FormaPago = @FormaCobroTarjetas

				IF @FormaCobro1 = @FormaCobroVales
					SELECT @ValesCobrados = @ValesCobrados + @Importe1

				IF @FormaCobro2 = @FormaCobroVales
					SELECT @ValesCobrados = @ValesCobrados + @Importe2

				IF @FormaCobro3 = @FormaCobroVales
					SELECT @ValesCobrados = @ValesCobrados + @Importe3

				IF @FormaCobro4 = @FormaCobroVales
					SELECT @ValesCobrados = @ValesCobrados + @Importe4

				IF @FormaCobro5 = @FormaCobroVales
					SELECT @ValesCobrados = @ValesCobrados + @Importe5

				IF @FormaCobro1 = @FormaCobroTarjetas
					SELECT @TarjetasCobradas = @TarjetasCobradas + @Importe1
						  ,@ReferenciaTarjetas = @Referencia1

				IF @FormaCobro2 = @FormaCobroTarjetas
					SELECT @TarjetasCobradas = @TarjetasCobradas + @Importe2
						  ,@ReferenciaTarjetas = @Referencia2

				IF @FormaCobro3 = @FormaCobroTarjetas
					SELECT @TarjetasCobradas = @TarjetasCobradas + @Importe3
						  ,@ReferenciaTarjetas = @Referencia3

				IF @FormaCobro4 = @FormaCobroTarjetas
					SELECT @TarjetasCobradas = @TarjetasCobradas + @Importe4
						  ,@ReferenciaTarjetas = @Referencia4

				IF @FormaCobro5 = @FormaCobroTarjetas
					SELECT @TarjetasCobradas = @TarjetasCobradas + @Importe5
						  ,@ReferenciaTarjetas = @Referencia5

				IF EXISTS (SELECT * FROM FormaPago WITH(NOLOCK) WHERE FormaPago IN (@FormaCobro1, @FormaCobro2, @FormaCobro3, @FormaCobro4, @FormaCobro5) AND FormaPago NOT IN (@FormaCobroTarjetas) AND LDI = 1)
				BEGIN
					EXEC spLDIPagoTarjetaCredito @ID
												,@Empresa
												,@Sucursal
												,@Modulo
												,@Usuario
												,@FormaCobro1
												,@FormaCobro2
												,@FormaCobro3
												,@FormaCobro4
												,@FormaCobro5
												,@FormaCobroTarjetas
												,@Importe1
												,@Importe2
												,@Importe3
												,@Importe4
												,@Importe5
												,@Referencia1
												,@Referencia2
												,@Referencia3
												,@Referencia4
												,@Referencia5
												,@Ok OUTPUT
												,@OkRef OUTPUT
												,@Accion
												,@Estatus
												,@EstacionTrabajo
				END

				IF @CobroDesglosado + @CobroDelEfectivo <> 0.0
				BEGIN
					SELECT @CobroCambio = @CobroDesglosado + @CobroDelEfectivo - (@ImporteTotalCx - @SumaRetenciones) - @CobroRedondeo

					IF (@CobroDesglosado + @CobroDelEfectivo) < ((@ImporteTotalCx - @SumaRetenciones) + @CobroRedondeo)
						SELECT @CobroCambio = 0.0

					IF ROUND(ABS(@CobroCambio), @RedondeoMonetarios) = 0.01
						SELECT @CobroCambio = 0.0

					IF @Accion <> 'CANCELAR'
						UPDATE VentaCobro WITH(NOLOCK)
						SET Actualizado = 1
						   ,Cambio = @CobroCambio
						WHERE ID = @ID

					SELECT @DineroImporte = @CobroDesglosado - @CobroCambio
				END

			END

			IF @CobroIntegrado = 1
				AND @CobroIntegradoCxc = 0
				AND @CobroIntegradoParcial = 0
				AND @OrigenTipo <> 'CR'
				AND @ImporteTotalCx <> 0.0
				AND (@Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') OR @EstatusNuevo = 'CANCELADO')
				AND @Ok IS NULL
			BEGIN

				IF @ValesCobrados > 0.0
					OR @TarjetasCobradas <> 0
					EXEC spValeAplicarCobro @Empresa
										   ,@Modulo
										   ,@ID
										   ,@TarjetasCobradas
										   ,@Accion
										   ,@FechaEmision
										   ,@Ok OUTPUT
										   ,@OkRef OUTPUT

				IF @OK IS NULL
					AND @TarjetasCobradas <> 0
					AND (@LDI = 0 OR (@LDI = 1 AND @LDITarjeta = 0))
					EXEC spValeGeneraAplicacionTarjeta @Empresa
													  ,@Modulo
													  ,@ID
													  ,@Mov
													  ,@MovID
													  ,@Accion
													  ,@FechaEmision
													  ,@Usuario
													  ,@Sucursal
													  ,@TarjetasCobradas
													  ,@CtaDinero
													  ,@MovMoneda
													  ,@MovTipoCambio
													  ,@Ok OUTPUT
													  ,@OkRef OUTPUT
													  ,@Referencia = @ReferenciaTarjetas

				IF @LDI = 1
					AND @OrigenTipo NOT IN ('POS', 'VMOS')
				BEGIN

					IF @OK IS NULL
						AND @Modulo = 'VTAS'
						AND @CfgVentaMonedero = 1
						AND @CfgVentaMonederoA = 0
						AND EXISTS (SELECT * FROM TarjetaSeriemov t WITH(NOLOCK) JOIN ValeSerie v WITH(NOLOCK) ON t.Serie = v.Serie JOIN Art a WITH(NOLOCK) ON v.Articulo = a.Articulo WHERE t.Empresa = @Empresa AND t.Modulo = @Modulo AND t.ID = @ID AND ISNULL(a.LDI, 0) = 0)
					BEGIN
						EXEC spVentaMonedero @Empresa
											,@Modulo
											,@ID
											,@Mov
											,@MovID
											,@MovTipo
											,@Accion
											,@FechaEmision
											,@Ejercicio
											,@Periodo
											,@Usuario
											,@Sucursal
											,@MovMoneda
											,@MovTipoCambio
											,@Ok OUTPUT
											,@OkRef OUTPUT
					END

				END
				ELSE
				BEGIN

					IF @OK IS NULL
						AND @Modulo = 'VTAS'
						AND @CfgVentaMonedero = 1
						AND @CfgVentaMonederoA = 0
						AND EXISTS (SELECT * FROM TarjetaSeriemov WITH(NOLOCK) WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID)
						AND @LDI = 0
						EXEC spVentaMonedero @Empresa
											,@Modulo
											,@ID
											,@Mov
											,@MovID
											,@MovTipo
											,@Accion
											,@FechaEmision
											,@Ejercicio
											,@Periodo
											,@Usuario
											,@Sucursal
											,@MovMoneda
											,@MovTipoCambio
											,@Ok OUTPUT
											,@OkRef OUTPUT

				END

				IF @OrigenTipo = 'POS'
				BEGIN
					EXEC spInvAfectarDineroPOS @ID
											  ,@Accion
											  ,@Base
											  ,@Empresa
											  ,@Modulo
											  ,@Mov
											  ,@MovID OUTPUT
											  ,@MovTipo
											  ,@MovMoneda
											  ,@MovTipoCambio
											  ,@FechaEmision
											  ,@FechaAfectacion
											  ,@FechaConclusion
											  ,@Concepto
											  ,@Proyecto
											  ,@Usuario
											  ,@Autorizacion
											  ,@Referencia
											  ,@DocFuente
											  ,@Observaciones
											  ,@Estatus
											  ,@EstatusNuevo
											  ,@FechaRegistro
											  ,@Ejercicio
											  ,@Periodo
											  ,@ClienteProv
											  ,@EnviarA
											  ,@SucursalOrigen
											  ,@Ok OUTPUT
											  ,@OkRef OUTPUT
											  ,@EsCargo OUTPUT
											  ,@CtaDinero OUTPUT
											  ,@Cajero OUTPUT
											  ,@DineroMov OUTPUT
											  ,@DineroMovID OUTPUT
											  ,@FormaPagoCambio OUTPUT
											  ,@CobroCambio OUTPUT
											  ,@DineroImporte OUTPUT
											  ,@CobroDelEfectivo OUTPUT
											  ,@CobroSumaEfectivo OUTPUT
											  ,@Importe1 OUTPUT
											  ,@Importe2 OUTPUT
											  ,@Importe3 OUTPUT
											  ,@Importe4 OUTPUT
											  ,@Importe5 OUTPUT
											  ,@ImporteCambio OUTPUT
											  ,@FormaCobro1 OUTPUT
											  ,@FormaCobro2 OUTPUT
											  ,@FormaCobro3 OUTPUT
											  ,@FormaCobro4 OUTPUT
											  ,@FormaCobro5 OUTPUT
											  ,@Referencia1 OUTPUT
											  ,@Referencia2 OUTPUT
											  ,@Referencia3 OUTPUT
											  ,@Referencia4 OUTPUT
											  ,@Referencia5 OUTPUT
											  ,@FormaMoneda OUTPUT
											  ,@FormaTipoCambio OUTPUT
											  ,@FormaCobroVales OUTPUT
											  ,@TipoCambio1 OUTPUT
											  ,@TipoCambio2 OUTPUT
											  ,@TipoCambio3 OUTPUT
											  ,@TipoCambio4 OUTPUT
											  ,@TipoCambio5 OUTPUT
				END
				ELSE
					EXEC spInvAfectarDinero @ID
										   ,@Accion
										   ,@Base
										   ,@Empresa
										   ,@Modulo
										   ,@Mov
										   ,@MovID OUTPUT
										   ,@MovTipo
										   ,@MovMoneda
										   ,@MovTipoCambio
										   ,@FechaEmision
										   ,@FechaAfectacion
										   ,@FechaConclusion
										   ,@Concepto
										   ,@Proyecto
										   ,@Usuario
										   ,@Autorizacion
										   ,@Referencia
										   ,@DocFuente
										   ,@Observaciones
										   ,@Estatus
										   ,@EstatusNuevo
										   ,@FechaRegistro
										   ,@Ejercicio
										   ,@Periodo
										   ,@ClienteProv
										   ,@EnviarA
										   ,@SucursalOrigen
										   ,@Ok OUTPUT
										   ,@OkRef OUTPUT
										   ,@EsCargo OUTPUT
										   ,@CtaDinero OUTPUT
										   ,@Cajero OUTPUT
										   ,@DineroMov OUTPUT
										   ,@DineroMovID OUTPUT
										   ,@FormaPagoCambio OUTPUT
										   ,@CobroCambio OUTPUT
										   ,@DineroImporte OUTPUT
										   ,@CobroDelEfectivo OUTPUT
										   ,@CobroSumaEfectivo OUTPUT
										   ,@Importe1 OUTPUT
										   ,@Importe2 OUTPUT
										   ,@Importe3 OUTPUT
										   ,@Importe4 OUTPUT
										   ,@Importe5 OUTPUT
										   ,@ImporteCambio OUTPUT
										   ,@FormaCobro1 OUTPUT
										   ,@FormaCobro2 OUTPUT
										   ,@FormaCobro3 OUTPUT
										   ,@FormaCobro4 OUTPUT
										   ,@FormaCobro5 OUTPUT
										   ,@Referencia1 OUTPUT
										   ,@Referencia2 OUTPUT
										   ,@Referencia3 OUTPUT
										   ,@Referencia4 OUTPUT
										   ,@Referencia5 OUTPUT
										   ,@FormaMoneda OUTPUT
										   ,@FormaTipoCambio OUTPUT
										   ,@FormaCobroVales OUTPUT
										   ,@FormaCobroCambio OUTPUT
										   ,@InterfazTC
										   ,@TCDelEfectivo
										   ,@TCProcesado1
										   ,@TCProcesado2
										   ,@TCProcesado3
										   ,@TCProcesado4
										   ,@TCProcesado5

			END
			ELSE

			IF @ImporteTotalCx > 0.0
				AND @Ok IS NULL
				AND @OrigenTipo <> 'CR'
				AND ((@MovTipo IN ('VTAS.FM', 'VTAS.N', 'VTAS.NO', 'VTAS.NR') AND @CobroIntegradoCxc = 1) OR (((@MovTipo IN ('VTAS.F', 'VTAS.FX', 'VTAS.FAR', 'VTAS.FB', 'VTAS.D', 'VTAS.DF')) OR (@SubClave = 'VTAS.FA')) AND @CobrarPedido = 0 AND (@Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') OR @EstatusNuevo = 'CANCELADO')) OR (@MovTipo IN ('VTAS.B', 'COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI', 'COMS.D', 'COMS.B', 'COMS.CA', 'COMS.GX') AND @EstatusNuevo IN ('CONCLUIDO', 'PROCESAR', 'CANCELADO')))
			BEGIN

				IF @BorrarRetencionCx = 1
					SELECT @RetencionCx = 0.0
						  ,@Retencion2Cx = 0.0
						  ,@Retencion3Cx = 0.0

				IF @MovTipo = 'COMS.EI'
					EXEC spGenerarCxImportacion @Sucursal
											   ,@SucursalOrigen
											   ,@SucursalDestino
											   ,@Accion
											   ,NULL
											   ,@Empresa
											   ,@Modulo
											   ,@ID
											   ,@Mov
											   ,@MovID
											   ,@MovTipo
											   ,@MovMoneda
											   ,@MovTipoCambio
											   ,@FechaAfectacion
											   ,@Concepto
											   ,@Proyecto
											   ,@Usuario
											   ,@Autorizacion
											   ,@Referencia
											   ,@DocFuente
											   ,@Observaciones
											   ,@FechaRegistro
											   ,@Ejercicio
											   ,@Periodo
											   ,@Condicion
											   ,@Vencimiento
											   ,@ClienteProv
											   ,@EnviarA
											   ,@Agente
											   ,NULL
											   ,NULL
											   ,NULL
											   ,@ImporteCx
											   ,@ImpuestosCx
											   ,@RetencionCx
											   ,@SumaComision
											   ,NULL
											   ,NULL
											   ,NULL
											   ,NULL
											   ,@VIN
											   ,NULL
											   ,@CxModulo OUTPUT
											   ,@CxMov OUTPUT
											   ,@CxMovID OUTPUT
											   ,@Ok OUTPUT
											   ,@OkRef OUTPUT
											   ,@INSTRUCCIONES_ESP = 'SIN_DOCAUTO'
											   ,@IVAFiscal = @IVAFiscal
											   ,@IEPSFiscal = @IEPSFiscal
											   ,@Retencion2 = @Retencion2Cx
											   ,@Retencion3 = @Retencion3Cx
				ELSE
				BEGIN

					IF (@CobroIntegradoCxc = 1 OR @CobroIntegradoParcial = 1)
						AND @Accion = 'CANCELAR'
						EXEC spCobroIntegradoCxcCancelar @Sucursal
														,@Accion
														,@Modulo
														,@Empresa
														,@Usuario
														,@ID
														,@Mov
														,@MovID
														,@FechaRegistro
														,@Ok OUTPUT
														,@OkRef OUTPUT

					SELECT @CondicionCx = @Condicion
						  ,@VencimientoCx = @Vencimiento

					IF @CobroIntegradoParcial = 1
						SELECT @CondicionCx = Condicion
							  ,@VencimientoCx = Vencimiento
						FROM VentaCobro WITH(NOLOCK)
						WHERE ID = @ID

					IF @CfgAC = 1
						AND @Modulo = 'VTAS'
					BEGIN
						SELECT @LCMetodo = ta.Metodo
							  ,@LCPorcentajeResidual = ISNULL(lc.PorcentajeResidual, 0)
						FROM Venta v WITH(NOLOCK)
						JOIN TipoAmortizacion ta WITH(NOLOCK)
							ON ta.TipoAmortizacion = v.TipoAmortizacion
						JOIN LC WITH(NOLOCK)
							ON lc.LineaCredito = v.LineaCredito
						WHERE v.ID = @ID
						EXEC xpPorcentajeResidual @Modulo
												 ,@ID
												 ,@LCPorcentajeResidual OUTPUT
					END

					EXEC @CxID = spGenerarCx @Sucursal
											,@SucursalOrigen
											,@SucursalDestino
											,@Accion
											,NULL
											,@Empresa
											,@Modulo
											,@ID
											,@Mov
											,@MovID
											,@MovTipo
											,@MovMoneda
											,@MovTipoCambio
											,@FechaAfectacion
											,@Concepto
											,@Proyecto
											,@Usuario
											,@Autorizacion
											,@Referencia
											,@DocFuente
											,@Observaciones
											,@FechaRegistro
											,@Ejercicio
											,@Periodo
											,@CondicionCx
											,@VencimientoCx
											,@ClienteProv
											,@EnviarA
											,@Agente
											,NULL
											,NULL
											,NULL
											,@ImporteCx
											,@ImpuestosCx
											,@RetencionCx
											,@SumaComision
											,NULL
											,NULL
											,NULL
											,NULL
											,@VIN
											,NULL
											,@CxModulo OUTPUT
											,@CxMov OUTPUT
											,@CxMovID OUTPUT
											,@Ok OUTPUT
											,@OkRef OUTPUT
											,@INSTRUCCIONES_ESP = 'SIN_DOCAUTO'
											,@IVAFiscal = @IVAFiscal
											,@IEPSFiscal = @IEPSFiscal
											,@Retencion2 = @Retencion2Cx
											,@Retencion3 = @Retencion3Cx
											,@EndosarA = @EndosarA
											,@CopiarMovImpuesto = 1

					IF (@CobroIntegradoCxc = 1 OR @CobroIntegradoParcial = 1)
						AND @Accion <> 'CANCELAR'
						EXEC spCobroIntegradoCxc @Sucursal
												,@SucursalOrigen
												,@SucursalDestino
												,@Accion
												,@Modulo
												,@Empresa
												,@Usuario
												,@ID
												,@Mov
												,@MovID
												,@MovTipo
												,@MovMoneda
												,@MovTipoCambio
												,@FechaRegistro
												,@DineroImporte
												,@CobroDelEfectivo
												,@CobroCambio
												,@FormaCobro1
												,@FormaCobro2
												,@FormaCobro3
												,@FormaCobro4
												,@FormaCobro5
												,@Importe1
												,@Importe2
												,@Importe3
												,@Importe4
												,@Importe5
												,@Referencia1
												,@Referencia2
												,@Referencia3
												,@Referencia4
												,@Referencia5
												,@CtaDinero
												,@Cajero
												,@CxID
												,@FormaCobroCambio
												,@Ok OUTPUT
												,@OkRef OUTPUT
												,@InterfazTC
												,@TCDelEfectivo
												,@TCProcesado1
												,@TCProcesado2
												,@TCProcesado3
												,@TCProcesado4
												,@TCProcesado5

					IF @CfgAC = 1
						AND @LCMetodo = 50
						AND @Accion <> 'CANCELAR'
					BEGIN
						SELECT @CxAjusteImporte = @ImporteCx * (@LCPorcentajeResidual / 100.0)

						IF @CxAjusteImporte > 0.0
						BEGIN
							SELECT @CxAjusteMov = ACAjusteValorResidual
							FROM EmpresaCfgMov WITH(NOLOCK)
							WHERE Empresa = @Empresa
							SELECT @CxConcepto = ACAjusteConceptoValorResidual
							FROM EmpresaCfg WITH(NOLOCK)
							WHERE Empresa = @Empresa
							EXEC @CxAjusteID = spAfectar 'CXC'
														,@CxID
														,'GENERAR'
														,'TODO'
														,@CxAjusteMov
														,@Usuario
														,@EnSilencio = 1
														,@Conexion = 1
														,@Ok = @Ok OUTPUT
														,@OkRef = @OkRef OUTPUT

							IF @Ok = 80030
								SELECT @Ok = NULL
									  ,@OkRef = NULL

							IF @Ok IS NULL
								AND @CxAjusteID IS NOT NULL
							BEGIN
								UPDATE Cxc WITH(ROWLOCK)
								SET Concepto = @CxConcepto
								   ,Importe = @CxAjusteImporte
								   ,Impuestos = NULL
								   ,AplicaManual = 1
								WHERE ID = @CxAjusteID
								DELETE CxcD
								WHERE ID = @CxAjusteID
								INSERT CxcD (ID, Renglon, Aplica, AplicaID, Importe)
									VALUES (@CxAjusteID, 2048.0, @Mov, @MovID, @CxAjusteImporte)
								EXEC spAfectar 'CXC'
											  ,@CxAjusteID
											  ,'AFECTAR'
											  ,'TODO'
											  ,NULL
											  ,@Usuario
											  ,@EnSilencio = 1
											  ,@Conexion = 1
											  ,@Ok = @Ok OUTPUT
											  ,@OkRef = @OkRef OUTPUT
							END

						END

						SELECT @CxAjusteImporte = @ImpuestosCx

						IF @CxAjusteImporte > 0.0
						BEGIN
							SELECT @CxAjusteMov = ACAjusteImpuestoAd
							FROM EmpresaCfgMov WITH(NOLOCK)
							WHERE Empresa = @Empresa
							SELECT @CxConcepto = ACAjusteConceptoImpuestoAd
							FROM EmpresaCfg WITH(NOLOCK)
							WHERE Empresa = @Empresa
							EXEC @CxAjusteID = spAfectar 'CXC'
														,@CxID
														,'GENERAR'
														,'TODO'
														,@CxAjusteMov
														,@Usuario
														,@EnSilencio = 1
														,@Conexion = 1
														,@Ok = @Ok OUTPUT
														,@OkRef = @OkRef OUTPUT

							IF @Ok = 80030
								SELECT @Ok = NULL
									  ,@OkRef = NULL

							IF @Ok IS NULL
								AND @CxAjusteID IS NOT NULL
							BEGIN
								UPDATE Cxc WITH(NOLOCK)
								SET Concepto = @CxConcepto
								   ,Importe = @CxAjusteImporte
								   ,Impuestos = NULL
								   ,AplicaManual = 1
								WHERE ID = @CxAjusteID
								DELETE CxcD
								WHERE ID = @CxAjusteID
								INSERT CxcD (ID, Renglon, Aplica, AplicaID, Importe)
									VALUES (@CxAjusteID, 2048.0, @Mov, @MovID, @CxAjusteImporte)
								EXEC spAfectar 'CXC'
											  ,@CxAjusteID
											  ,'AFECTAR'
											  ,'TODO'
											  ,NULL
											  ,@Usuario
											  ,@EnSilencio = 1
											  ,@Conexion = 1
											  ,@Ok = @Ok OUTPUT
											  ,@OkRef = @OkRef OUTPUT
							END

						END

					END

				END

				IF @CxID IS NOT NULL
					SELECT @CxMovTipo = Clave
					FROM MovTipo WITH(NOLOCK)
					WHERE Modulo = @CxModulo
					AND Mov = @CxMov

			END

			IF (@CobroIntegradoCxc = 1 OR @CobroIntegradoParcial = 1)
				AND @Ok IS NULL
				AND @TCDelEfectivo > 0
				AND @InterfazTC = 1
				AND @Accion IN ('AFECTAR', 'CANCELAR')
			BEGIN
				EXEC spTCAplicacionSaldo @Modulo
										,@ID
										,@Mov
										,@MovTipo
										,@Empresa
										,@Sucursal
										,@Usuario
										,@Accion
										,@Cliente
										,@TCDelEfectivo
										,@FechaEmision
										,@CxID
										,@CxMov
										,@CxMovID
										,@Ok OUTPUT
										,@OkRef OUTPUT
			END

			EXEC spInvGenerarRetencionesCompra @Fiscal
											  ,@FiscalGenerarRetenciones
											  ,@CfgRetencionAlPago
											  ,@MovTipo
											  ,@SumaRetencion
											  ,@SumaRetencion2
											  ,@SumaRetencion3
											  ,@CfgRetencionAcreedor
											  ,@Sucursal
											  ,@SucursalOrigen
											  ,@SucursalDestino
											  ,@Accion
											  ,@Empresa
											  ,@Modulo
											  ,@ID
											  ,@Mov
											  ,@MovID
											  ,@MovMoneda
											  ,@MovTipoCambio
											  ,@FechaEmision
											  ,@CfgRetencionConcepto
											  ,@Proyecto
											  ,@Usuario
											  ,@Autorizacion
											  ,@DocFuente
											  ,@Observaciones
											  ,@FechaRegistro
											  ,@Ejercicio
											  ,@Periodo
											  ,@CfgRetencionMov
											  ,@CfgRetencion2Acreedor
											  ,@CfgRetencion2Concepto
											  ,@CfgRetencion3Acreedor
											  ,@CfgRetencion3Concepto
											  ,@CxModulo = @CxModulo OUTPUT
											  ,@CxMov = @CxMov OUTPUT
											  ,@CxMovID = @CxMovID OUTPUT
											  ,@Ok = @Ok OUTPUT
											  ,@OkRef = @OkRef OUTPUT

			IF @MovTipo IN ('VTAS.F', 'VTAS.FAR', 'VTAS.FB', 'VTAS.N')
				AND (@Estatus = 'SINAFECTAR' OR @EstatusNuevo = 'CANCELADO')
				AND @CfgAnticiposFacturados = 1
				AND (@AnticiposFacturados > 0.0 OR @AnticipoFacturadoTipoServicio = 1)
			BEGIN

				IF @Accion = 'CANCELAR'
					SELECT @EsCargo = 1
				ELSE
					SELECT @EsCargo = 0

				IF @Accion = 'CANCELAR'
				BEGIN
					UPDATE Cxc WITH(ROWLOCK)
					SET AnticipoSaldo = ISNULL(AnticipoSaldo, 0) + vfa.Importe
					FROM Cxc c WITH(ROWLOCK), VentaFacturaAnticipo vfa WITH(NOLOCK)
					WHERE vfa.ID = @ID
					AND vfa.CxcID = c.ID

					IF @AnticipoFacturadoTipoServicio = 1
						SELECT @AnticiposFacturados = (
							 SELECT SUM(ABS(ISNULL(Importetotal, 0.0)) - ABS(ISNULL(AnticipoRetencion, 0.0)))
							 FROM VentaTCalc WITH(NOLOCK)
							 WHERE ID = @ID
							 AND AnticipoFacturado = 1
						 )

				END
				ELSE
				BEGIN

					IF EXISTS (SELECT 1 FROM VentaD WITH(NOLOCK) WHERE ID = @ID AND AnticipoFacturado = 1 AND (AnticipoMoneda <> @MovMoneda OR AnticipoTipoCambio <> @MovTipoCambio))
						SELECT @Ok = 10495

					SELECT @SumaAnticiposFacturados = SUM(CASE
						 WHEN RTRIM(LTRIM(Moneda)) = RTRIM(LTRIM(@MovMoneda)) THEN AnticipoAplicar
						 ELSE (AnticipoAplicar * TipoCambio) / @MovTipoCambio
					 END)
					FROM Cxc WITH(NOLOCK)
					WHERE AnticipoAplicaModulo = @Modulo
					AND AnticipoAplicaID = @ID
					AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
					EXEC xpSumaAnticiposFacturados @Empresa
												  ,@Usuario
												  ,@Accion
												  ,@Modulo
												  ,@ID
												  ,@MovMoneda
												  ,@MovTipoCambio
												  ,@SumaAnticiposFacturados OUTPUT
												  ,@Ok OUTPUT
												  ,@OkRef OUTPUT

					IF @AnticipoFacturadoTipoServicio = 1
						SELECT @AnticiposFacturados = (
							 SELECT SUM(ABS(ISNULL(Importetotal, 0.0)) - ABS(ISNULL(AnticipoRetencion, 0.0)))
							 FROM VentaTCalc WITH(NOLOCK)
							 WHERE ID = @ID
							 AND AnticipoFacturado = 1
						 )

					IF ABS(ROUND(@AnticiposFacturados, 2) - ROUND(@SumaAnticiposFacturados, 2)) > 0.1
						SELECT @Ok = 30405
					ELSE

					IF @AnticipoFacturadoTipoServicio = 1
						AND ABS(ROUND(@AnticiposFacturados, 2) - ROUND(@SumaAnticiposFacturados, 2)) > 0.1
						SELECT @Ok = 30405
					ELSE

					IF @AnticipoFacturadoTipoServicio = 1
						AND EXISTS (SELECT 1 FROM VentaTCalc WITH(NOLOCK) WHERE ID = @ID AND AnticipoFacturado = 1 AND ImporteTotal > 0.0)
						SELECT @Ok = 30405

					IF EXISTS (SELECT * FROM Cxc WITH(NOLOCK) WHERE AnticipoAplicaModulo = @Modulo AND AnticipoAplicaID = @ID AND (ISNULL(AnticipoAplicar, 0) < 0.0 OR ROUND(AnticipoAplicar, 0) > ROUND(AnticipoSaldo, 0)))
						SELECT @Ok = 30405
					ELSE
					BEGIN
						INSERT VentaFacturaAnticipo (ID, CxcID, Importe)
							SELECT @ID
								  ,ID
								  ,AnticipoAplicar
							FROM Cxc WITH(NOLOCK)
							WHERE AnticipoAplicaModulo = @Modulo
							AND AnticipoAplicaID = @ID
						UPDATE Cxc WITH(ROWLOCK)
						SET AnticipoSaldo = ISNULL(AnticipoSaldo, 0) - ISNULL(AnticipoAplicar, 0)
						   ,AnticipoAplicar = NULL
						   ,AnticipoAplicaModulo = NULL
						   ,AnticipoAplicaID = NULL
						WHERE AnticipoAplicaModulo = @Modulo
						AND AnticipoAplicaID = @ID
					END

				END

				EXEC spSaldo @Sucursal
							,@Accion
							,@Empresa
							,@Usuario
							,'CANT'
							,@MovMoneda
							,@MovTipoCambio
							,@ClienteProv
							,NULL
							,NULL
							,NULL
							,@Modulo
							,@ID
							,@Mov
							,@MovID
							,@EsCargo
							,@AnticiposFacturados
							,NULL
							,NULL
							,@FechaAfectacion
							,@Ejercicio
							,@Periodo
							,@Mov
							,@MovID
							,0
							,0
							,0
							,@Ok OUTPUT
							,@OkRef OUTPUT
			END

			IF @MovTipo IN ('COMS.EG', 'COMS.EI', 'INV.EI', 'COMS.GX')
				AND @EstatusNuevo IN ('CONCLUIDO', 'PROCESAR', 'CANCELADO')
				EXEC spAfectarGastoDiverso @Sucursal
										  ,@SucursalOrigen
										  ,@SucursalDestino
										  ,@Accion
										  ,@Empresa
										  ,@Modulo
										  ,@ID
										  ,@Mov
										  ,@MovID
										  ,@MovTipo
										  ,@FechaRegistro
										  ,@Proyecto
										  ,@Usuario
										  ,@Autorizacion
										  ,@Referencia
										  ,@DocFuente
										  ,@Observaciones
										  ,@Ejercicio
										  ,@Periodo
										  ,@VIN
										  ,@Ok OUTPUT
										  ,@OkRef OUTPUT

			IF @UltAgente IS NOT NULL
				AND @ComisionAcum <> 0.0
				AND @Ok IS NULL
				AND (((@MovTipo IN ('VTAS.F', 'VTAS.FAR', 'VTAS.FB', 'VTAS.D', 'VTAS.DF', 'VTAS.B') AND (@Estatus = 'SINAFECTAR' OR @EstatusNuevo = 'CANCELADO')) AND (@CfgVentaComisionesCobradas = 0 OR @CobroIntegrado = 1 OR @CobrarPedido = 1)) OR @MovTipo IN ('VTAS.FM', 'VTAS.N', 'VTAS.NO', 'VTAS.NR'))
			BEGIN
				EXEC spGenerarCx @Sucursal
								,@SucursalOrigen
								,@SucursalDestino
								,@Accion
								,'AGENT'
								,@Empresa
								,@Modulo
								,@ID
								,@Mov
								,@MovID
								,@MovTipo
								,@MovMoneda
								,@MovTipoCambio
								,@FechaAfectacion
								,@Concepto
								,@Proyecto
								,@Usuario
								,@Autorizacion
								,@Referencia
								,@DocFuente
								,@Observaciones
								,@FechaRegistro
								,@Ejercicio
								,@Periodo
								,NULL
								,NULL
								,@ClienteProv
								,NULL
								,@UltAgente
								,NULL
								,NULL
								,NULL
								,@ComisionImporteNeto
								,NULL
								,NULL
								,@ComisionAcum
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,@CxModulo
								,@CxMov
								,@CxMovID
								,@Ok OUTPUT
								,@OkRef OUTPUT
				SELECT @ComisionAcum = 0.0
					  ,@ComisionImporteNeto = 0.0
			END

			IF @MovTipo = 'VTAS.DF'
				OR (@MovTipo = 'INV.A' AND @CfgInvAjusteCargoAgente <> 'NO')
				AND @Ok IS NULL
			BEGIN
				SELECT @CxImporte = NULL
					  ,@CxMovEspecifico = NULL
					  ,@CxAgente = @Agente

				IF @MovTipo = 'VTAS.DF'
				BEGIN
					SELECT @CxImporte = -SUM(Cantidad * Costo)
					FROM VentaD WITH(NOLOCK)
					WHERE ID = @ID
					SELECT @CxMovEspecifico = @Mov
					SELECT @CxAgente = AgenteServicio
					FROM Venta WITH(NOLOCK)
					WHERE ID = @ID
				END
				ELSE
				BEGIN

					IF @CfgInvAjusteCargoAgente = 'PRECIO'
						SELECT @CxImporte = SUM(d.Cantidad * ISNULL(d.Precio, a.PrecioLista))
						FROM InvD d WITH(NOLOCK)
							,Art a WITH(NOLOCK)
						WHERE d.ID = @ID
						AND d.Articulo = a.Articulo
					ELSE
						SELECT @CxImporte = SUM(Cantidad * Costo)
						FROM InvD WITH(NOLOCK)
						WHERE ID = @ID

				END

				IF ISNULL(@CxImporte, 0.0) < 0.0
				BEGIN
					SELECT @CxImporte = -@CxImporte
					EXEC spGenerarCx @Sucursal
									,@SucursalOrigen
									,@SucursalDestino
									,@Accion
									,'AGENT'
									,@Empresa
									,@Modulo
									,@ID
									,@Mov
									,@MovID
									,@MovTipo
									,@MovMoneda
									,@MovTipoCambio
									,@FechaAfectacion
									,@Concepto
									,@Proyecto
									,@Usuario
									,@Autorizacion
									,@Referencia
									,@DocFuente
									,@Observaciones
									,@FechaRegistro
									,@Ejercicio
									,@Periodo
									,NULL
									,NULL
									,@Agente
									,NULL
									,@CxAgente
									,NULL
									,NULL
									,NULL
									,@CxImporte
									,NULL
									,NULL
									,@CxImporte
									,NULL
									,NULL
									,NULL
									,NULL
									,NULL
									,@CxMovEspecifico
									,@CxModulo
									,@CxMov
									,@CxMovID
									,@Ok OUTPUT
									,@OkRef OUTPUT

					IF @Ok = 80030
						SELECT @Ok = NULL
							  ,@OkRef = NULL

				END

			END

			IF @Accion <> 'CANCELAR'
			BEGIN

				IF @CfgCompraAutoCargos = 1
					AND @MovTipo IN ('COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI', 'COMS.D', 'COMS.B')
					AND @Ok IS NULL
					EXEC xpCompraAutoCargos @Sucursal
										   ,@SucursalOrigen
										   ,@SucursalDestino
										   ,@Accion
										   ,@Modulo
										   ,@Empresa
										   ,@ID
										   ,@Mov
										   ,@MovID
										   ,@MovTipo
										   ,@MovMoneda
										   ,@MovTipoCambio
										   ,@FechaEmision
										   ,@Concepto
										   ,@Proyecto
										   ,@Usuario
										   ,@Autorizacion
										   ,@Referencia
										   ,@DocFuente
										   ,@Observaciones
										   ,@FechaRegistro
										   ,@Ejercicio
										   ,@Periodo
										   ,@Condicion
										   ,@Vencimiento
										   ,@ClienteProv
										   ,@SumaImporteNeto
										   ,@SumaImpuestosNetos
										   ,@VIN
										   ,@Ok OUTPUT
										   ,@OkRef OUTPUT

				IF @CfgVentaAutoBonif = 1
					AND @MovTipo IN ('VTAS.F', 'VTAS.FAR', 'VTAS.D', 'VTAS.DF', 'VTAS.B')
					AND @Ok IS NULL
					EXEC xpVentaAutoBonif @Sucursal
										 ,@SucursalOrigen
										 ,@SucursalDestino
										 ,@Accion
										 ,@Modulo
										 ,@Empresa
										 ,@ID
										 ,@Mov
										 ,@MovID
										 ,@MovTipo
										 ,@MovMoneda
										 ,@MovTipoCambio
										 ,@FechaEmision
										 ,@Concepto
										 ,@Proyecto
										 ,@Usuario
										 ,@Autorizacion
										 ,@Referencia
										 ,@DocFuente
										 ,@Observaciones
										 ,@FechaRegistro
										 ,@Ejercicio
										 ,@Periodo
										 ,@Condicion
										 ,@Vencimiento
										 ,@ClienteProv
										 ,@CobroIntegrado
										 ,@SumaImporteNeto
										 ,@SumaImpuestosNetos
										 ,@VIN
										 ,@Ok OUTPUT
										 ,@OkRef OUTPUT

			END

			IF @Accion <> 'CANCELAR'
				AND @MovTipo IN ('VTAS.F', 'VTAS.FAR')
				AND (
					SELECT CxcAutoAplicarAnticiposPedidos
					FROM EmpresaCfg2 WITH(NOLOCK)
					WHERE Empresa = @Empresa
				)
				= 1
			BEGIN
				SELECT @ReferenciaAplicacionAnticipo = RTRIM(@Origen) + ' ' + RTRIM(@OrigenID)
				EXEC xpVentaAutoAplicarAnticiposPedidos @Sucursal
													   ,@SucursalOrigen
													   ,@SucursalDestino
													   ,@Accion
													   ,@Modulo
													   ,@Empresa
													   ,@ID
													   ,@Mov
													   ,@MovID
													   ,@MovTipo
													   ,@MovMoneda
													   ,@MovTipoCambio
													   ,@FechaEmision
													   ,@Concepto
													   ,@Proyecto
													   ,@Usuario
													   ,@Autorizacion
													   ,@ReferenciaAplicacionAnticipo
													   ,@DocFuente
													   ,@Observaciones
													   ,@FechaRegistro
													   ,@Ejercicio
													   ,@Periodo
													   ,@Condicion
													   ,@Vencimiento
													   ,@ClienteProv
													   ,@CobroIntegrado
													   ,@SumaImporteNeto
													   ,@SumaImpuestosNetos
													   ,@VIN
													   ,@Ok OUTPUT
													   ,@OkRef OUTPUT
			END

			IF @Ok IN (NULL, 80030)
				AND @CxID IS NOT NULL
				AND @CxMovTipo IN ('CXC.F', 'CXC.CA', 'CXC.CAP', 'CXC.CAD', 'CXC.D', 'CXP.F', 'CXP.CA', 'CXP.CAP', 'CXP.CAD', 'CXP.D')
				AND @Condicion IS NOT NULL
				AND @Accion <> 'CANCELAR'
			BEGIN
				SELECT @Ok = NULL
					  ,@OkRef = NULL

				IF (
						SELECT AC
						FROM EmpresaGral WITH(NOLOCK)
						WHERE Empresa = @Empresa
					)
					= 0

					IF EXISTS (SELECT * FROM Condicion WITH(NOLOCK) WHERE Condicion = @Condicion AND DA = 1)
						EXEC spCxDocAuto @CxModulo
										,@CxID
										,@Usuario
										,@Ok OUTPUT
										,@OkRef OUTPUT

			END

			IF @CfgCompraAutoEndosoAutoCargos = 1
				AND @Modulo = 'COMS'
				AND @MovTipo = 'COMS.F'
				AND @Accion = 'AFECTAR'
				AND @EstatusNuevo = 'CONCLUIDO'
				AND @CxModulo = 'CXP'
				AND @CxmovTipo = 'CXP.F'
				AND @CxID IS NOT NULL
				AND @Ok IN (NULL, 80030)
			BEGIN
				SELECT @Proveedor = Proveedor
				FROM Compra WITH(NOLOCK)
				WHERE ID = @ID
				SELECT @AutoEndosar = AutoEndoso
				FROM Prov WITH(NOLOCK)
				WHERE Proveedor = @Proveedor

				IF @AutoEndosar IS NOT NULL
				BEGIN
					SELECT @Ok = NULL
						  ,@OkRef = NULL
					SELECT @CxEndosoMov = CxpEndoso
					FROM EmpresaCfgMov WITH(NOLOCK)
					WHERE Empresa = @Empresa
					EXEC spCx @CxID
							 ,@CxModulo
							 ,'GENERAR'
							 ,'TODO'
							 ,@FechaRegistro
							 ,@CxEndosoMov
							 ,@Usuario
							 ,1
							 ,0
							 ,@CxEndosoMov OUTPUT
							 ,@CxEndosoMovID OUTPUT
							 ,@CxEndosoID OUTPUT
							 ,@Ok OUTPUT
							 ,@OkRef OUTPUT

					IF @Ok = 80030
						SELECT @Ok = NULL
							  ,@OkRef = NULL

					IF @Ok IS NULL
					BEGIN

						IF @CxModulo = 'CXP'
							UPDATE Cxp WITH(ROWLOCK)
							SET FechaEmision = @FechaEmision
							   ,Proveedor = @AutoEndosar
							WHERE ID = @CxEndosoID

						EXEC spCx @CxEndosoID
								 ,@CxModulo
								 ,'AFECTAR'
								 ,'TODO'
								 ,@FechaRegistro
								 ,NULL
								 ,@Usuario
								 ,1
								 ,0
								 ,@CxEndosoMov OUTPUT
								 ,@CxEndosoMovID OUTPUT
								 ,NULL
								 ,@Ok OUTPUT
								 ,@OkRef OUTPUT
					END

				END

			END

			IF @MovTipo = 'COMS.OP'
				AND @Ok IS NULL
				EXEC spCompraProrrateo @Sucursal
									  ,@Empresa
									  ,@Usuario
									  ,@Accion
									  ,@Modulo
									  ,@ID
									  ,@FechaRegistro
									  ,@Mov
									  ,@MovID
									  ,@FechaEmision
									  ,@Ejercicio
									  ,@Periodo
									  ,@MovMoneda
									  ,@MovTipoCambio
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT

			IF @MovTipo = 'PROD.O'
				AND @Ok IS NULL
				EXEC spProdExplotar @Sucursal
								   ,@Empresa
								   ,@Usuario
								   ,@Accion
								   ,@Modulo
								   ,@ID
								   ,@FechaRegistro
								   ,0
								   ,@Ok OUTPUT
								   ,@OkRef OUTPUT

			IF @MovTipo IN ('VTAS.FG')
				AND @Ok IS NULL
				EXEC spGenerarGasto @Accion
								   ,@Empresa
								   ,@Sucursal
								   ,@Usuario
								   ,@Modulo
								   ,@ID
								   ,@Mov
								   ,@MovID
								   ,@FechaEmision
								   ,@FechaRegistro
								   ,@Ok OUTPUT
								   ,@OkRef OUTPUT
								   ,@MovTipo = @MovTipo

		END

	END

	IF @Modulo = 'VTAS'
	BEGIN

		IF (
				SELECT TieneMovimientos
				FROM Cte WITH(NOLOCK)
				WHERE Cliente = @ClienteProv
			)
			= 0
			UPDATE Cte WITH(ROWLOCK)
			SET TieneMovimientos = 1
			WHERE Cliente = @ClienteProv

	END

	IF @Modulo = 'VTAS'
		AND @EnviarA IS NOT NULL
	BEGIN

		IF (
				SELECT TieneMovimientos
				FROM CteEnviarA WITH(NOLOCK)
				WHERE Cliente = @ClienteProv
				AND ID = @EnviarA
			)
			= 0
			UPDATE CteEnviarA WITH(ROWLOCK)
			SET TieneMovimientos = 1
			WHERE Cliente = @ClienteProv
			AND ID = @EnviarA

	END

	IF @Almacen IS NOT NULL
	BEGIN

		IF (
				SELECT TieneMovimientos
				FROM Alm WITH(NOLOCK)
				WHERE Almacen = @Almacen
			)
			= 0
			UPDATE Alm WITH(ROWLOCK)
			SET TieneMovimientos = 1
			WHERE Almacen = @Almacen

	END

	IF @AlmacenDestino IS NOT NULL
	BEGIN

		IF (
				SELECT TieneMovimientos
				FROM Alm WITH(NOLOCK)
				WHERE Almacen = @AlmacenDestino
			)
			= 0
			UPDATE Alm WITH(ROWLOCK)
			SET TieneMovimientos = 1
			WHERE Almacen = @AlmacenDestino

	END

	IF @Agente IS NOT NULL
	BEGIN

		IF (
				SELECT TieneMovimientos
				FROM Agente WITH(NOLOCK)
				WHERE Agente = @Agente
			)
			= 0
			UPDATE Agente WITH(ROWLOCK)
			SET TieneMovimientos = 1
			WHERE Agente = @Agente

	END

	IF @Modulo = 'COMS'
	BEGIN

		IF (
				SELECT TieneMovimientos
				FROM Prov WITH(NOLOCK)
				WHERE Proveedor = @ClienteProv
			)
			= 0
			UPDATE Prov WITH(ROWLOCK)
			SET TieneMovimientos = 1
			WHERE Proveedor = @ClienteProv

	END

	IF @OrigenMovTipo = 'VTAS.FR'
		EXEC spAfectarMovRecurrente @Accion
								   ,@Empresa
								   ,@Modulo
								   ,@Origen
								   ,@OrigenID
								   ,@Ok OUTPUT
								   ,@OkRef OUTPUT

	IF @MovTipo = 'VTAS.CTO'
		EXEC spMovContratoGenerar @Accion
								 ,@Empresa
								 ,@Sucursal
								 ,@Usuario
								 ,@Modulo
								 ,@ID
								 ,@Mov
								 ,@MovID
								 ,@FechaRegistro
								 ,@Ok OUTPUT
								 ,@OkRef OUTPUT

	IF @MovTipo IN ('COMS.CA', 'COMS.GX')
	BEGIN
		SELECT @ProrrateoAplicaID = p.ID
			  ,@ProrrateoAplicaIDMov = p.Mov
			  ,@ProrrateoAplicaIDMovID = p.MovID
		FROM Compra c WITH(NOLOCK)
			,Compra p WITH(NOLOCK)
		WHERE c.ID = @ID
		AND c.ProrrateoAplicaID = p.ID

		IF @ProrrateoAplicaID IS NOT NULL
			EXEC spMovFlujo @Sucursal
						   ,@Accion
						   ,@Empresa
						   ,@Modulo
						   ,@ID
						   ,@Mov
						   ,@MovID
						   ,@Modulo
						   ,@ProrrateoAplicaID
						   ,@ProrrateoAplicaIDMov
						   ,@ProrrateoAplicaIDMovID
						   ,@Ok OUTPUT

	END

	IF @Ok IS NULL
		OR @Ok BETWEEN 80030 AND 81000
	BEGIN

		IF @GenerarGasto = 1
			AND @Modulo = 'INV'
			EXEC spGenerarGasto @Accion
							   ,@Empresa
							   ,@Sucursal
							   ,@Usuario
							   ,@Modulo
							   ,@ID
							   ,@Mov
							   ,@MovID
							   ,@FechaEmision
							   ,@FechaRegistro
							   ,@Ok OUTPUT
							   ,@OkRef OUTPUT
							   ,@MovTipoGenerarGasto = 1

		EXEC xpInvGenerarGasto @Sucursal
							  ,@Accion
							  ,@Modulo
							  ,@ID
							  ,@Mov
							  ,@MovID
							  ,@MovTipo
							  ,@Empresa
							  ,@Usuario
							  ,@FechaRegistro
							  ,@ClienteProv
							  ,@Ok OUTPUT
							  ,@OkRef OUTPUT
	END

	IF @MovTipo IN ('COMS.F', 'COMS.CC', 'VTAS.F')
		AND @Accion = 'AFECTAR'
		AND @EstatusNuevo = 'CONCLUIDO'
		EXEC spEliminarOrdenesPendientes @ID
										,@Accion
										,@Base
										,@Empresa
										,@Usuario
										,@Modulo
										,@Mov
										,@MovID
										,@MovTipo
										,@MovMoneda
										,@MovTipoCambio
										,@Estatus
										,@EstatusNuevo
										,@FechaEmision
										,@FechaRegistro
										,@FechaAfectacion
										,@Conexion
										,@SincroFinal
										,@Sucursal
										,NULL
										,NULL
										,@Ok OUTPUT
										,@OkRef OUTPUT

	IF @MovTipo = 'COMS.O'
		AND @Accion = 'AFECTAR'
		AND @EstatusNuevo = 'PENDIENTE'
		EXEC spCancelarRequisicionesPendientes @ID
											  ,@Accion
											  ,@Base
											  ,@Empresa
											  ,@Usuario
											  ,@Modulo
											  ,@Mov
											  ,@MovID
											  ,@MovTipo
											  ,@MovMoneda
											  ,@MovTipoCambio
											  ,@Estatus
											  ,@EstatusNuevo
											  ,@FechaEmision
											  ,@FechaRegistro
											  ,@FechaAfectacion
											  ,@Conexion
											  ,@SincroFinal
											  ,@Sucursal
											  ,NULL
											  ,NULL
											  ,@Ok OUTPUT
											  ,@OkRef OUTPUT

	IF @MovTipo IN ('VTAS.P', 'VTAS.S')
		AND @CfgVentaDMultiAgenteSugerir = 1
		AND @EstatusNuevo = 'PENDIENTE'
		EXEC spSugerirVentaDAgenteFecha @ID
									   ,@EnSilencio = 1

	IF @OrigenMovTipo <> 'INV.IF'
	BEGIN

		IF @MovTipo <> 'INV.T'
			AND @WMS = 1
			AND EXISTS (SELECT * FROM Alm WITH(NOLOCK) WHERE Almacen = @Almacen AND WMS = 1)
			AND @Accion IN ('AFECTAR', 'CANCELAR', 'RESERVARPARCIAL')
			AND @OrigenTipo <> 'TMA'
			AND @Ok IS NULL
		BEGIN
			EXEC spFlujoWMS @Modulo
						   ,@ID
						   ,@Accion
						   ,@Empresa
						   ,@Sucursal
						   ,@Usuario
						   ,@Mov
						   ,@MovID
						   ,@MovTipo
						   ,@Almacen
						   ,@FechaEmision
						   ,@Proyecto
						   ,@Tarima
						   ,@Articulo
						   ,@Ok OUTPUT
						   ,@OkRef OUTPUT

			IF @MovTipo = 'INV.SOL'
			BEGIN
				SELECT @CrossDocking = CrossDocking
					  ,@Almacen = Almacen
					  ,@PosicionWMS = PosicionWMS
				FROM INV WITH(NOLOCK)
				WHERE ID = @ID
				SELECT @EsCrossDocking = RTRIM(LTRIM(ISNULL(EsCrossDocking, '')))
					  ,@posicioncrossdocking = ISNULL(defposicioncrossdocking, '')
				FROM ALM WITH(NOLOCK)
				WHERE Almacen = @Almacen

				IF @posicioncrossdocking = ''
					AND @CrossDocking = 1
				BEGIN
					SELECT @Ok = Mensaje
						  ,@OkRef = Descripcion
					FROM MensajeLista WITH(NOLOCK)
					WHERE Mensaje = 20028
					SELECT @OkRef
					ROLLBACK TRANSACTION
					EXEC spEliminarMov @Modulo
									  ,@ID
					RETURN
				END

				IF @EsCrossDocking = ''
					AND @CrossDocking = 1
				BEGIN
					SELECT @Ok = Mensaje
						  ,@OkRef = Descripcion
					FROM MensajeLista WITH(NOLOCK)
					WHERE Mensaje = 20027
					SELECT @OkRef
					ROLLBACK TRANSACTION
					EXEC spEliminarMov @Modulo
									  ,@ID
					RETURN
				END

				IF @CrossDocking = 1
					AND @EsCrossDocking IN ('Si', 'No')
				BEGIN
					EXEC spAfectar 'INV'
								  ,@ID
								  ,'AFECTAR'
								  ,'Todo'
								  ,NULL
								  ,@Usuario
								  ,@EnSilencio = 1
								  ,@Estacion = @@SPID
					EXEC spAfectar 'INV'
								  ,@ID
								  ,'GENERAR'
								  ,'Pendiente'
								  ,'Entarimado'
								  ,@Usuario
								  ,@EnSilencio = 1
								  ,@Estacion = @@SPID
				END

			END

		END

	END

	IF @FEA = 1
	BEGIN
		EXEC spInvAfectarFEA @ID
							,@Accion
							,@Empresa
							,@Sucursal
							,@Estatus
							,@Modulo
							,@Mov
							,@MovTipoConsecutivoFEA
							,@FEAConsecutivo
							,@FEAReferencia
							,@FEASerie
							,@FEAFolio
							,@Ok OUTPUT
							,@OkRef OUTPUT
	END

	IF @MovTipo = 'INV.A'
		AND @OrigenMovTipo = 'INV.IF'
		EXEC spMovFlujo @Sucursal
					   ,@Accion
					   ,@Empresa
					   ,'INV'
					   ,@IDOrigen
					   ,@Origen
					   ,@OrigenID
					   ,'INV'
					   ,@ID
					   ,@Mov
					   ,@MovID
					   ,@Ok OUTPUT

	IF @WMS = 1
		AND @Modulo = 'INV'
		AND @MovTipo = 'INV.A'
		AND @Accion = 'CANCELAR'
		AND @OrigenMovTipo = 'INV.IF'
	BEGIN
		UPDATE Tarima WITH(ROWLOCK)
		SET Estatus = 'ALTA'
		   ,Baja = NULL
		FROM Tarima WITH(NOLOCK)
		JOIN InvD WITH(NOLOCK)
			ON Tarima.Posicion = InvD.PosicionReal
		JOIN Inv WITH(NOLOCK)
			ON InvD.ID = Inv.ID
		JOIN AlmPos WITH(NOLOCK)
			ON Inv.Almacen = AlmPos.Almacen
			AND InvD.PosicionReal = AlmPos.Posicion
		JOIN ArtDisponibleTarima WITH(NOLOCK)
			ON Tarima.Tarima = ArtDisponibleTarima.Tarima
			AND ArtDisponibleTarima.Empresa = Inv.Empresa
			AND ArtDisponibleTarima.Almacen = Inv.Almacen
		WHERE InvD.ID = @ID
		AND AlmPos.Tipo <> 'DOMICILIO'
		AND Disponible > 0
		AND Tarima.Estatus = 'BAJA'
	END

	IF @Ok IS NULL
		OR @Ok BETWEEN 80030 AND 81000
		EXEC spMovFinal @Empresa
					   ,@Sucursal
					   ,@Modulo
					   ,@ID
					   ,@Estatus
					   ,@EstatusNuevo
					   ,@Usuario
					   ,@FechaEmision
					   ,@FechaRegistro
					   ,@Mov
					   ,@MovID
					   ,@MovTipo
					   ,@IDGenerar
					   ,@Ok OUTPUT
					   ,@OkRef OUTPUT
					   ,@Estacion = @EstacionTrabajo

	IF @Ok IS NULL
		EXEC spInvAfectar2 @ID
						  ,@Accion
						  ,@Base
						  ,@Empresa
						  ,@Usuario
						  ,@Modulo
						  ,@Mov
						  ,@MovID
						  ,@MovTipo
						  ,@MovMoneda
						  ,@MovTipoCambio
						  ,@Estatus
						  ,@EstatusNuevo
						  ,@FechaEmision
						  ,@FechaRegistro
						  ,@FechaAfectacion
						  ,@Conexion
						  ,@SincroFinal
						  ,@Sucursal
						  ,@UtilizarID
						  ,@UtilizarMovTipo
						  ,@EsEcuador
						  ,@IDGenerar
						  ,@GenerarOP
						  ,@ClienteProv
						  ,@ServicioSerie
						  ,@OrigenTipo
						  ,@Ok OUTPUT
						  ,@OkRef OUTPUT
						  ,@OPORT
						  ,@SubClave
						  ,@Origen
						  ,@OrigenID
						  ,@CfgVentaPuntosEnVales
						  ,@AlmacenDestinoOriginal
						  ,@Almacen
						  ,@Referencia
						  ,@IDTransito
						  ,@ContID
						  ,@Estacion
						  ,@TransitoSucursal
						  ,@TransitoMov
						  ,@TransitoMovID
						  ,@TransitoEstatus
						  ,@TraspasoExpressMov
						  ,@TraspasoExpressMovID
						  ,@CFGProdInterfazInfor
						  ,@OrigenMovTipo
						  ,@Proyecto
						  ,@Tarima
						  ,@Articulo

	IF @Ok IS NULL
		OR @Ok BETWEEN 80030 AND 81000
		EXEC xpInvAfectar @ID
						 ,@Accion
						 ,@Base
						 ,@Empresa
						 ,@Usuario
						 ,@Modulo
						 ,@Mov
						 ,@MovID
						 ,@MovTipo
						 ,@MovMoneda
						 ,@MovTipoCambio
						 ,@Estatus
						 ,@EstatusNuevo
						 ,@FechaEmision
						 ,@FechaRegistro
						 ,@FechaAfectacion
						 ,@Conexion
						 ,@SincroFinal
						 ,@Sucursal
						 ,NULL
						 ,NULL
						 ,@Ok OUTPUT
						 ,@OkRef OUTPUT

	IF @Modulo = 'COMS'
		AND @MovTipo = 'COMS.O'
		AND @SubMovTipo = 'COMS.OPREENTARIMADO'
	BEGIN
		EXEC spGenerarOrdenEntarimado @Modulo
									 ,@ID
									 ,@Accion
									 ,@Empresa
									 ,@Sucursal
									 ,@Usuario
									 ,@Mov
									 ,@MovID
									 ,@MovTipo
									 ,@Almacen
									 ,@Ok OUTPUT
									 ,@OkRef OUTPUT
	END

	IF @Modulo = 'COMS'
		AND @MovTipo = 'COMS.O'
		AND @SubMovTipo = 'COMS.EIMPO'
	BEGIN
		EXEC spGenerarReciboImportacion @Modulo
									   ,@ID
									   ,@Accion
									   ,@Empresa
									   ,@Sucursal
									   ,@Usuario
									   ,@Mov
									   ,@MovID
									   ,@MovTipo
									   ,@Estatus
									   ,@Ok OUTPUT
									   ,@OkRef OUTPUT
	END

	IF @Accion = 'CANCELAR'
		AND @EstatusNuevo = 'CANCELADO'
		AND @Ok IS NULL
	BEGIN
		EXEC spCancelarFlujo @Empresa
							,@Modulo
							,@ID
							,@Ok OUTPUT

		IF @Modulo = 'VTAS'
			UPDATE VentaOrigen WITH(ROWLOCK)
			SET OrigenID = 0
			WHERE ID = @ID

	END

	IF @SAUX = 1
		AND @Accion IN ('AFECTAR', 'CANCELAR', 'RESERVARPARCIAL')
		AND @OK IS NULL
		EXEC spFlujoSAUX @Modulo
						,@ID
						,@Accion
						,@Base
						,@FechaRegistro
						,NULL
						,@Empresa
						,@Sucursal
						,@Usuario
						,@Conexion
						,@SincroFinal
						,@Mov
						,@MovID
						,@MovTipo
						,@Almacen
						,@FechaEmision
						,@Proyecto
						,@Ok OUTPUT
						,@OkRef OUTPUT

	IF @Modulo = 'VTAS'
		AND EXISTS (SELECT * FROM ValeSerie v WITH(NOLOCK) JOIN VentaD d WITH(NOLOCK) ON v.Articulo = d.Articulo JOIN SerieLoteMov s WITH(NOLOCK) ON d.ID = s.ID AND s.Modulo = 'VTAS' AND s.Empresa = @Empresa AND s.RenglonID = d.RenglonID AND d.Articulo = s.Articulo AND ISNULL(d.SubCuenta, '') = ISNULL(s.SubCuenta, '') AND v.Serie = s.SerieLote JOIN Art a WITH(NOLOCK) ON d.Articulo = a.Articulo WHERE d.ID = @ID AND a.LDI = 1)
		AND @LDI = 1
		AND @OrigenTipo NOT IN ('POS', 'VMOS')
		AND @Accion NOT IN ('CANCELAR')
		AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
		EXEC spLDIVentaGenerarActivacionVale @Empresa
											,@Modulo
											,@ID
											,@Mov
											,@MovID
											,@MovTipo
											,@Accion
											,@FechaEmision
											,@Ejercicio
											,@Periodo
											,@Usuario
											,@Sucursal
											,@MovMoneda
											,@MovTipoCambio
											,@Ok OUTPUT
											,@OkRef OUTPUT

	IF @CobroIntegrado = 1
		AND @CobroIntegradoCxc = 0
		AND @CobroIntegradoParcial = 0
		AND @OrigenTipo NOT IN ('CR', 'POS', 'VMOS')
		AND @ImporteTotalCx <> 0.0
		AND (@Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') OR @EstatusNuevo = 'CANCELADO')
		AND @Ok IS NULL
	BEGIN

		IF @OK IS NULL
			AND @TarjetasCobradas <> 0
			AND @LDI = 1
			AND @LDITarjeta = 1
			EXEC spValeGeneraAplicacionTarjeta @Empresa
											  ,@Modulo
											  ,@ID
											  ,@Mov
											  ,@MovID
											  ,@Accion
											  ,@FechaEmision
											  ,@Usuario
											  ,@Sucursal
											  ,@TarjetasCobradas
											  ,@CtaDinero
											  ,@MovMoneda
											  ,@MovTipoCambio
											  ,@Ok OUTPUT
											  ,@OkRef OUTPUT
											  ,@LDI = 1
											  ,@Referencia = @ReferenciaTarjetas

	END

	IF @OK IS NULL
		AND @Modulo = 'VTAS'
		AND @CfgVentaMonedero = 1
		AND @CfgVentaMonederoA = 0
		AND EXISTS (SELECT * FROM TarjetaSeriemov t WITH(NOLOCK) JOIN ValeSerie v WITH(NOLOCK) ON t.Serie = v.Serie JOIN Art a WITH(NOLOCK) ON v.Articulo = a.Articulo WHERE t.Empresa = @Empresa AND t.Modulo = @Modulo AND t.ID = @ID AND ISNULL(a.LDI, 0) = 1)
		AND @LDI = 1
		AND @OrigenTipo NOT IN ('VMOS')
		EXEC spVentaMonedero @Empresa
							,@Modulo
							,@ID
							,@Mov
							,@MovID
							,@MovTipo
							,@Accion
							,@FechaEmision
							,@Ejercicio
							,@Periodo
							,@Usuario
							,@Sucursal
							,@MovMoneda
							,@MovTipoCambio
							,@Ok OUTPUT
							,@OkRef OUTPUT
							,@LDI = 1

	IF @Modulo = 'VTAS'
		AND @MovTipo = 'VTAS.N'
		AND @SubClave = 'VTAS.NLDI'
		AND @Ok IS NULL
		AND @OrigenTipo NOT IN ('POS', 'VMOS')
		AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
		AND @Accion NOT IN ('CANCELAR')
		EXEC spLDIVentaGenerarRecargaTel @Empresa
										,@Modulo
										,@ID
										,@Mov
										,@MovID
										,@MovTipo
										,@Accion
										,@FechaEmision
										,@Ejercicio
										,@Periodo
										,@Usuario
										,@Sucursal
										,@MovMoneda
										,@MovTipoCambio
										,@Ok OUTPUT
										,@OkRef OUTPUT

	IF @Modulo = 'VTAS'
		AND @MovTipo = 'VTAS.N'
		AND @SubClave = 'VTAS.NLDISERVICIO'
		AND @Ok IS NULL
		AND @OrigenTipo NOT IN ('POS', 'VMOS')
		AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
		AND @Accion NOT IN ('CANCELAR')
		EXEC spLDIVentaGenerarPagoServicio @Empresa
										  ,@Modulo
										  ,@ID
										  ,@Mov
										  ,@MovID
										  ,@MovTipo
										  ,@Accion
										  ,@FechaEmision
										  ,@Ejercicio
										  ,@Periodo
										  ,@Usuario
										  ,@Sucursal
										  ,@MovMoneda
										  ,@MovTipoCambio
										  ,@Ok OUTPUT
										  ,@OkRef OUTPUT

	IF @LDI = 1
		AND @Ok IS NOT NULL
		AND EXISTS (SELECT * FROM WITH(NOLOCK) LDIIDTemp WHERE Estacion = @@SPID AND Modulo = @Modulo)
	BEGIN
		INSERT @LDILog (IDModulo, Modulo, Servicio, Fecha, TipoTransaccion, TipoSubservicio, CodigoRespuesta, DescripcionRespuesta, OrigenRespuesta, InfoAdicional, IDTransaccion, CodigoAutorizacion, Comprobante, Cadena, CadenaRespuesta, Importe, RIDCobro)
			SELECT IDModulo
				  ,Modulo
				  ,Servicio
				  ,Fecha
				  ,TipoTransaccion
				  ,TipoSubservicio
				  ,CodigoRespuesta
				  ,DescripcionRespuesta
				  ,OrigenRespuesta
				  ,InfoAdicional
				  ,IDTransaccion
				  ,CodigoAutorizacion
				  ,Comprobante
				  ,Cadena
				  ,CadenaRespuesta
				  ,Importe
				  ,RIDCobro
			FROM LDIMovLog WITH(NOLOCK)
			WHERE IDModulo = @ID
			AND ID IN (SELECT ID FROM LDIIDTemp WITH(NOLOCK) WHERE Estacion = @@SPID AND Modulo = @Modulo)
	END

	IF @Conexion = 0
	BEGIN

		IF @Ok IS NULL
			OR @Ok BETWEEN 80030 AND 81000
			COMMIT TRANSACTION
		ELSE
		BEGIN
			DECLARE
				@PolizaDescuadrada TABLE (
					Cuenta VARCHAR(20) NULL
				   ,SubCuenta VARCHAR(50) NULL
				   ,Concepto VARCHAR(50) NULL
				   ,Debe MONEY NULL
				   ,Haber MONEY NULL
				   ,SucursalContable INT NULL
				)

			IF EXISTS (SELECT * FROM PolizaDescuadrada WITH(NOLOCK) WHERE Modulo = @Modulo AND ID = @ID)
				INSERT @PolizaDescuadrada (Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable)
					SELECT Cuenta
						  ,SubCuenta
						  ,Concepto
						  ,Debe
						  ,Haber
						  ,SucursalContable
					FROM PolizaDescuadrada WITH(NOLOCK)
					WHERE Modulo = @Modulo
					AND ID = @ID

			ROLLBACK TRANSACTION
			DELETE PolizaDescuadrada
			WHERE Modulo = @Modulo
				AND ID = @ID
			INSERT PolizaDescuadrada (Modulo, ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable)
				SELECT @Modulo
					  ,@ID
					  ,Cuenta
					  ,SubCuenta
					  ,Concepto
					  ,Debe
					  ,Haber
					  ,SucursalContable
				FROM @PolizaDescuadrada

			IF EXISTS (SELECT * FROM @LDILog)
			BEGIN
				INSERT LDIMovLog (IDModulo, Modulo, Servicio, Fecha, TipoTransaccion, TipoSubservicio, CodigoRespuesta, DescripcionRespuesta, OrigenRespuesta, InfoAdicional, IDTransaccion, CodigoAutorizacion, Comprobante, Cadena, CadenaRespuesta, Importe, RIDCobro)
					SELECT IDModulo
						  ,Modulo
						  ,Servicio
						  ,Fecha
						  ,TipoTransaccion
						  ,TipoSubservicio
						  ,CodigoRespuesta
						  ,DescripcionRespuesta
						  ,OrigenRespuesta
						  ,InfoAdicional
						  ,IDTransaccion
						  ,CodigoAutorizacion
						  ,Comprobante
						  ,Cadena
						  ,CadenaRespuesta
						  ,Importe
						  ,RIDCobro
					FROM @LDILog
			END

		END

	END

	SELECT @BanderaDesentarimado = DesentarimarPedido
	FROM EmpresaCfg WITH(NOLOCK)
	WHERE Empresa = @Empresa

	IF @BanderaDesentarimado = 1
		AND @Accion = 'CANCELAR'
		AND @MovTipo = 'VTAS.P'
	BEGIN
		EXEC SPDesentarimarSurtidoPedido @ID
										,@Empresa
										,@Estacion
										,@Usuario
	END

	IF @Ok = 80070
		AND @MovTipo = 'INV.IF'
		UPDATE Inv WITH(ROWLOCK)
		SET Estatus = 'CONCLUIDO'
		   ,FechaConclusion = GETDATE()
		WHERE ID = @ID

	RETURN
END

