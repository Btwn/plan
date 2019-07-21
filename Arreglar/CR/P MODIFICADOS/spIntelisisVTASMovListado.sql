SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisVTASMovListado
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@IDO					int   ,
@Empresa				varchar(5),
@Mov					varchar(20),
@MovID					varchar(20),
@FechaEmision			datetime   ,
@UltimoCambio			datetime   ,
@Concepto				varchar(50),
@Proyecto				varchar(50),
@UEN					int   ,
@Moneda					varchar(10),
@TipoCambio			    float   ,
@Usuario				varchar(10),
@Autorizacion		    varchar(10),
@Referencia				varchar(50),
@DocFuente				int   ,
@Observaciones			varchar(100),
@Estatus				varchar(15),
@Situacion				varchar(50),
@SituacionFecha			datetime   ,
@SituacionUsuario		varchar(10),
@SituacionNota			varchar(100),
@Directo				bit   ,
@Prioridad				varchar(10),
@RenglonID				int   ,
@FechaOriginal			datetime   ,
@Codigo					varchar(30),
@Cliente				varchar(10),
@EnviarA				int   ,
@Almacen				varchar(10),
@AlmacenDestino			varchar(10),
@Agente					varchar(10),
@AgenteServicio			varchar(10),
@AgenteComision			float   ,
@FormaEnvio				varchar(50),
@FechaRequerida			datetime   ,
@HoraRequerida			varchar(5),
@FechaProgramadaEnvio   datetime   ,
@FechaOrdenCompra		datetime   ,
@ReferenciaOrdenCompra  varchar(50),
@OrdenCompra			varchar(50),
@Condicion				varchar(50),
@Vencimiento			datetime   ,
@CtaDinero				varchar(10),
@Descuento				varchar(30),
@DescuentoGlobal		float   ,
@Importe				money   ,
@Impuestos				money   ,
@Saldo					money   ,
@AnticiposFacturados	money   ,
@AnticiposImpuestos		money   ,
@Retencion				money   ,
@DescuentoLineal		money   ,
@ComisionTotal			money   ,
@CostoTotal				money   ,
@PrecioTotal			money   ,
@Paquetes				int   ,
@ServicioTipo			varchar(50),
@ServicioArticulo		varchar(20),
@ServicioSerie			varchar(50),
@ServicioContrato		varchar(20),
@ServicioContratoID		varchar(20),
@ServicioContratoTipo   varchar(50),
@ServicioGarantia		bit   ,
@ServicioDescripcion	varchar(100),
@ServicioFecha			datetime   ,
@ServicioFlotilla		bit   ,
@ServicioRampa			bit   ,
@ServicioIdentificador  varchar(20),
@ServicioPlacas			varchar(20),
@ServicioKms			int   ,
@ServicioTipoOrden		varchar(20),
@ServicioTipoOperacion  varchar(50),
@ServicioSiniestro		varchar(20),
@ServicioExpress		bit   ,
@ServicioDemerito		bit   ,
@ServicioDeducible		bit   ,
@ServicioDeducibleImporte   money   ,
@ServicioNumero			float   ,
@ServicioNumeroEconomico  varchar(20),
@ServicioAseguradora	varchar(10),
@ServicioPuntual		bit   ,
@ServicioPoliza			varchar(20),
@OrigenTipo				varchar(10),
@Origen					varchar(20),
@OrigenID				varchar(20),
@Poliza					varchar(20),
@PolizaID				varchar(20),
@GenerarPoliza			bit   ,
@ContID					int   ,
@Ejercicio				int   ,
@Periodo				int   ,
@FechaRegistro			datetime   ,
@FechaConclusion		datetime   ,
@FechaCancelacion		datetime   ,
@FechaEntrega			datetime   ,
@EmbarqueEstado			varchar(50),
@EmbarqueGastos			money   ,
@Peso					float   ,
@Volumen				float   ,
@Causa					varchar(50),
@Atencion				varchar(50),
@AtencionTelefono		varchar(50),
@ListaPreciosEsp		varchar(20),
@ZonaImpuesto			varchar(30),
@Extra					bit   ,
@CancelacionID			int   ,
@Mensaje				int   ,
@Departamento			int   ,
@Sucursal				int   ,
@GenerarOP				bit   ,
@DesglosarImpuestos		bit   ,
@DesglosarImpuesto2		bit   ,
@ExcluirPlaneacion		bit   ,
@ConVigencia			bit   ,
@VigenciaDesde			datetime   ,
@VigenciaHasta			datetime   ,
@Enganche				money   ,
@Bonificacion			float   ,
@IVAFiscal				float   ,
@IEPSFiscal				float   ,
@EstaImpreso			bit   ,
@Periodicidad			varchar(20),
@SubModulo				varchar(5),
@ContUso				varchar(20),
@Espacio				varchar(10),
@AutoCorrida			varchar(20),
@AutoCorridaHora		varchar(5),
@AutoCorridaServicio	varchar(50),
@AutoCorridaRol			varchar(50),
@AutoCorridaOrigen		varchar(5),
@AutoCorridaDestino		varchar(5),
@AutoCorridaKms			int   ,
@AutoCorridaLts			int   ,
@AutoCorridaRuta		varchar(5),
@AutoOperador2			varchar(10),
@AutoBoleto				varchar(11),
@AutoKms				int   ,
@AutoKmsActuales		int   ,
@AutoBomba				varchar(10),
@AutoBombaContador		int   ,
@Logico1				bit   ,
@Logico2				bit   ,
@Logico3				bit   ,
@Logico4				bit   ,
@DifCredito				money   ,
@EspacioResultado		bit   ,
@Clase					varchar(50),
@Subclase				varchar(50),
@GastoAcreedor			varchar(10),
@GastoConcepto			varchar(50),
@Pagado					float   ,
@GenerarDinero			bit   ,
@Dinero					varchar(20),
@DineroID				varchar(20),
@DineroCtaDinero		varchar(10),
@DineroConciliado		bit   ,
@DineroFechaConciliacion datetime   ,
@Extra1					bit   ,
@Extra2					bit   ,
@Extra3					bit   ,
@Reabastecido			bit   ,
@SucursalVenta			int   ,
@AF						bit   ,
@AFArticulo				varchar(20),
@AFSerie				varchar(20),
@ContratoTipo			varchar(50),
@ContratoDescripcion	varchar(100),
@ContratoSerie			varchar(20),
@ContratoValor			money   ,
@ContratoValorMoneda	varchar(10),
@ContratoSeguro			varchar(20),
@ContratoVencimiento	datetime   ,
@ContratoResponsabl		varchar(10),
@Incentivo				money   ,
@IncentivoConcepto		varchar(50),
@EndosarA				varchar(10),
@InteresTasa			float   ,
@InteresIVA				float   ,
@AnexoID				int   ,
@FordVisitoOASIS		bit   ,
@LineaCredito			varchar(20),
@TipoAmortizacion		varchar(20),
@TipoTasa				varchar(20),
@Comisiones				money   ,
@ComisionesIVA			money   ,
@CompraID				int   ,
@OperacionRelevante		bit   ,
@TieneTasaEsp			bit   ,
@TasaEsp				float   ,
@FormaPagoTipo			varchar(50),
@SobrePrecio			float   ,
@SincroID				timestamp   ,
@SincroC				int   ,
@SucursalOrigen			int   ,
@SucursalDestino		int   ,
@ContUso2				varchar(20),
@ContUso3				varchar(20),
@Actividad				varchar(50),
@ContratoID				int   ,
@ContratoMov			varchar(20),
@ContratoMovID			varchar(20),
@MAFCiclo				int   ,
@TipoComprobante		varchar(20),
@SustentoComprobante	varchar(20),
@TipoIdentificacion		varchar(20),
@DerechoDevolucion		bit   ,
@Establecimiento		varchar(20),
@PuntoEmision			varchar(50),
@SecuencialSRI			varchar(50),
@AutorizacionSRI		varchar(50),
@VigenteA				datetime   ,
@SecuenciaRetencion		varchar(50),
@Comprobante			bit   ,
@FechaContableMov		datetime   ,
@Texto					xml,
@Texto2					xml,
@ReferenciaIS			varchar(100),
@SubReferencia			varchar(100)
BEGIN TRANSACTION
IF @Ok IS NULL
BEGIN
SELECT @IDO = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='ID'
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='Empresa'
SELECT @Mov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='Mov'
SELECT @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='MovID'
SELECT @FechaEmision = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='FechaEmision'
SELECT @UltimoCambio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='UltimoCambio'
SELECT @Concepto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='Concepto'
SELECT @Proyecto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='Proyecto'
SELECT @UEN = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='UEN'
SELECT @Moneda = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='Moneda'
SELECT @TipoCambio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='TipoCambio'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='Usuario'
SELECT @Autorizacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='Autorizacion'
SELECT @Referencia = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='Referencia'
SELECT @DocFuente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='DocFuente'
SELECT @Observaciones = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='Observaciones'
SELECT @Estatus = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='Estatus'
SELECT @Situacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='Situacion'
SELECT @SituacionFecha = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='SituacionFecha'
SELECT @SituacionUsuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='SituacionUsuario'
SELECT @SituacionNota = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='SituacionNota'
SELECT @Directo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='Directo'
SELECT @Prioridad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='Prioridad'
SELECT @RenglonID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='RenglonID'
SELECT @FechaOriginal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='FechaOriginal'
SELECT @Codigo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='Codigo'
SELECT @Cliente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='Cliente'
SELECT @EnviarA = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='EnviarA'
SELECT @Almacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='Almacen'
SELECT @AlmacenDestino = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='AlmacenDestino'
SELECT @Agente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='Agente'
SELECT @AgenteServicio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='AgenteServicio'
SELECT @AgenteComision = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='AgenteComision'
SELECT @FormaEnvio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='FormaEnvio'
SELECT @FechaRequerida = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='FechaRequerida'
SELECT @HoraRequerida = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='HoraRequerida'
SELECT @FechaProgramadaEnvio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='FechaProgramadaEnvio'
SELECT @FechaOrdenCompra = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='FechaOrdenCompra'
SELECT @ReferenciaOrdenCompra = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='ReferenciaOrdenCompra'
SELECT @OrdenCompra = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='OrdenCompra'
SELECT @Condicion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Condicion'
SELECT @Vencimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Vencimiento'
SELECT @CtaDinero = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='CtaDinero'
SELECT @Descuento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Descuento'
SELECT @DescuentoGlobal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='DescuentoGlobal'
SELECT @Importe = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Importe'
SELECT @Impuestos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Impuestos'
SELECT @Saldo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Saldo'
SELECT @AnticiposFacturados = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AnticiposFacturados'
SELECT @AnticiposImpuestos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AnticiposImpuestos'
SELECT @Retencion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Retencion'
SELECT @DescuentoLineal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='DescuentoLineal'
SELECT @ComisionTotal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ComisionTotal'
SELECT @CostoTotal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='CostoTotal'
SELECT @PrecioTotal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='PrecioTotal'
SELECT @Paquetes = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Paquetes'
SELECT @ServicioTipo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioTipo'
SELECT @ServicioArticulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioArticulo'
SELECT @ServicioSerie = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioSerie'
SELECT @ServicioContrato = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioContrato'
SELECT @ServicioContratoID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioContratoID'
SELECT @ServicioContratoTipo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioContratoTipo'
SELECT @ServicioGarantia = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioGarantia'
SELECT @ServicioDescripcion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioDescripcion'
SELECT @ServicioFecha = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioFecha'
SELECT @ServicioFlotilla = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioFlotilla'
SELECT @ServicioRampa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioRampa'
SELECT @ServicioIdentificador = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioIdentificador'
SELECT @ServicioPlacas = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioPlacas'
SELECT @ServicioKms = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioKms'
SELECT @ServicioTipoOrden = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioTipoOrden'
SELECT @ServicioTipoOperacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioTipoOperacion'
SELECT @ServicioSiniestro = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioSiniestro'
SELECT @ServicioExpress = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioExpress'
SELECT @ServicioDemerito = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioDemerito'
SELECT @ServicioDeducible = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioDeducible'
SELECT @ServicioDeducibleImporte = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioDeducibleImporte'
SELECT @ServicioNumero = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioNumero'
SELECT @ServicioNumeroEconomico = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioNumeroEconomico'
SELECT @ServicioAseguradora = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioAseguradora'
SELECT @ServicioPuntual = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioPuntual'
SELECT @ServicioPoliza = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ServicioPoliza'
SELECT @OrigenTipo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='OrigenTipo'
SELECT @Origen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Origen'
SELECT @OrigenID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='OrigenID'
SELECT @Poliza = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Poliza'
SELECT @PolizaID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='PolizaID'
SELECT @GenerarPoliza = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='GenerarPoliza'
SELECT @ContID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ContID'
SELECT @Ejercicio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Ejercicio'
SELECT @Periodo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Periodo'
SELECT @FechaRegistro = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='FechaRegistro'
SELECT @FechaConclusion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='FechaConclusion'
SELECT @FechaCancelacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='FechaCancelacion'
SELECT @FechaEntrega = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='FechaEntrega'
SELECT @EmbarqueEstado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='EmbarqueEstado'
SELECT @EmbarqueGastos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='EmbarqueGastos'
SELECT @Peso = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Peso'
SELECT @Volumen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Volumen'
SELECT @Causa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Causa'
SELECT @Atencion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Atencion'
SELECT @AtencionTelefono = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AtencionTelefono'
SELECT @ListaPreciosEsp = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ListaPreciosEsp'
SELECT @ZonaImpuesto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ZonaImpuesto'
SELECT @Extra = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Extra'
SELECT @CancelacionID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='CancelacionID'
SELECT @Mensaje = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Mensaje'
SELECT @Departamento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Departamento'
SELECT @Sucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Sucursal'
SELECT @GenerarOP = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='GenerarOP'
SELECT @DesglosarImpuestos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='DesglosarImpuestos'
SELECT @DesglosarImpuesto2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='DesglosarImpuesto2'
SELECT @ExcluirPlaneacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ExcluirPlaneacion'
SELECT @ConVigencia = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ConVigencia'
SELECT @VigenciaDesde = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='VigenciaDesde'
SELECT @VigenciaHasta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='VigenciaHasta'
SELECT @Enganche = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Enganche'
SELECT @Bonificacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Bonificacion'
SELECT @IVAFiscal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='IVAFiscal'
SELECT @IEPSFiscal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='IEPSFiscal'
SELECT @EstaImpreso = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='EstaImpreso'
SELECT @Periodicidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Periodicidad'
SELECT @SubModulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='SubModulo'
SELECT @ContUso = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ContUso'
SELECT @Espacio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Espacio'
SELECT @AutoCorrida = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AutoCorrida'
SELECT @AutoCorridaHora = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AutoCorridaHora'
SELECT @AutoCorridaServicio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AutoCorridaServicio'
SELECT @AutoCorridaRol = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AutoCorridaRol'
SELECT @AutoCorridaOrigen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AutoCorridaOrigen'
SELECT @AutoCorridaDestino = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AutoCorridaDestino'
SELECT @AutoCorridaKms = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AutoCorridaKms'
SELECT @AutoCorridaLts = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AutoCorridaLts'
SELECT @AutoCorridaRuta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AutoCorridaRuta'
SELECT @AutoOperador2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')     WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo ='AutoOperador2'
SELECT @AutoBoleto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AutoBoleto'
SELECT @AutoKms = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AutoKms'
SELECT @AutoKmsActuales = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AutoKmsActuales'
SELECT @AutoBomba = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AutoBomba'
SELECT @AutoBombaContador = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AutoBombaContador'
SELECT @Logico1 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Logico1'
SELECT @Logico2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Logico2'
SELECT @Logico3 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Logico3'
SELECT @Logico4 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Logico4'
SELECT @DifCredito = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='DifCredito'
SELECT @EspacioResultado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='EspacioResultado'
SELECT @Clase = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Clase'
SELECT @Subclase = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Subclase'
SELECT @GastoAcreedor = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='GastoAcreedor'
SELECT @GastoConcepto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='GastoConcepto'
SELECT @Pagado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Pagado'
SELECT @GenerarDinero = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='GenerarDinero'
SELECT @Dinero = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Dinero'
SELECT @DineroID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='DineroID'
SELECT @DineroCtaDinero = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='DineroCtaDinero'
SELECT @DineroConciliado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='DineroConciliado'
SELECT @DineroFechaConciliacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='DineroFechaConciliacion'
SELECT @Extra1 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Extra1'
SELECT @Extra2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Extra2'
SELECT @Extra3 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Extra3'
SELECT @Reabastecido = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Reabastecido'
SELECT @SucursalVenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='SucursalVenta'
SELECT @AF = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AF'
SELECT @AFArticulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AFArticulo'
SELECT @AFSerie = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AFSerie'
SELECT @ContratoTipo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ContratoTipo'
SELECT @ContratoDescripcion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ContratoDescripcion'
SELECT @ContratoSerie = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ContratoSerie'
SELECT @ContratoValor = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ContratoValor'
SELECT @ContratoValorMoneda = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ContratoValorMoneda'
SELECT @ContratoSeguro = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ContratoSeguro'
SELECT @ContratoVencimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ContratoVencimiento'
SELECT @Incentivo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Incentivo'
SELECT @IncentivoConcepto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='IncentivoConcepto'
SELECT @EndosarA = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='EndosarA'
SELECT @InteresTasa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='InteresTasa'
SELECT @InteresIVA = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='InteresIVA'
SELECT @AnexoID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AnexoID'
SELECT @FordVisitoOASIS = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='FordVisitoOASIS'
SELECT @LineaCredito = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='LineaCredito'
SELECT @TipoAmortizacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='TipoAmortizacion'
SELECT @TipoTasa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='TipoTasa'
SELECT @Comisiones = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Comisiones'
SELECT @ComisionesIVA = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ComisionesIVA'
SELECT @CompraID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='CompraID'
SELECT @OperacionRelevante = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='OperacionRelevante'
SELECT @TieneTasaEsp = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='TieneTasaEsp'
SELECT @TasaEsp = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='TasaEsp'
SELECT @FormaPagoTipo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='FormaPagoTipo'
SELECT @SobrePrecio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='SobrePrecio'
SELECT @SincroC = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='SincroC'
SELECT @SucursalOrigen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='SucursalOrigen'
SELECT @SucursalDestino = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='SucursalDestino'
SELECT @ContUso2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ContUso2'
SELECT @ContUso3 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ContUso3'
SELECT @Actividad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Actividad'
SELECT @ContratoID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ContratoID'
SELECT @ContratoMov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ContratoMov'
SELECT @ContratoMovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='ContratoMovID'
SELECT @MAFCiclo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='MAFCiclo'
SELECT @TipoComprobante = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='TipoComprobante'
SELECT @SustentoComprobante = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='SustentoComprobante'
SELECT @TipoIdentificacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='TipoIdentificacion'
SELECT @DerechoDevolucion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='DerechoDevolucion'
SELECT @Establecimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Establecimiento'
SELECT @PuntoEmision = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='PuntoEmision'
SELECT @SecuencialSRI = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='SecuencialSRI'
SELECT @AutorizacionSRI = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='AutorizacionSRI'
SELECT @VigenteA = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='VigenteA'
SELECT @SecuenciaRetencion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='SecuenciaRetencion'
SELECT @Comprobante = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='Comprobante'
SELECT @FechaContableMov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo ='FechaContableMov'
SELECT @Texto =(SELECT * FROM Venta
WITH(NOLOCK) WHERE ISNULL(ID,'') = ISNULL(ISNULL(@IDO,ID),'')
AND ISNULL(Empresa,'') = ISNULL(ISNULL(@Empresa,Empresa),'')
AND ISNULL(Mov,'') = ISNULL(ISNULL(@Mov,Mov),'')
AND ISNULL(MovID,'') = ISNULL(ISNULL(@MovID,MovID),'')
AND ISNULL(FechaEmision,'') = ISNULL(ISNULL(@FechaEmision,FechaEmision),'')
AND ISNULL(UltimoCambio,'') = ISNULL(ISNULL(@UltimoCambio,UltimoCambio),'')
AND ISNULL(Concepto,'') = ISNULL(ISNULL(@Concepto,Concepto),'')
AND ISNULL(Proyecto,'') = ISNULL(ISNULL(@Proyecto,Proyecto),'')
AND ISNULL(UEN,'') = ISNULL(ISNULL(@UEN,UEN),'')
AND ISNULL(Moneda,'') = ISNULL(ISNULL(@Moneda,Moneda),'')
AND ISNULL(TipoCambio,'') = ISNULL(ISNULL(@TipoCambio,TipoCambio),'')
AND ISNULL(Usuario,'') = ISNULL(ISNULL(@Usuario,Usuario),'')
AND ISNULL(Autorizacion,'') = ISNULL(ISNULL(@Autorizacion,Autorizacion),'')
AND ISNULL(Referencia,'') = ISNULL(ISNULL(@Referencia,Referencia),'')
AND ISNULL(DocFuente,'') = ISNULL(ISNULL(@DocFuente,DocFuente),'')
AND ISNULL(Observaciones,'') = ISNULL(ISNULL(@Observaciones,Observaciones),'')
AND ISNULL(Estatus,'') = ISNULL(ISNULL(@Estatus,Estatus),'')
AND ISNULL(Situacion,'') = ISNULL(ISNULL(@Situacion,Situacion),'')
AND ISNULL(SituacionFecha,'') = ISNULL(ISNULL(@SituacionFecha,SituacionFecha),'')
AND ISNULL(SituacionUsuario,'') = ISNULL(ISNULL(@SituacionUsuario,SituacionUsuario),'')
AND ISNULL(SituacionNota,'') = ISNULL(ISNULL(@SituacionNota,SituacionNota),'')
AND ISNULL(Directo,'') = ISNULL(ISNULL(@Directo,Directo),'')
AND ISNULL(Prioridad,'') = ISNULL(ISNULL(@Prioridad,Prioridad),'')
AND ISNULL(RenglonID,'') = ISNULL(ISNULL(@RenglonID,RenglonID),'')
AND ISNULL(FechaOriginal,'') = ISNULL(ISNULL(@FechaOriginal,FechaOriginal),'')
AND ISNULL(Codigo,'') = ISNULL(ISNULL(@Codigo,Codigo),'')
AND ISNULL(Cliente,'') = ISNULL(ISNULL(@Cliente,Cliente),'')
AND ISNULL(EnviarA,'') = ISNULL(ISNULL(@EnviarA,EnviarA),'')
AND ISNULL(Almacen,'') = ISNULL(ISNULL(@Almacen,Almacen),'')
AND ISNULL(AlmacenDestino,'') = ISNULL(ISNULL(@AlmacenDestino,AlmacenDestino),'')
AND ISNULL(Agente,'') = ISNULL(ISNULL(@Agente,Agente),'')
AND ISNULL(AgenteServicio,'') = ISNULL(ISNULL(@AgenteServicio,AgenteServicio),'')
AND ISNULL(AgenteComision,'') = ISNULL(ISNULL(@AgenteComision,AgenteComision),'')
AND ISNULL(FormaEnvio,'') = ISNULL(ISNULL(@FormaEnvio,FormaEnvio),'')
AND ISNULL(FechaRequerida,'') = ISNULL(ISNULL(@FechaRequerida,FechaRequerida),'')
AND ISNULL(HoraRequerida,'') = ISNULL(ISNULL(@HoraRequerida,HoraRequerida),'')
AND ISNULL(FechaProgramadaEnvio,'') = ISNULL(ISNULL(@FechaProgramadaEnvio,FechaProgramadaEnvio),'')
AND ISNULL(FechaOrdenCompra,'') = ISNULL(ISNULL(@FechaOrdenCompra,FechaOrdenCompra),'')
AND ISNULL(ReferenciaOrdenCompra,'') = ISNULL(ISNULL(@ReferenciaOrdenCompra,ReferenciaOrdenCompra),'')
AND ISNULL(OrdenCompra,'') = ISNULL(ISNULL(@OrdenCompra,OrdenCompra),'')
AND ISNULL(Condicion,'') = ISNULL(ISNULL(@Condicion,Condicion),'')
AND ISNULL(Vencimiento,'') = ISNULL(ISNULL(@Vencimiento,Vencimiento),'')
AND ISNULL(CtaDinero,'') = ISNULL(ISNULL(@CtaDinero,CtaDinero),'')
AND ISNULL(Descuento,'') = ISNULL(ISNULL(@Descuento,Descuento),'')
AND ISNULL(DescuentoGlobal,'') = ISNULL(ISNULL(@DescuentoGlobal,DescuentoGlobal),'')
AND ISNULL(Importe,'') = ISNULL(ISNULL(@Importe,Importe),'')
AND ISNULL(Impuestos,'') = ISNULL(ISNULL(@Impuestos,Impuestos),'')
AND ISNULL(Saldo,'') = ISNULL(ISNULL(@Saldo,Saldo),'')
AND ISNULL(AnticiposFacturados,'') = ISNULL(ISNULL(@AnticiposFacturados,AnticiposFacturados),'')
AND ISNULL(AnticiposImpuestos,'') = ISNULL(ISNULL(@AnticiposImpuestos,AnticiposImpuestos),'')
AND ISNULL(Retencion,'') = ISNULL(ISNULL(@Retencion,Retencion),'')
AND ISNULL(DescuentoLineal,'') = ISNULL(ISNULL(@DescuentoLineal,DescuentoLineal),'')
AND ISNULL(ComisionTotal,'') = ISNULL(ISNULL(@ComisionTotal,ComisionTotal),'')
AND ISNULL(CostoTotal,'') = ISNULL(ISNULL(@CostoTotal,CostoTotal),'')
AND ISNULL(PrecioTotal,'') = ISNULL(ISNULL(@PrecioTotal,PrecioTotal),'')
AND ISNULL(Paquetes,'') = ISNULL(ISNULL(@Paquetes,Paquetes),'')
AND ISNULL(ServicioTipo,'') = ISNULL(ISNULL(@ServicioTipo,ServicioTipo),'')
AND ISNULL(ServicioArticulo,'') = ISNULL(ISNULL(@ServicioArticulo,ServicioArticulo),'')
AND ISNULL(ServicioSerie,'') = ISNULL(ISNULL(@ServicioSerie,ServicioSerie),'')
AND ISNULL(ServicioContrato,'') = ISNULL(ISNULL(@ServicioContrato,ServicioContrato),'')
AND ISNULL(ServicioContratoID,'') = ISNULL(ISNULL(@ServicioContratoID,ServicioContratoID),'')
AND ISNULL(ServicioContratoTipo,'') = ISNULL(ISNULL(@ServicioContratoTipo,ServicioContratoTipo),'')
AND ISNULL(ServicioGarantia,'') = ISNULL(ISNULL(@ServicioGarantia,ServicioGarantia),'')
AND ISNULL(ServicioDescripcion,'') = ISNULL(ISNULL(@ServicioDescripcion,ServicioDescripcion),'')
AND ISNULL(ServicioFecha,'') = ISNULL(ISNULL(@ServicioFecha,ServicioFecha),'')
AND ISNULL(ServicioFlotilla,'') = ISNULL(ISNULL(@ServicioFlotilla,ServicioFlotilla),'')
AND ISNULL(ServicioRampa,'') = ISNULL(ISNULL(@ServicioRampa,ServicioRampa),'')
AND ISNULL(ServicioIdentificador,'') = ISNULL(ISNULL(@ServicioIdentificador,ServicioIdentificador),'')
AND ISNULL(ServicioPlacas,'') = ISNULL(ISNULL(@ServicioPlacas,ServicioPlacas),'')
AND ISNULL(ServicioKms,'') = ISNULL(ISNULL(@ServicioKms,ServicioKms),'')
AND ISNULL(ServicioTipoOrden,'') = ISNULL(ISNULL(@ServicioTipoOrden,ServicioTipoOrden),'')
AND ISNULL(ServicioTipoOperacion,'') = ISNULL(ISNULL(@ServicioTipoOperacion,ServicioTipoOperacion),'')
AND ISNULL(ServicioSiniestro,'') = ISNULL(ISNULL(@ServicioSiniestro,ServicioSiniestro),'')
AND ISNULL(ServicioExpress,'') = ISNULL(ISNULL(@ServicioExpress,ServicioExpress),'')
AND ISNULL(ServicioDemerito,'') = ISNULL(ISNULL(@ServicioDemerito,ServicioDemerito),'')
AND ISNULL(ServicioDeducible,'') = ISNULL(ISNULL(@ServicioDeducible,ServicioDeducible),'')
AND ISNULL(ServicioDeducibleImporte,'') = ISNULL(ISNULL(@ServicioDeducibleImporte,ServicioDeducibleImporte),'')
AND ISNULL(ServicioNumero,'') = ISNULL(ISNULL(@ServicioNumero,ServicioNumero),'')
AND ISNULL(ServicioNumeroEconomico,'') = ISNULL(ISNULL(@ServicioNumeroEconomico,ServicioNumeroEconomico),'')
AND ISNULL(ServicioAseguradora,'') = ISNULL(ISNULL(@ServicioAseguradora,ServicioAseguradora),'')
AND ISNULL(ServicioPuntual,'') = ISNULL(ISNULL(@ServicioPuntual,ServicioPuntual),'')
AND ISNULL(ServicioPoliza,'') = ISNULL(ISNULL(@ServicioPoliza,ServicioPoliza),'')
AND ISNULL(OrigenTipo,'') = ISNULL(ISNULL(@OrigenTipo,OrigenTipo),'')
AND ISNULL(Origen,'') = ISNULL(ISNULL(@Origen,Origen),'')
AND ISNULL(OrigenID,'') = ISNULL(ISNULL(@OrigenID,OrigenID),'')
AND ISNULL(Poliza,'') = ISNULL(ISNULL(@Poliza,Poliza),'')
AND ISNULL(PolizaID,'') = ISNULL(ISNULL(@PolizaID,PolizaID),'')
AND ISNULL(GenerarPoliza,'') = ISNULL(ISNULL(@GenerarPoliza,GenerarPoliza),'')
AND ISNULL(ContID,'') = ISNULL(ISNULL(@ContID,ContID),'')
AND ISNULL(Ejercicio,'') = ISNULL(ISNULL(@Ejercicio,Ejercicio),'')
AND ISNULL(Periodo,'') = ISNULL(ISNULL(@Periodo,Periodo),'')
AND ISNULL(FechaRegistro,'') = ISNULL(ISNULL(@FechaRegistro,FechaRegistro),'')
AND ISNULL(FechaConclusion,'') = ISNULL(ISNULL(@FechaConclusion,FechaConclusion),'')
AND ISNULL(FechaCancelacion,'') = ISNULL(ISNULL(@FechaCancelacion,FechaCancelacion),'')
AND ISNULL(FechaEntrega,'') = ISNULL(ISNULL(@FechaEntrega,FechaEntrega),'')
AND ISNULL(EmbarqueEstado,'') = ISNULL(ISNULL(@EmbarqueEstado,EmbarqueEstado),'')
AND ISNULL(EmbarqueGastos,'') = ISNULL(ISNULL(@EmbarqueGastos,EmbarqueGastos),'')
AND ISNULL(Peso,'') = ISNULL(ISNULL(@Peso,Peso),'')
AND ISNULL(Volumen,'') = ISNULL(ISNULL(@Volumen,Volumen),'')
AND ISNULL(Causa,'') = ISNULL(ISNULL(@Causa,Causa),'')
AND ISNULL(Atencion,'') = ISNULL(ISNULL(@Atencion,Atencion),'')
AND ISNULL(AtencionTelefono,'') = ISNULL(ISNULL(@AtencionTelefono,AtencionTelefono),'')
AND ISNULL(ListaPreciosEsp,'') = ISNULL(ISNULL(@ListaPreciosEsp,ListaPreciosEsp),'')
AND ISNULL(ZonaImpuesto,'') = ISNULL(ISNULL(@ZonaImpuesto,ZonaImpuesto),'')
AND ISNULL(Extra,'') = ISNULL(ISNULL(@Extra,Extra),'')
AND ISNULL(CancelacionID,'') = ISNULL(ISNULL(@CancelacionID,CancelacionID),'')
AND ISNULL(Mensaje,'') = ISNULL(ISNULL(@Mensaje,Mensaje),'')
AND ISNULL(Departamento,'') = ISNULL(ISNULL(@Departamento,Departamento),'')
AND ISNULL(Sucursal,'') = ISNULL(ISNULL(@Sucursal,Sucursal),'')
AND ISNULL(GenerarOP,'') = ISNULL(ISNULL(@GenerarOP,GenerarOP),'')
AND ISNULL(DesglosarImpuestos,'') = ISNULL(ISNULL(@DesglosarImpuestos,DesglosarImpuestos),'')
AND ISNULL(DesglosarImpuesto2,'') = ISNULL(ISNULL(@DesglosarImpuesto2,DesglosarImpuesto2),'')
AND ISNULL(ExcluirPlaneacion,'') = ISNULL(ISNULL(@ExcluirPlaneacion,ExcluirPlaneacion),'')
AND ISNULL(ConVigencia,'') = ISNULL(ISNULL(@ConVigencia,ConVigencia),'')
AND ISNULL(VigenciaDesde,'') = ISNULL(ISNULL(@VigenciaDesde,VigenciaDesde),'')
AND ISNULL(VigenciaHasta,'') = ISNULL(ISNULL(@VigenciaHasta,VigenciaHasta),'')
AND ISNULL(Enganche,'') = ISNULL(ISNULL(@Enganche,Enganche),'')
AND ISNULL(Bonificacion,'') = ISNULL(ISNULL(@Bonificacion,Bonificacion),'')
AND ISNULL(IVAFiscal,'') = ISNULL(ISNULL(@IVAFiscal,IVAFiscal),'')
AND ISNULL(IEPSFiscal,'') = ISNULL(ISNULL(@IEPSFiscal,IEPSFiscal),'')
AND ISNULL(EstaImpreso,'') = ISNULL(ISNULL(@EstaImpreso,EstaImpreso),'')
AND ISNULL(Periodicidad,'') = ISNULL(ISNULL(@Periodicidad,Periodicidad),'')
AND ISNULL(SubModulo,'') = ISNULL(ISNULL(@SubModulo,SubModulo),'')
AND ISNULL(ContUso,'') = ISNULL(ISNULL(@ContUso,ContUso),'')
AND ISNULL(Espacio,'') = ISNULL(ISNULL(@Espacio,Espacio),'')
AND ISNULL(AutoCorrida,'') = ISNULL(ISNULL(@AutoCorrida,AutoCorrida),'')
AND ISNULL(AutoCorridaHora,'') = ISNULL(ISNULL(@AutoCorridaHora,AutoCorridaHora),'')
AND ISNULL(AutoCorridaServicio,'') = ISNULL(ISNULL(@AutoCorridaServicio,AutoCorridaServicio),'')
AND ISNULL(AutoCorridaRol,'') = ISNULL(ISNULL(@AutoCorridaRol,AutoCorridaRol),'')
AND ISNULL(AutoCorridaOrigen,'') = ISNULL(ISNULL(@AutoCorridaOrigen,AutoCorridaOrigen),'')
AND ISNULL(AutoCorridaDestino,'') = ISNULL(ISNULL(@AutoCorridaDestino,AutoCorridaDestino),'')
AND ISNULL(AutoCorridaKms,'') = ISNULL(ISNULL(@AutoCorridaKms,AutoCorridaKms),'')
AND ISNULL(AutoCorridaLts,'') = ISNULL(ISNULL(@AutoCorridaLts,AutoCorridaLts),'')
AND ISNULL(AutoCorridaRuta,'') = ISNULL(ISNULL(@AutoCorridaRuta,AutoCorridaRuta),'')
AND ISNULL(AutoOperador2,'') = ISNULL(ISNULL(@AutoOperador2,AutoOperador2),'')
AND ISNULL(AutoBoleto,'') = ISNULL(ISNULL(@AutoBoleto,AutoBoleto),'')
AND ISNULL(AutoKms,'') = ISNULL(ISNULL(@AutoKms,AutoKms),'')
AND ISNULL(AutoKmsActuales,'') = ISNULL(ISNULL(@AutoKmsActuales,AutoKmsActuales),'')
AND ISNULL(AutoBomba,'') = ISNULL(ISNULL(@AutoBomba,AutoBomba),'')
AND ISNULL(AutoBombaContador,'') = ISNULL(ISNULL(@AutoBombaContador,AutoBombaContador),'')
AND ISNULL(Logico1,'') = ISNULL(ISNULL(@Logico1,Logico1),'')
AND ISNULL(Logico2,'') = ISNULL(ISNULL(@Logico2,Logico2),'')
AND ISNULL(Logico3,'') = ISNULL(ISNULL(@Logico3,Logico3),'')
AND ISNULL(Logico4,'') = ISNULL(ISNULL(@Logico4,Logico4),'')
AND ISNULL(DifCredito,'') = ISNULL(ISNULL(@DifCredito,DifCredito),'')
AND ISNULL(EspacioResultado,'') = ISNULL(ISNULL(@EspacioResultado,EspacioResultado),'')
AND ISNULL(Clase,'') = ISNULL(ISNULL(@Clase,Clase),'')
AND ISNULL(Subclase,'') = ISNULL(ISNULL(@Subclase,Subclase),'')
AND ISNULL(GastoAcreedor,'') = ISNULL(ISNULL(@GastoAcreedor,GastoAcreedor),'')
AND ISNULL(GastoConcepto,'') = ISNULL(ISNULL(@GastoConcepto,GastoConcepto),'')
AND ISNULL(Pagado,'') = ISNULL(ISNULL(@Pagado,Pagado),'')
AND ISNULL(GenerarDinero,'') = ISNULL(ISNULL(@GenerarDinero,GenerarDinero),'')
AND ISNULL(Dinero,'') = ISNULL(ISNULL(@Dinero,Dinero),'')
AND ISNULL(DineroID,'') = ISNULL(ISNULL(@DineroID,DineroID),'')
AND ISNULL(DineroCtaDinero,'') = ISNULL(ISNULL(@DineroCtaDinero,DineroCtaDinero),'')
AND ISNULL(DineroConciliado,'') = ISNULL(ISNULL(@DineroConciliado,DineroConciliado),'')
AND ISNULL(DineroFechaConciliacion,'') = ISNULL(ISNULL(@DineroFechaConciliacion,DineroFechaConciliacion),'')
AND ISNULL(Extra1,'') = ISNULL(ISNULL(@Extra1,Extra1),'')
AND ISNULL(Extra2,'') = ISNULL(ISNULL(@Extra2,Extra2),'')
AND ISNULL(Extra3,'') = ISNULL(ISNULL(@Extra3,Extra3),'')
AND ISNULL(Reabastecido,'') = ISNULL(ISNULL(@Reabastecido,Reabastecido),'')
AND ISNULL(SucursalVenta,'') = ISNULL(ISNULL(@SucursalVenta,SucursalVenta),'')
AND ISNULL(AF,'') = ISNULL(ISNULL(@AF,AF),'')
AND ISNULL(AFArticulo,'') = ISNULL(ISNULL(@AFArticulo,AFArticulo),'')
AND ISNULL(AFSerie,'') = ISNULL(ISNULL(@AFSerie,AFSerie),'')
AND ISNULL(ContratoTipo,'') = ISNULL(ISNULL(@ContratoTipo,ContratoTipo),'')
AND ISNULL(ContratoDescripcion,'') = ISNULL(ISNULL(@ContratoDescripcion,ContratoDescripcion),'')
AND ISNULL(ContratoSerie,'') = ISNULL(ISNULL(@ContratoSerie,ContratoSerie),'')
AND ISNULL(ContratoValor,'') = ISNULL(ISNULL(@ContratoValor,ContratoValor),'')
AND ISNULL(ContratoValorMoneda,'') = ISNULL(ISNULL(@ContratoValorMoneda,ContratoValorMoneda),'')
AND ISNULL(ContratoSeguro,'') = ISNULL(ISNULL(@ContratoSeguro,ContratoSeguro),'')
AND ISNULL(ContratoVencimiento,'') = ISNULL(ISNULL(@ContratoVencimiento,ContratoVencimiento),'')
AND ISNULL(Incentivo,'') = ISNULL(ISNULL(@Incentivo,Incentivo),'')
AND ISNULL(IncentivoConcepto,'') = ISNULL(ISNULL(@IncentivoConcepto,IncentivoConcepto),'')
AND ISNULL(EndosarA,'') = ISNULL(ISNULL(@EndosarA,EndosarA),'')
AND ISNULL(InteresTasa,'') = ISNULL(ISNULL(@InteresTasa,InteresTasa),'')
AND ISNULL(InteresIVA,'') = ISNULL(ISNULL(@InteresIVA,InteresIVA),'')
AND ISNULL(AnexoID,'') = ISNULL(ISNULL(@AnexoID,AnexoID),'')
AND ISNULL(FordVisitoOASIS,'') = ISNULL(ISNULL(@FordVisitoOASIS,FordVisitoOASIS),'')
AND ISNULL(LineaCredito,'') = ISNULL(ISNULL(@LineaCredito,LineaCredito),'')
AND ISNULL(TipoAmortizacion,'') = ISNULL(ISNULL(@TipoAmortizacion,TipoAmortizacion),'')
AND ISNULL(TipoTasa,'') = ISNULL(ISNULL(@TipoTasa,TipoTasa),'')
AND ISNULL(Comisiones,'') = ISNULL(ISNULL(@Comisiones,Comisiones),'')
AND ISNULL(ComisionesIVA,'') = ISNULL(ISNULL(@ComisionesIVA,ComisionesIVA),'')
AND ISNULL(CompraID,'') = ISNULL(ISNULL(@CompraID,CompraID),'')
AND ISNULL(OperacionRelevante,'') = ISNULL(ISNULL(@OperacionRelevante,OperacionRelevante),'')
AND ISNULL(TieneTasaEsp,'') = ISNULL(ISNULL(@TieneTasaEsp,TieneTasaEsp),'')
AND ISNULL(TasaEsp,'') = ISNULL(ISNULL(@TasaEsp,TasaEsp),'')
AND ISNULL(FormaPagoTipo,'') = ISNULL(ISNULL(@FormaPagoTipo,FormaPagoTipo),'')
AND ISNULL(SobrePrecio,'') = ISNULL(ISNULL(@SobrePrecio,SobrePrecio),'')
AND ISNULL(SincroC,'') = ISNULL(ISNULL(@SincroC,SincroC),'')
AND ISNULL(SucursalOrigen,'') = ISNULL(ISNULL(@SucursalOrigen,SucursalOrigen),'')
AND ISNULL(SucursalDestino,'') = ISNULL(ISNULL(@SucursalDestino,SucursalDestino),'')
AND ISNULL(ContUso2,'') = ISNULL(ISNULL(@ContUso2,ContUso2),'')
AND ISNULL(ContUso3,'') = ISNULL(ISNULL(@ContUso3,ContUso3),'')
AND ISNULL(Actividad,'') = ISNULL(ISNULL(@Actividad,Actividad),'')
AND ISNULL(ContratoID,'') = ISNULL(ISNULL(@ContratoID,ContratoID),'')
AND ISNULL(ContratoMov,'') = ISNULL(ISNULL(@ContratoMov,ContratoMov),'')
AND ISNULL(ContratoMovID,'') = ISNULL(ISNULL(@ContratoMovID,ContratoMovID),'')
AND ISNULL(MAFCiclo,'') = ISNULL(ISNULL(@MAFCiclo,MAFCiclo),'')
AND ISNULL(TipoComprobante,'') = ISNULL(ISNULL(@TipoComprobante,TipoComprobante),'')
AND ISNULL(SustentoComprobante,'') = ISNULL(ISNULL(@SustentoComprobante,SustentoComprobante),'')
AND ISNULL(TipoIdentificacion,'') = ISNULL(ISNULL(@TipoIdentificacion,TipoIdentificacion),'')
AND ISNULL(DerechoDevolucion,'') = ISNULL(ISNULL(@DerechoDevolucion,DerechoDevolucion),'')
AND ISNULL(Establecimiento,'') = ISNULL(ISNULL(@Establecimiento,Establecimiento),'')
AND ISNULL(PuntoEmision,'') = ISNULL(ISNULL(@PuntoEmision,PuntoEmision),'')
AND ISNULL(SecuencialSRI,'') = ISNULL(ISNULL(@SecuencialSRI,SecuencialSRI),'')
AND ISNULL(AutorizacionSRI,'') = ISNULL(ISNULL(@AutorizacionSRI,AutorizacionSRI),'')
AND ISNULL(VigenteA,'') = ISNULL(ISNULL(@VigenteA,VigenteA),'')
AND ISNULL(SecuenciaRetencion,'') = ISNULL(ISNULL(@SecuenciaRetencion,SecuenciaRetencion),'')
AND ISNULL(Comprobante,'') = ISNULL(ISNULL(@Comprobante,Comprobante),'')
AND ISNULL(FechaContableMov,'') = ISNULL(ISNULL(@FechaContableMov,FechaContableMov),'')
FOR XML AUTO)
SELECT @Texto2 =(SELECT * FROM VentaD
WITH(NOLOCK) WHERE ID = @IDO
FOR XML AUTO)
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @ID
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),@Texto) + CONVERT(varchar(max),@Texto2)+'</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
END
END

