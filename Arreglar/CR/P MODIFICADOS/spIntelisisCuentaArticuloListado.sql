SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisCuentaArticuloListado
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Articulo					varchar	(20),
@Rama						varchar	(20),
@Descripcion1				varchar	(100),
@Descripcion2				varchar	(255),
@NombreCorto				varchar	(20),
@Grupo						varchar	(50),
@Categoria					varchar	(50),
@CategoriaActivoFijo		varchar	(50),
@Familia					varchar	(50),
@Linea						varchar	(50),
@Fabricante					varchar	(50),
@ClaveFabricante			varchar	(50),
@Impuesto1					float,
@Impuesto2					float,
@Impuesto3					float,
@Factor						varchar	(50),
@Unidad						varchar	(50),
@UnidadCompra				varchar	(50),
@UnidadTraspaso				varchar	(50),
@UnidadCantidad				float,
@TipoCosteo					varchar	(10),
@Peso						float,
@Tara						float,
@Volumen					float,
@Tipo						varchar	(20),
@TipoOpcion					varchar	(20),
@Accesorios					bit,
@Refacciones				bit,
@Sustitutos					bit,
@Servicios					bit,
@Consumibles				bit,
@MonedaCosto				varchar	(10),
@MonedaPrecio				varchar	(10),
@MargenMinimo				money,
@PrecioLista				money,
@PrecioMinimo				money,
@FactorAlterno				float,
@PrecioAnterior				money,
@Utilidad					varchar	(50),
@DescuentoCompra			float,
@Clase						varchar	(15),
@Estatus					varchar	(15),
@UltimoCambio				datetime,
@Alta						datetime,
@Conciliar					bit,
@Mensaje					varchar	(50),
@Comision					varchar	(50),
@Arancel					varchar	(50),
@ArancelDesperdicio			varchar	(50),
@ABC						varchar	(1),
@Usuario					varchar	(10),
@Precio2					money,
@Precio3					money,
@Precio4					money,
@Precio5					money,
@Precio6					money,
@Precio7					money,
@Precio8					money,
@Precio9					money,
@Precio10					money,
@Refrigeracion				bit,
@TieneCaducidad				bit,
@BasculaPesar				bit,
@SeProduce					bit,
@Situacion					varchar	(50),
@SituacionFecha				datetime,
@SituacionUsuario			varchar	(10),
@SituacionNota				varchar	(100),
@EstatusPrecio				varchar	(15),
@wMostrar					bit,
@Merma						float,
@Desperdicio				float,
@SeCompra					bit,
@SeVende					bit,
@EsFormula					bit,
@TiempoEntrega				int,
@TiempoEntregaUnidad		varchar	(10),
@TiempoEntregaSeg			int,
@TiempoEntregaSegUnidad		varchar	(10),
@LoteOrdenar				varchar	(30),
@CantidadOrdenar			float,
@MultiplosOrdenar			float,
@InvSeguridad				float,
@ProdRuta					varchar	(20),
@AlmacenROP					varchar	(10),
@CategoriaProd				varchar	(50),
@ProdCantidad				float,
@ProdUsuario				varchar	(10),
@ProdPasoTotal				int,
@ProdMovGrupo				varchar	(50),
@ProdEstacion				varchar	(10),
@ProdOpciones				bit,
@ProdVerConcentracion		bit,
@ProdVerCostoAcumulado		bit,
@ProdVerMerma				bit,
@ProdVerDesperdicio			bit,
@ProdVerPorcentaje			bit,
@RevisionUltima				datetime,
@RevisionUsuario			varchar	(10),
@RevisionFrecuencia			int,
@RevisionFrecuenciaUnidad	varchar	(10),
@RevisionSiguiente			datetime,
@ProdMov					varchar	(20),
@TipoCompra					varchar	(20),
@TieneMovimientos			bit,
@Registro1					varchar	(20),
@Registro1Vencimiento		datetime,
@AlmacenEspecificoVenta		varchar	(10),
@AlmacenEspecificoVentaMov	varchar	(20),
@RutaDistribucion			varchar	(50),
@CostoEstandar				float,
@CostoReposicion			float,
@EstatusCosto				varchar	(15),
@Margen						money,
@Proveedor					varchar	(10),
@NivelAcceso				varchar	(50),
@Temporada					varchar	(50),
@SolicitarPrecios			bit,
@AutoRecaudacion			varchar	(30),
@Concepto					varchar	(50),
@Cuenta						varchar	(20),
@Retencion1					float,
@Retencion2					float,
@Retencion3					float,
@Espacios					bit,
@EspaciosEspecificos		bit,
@EspaciosSobreventa			float,
@EspaciosNivel				varchar	(50),
@EspaciosMinutos			int,
@EspaciosBloquearAnteriores	bit,
@EspaciosHoraD				varchar	(5),
@EspaciosHoraA				varchar	(5),
@SerieLoteInfo				bit,
@CantidadMinimaVenta		float,
@CantidadMaximaVenta		float,
@EstimuloFiscal				float,
@OrigenPais					varchar	(50),
@OrigenLocalidad			varchar	(50),
@Incentivo					money,
@FactorCompra				float,
@Horas						float,
@ISAN						bit,
@ExcluirDescFormaPago		bit,
@EsDeducible				bit,
@Peaje						money,
@CodigoAlterno				varchar	(50),
@TipoCatalogo				varchar	(20),
@AnexosAlFacturar			bit,
@CaducidadMinima			int,
@Actividades				bit,
@ValidarPresupuestoCompra	varchar	(20),
@SeriesLotesAutoOrden		varchar	(20),
@LotesFijos					bit,
@LotesAuto					bit,
@Consecutivo				int,
@TipoEmpaque				varchar	(50),
@Modelo						varchar	(4),
@ArtVersion					varchar	(50),
@TieneDireccion				bit,
@Direccion					varchar	(100),
@DireccionNumero			varchar	(20),
@DireccionNumeroInt			varchar	(20),
@EntreCalles				varchar	(100),
@Plano						varchar	(15),
@Observaciones				varchar	(100),
@Colonia					varchar	(100),
@Delegacion					varchar	(100),
@Poblacion					varchar	(100),
@Estado						varchar	(30),
@Pais						varchar	(30),
@CodigoPostal				varchar	(15),
@Ruta						varchar	(50),
@Codigo						varchar	(50),
@ClaveVehicular				varchar	(20),
@TipoVehiculo				varchar	(20),
@DiasLibresIntereses		int,
@PrecioLiberado				bit,
@ValidarCodigo				bit,
@Presentacion				varchar	(50),
@GarantiaPlazo				int,
@CostoIdentificado			bit,
@CantidadTarima				float,
@UnidadTarima				varchar	(50),
@MinimoTarima				float,
@DepartamentoDetallista		int,
@TratadoComercial			varchar	(50),
@CuentaPresupuesto			varchar	(20),
@ProgramaSectorial			varchar	(50),
@PedimentoClave				varchar	(5),
@PedimentoRegimen			varchar	(5),
@Permiso					varchar	(20),
@PermisoRenglon				varchar	(20),
@Cuenta2					varchar	(20),
@Cuenta3					varchar	(20),
@Impuesto1Excento			bit,
@CalcularPresupuesto		bit,
@InflacionPresupuesto		float,
@Excento2					bit,
@Excento3					bit,
@ContUso					varchar	(20),
@ContUso2					varchar	(20),
@ContUso3					varchar	(20),
@NivelToleranciaCosto		varchar	(10),
@ToleranciaCosto			money,
@ToleranciaCostoInferior	money,
@ObjetoGasto				varchar	(10),
@ObjetoGastoRef				varchar	(10),
@ClavePresupuestalImpuesto1	varchar	(50),
@Estructura					varchar	(50),
@TipoImpuesto1				varchar	(10),
@TipoImpuesto2				varchar	(10),
@TipoImpuesto3				varchar	(10),
@TipoRetencion1				varchar	(10),
@TipoRetencion2				varchar	(10),
@TipoRetencion3				varchar	(10),
@TipoImpuesto4				varchar	(10),
@Calificacion				smallint,
@Texto						xml,
@ReferenciaIS				varchar(100),
@SubReferencia				varchar(100),
@UltimoCosto				float,
@CostoPromedio				float,
@Empresa					varchar(20),
@ID0						int,
@Sucursal					int
BEGIN TRANSACTION
IF @Ok IS NULL
BEGIN
SELECT @ID0 = dbo.fnAccesoID(@@SPID)
SELECT @Empresa = Empresa, @Sucursal = Sucursal FROM Acceso with(nolock) WHERE ID = @ID0
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SELECT @Rama = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Rama'
SELECT @Descripcion1 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Descripcion1'
SELECT @Descripcion2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Descripcion2'
SELECT @NombreCorto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'NombreCorto'
SELECT @Grupo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Grupo'
SELECT @Categoria = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Categoria'
SELECT @CategoriaActivoFijo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CategoriaActivoFijo'
SELECT @Familia = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Familia'
SELECT @Linea = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Linea'
SELECT @Fabricante = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Fabricante'
SELECT @ClaveFabricante = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ClaveFabricante'
SELECT @Impuesto1 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Impuesto1'
SELECT @Impuesto2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Impuesto2'
SELECT @Impuesto3 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Impuesto3'
SELECT @Factor = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Factor'
SELECT @Unidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Unidad'
SELECT @UnidadCompra = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'UnidadCompra'
SELECT @UnidadTraspaso = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'UnidadTraspaso'
SELECT @UnidadCantidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'UnidadCantidad'
SELECT @TipoCosteo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TipoCosteo'
SELECT @Peso = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Peso'
SELECT @Tara = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tara'
SELECT @Volumen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Volumen'
SELECT @Tipo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tipo'
SELECT @TipoOpcion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TipoOpcion'
SELECT @Accesorios = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Accesorios'
SELECT @Refacciones = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Refacciones'
SELECT @Sustitutos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sustitutos'
SELECT @Servicios = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Servicios'
SELECT @Consumibles = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Consumibles'
SELECT @MonedaCosto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MonedaCosto'
SELECT @MonedaPrecio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MonedaPrecio'
SELECT @MargenMinimo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MargenMinimo'
SELECT @PrecioLista = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PrecioLista'
SELECT @PrecioMinimo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PrecioMinimo'
SELECT @FactorAlterno = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FactorAlterno'
SELECT @PrecioAnterior = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PrecioAnterior'
SELECT @Utilidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Utilidad'
SELECT @DescuentoCompra = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DescuentoCompra'
SELECT @Clase = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Clase'
SELECT @Estatus = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Estatus'
SELECT @UltimoCambio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'UltimoCambio'
SELECT @Alta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Alta'
SELECT @Conciliar = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Conciliar'
SELECT @Mensaje = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mensaje'
SELECT @Comision = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Comision'
SELECT @Arancel = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Arancel'
SELECT @ArancelDesperdicio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ArancelDesperdicio'
SELECT @ABC = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ABC'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @Precio2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Precio2'
SELECT @Precio3 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Precio3'
SELECT @Precio4 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Precio4'
SELECT @Precio5 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Precio5'
SELECT @Precio6 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Precio6'
SELECT @Precio7 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Precio7'
SELECT @Precio8 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Precio8'
SELECT @Precio9 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Precio9'
SELECT @Precio10 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Precio10'
SELECT @Refrigeracion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Refrigeracion'
SELECT @TieneCaducidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TieneCaducidad'
SELECT @BasculaPesar = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BasculaPesar'
SELECT @SeProduce = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SeProduce'
SELECT @Situacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Situacion'
SELECT @SituacionFecha = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SituacionFecha'
SELECT @SituacionUsuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SituacionUsuario'
SELECT @SituacionNota = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SituacionNota'
SELECT @EstatusPrecio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EstatusPrecio'
SELECT @wMostrar = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'wMostrar'
SELECT @Merma = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Merma'
SELECT @Desperdicio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Desperdicio'
SELECT @SeCompra = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SeCompra'
SELECT @SeVende = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SeVende'
SELECT @EsFormula = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EsFormula'
SELECT @TiempoEntrega = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TiempoEntrega'
SELECT @TiempoEntregaUnidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TiempoEntregaUnidad'
SELECT @TiempoEntregaSeg = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TiempoEntregaSeg'
SELECT @TiempoEntregaSegUnidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TiempoEntregaSegUnidad'
SELECT @LoteOrdenar = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'LoteOrdenar'
SELECT @CantidadOrdenar = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CantidadOrdenar'
SELECT @MultiplosOrdenar = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MultiplosOrdenar'
SELECT @InvSeguridad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'InvSeguridad'
SELECT @ProdRuta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ProdRuta'
SELECT @AlmacenROP = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AlmacenROP'
SELECT @CategoriaProd = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CategoriaProd'
SELECT @ProdCantidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ProdCantidad'
SELECT @ProdUsuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ProdUsuario'
SELECT @ProdPasoTotal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ProdPasoTotal'
SELECT @ProdMovGrupo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ProdMovGrupo'
SELECT @ProdEstacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ProdEstacion'
SELECT @ProdOpciones = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ProdOpciones'
SELECT @ProdVerConcentracion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ProdVerConcentracion'
SELECT @ProdVerCostoAcumulado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ProdVerCostoAcumulado'
SELECT @ProdVerMerma = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ProdVerMerma'
SELECT @ProdVerDesperdicio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ProdVerDesperdicio'
SELECT @ProdVerPorcentaje = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ProdVerPorcentaje'
SELECT @RevisionUltima = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RevisionUltima'
SELECT @RevisionUsuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RevisionUsuario'
SELECT @RevisionFrecuencia = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RevisionFrecuencia'
SELECT @RevisionFrecuenciaUnidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RevisionFrecuenciaUnidad'
SELECT @RevisionSiguiente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RevisionSiguiente'
SELECT @ProdMov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ProdMov'
SELECT @TipoCompra = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TipoCompra'
SELECT @TieneMovimientos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TieneMovimientos'
SELECT @Registro1 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Registro1'
SELECT @Registro1Vencimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Registro1Vencimiento'
SELECT @AlmacenEspecificoVenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AlmacenEspecificoVenta'
SELECT @AlmacenEspecificoVentaMov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AlmacenEspecificoVentaMov'
SELECT @RutaDistribucion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RutaDistribucion'
SELECT @CostoEstandar = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CostoEstandar'
SELECT @CostoReposicion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CostoReposicion'
SELECT @EstatusCosto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EstatusCosto'
SELECT @Margen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Margen'
SELECT @Proveedor = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Proveedor'
SELECT @NivelAcceso = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'NivelAcceso'
SELECT @Temporada = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Temporada'
SELECT @SolicitarPrecios = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SolicitarPrecios'
SELECT @AutoRecaudacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AutoRecaudacion'
SELECT @Concepto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Concepto'
SELECT @Cuenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cuenta'
SELECT @Retencion1 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Retencion1'
SELECT @Retencion2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Retencion2'
SELECT @Retencion3 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Retencion3'
SELECT @Espacios = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Espacios'
SELECT @EspaciosEspecificos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EspaciosEspecificos'
SELECT @EspaciosSobreventa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EspaciosSobreventa'
SELECT @EspaciosNivel = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EspaciosNivel'
SELECT @EspaciosMinutos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EspaciosMinutos'
SELECT @EspaciosBloquearAnteriores = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EspaciosBloquearAnteriores'
SELECT @EspaciosHoraD = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EspaciosHoraD'
SELECT @EspaciosHoraA = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EspaciosHoraA'
SELECT @SerieLoteInfo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SerieLoteInfo'
SELECT @CantidadMinimaVenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CantidadMinimaVenta'
SELECT @CantidadMaximaVenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CantidadMaximaVenta'
SELECT @EstimuloFiscal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EstimuloFiscal'
SELECT @OrigenPais = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'OrigenPais'
SELECT @OrigenLocalidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'OrigenLocalidad'
SELECT @Incentivo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Incentivo'
SELECT @FactorCompra = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FactorCompra'
SELECT @Horas = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Horas'
SELECT @ISAN = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ISAN'
SELECT @ExcluirDescFormaPago = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ExcluirDescFormaPago'
SELECT @EsDeducible = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EsDeducible'
SELECT @Peaje = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Peaje'
SELECT @CodigoAlterno = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CodigoAlterno'
SELECT @TipoCatalogo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TipoCatalogo'
SELECT @AnexosAlFacturar = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AnexosAlFacturar'
SELECT @CaducidadMinima = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CaducidadMinima'
SELECT @Actividades = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Actividades'
SELECT @ValidarPresupuestoCompra = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ValidarPresupuestoCompra'
SELECT @SeriesLotesAutoOrden = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SeriesLotesAutoOrden'
SELECT @LotesFijos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'LotesFijos'
SELECT @LotesAuto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'LotesAuto'
SELECT @Consecutivo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Consecutivo'
SELECT @TipoEmpaque = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TipoEmpaque'
SELECT @Modelo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Modelo'
SELECT @ArtVersion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Version'
SELECT @TieneDireccion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TieneDireccion'
SELECT @Direccion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Direccion'
SELECT @DireccionNumero = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DireccionNumero'
SELECT @DireccionNumeroInt = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DireccionNumeroInt'
SELECT @EntreCalles = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EntreCalles'
SELECT @Plano = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Plano'
SELECT @Observaciones = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Observaciones'
SELECT @Colonia = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Colonia'
SELECT @Delegacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Delegacion'
SELECT @Poblacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Poblacion'
SELECT @Estado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Estado'
SELECT @Pais = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Pais'
SELECT @CodigoPostal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CodigoPostal'
SELECT @Ruta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Ruta'
SELECT @Codigo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Codigo'
SELECT @ClaveVehicular = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ClaveVehicular'
SELECT @TipoVehiculo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TipoVehiculo'
SELECT @DiasLibresIntereses = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DiasLibresIntereses'
SELECT @PrecioLiberado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PrecioLiberado'
SELECT @ValidarCodigo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ValidarCodigo'
SELECT @Presentacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Presentacion'
SELECT @GarantiaPlazo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'GarantiaPlazo'
SELECT @CostoIdentificado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CostoIdentificado'
SELECT @CantidadTarima = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CantidadTarima'
SELECT @UnidadTarima = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'UnidadTarima'
SELECT @MinimoTarima = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MinimoTarima'
SELECT @DepartamentoDetallista = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DepartamentoDetallista'
SELECT @TratadoComercial = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TratadoComercial'
SELECT @CuentaPresupuesto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CuentaPresupuesto'
SELECT @ProgramaSectorial = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ProgramaSectorial'
SELECT @PedimentoClave = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PedimentoClave'
SELECT @PedimentoRegimen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PedimentoRegimen'
SELECT @Permiso = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Permiso'
SELECT @PermisoRenglon = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PermisoRenglon'
SELECT @Cuenta2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cuenta2'
SELECT @Cuenta3 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cuenta3'
SELECT @Impuesto1Excento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Impuesto1Excento'
SELECT @CalcularPresupuesto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CalcularPresupuesto'
SELECT @InflacionPresupuesto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'InflacionPresupuesto'
SELECT @Excento2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Excento2'
SELECT @Excento3 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Excento3'
SELECT @ContUso = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ContUso'
SELECT @ContUso2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ContUso2'
SELECT @ContUso3 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ContUso3'
SELECT @NivelToleranciaCosto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'NivelToleranciaCosto'
SELECT @ToleranciaCosto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ToleranciaCosto'
SELECT @ToleranciaCostoInferior = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ToleranciaCostoInferior'
SELECT @ObjetoGasto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ObjetoGasto'
SELECT @ObjetoGastoRef = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ObjetoGastoRef'
SELECT @ClavePresupuestalImpuesto1 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ClavePresupuestalImpuesto1'
SELECT @Estructura = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Estructura'
SELECT @TipoImpuesto1 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TipoImpuesto1'
SELECT @TipoImpuesto2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TipoImpuesto2'
SELECT @TipoImpuesto3 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TipoImpuesto3'
SELECT @TipoRetencion1 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TipoRetencion1'
SELECT @TipoRetencion2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TipoRetencion2'
SELECT @TipoRetencion3 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TipoRetencion3'
SELECT @TipoImpuesto4 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TipoImpuesto4'
SELECT @Calificacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Calificacion'
IF NOT EXISTS(SELECT * FROM ArtIntelisisService with(nolock) WHERE Empresa=@Empresa AND Sucursal=@Sucursal AND Articulo =@Articulo)select @Empresa=null,@sucursal=null
SELECT @Texto =(SELECT * FROM ArtIntelisisService Art
WITH(NOLOCK) WHERE ISNULL(Empresa,'') = ISNULL(ISNULL(@Empresa,Empresa),'')
AND ISNULL(Sucursal,'')= ISNULL(ISNULL(@Sucursal,Sucursal),'')
AND ISNULL(Articulo,'' ) = ISNULL(ISNULL(@Articulo,Articulo),'')
AND ISNULL(Rama,'' ) = ISNULL(ISNULL(@Rama,Rama),'')
AND ISNULL(Descripcion1,'' ) = ISNULL(ISNULL(@Descripcion1,Descripcion1),'')
AND ISNULL(Descripcion2,'' ) = ISNULL(ISNULL(@Descripcion2,Descripcion2),'')
AND ISNULL(NombreCorto,'' ) = ISNULL(ISNULL(@NombreCorto,NombreCorto),'')
AND ISNULL(Grupo,'' ) = ISNULL(ISNULL(@Grupo,Grupo),'')
AND ISNULL(Categoria,'' ) = ISNULL(ISNULL(@Categoria,Categoria),'')
AND ISNULL(CategoriaActivoFijo,'' ) = ISNULL(ISNULL(@CategoriaActivoFijo,CategoriaActivoFijo),'')
AND ISNULL(Familia,'' ) = ISNULL(ISNULL(@Familia,Familia),'')
AND ISNULL(Linea,'' ) = ISNULL(ISNULL(@Linea,Linea),'')
AND ISNULL(Fabricante,'' ) = ISNULL(ISNULL(@Fabricante,Fabricante),'')
AND ISNULL(ClaveFabricante,'' ) = ISNULL(ISNULL(@ClaveFabricante,ClaveFabricante),'')
AND ISNULL(Impuesto1,'' ) = ISNULL(ISNULL(@Impuesto1,Impuesto1),'')
AND ISNULL(Impuesto2,'' ) = ISNULL(ISNULL(@Impuesto2,Impuesto2),'')
AND ISNULL(Impuesto3,'' ) = ISNULL(ISNULL(@Impuesto3,Impuesto3),'')
AND ISNULL(Factor,'' ) = ISNULL(ISNULL(@Factor,Factor),'')
AND ISNULL(Unidad,'' ) = ISNULL(ISNULL(@Unidad,Unidad),'')
AND ISNULL(UnidadCompra,'' ) = ISNULL(ISNULL(@UnidadCompra,UnidadCompra),'')
AND ISNULL(UnidadTraspaso,'' ) = ISNULL(ISNULL(@UnidadTraspaso,UnidadTraspaso),'')
AND ISNULL(UnidadCantidad,'' ) = ISNULL(ISNULL(@UnidadCantidad,UnidadCantidad),'')
AND ISNULL(TipoCosteo,'' ) = ISNULL(ISNULL(@TipoCosteo,TipoCosteo),'')
AND ISNULL(Peso,'' ) = ISNULL(ISNULL(@Peso,Peso),'')
AND ISNULL(Tara,'' ) = ISNULL(ISNULL(@Tara,Tara),'')
AND ISNULL(Volumen,'' ) = ISNULL(ISNULL(@Volumen,Volumen),'')
AND ISNULL(Tipo,'' ) = ISNULL(ISNULL(@Tipo,Tipo),'')
AND ISNULL(TipoOpcion,'' ) = ISNULL(ISNULL(@TipoOpcion,TipoOpcion),'')
AND ISNULL(Accesorios,'' ) = ISNULL(ISNULL(@Accesorios,Accesorios),'')
AND ISNULL(Refacciones,'' ) = ISNULL(ISNULL(@Refacciones,Refacciones),'')
AND ISNULL(Sustitutos,'' ) = ISNULL(ISNULL(@Sustitutos,Sustitutos),'')
AND ISNULL(Servicios,'' ) = ISNULL(ISNULL(@Servicios,Servicios),'')
AND ISNULL(Consumibles,'' ) = ISNULL(ISNULL(@Consumibles,Consumibles),'')
AND ISNULL(MonedaCosto,'' ) = ISNULL(ISNULL(@MonedaCosto,MonedaCosto),'')
AND ISNULL(MonedaPrecio,'' ) = ISNULL(ISNULL(@MonedaPrecio,MonedaPrecio),'')
AND ISNULL(MargenMinimo,'' ) = ISNULL(ISNULL(@MargenMinimo,MargenMinimo),'')
AND ISNULL(PrecioLista,'' ) = ISNULL(ISNULL(@PrecioLista,PrecioLista),'')
AND ISNULL(PrecioMinimo,'' ) = ISNULL(ISNULL(@PrecioMinimo,PrecioMinimo),'')
AND ISNULL(FactorAlterno,'' ) = ISNULL(ISNULL(@FactorAlterno,FactorAlterno),'')
AND ISNULL(PrecioAnterior,'' ) = ISNULL(ISNULL(@PrecioAnterior,PrecioAnterior),'')
AND ISNULL(Utilidad,'' ) = ISNULL(ISNULL(@Utilidad,Utilidad),'')
AND ISNULL(DescuentoCompra,'' ) = ISNULL(ISNULL(@DescuentoCompra,DescuentoCompra),'')
AND ISNULL(Clase,'' ) = ISNULL(ISNULL(@Clase,Clase),'')
AND ISNULL(Estatus,'' ) = ISNULL(ISNULL(@Estatus,Estatus),'')
AND ISNULL(UltimoCambio,'' ) = ISNULL(ISNULL(@UltimoCambio,UltimoCambio),'')
AND ISNULL(Alta,'' ) = ISNULL(ISNULL(@Alta,Alta),'')
AND ISNULL(Conciliar,'' ) = ISNULL(ISNULL(@Conciliar,Conciliar),'')
AND ISNULL(Mensaje,'' ) = ISNULL(ISNULL(@Mensaje,Mensaje),'')
AND ISNULL(Comision,'' ) = ISNULL(ISNULL(@Comision,Comision),'')
AND ISNULL(Arancel,'' ) = ISNULL(ISNULL(@Arancel,Arancel),'')
AND ISNULL(ArancelDesperdicio,'' ) = ISNULL(ISNULL(@ArancelDesperdicio,ArancelDesperdicio),'')
AND ISNULL(ABC,'' ) = ISNULL(ISNULL(@ABC,ABC),'')
AND ISNULL(Usuario,'' ) = ISNULL(ISNULL(@Usuario,Usuario),'')
AND ISNULL(Precio2,'' ) = ISNULL(ISNULL(@Precio2,Precio2),'')
AND ISNULL(Precio3,'' ) = ISNULL(ISNULL(@Precio3,Precio3),'')
AND ISNULL(Precio4,'' ) = ISNULL(ISNULL(@Precio4,Precio4),'')
AND ISNULL(Precio5,'' ) = ISNULL(ISNULL(@Precio5,Precio5),'')
AND ISNULL(Precio6,'' ) = ISNULL(ISNULL(@Precio6,Precio6),'')
AND ISNULL(Precio7,'' ) = ISNULL(ISNULL(@Precio7,Precio7),'')
AND ISNULL(Precio8,'' ) = ISNULL(ISNULL(@Precio8,Precio8),'')
AND ISNULL(Precio9,'' ) = ISNULL(ISNULL(@Precio9,Precio9),'')
AND ISNULL(Precio10,'' ) = ISNULL(ISNULL(@Precio10,Precio10),'')
AND ISNULL(Refrigeracion,'' ) = ISNULL(ISNULL(@Refrigeracion,Refrigeracion),'')
AND ISNULL(TieneCaducidad,'' ) = ISNULL(ISNULL(@TieneCaducidad,TieneCaducidad),'')
AND ISNULL(BasculaPesar,'' ) = ISNULL(ISNULL(@BasculaPesar,BasculaPesar),'')
AND ISNULL(SeProduce,'' ) = ISNULL(ISNULL(@SeProduce,SeProduce),'')
AND ISNULL(Situacion,'' ) = ISNULL(ISNULL(@Situacion,Situacion),'')
AND ISNULL(SituacionFecha,'' ) = ISNULL(ISNULL(@SituacionFecha,SituacionFecha),'')
AND ISNULL(SituacionUsuario,'' ) = ISNULL(ISNULL(@SituacionUsuario,SituacionUsuario),'')
AND ISNULL(SituacionNota,'' ) = ISNULL(ISNULL(@SituacionNota,SituacionNota),'')
AND ISNULL(EstatusPrecio,'' ) = ISNULL(ISNULL(@EstatusPrecio,EstatusPrecio),'')
AND ISNULL(wMostrar,'' ) = ISNULL(ISNULL(@wMostrar,wMostrar),'')
AND ISNULL(Merma,'' ) = ISNULL(ISNULL(@Merma,Merma),'')
AND ISNULL(Desperdicio,'' ) = ISNULL(ISNULL(@Desperdicio,Desperdicio),'')
AND ISNULL(SeCompra,'' ) = ISNULL(ISNULL(@SeCompra,SeCompra),'')
AND ISNULL(SeVende,'' ) = ISNULL(ISNULL(@SeVende,SeVende),'')
AND ISNULL(EsFormula,'' ) = ISNULL(ISNULL(@EsFormula,EsFormula),'')
AND ISNULL(TiempoEntrega,'' ) = ISNULL(ISNULL(@TiempoEntrega,TiempoEntrega),'')
AND ISNULL(TiempoEntregaUnidad,'' ) = ISNULL(ISNULL(@TiempoEntregaUnidad,TiempoEntregaUnidad),'')
AND ISNULL(TiempoEntregaSeg,'' ) = ISNULL(ISNULL(@TiempoEntregaSeg,TiempoEntregaSeg),'')
AND ISNULL(TiempoEntregaSegUnidad,'' ) = ISNULL(ISNULL(@TiempoEntregaSegUnidad,TiempoEntregaSegUnidad),'')
AND ISNULL(LoteOrdenar,'' ) = ISNULL(ISNULL(@LoteOrdenar,LoteOrdenar),'')
AND ISNULL(CantidadOrdenar,'' ) = ISNULL(ISNULL(@CantidadOrdenar,CantidadOrdenar),'')
AND ISNULL(MultiplosOrdenar,'' ) = ISNULL(ISNULL(@MultiplosOrdenar,MultiplosOrdenar),'')
AND ISNULL(InvSeguridad,'' ) = ISNULL(ISNULL(@InvSeguridad,InvSeguridad),'')
AND ISNULL(ProdRuta,'' ) = ISNULL(ISNULL(@ProdRuta,ProdRuta),'')
AND ISNULL(AlmacenROP,'' ) = ISNULL(ISNULL(@AlmacenROP,AlmacenROP),'')
AND ISNULL(CategoriaProd,'' ) = ISNULL(ISNULL(@CategoriaProd,CategoriaProd),'')
AND ISNULL(ProdCantidad,'' ) = ISNULL(ISNULL(@ProdCantidad,ProdCantidad),'')
AND ISNULL(ProdUsuario,'' ) = ISNULL(ISNULL(@ProdUsuario,ProdUsuario),'')
AND ISNULL(ProdPasoTotal,'' ) = ISNULL(ISNULL(@ProdPasoTotal,ProdPasoTotal),'')
AND ISNULL(ProdMovGrupo,'' ) = ISNULL(ISNULL(@ProdMovGrupo,ProdMovGrupo),'')
AND ISNULL(ProdEstacion,'' ) = ISNULL(ISNULL(@ProdEstacion,ProdEstacion),'')
AND ISNULL(ProdOpciones,'' ) = ISNULL(ISNULL(@ProdOpciones,ProdOpciones),'')
AND ISNULL(ProdVerConcentracion,'' ) = ISNULL(ISNULL(@ProdVerConcentracion,ProdVerConcentracion),'')
AND ISNULL(ProdVerCostoAcumulado,'' ) = ISNULL(ISNULL(@ProdVerCostoAcumulado,ProdVerCostoAcumulado),'')
AND ISNULL(ProdVerMerma,'' ) = ISNULL(ISNULL(@ProdVerMerma,ProdVerMerma),'')
AND ISNULL(ProdVerDesperdicio,'' ) = ISNULL(ISNULL(@ProdVerDesperdicio,ProdVerDesperdicio),'')
AND ISNULL(ProdVerPorcentaje,'' ) = ISNULL(ISNULL(@ProdVerPorcentaje,ProdVerPorcentaje),'')
AND ISNULL(RevisionUltima,'' ) = ISNULL(ISNULL(@RevisionUltima,RevisionUltima),'')
AND ISNULL(RevisionUsuario,'' ) = ISNULL(ISNULL(@RevisionUsuario,RevisionUsuario),'')
AND ISNULL(RevisionFrecuencia,'' ) = ISNULL(ISNULL(@RevisionFrecuencia,RevisionFrecuencia),'')
AND ISNULL(RevisionFrecuenciaUnidad,'' ) = ISNULL(ISNULL(@RevisionFrecuenciaUnidad,RevisionFrecuenciaUnidad),'')
AND ISNULL(RevisionSiguiente,'' ) = ISNULL(ISNULL(@RevisionSiguiente,RevisionSiguiente),'')
AND ISNULL(ProdMov,'' ) = ISNULL(ISNULL(@ProdMov,ProdMov),'')
AND ISNULL(TipoCompra,'' ) = ISNULL(ISNULL(@TipoCompra,TipoCompra),'')
AND ISNULL(TieneMovimientos,'' ) = ISNULL(ISNULL(@TieneMovimientos,TieneMovimientos),'')
AND ISNULL(Registro1,'' ) = ISNULL(ISNULL(@Registro1,Registro1),'')
AND ISNULL(Registro1Vencimiento,'' ) = ISNULL(ISNULL(@Registro1Vencimiento,Registro1Vencimiento),'')
AND ISNULL(AlmacenEspecificoVenta,'' ) = ISNULL(ISNULL(@AlmacenEspecificoVenta,AlmacenEspecificoVenta),'')
AND ISNULL(AlmacenEspecificoVentaMov,'' ) = ISNULL(ISNULL(@AlmacenEspecificoVentaMov,AlmacenEspecificoVentaMov),'')
AND ISNULL(RutaDistribucion,'' ) = ISNULL(ISNULL(@RutaDistribucion,RutaDistribucion),'')
AND ISNULL(CostoEstandar,'' ) = ISNULL(ISNULL(@CostoEstandar,CostoEstandar),'')
AND ISNULL(CostoReposicion,'' ) = ISNULL(ISNULL(@CostoReposicion,CostoReposicion),'')
AND ISNULL(EstatusCosto,'' ) = ISNULL(ISNULL(@EstatusCosto,EstatusCosto),'')
AND ISNULL(Margen,'' ) = ISNULL(ISNULL(@Margen,Margen),'')
AND ISNULL(Proveedor,'' ) = ISNULL(ISNULL(@Proveedor,Proveedor),'')
AND ISNULL(NivelAcceso,'' ) = ISNULL(ISNULL(@NivelAcceso,NivelAcceso),'')
AND ISNULL(Temporada,'' ) = ISNULL(ISNULL(@Temporada,Temporada),'')
AND ISNULL(SolicitarPrecios,'' ) = ISNULL(ISNULL(@SolicitarPrecios,SolicitarPrecios),'')
AND ISNULL(AutoRecaudacion,'' ) = ISNULL(ISNULL(@AutoRecaudacion,AutoRecaudacion),'')
AND ISNULL(Concepto,'' ) = ISNULL(ISNULL(@Concepto,Concepto),'')
AND ISNULL(Cuenta,'' ) = ISNULL(ISNULL(@Cuenta,Cuenta),'')
AND ISNULL(Retencion1,'' ) = ISNULL(ISNULL(@Retencion1,Retencion1),'')
AND ISNULL(Retencion2,'' ) = ISNULL(ISNULL(@Retencion2,Retencion2),'')
AND ISNULL(Retencion3,'' ) = ISNULL(ISNULL(@Retencion3,Retencion3),'')
AND ISNULL(Espacios,'' ) = ISNULL(ISNULL(@Espacios,Espacios),'')
AND ISNULL(EspaciosEspecificos,'' ) = ISNULL(ISNULL(@EspaciosEspecificos,EspaciosEspecificos),'')
AND ISNULL(EspaciosSobreventa,'' ) = ISNULL(ISNULL(@EspaciosSobreventa,EspaciosSobreventa),'')
AND ISNULL(EspaciosNivel,'' ) = ISNULL(ISNULL(@EspaciosNivel,EspaciosNivel),'')
AND ISNULL(EspaciosMinutos,'' ) = ISNULL(ISNULL(@EspaciosMinutos,EspaciosMinutos),'')
AND ISNULL(EspaciosBloquearAnteriores,'' ) = ISNULL(ISNULL(@EspaciosBloquearAnteriores,EspaciosBloquearAnteriores),'')
AND ISNULL(EspaciosHoraD,'' ) = ISNULL(ISNULL(@EspaciosHoraD,EspaciosHoraD),'')
AND ISNULL(EspaciosHoraA,'' ) = ISNULL(ISNULL(@EspaciosHoraA,EspaciosHoraA),'')
AND ISNULL(SerieLoteInfo,'' ) = ISNULL(ISNULL(@SerieLoteInfo,SerieLoteInfo),'')
AND ISNULL(CantidadMinimaVenta,'' ) = ISNULL(ISNULL(@CantidadMinimaVenta,CantidadMinimaVenta),'')
AND ISNULL(CantidadMaximaVenta,'' ) = ISNULL(ISNULL(@CantidadMaximaVenta,CantidadMaximaVenta),'')
AND ISNULL(EstimuloFiscal,'' ) = ISNULL(ISNULL(@EstimuloFiscal,EstimuloFiscal),'')
AND ISNULL(OrigenPais,'' ) = ISNULL(ISNULL(@OrigenPais,OrigenPais),'')
AND ISNULL(OrigenLocalidad,'' ) = ISNULL(ISNULL(@OrigenLocalidad,OrigenLocalidad),'')
AND ISNULL(Incentivo,'' ) = ISNULL(ISNULL(@Incentivo,Incentivo),'')
AND ISNULL(FactorCompra,'' ) = ISNULL(ISNULL(@FactorCompra,FactorCompra),'')
AND ISNULL(Horas,'' ) = ISNULL(ISNULL(@Horas,Horas),'')
AND ISNULL(ISAN,'' ) = ISNULL(ISNULL(@ISAN,ISAN),'')
AND ISNULL(ExcluirDescFormaPago,'' ) = ISNULL(ISNULL(@ExcluirDescFormaPago,ExcluirDescFormaPago),'')
AND ISNULL(EsDeducible,'' ) = ISNULL(ISNULL(@EsDeducible,EsDeducible),'')
AND ISNULL(Peaje,'' ) = ISNULL(ISNULL(@Peaje,Peaje),'')
AND ISNULL(CodigoAlterno,'' ) = ISNULL(ISNULL(@CodigoAlterno,CodigoAlterno),'')
AND ISNULL(TipoCatalogo,'' ) = ISNULL(ISNULL(@TipoCatalogo,TipoCatalogo),'')
AND ISNULL(AnexosAlFacturar,'' ) = ISNULL(ISNULL(@AnexosAlFacturar,AnexosAlFacturar),'')
AND ISNULL(CaducidadMinima,'' ) = ISNULL(ISNULL(@CaducidadMinima,CaducidadMinima),'')
AND ISNULL(Actividades,'' ) = ISNULL(ISNULL(@Actividades,Actividades),'')
AND ISNULL(ValidarPresupuestoCompra,'' ) = ISNULL(ISNULL(@ValidarPresupuestoCompra,ValidarPresupuestoCompra),'')
AND ISNULL(SeriesLotesAutoOrden,'' ) = ISNULL(ISNULL(@SeriesLotesAutoOrden,SeriesLotesAutoOrden),'')
AND ISNULL(LotesFijos,'' ) = ISNULL(ISNULL(@LotesFijos,LotesFijos),'')
AND ISNULL(LotesAuto,'' ) = ISNULL(ISNULL(@LotesAuto,LotesAuto),'')
AND ISNULL(Consecutivo,'' ) = ISNULL(ISNULL(@Consecutivo,Consecutivo),'')
AND ISNULL(TipoEmpaque,'' ) = ISNULL(ISNULL(@TipoEmpaque,TipoEmpaque),'')
AND ISNULL(Modelo,'' ) = ISNULL(ISNULL(@Modelo,Modelo),'')
AND ISNULL(Version,'' ) = ISNULL(ISNULL(@ArtVersion,Version),'')
AND ISNULL(TieneDireccion,'' ) = ISNULL(ISNULL(@TieneDireccion,TieneDireccion),'')
AND ISNULL(Direccion,'' ) = ISNULL(ISNULL(@Direccion,Direccion),'')
AND ISNULL(DireccionNumero,'' ) = ISNULL(ISNULL(@DireccionNumero,DireccionNumero),'')
AND ISNULL(DireccionNumeroInt,'' ) = ISNULL(ISNULL(@DireccionNumeroInt,DireccionNumeroInt),'')
AND ISNULL(EntreCalles,'' ) = ISNULL(ISNULL(@EntreCalles,EntreCalles),'')
AND ISNULL(Plano,'' ) = ISNULL(ISNULL(@Plano,Plano),'')
AND ISNULL(Observaciones,'' ) = ISNULL(ISNULL(@Observaciones,Observaciones),'')
AND ISNULL(Colonia,'' ) = ISNULL(ISNULL(@Colonia,Colonia),'')
AND ISNULL(Delegacion,'' ) = ISNULL(ISNULL(@Delegacion,Delegacion),'')
AND ISNULL(Poblacion,'' ) = ISNULL(ISNULL(@Poblacion,Poblacion),'')
AND ISNULL(Estado,'' ) = ISNULL(ISNULL(@Estado,Estado),'')
AND ISNULL(Pais,'' ) = ISNULL(ISNULL(@Pais,Pais),'')
AND ISNULL(CodigoPostal,'' ) = ISNULL(ISNULL(@CodigoPostal,CodigoPostal),'')
AND ISNULL(Ruta,'' ) = ISNULL(ISNULL(@Ruta,Ruta),'')
AND ISNULL(Codigo,'' ) = ISNULL(ISNULL(@Codigo,Codigo),'')
AND ISNULL(ClaveVehicular,'' ) = ISNULL(ISNULL(@ClaveVehicular,ClaveVehicular),'')
AND ISNULL(TipoVehiculo,'' ) = ISNULL(ISNULL(@TipoVehiculo,TipoVehiculo),'')
AND ISNULL(DiasLibresIntereses,'' ) = ISNULL(ISNULL(@DiasLibresIntereses,DiasLibresIntereses),'')
AND ISNULL(PrecioLiberado,'' ) = ISNULL(ISNULL(@PrecioLiberado,PrecioLiberado),'')
AND ISNULL(ValidarCodigo,'' ) = ISNULL(ISNULL(@ValidarCodigo,ValidarCodigo),'')
AND ISNULL(Presentacion,'' ) = ISNULL(ISNULL(@Presentacion,Presentacion),'')
AND ISNULL(GarantiaPlazo,'' ) = ISNULL(ISNULL(@GarantiaPlazo,GarantiaPlazo),'')
AND ISNULL(CostoIdentificado,'' ) = ISNULL(ISNULL(@CostoIdentificado,CostoIdentificado),'')
AND ISNULL(CantidadTarima,'' ) = ISNULL(ISNULL(@CantidadTarima,CantidadTarima),'')
AND ISNULL(UnidadTarima,'' ) = ISNULL(ISNULL(@UnidadTarima,UnidadTarima),'')
AND ISNULL(MinimoTarima,'' ) = ISNULL(ISNULL(@MinimoTarima,MinimoTarima),'')
AND ISNULL(DepartamentoDetallista,'' ) = ISNULL(ISNULL(@DepartamentoDetallista,DepartamentoDetallista),'')
AND ISNULL(TratadoComercial,'' ) = ISNULL(ISNULL(@TratadoComercial,TratadoComercial),'')
AND ISNULL(CuentaPresupuesto,'' ) = ISNULL(ISNULL(@CuentaPresupuesto,CuentaPresupuesto),'')
AND ISNULL(ProgramaSectorial,'' ) = ISNULL(ISNULL(@ProgramaSectorial,ProgramaSectorial),'')
AND ISNULL(PedimentoClave,'' ) = ISNULL(ISNULL(@PedimentoClave,PedimentoClave),'')
AND ISNULL(PedimentoRegimen,'' ) = ISNULL(ISNULL(@PedimentoRegimen,PedimentoRegimen),'')
AND ISNULL(Permiso,'' ) = ISNULL(ISNULL(@Permiso,Permiso),'')
AND ISNULL(PermisoRenglon,'' ) = ISNULL(ISNULL(@PermisoRenglon,PermisoRenglon),'')
AND ISNULL(Cuenta2,'' ) = ISNULL(ISNULL(@Cuenta2,Cuenta2),'')
AND ISNULL(Cuenta3,'' ) = ISNULL(ISNULL(@Cuenta3,Cuenta3),'')
AND ISNULL(Impuesto1Excento,'' ) = ISNULL(ISNULL(@Impuesto1Excento,Impuesto1Excento),'')
AND ISNULL(CalcularPresupuesto,'' ) = ISNULL(ISNULL(@CalcularPresupuesto,CalcularPresupuesto),'')
AND ISNULL(InflacionPresupuesto,'' ) = ISNULL(ISNULL(@InflacionPresupuesto,InflacionPresupuesto),'')
AND ISNULL(Excento2,'' ) = ISNULL(ISNULL(@Excento2,Excento2),'')
AND ISNULL(Excento3,'' ) = ISNULL(ISNULL(@Excento3,Excento3),'')
AND ISNULL(ContUso,'' ) = ISNULL(ISNULL(@ContUso,ContUso),'')
AND ISNULL(ContUso2,'' ) = ISNULL(ISNULL(@ContUso2,ContUso2),'')
AND ISNULL(ContUso3,'' ) = ISNULL(ISNULL(@ContUso3,ContUso3),'')
AND ISNULL(NivelToleranciaCosto,'' ) = ISNULL(ISNULL(@NivelToleranciaCosto,NivelToleranciaCosto),'')
AND ISNULL(ToleranciaCosto,'' ) = ISNULL(ISNULL(@ToleranciaCosto,ToleranciaCosto),'')
AND ISNULL(ToleranciaCostoInferior,'' ) = ISNULL(ISNULL(@ToleranciaCostoInferior,ToleranciaCostoInferior),'')
AND ISNULL(ObjetoGasto,'' ) = ISNULL(ISNULL(@ObjetoGasto,ObjetoGasto),'')
AND ISNULL(ObjetoGastoRef,'' ) = ISNULL(ISNULL(@ObjetoGastoRef,ObjetoGastoRef),'')
AND ISNULL(ClavePresupuestalImpuesto1,'' ) = ISNULL(ISNULL(@ClavePresupuestalImpuesto1,ClavePresupuestalImpuesto1),'')
AND ISNULL(Estructura,'' ) = ISNULL(ISNULL(@Estructura,Estructura),'')
AND ISNULL(TipoImpuesto1,'' ) = ISNULL(ISNULL(@TipoImpuesto1,TipoImpuesto1),'')
AND ISNULL(TipoImpuesto2,'' ) = ISNULL(ISNULL(@TipoImpuesto2,TipoImpuesto2),'')
AND ISNULL(TipoImpuesto3,'' ) = ISNULL(ISNULL(@TipoImpuesto3,TipoImpuesto3),'')
AND ISNULL(TipoRetencion1,'' ) = ISNULL(ISNULL(@TipoRetencion1,TipoRetencion1),'')
AND ISNULL(TipoRetencion2,'' ) = ISNULL(ISNULL(@TipoRetencion2,TipoRetencion2),'')
AND ISNULL(TipoRetencion3,'' ) = ISNULL(ISNULL(@TipoRetencion3,TipoRetencion3),'')
AND ISNULL(TipoImpuesto4,'' ) = ISNULL(ISNULL(@TipoImpuesto4,TipoImpuesto4),'')
AND ISNULL(Calificacion,'' ) = ISNULL(ISNULL(@Calificacion,Calificacion),'')
FOR XML AUTO)
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @ID
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'')+ '</Resultado></Intelisis>'
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

