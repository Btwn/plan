SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisCuentaUsuarioListado
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Usuario						varchar(10),
@Nombre							varchar(100),
@Sucursal						int,
@DefEmpresa						varchar(5),
@GrupoTrabajo					varchar(50),
@Departamento					varchar(50),
@Contrasena						varchar(32),
@ContrasenaConfirmacion			varchar(32),
@ContrasenaFecha				datetime,
@ContrasenaModificar			bit,
@Telefono						varchar(100),
@Extencion						varchar(10),
@DefAgente						varchar(10),
@DefCajero						varchar(10),
@DefAlmacen						varchar(10),
@DefAlmacenTrans				varchar(10),
@DefCtaDinero					varchar(10),
@DefCtaDineroTrans				varchar(10),
@DefMoneda						varchar(10),
@DefProyecto					varchar(50),
@DefLocalidad					varchar(50),
@DefCliente						varchar(10),
@DefActividad					varchar(50),
@DefMovVentas					varchar(20),
@DefZonaImpuesto				varchar(30),
@DefFormaPago					varchar(50),
@Afectar						bit,
@Cancelar						bit,
@Desafectar						bit,
@Autorizar						bit,
@AutorizarVenta					bit,
@AutorizarCxp					bit,
@AutorizarGasto					bit,
@AutorizarDinero				bit,
@AutorizarPV					bit,
@AutorizarCompra				bit,
@AutorizarGestion				bit,
@AutorizarSeriesLotes			bit,
@AfectarOtrosMovs				bit,
@CancelarOtrosMovs				bit,
@ConsultarOtrosMovs				bit,
@ConsultarOtrosMovsGrupo		bit,
@ConsultarOtrasEmpresas			bit,
@ConsultarOtrasSucursales		bit,
@AccesarOtrasSucursalesEnLinea	bit,
@AfectarOtrasSucursalesEnLinea	bit,
@ModificarOtrosMovs				bit,
@ModificarVencimientos			bit,
@ModificarEntregas				bit,
@ModificarFechaRequerida		bit,
@ModificarEnvios				bit,
@ModificarReferencias			bit,
@ModificarAlmacenEntregas		bit,
@ModificarSituacion				bit,
@ModificarAgente				bit,
@ModificarUsuario				bit,
@ModificarListaPrecios			bit,
@ModificarZonaImpuesto			bit,
@ModificarSucursalDestino		bit,
@ModificarProyUENActCC			bit,
@AgregarCteExpress				bit,
@AgregarArtExpress				bit,
@Costos							bit,
@BloquearCostos					bit,
@VerInfoDeudores				bit,
@VerInfoAcreedores				bit,
@VerComisionesPendientes		bit,
@BloquearEncabezadoVenta		bit,
@BloquearCxcCtaDinero			bit,
@BloquearCxpCtaDinero			bit,
@BloquearDineroCtaDinero		bit,
@EnviarExcel					bit,
@ImprimirMovs					bit,
@PreliminarMovs					bit,
@Reservar						bit,
@DesReservar					bit,
@Asignar						bit,
@DesAsignar						bit,
@ModificarAlmacenPedidos		bit,
@ModificarConceptos				bit,
@ModificarReferenciasSiempre	bit,
@ModificarAgenteCxcPendiente	bit,
@ModificarMovsNominaVigentes	bit,
@BloquearPrecios				bit,
@BloquearDescGlobal				bit,
@BloquearDescLinea				bit,
@BloquearCondiciones			bit,
@BloquearAlmacen				bit,
@BloquearMoneda					bit,
@BloquearAgente					bit,
@BloquearFechaEmision			bit,
@BloquearProyecto				bit,
@BloquearFormaPago				bit,
@Oficina						varchar(50),
@DefArtTipo						varchar(20),
@DefUnidad						varchar(50),
@AbrirCajon						bit,
@BloquearCobroInmediato			bit,
@ConsultarCompraPendiente		bit,
@AccesoTotalCuentas				bit,
@Estatus						varchar(15),
@UltimoCambio					datetime,
@Alta							datetime,
@Configuracion					varchar(10),
@Acceso							varchar(10),
@TieneMovimientos				bit,
@Refacturar						bit,
@DefListaPreciosEsp				varchar(20),
@LimiteTableroControl			int,
@CteInfo						bit,
@CteBloquearOtrosDatos			bit,
@ArtBloquearOtrosDatos			bit,
@CteSucursalVenta				bit,
@CtaDineroInfo					bit,
@ImpresionInmediata				bit,
@MostrarCampos					bit,
@AsistentePrecios				bit,
@CambioValidarCobertura			bit,
@CambioNormatividad				bit,
@CambioEditarCobertura			bit,
@CambioVerPosicionEmpresa		bit,
@CambioVerPosicionSucursal		bit,
@CambioVerPosicionOtraSucursal	bit,
@CambioAutorizarOperacionLimite	bit,
@AutoDobleCapturaPrecios		bit,
@AutoArtGrupo					varchar(50),
@AutoAgregarRecaudacionConsumo	bit,
@AutoDiesel						bit,
@BloquearActividad				bit,
@UEN							int,
@eMail							varchar(50),
@CteMov							bit,
@CteArt							bit,
@ProvMov						bit,
@ArtMov							bit,
@DefContUso						varchar(20),
@BloquearContUso				bit,
@Observaciones					varchar(255),
@TraspasarTodo					bit,
@BloquearNotasNegativas			bit,
@ModificarSerieLoteProp			bit,
@NominaEliminacionParcial		bit,
@ModificarPropiedadesLotes		bit,
@PVAbrirCajonSiempre			bit,
@PVBloquearEgresos				bit,
@PVCobrarNotasEstatusBorrador	bit,
@PVModificarEstatusBorrador		bit,
@BloquearPersonalCfg			bit,
@BloquearFacturacionDirecta		bit,
@BloquearInvSalidaDirecta		bit,
@Idioma							varchar(50),
@ModificarDatosVIN				bit,
@ModificarDatosCliente			bit,
@CxcExpress						bit,
@CxpExpress						bit,
@Cliente						varchar(10),
@SubModuloAtencion				varchar(5),
@BloquearCancelarFactura		bit,
@CambioPresentacionExpress		bit,
@ModificarConsecutivos			bit,
@ModificarVINFechaBaja			bit,
@ModificarVINFechaPago			bit,
@ModificarVINAccesorio			bit,
@PVEditarNota					bit,
@ModificarDescGlobalImporte		bit,
@ConsultarClientesOtrosAgentes	bit,
@ACLCUsoEspecifico				varchar(20),
@ACEditarTablaAmortizacion		bit,
@PlantillasOffice				bit,
@ConfigPlantillasOffice			bit,
@ACTasaGrupo					varchar(50),
@CambioAgregarBeneficiarios		bit,
@AgregarConceptoExpress			bit,
@BloquearArtMaterial			bit,
@InfoPath						bit,
@InfoPathExe					varchar(255),
@FEA							bit,
@FEACertificado					varchar(100),
@FEALlave						varchar(100),
@ContrasenaNuncaExpira			bit,
@Menu							varchar(50),
@MenuAccesoTotal				bit,
@BloquearPDF					bit,
@VerificarOrtografia			bit,
@ContSinOrigen					bit,
@UnidadOrganizacional			varchar(20),
@ProyectoMov					bit,
@CompraDevTodo					bit,
@BloquearWebContenido			bit,
@BloquearWebHTML				bit,
@DBMailPerfil					varchar(50),
@UltimoAcceso					datetime,
@BloquearSituacionUsuario		bit,
@InformacionConfidencial		bit,
@PerfilForma					varchar(50),
@Licenciamiento					varchar(50),
@SituacionArea					varchar(50),
@ModificarTipoImpuesto			bit,
@AgregarProvExpress				bit,
@ProyMov						bit,
@Texto							xml,
@ReferenciaIS					varchar(100),
@SubReferencia					varchar(100)
BEGIN TRANSACTION
IF @Ok IS NULL
BEGIN
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @Nombre = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Nombre'
SELECT @Sucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @DefEmpresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DefEmpresa'
SELECT @GrupoTrabajo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'GrupoTrabajo'
SELECT @Departamento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Departamento'
SELECT @Contrasena = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Contrasena'
SELECT @ContrasenaConfirmacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ContrasenaConfirmacion'
SELECT @ContrasenaFecha = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ContrasenaFecha'
SELECT @ContrasenaModificar = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ContrasenaModificar'
SELECT @Telefono = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Telefono'
SELECT @Extencion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Extencion'
SELECT @DefAgente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DefAgente'
SELECT @DefCajero = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DefCajero'
SELECT @DefAlmacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DefAlmacen'
SELECT @DefAlmacenTrans = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DefAlmacenTrans'
SELECT @DefCtaDinero = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DefCtaDinero'
SELECT @DefCtaDineroTrans = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DefCtaDineroTrans'
SELECT @DefMoneda = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DefMoneda'
SELECT @DefProyecto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DefProyecto'
SELECT @DefLocalidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DefLocalidad'
SELECT @DefCliente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DefCliente'
SELECT @DefActividad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DefActividad'
SELECT @DefMovVentas = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DefMovVentas'
SELECT @DefZonaImpuesto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DefZonaImpuesto'
SELECT @DefFormaPago = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DefFormaPago'
SELECT @Afectar = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Afectar'
SELECT @Cancelar = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cancelar'
SELECT @Desafectar = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Desafectar'
SELECT @Autorizar = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Autorizar'
SELECT @AutorizarVenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AutorizarVenta'
SELECT @AutorizarCxp = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AutorizarCxp'
SELECT @AutorizarGasto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AutorizarGasto'
SELECT @AutorizarDinero = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AutorizarDinero'
SELECT @AutorizarPV = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AutorizarPV'
SELECT @AutorizarCompra = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AutorizarCompra'
SELECT @AutorizarGestion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AutorizarGestion'
SELECT @AutorizarSeriesLotes = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AutorizarSeriesLotes'
SELECT @AfectarOtrosMovs = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AfectarOtrosMovs'
SELECT @CancelarOtrosMovs = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CancelarOtrosMovs'
SELECT @ConsultarOtrosMovs = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ConsultarOtrosMovs'
SELECT @ConsultarOtrosMovsGrupo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ConsultarOtrosMovsGrupo'
SELECT @ConsultarOtrasEmpresas = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ConsultarOtrasEmpresas'
SELECT @ConsultarOtrasSucursales = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ConsultarOtrasSucursales'
SELECT @AccesarOtrasSucursalesEnLinea = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AccesarOtrasSucursalesEnLinea'
SELECT @AfectarOtrasSucursalesEnLinea = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AfectarOtrasSucursalesEnLinea'
SELECT @ModificarOtrosMovs = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarOtrosMovs'
SELECT @ModificarVencimientos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarVencimientos'
SELECT @ModificarEntregas = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarEntregas'
SELECT @ModificarFechaRequerida = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarFechaRequerida'
SELECT @ModificarEnvios = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarEnvios'
SELECT @ModificarReferencias = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarReferencias'
SELECT @ModificarAlmacenEntregas = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarAlmacenEntregas'
SELECT @ModificarSituacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarSituacion'
SELECT @ModificarAgente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarAgente'
SELECT @ModificarUsuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarUsuario'
SELECT @ModificarListaPrecios = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarListaPrecios'
SELECT @ModificarZonaImpuesto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarZonaImpuesto'
SELECT @ModificarSucursalDestino = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarSucursalDestino'
SELECT @ModificarProyUENActCC = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarProyUENActCC'
SELECT @AgregarCteExpress = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AgregarCteExpress'
SELECT @AgregarArtExpress = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AgregarArtExpress'
SELECT @Costos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Costos'
SELECT @BloquearCostos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearCostos'
SELECT @VerInfoDeudores = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'VerInfoDeudores'
SELECT @VerInfoAcreedores = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'VerInfoAcreedores'
SELECT @VerComisionesPendientes = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'VerComisionesPendientes'
SELECT @BloquearEncabezadoVenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearEncabezadoVenta'
SELECT @BloquearCxcCtaDinero = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearCxcCtaDinero'
SELECT @BloquearCxpCtaDinero = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearCxpCtaDinero'
SELECT @BloquearDineroCtaDinero = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearDineroCtaDinero'
SELECT @EnviarExcel = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EnviarExcel'
SELECT @ImprimirMovs = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ImprimirMovs'
SELECT @PreliminarMovs = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PreliminarMovs'
SELECT @Reservar = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Reservar'
SELECT @DesReservar = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DesReservar'
SELECT @Asignar = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Asignar'
SELECT @DesAsignar = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DesAsignar'
SELECT @ModificarAlmacenPedidos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarAlmacenPedidos'
SELECT @ModificarConceptos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarConceptos'
SELECT @ModificarReferenciasSiempre = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarReferenciasSiempre'
SELECT @ModificarAgenteCxcPendiente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarAgenteCxcPendiente'
SELECT @ModificarMovsNominaVigentes = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarMovsNominaVigentes'
SELECT @BloquearPrecios = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearPrecios'
SELECT @BloquearDescGlobal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearDescGlobal'
SELECT @BloquearDescLinea = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearDescLinea'
SELECT @BloquearCondiciones = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearCondiciones'
SELECT @BloquearAlmacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearAlmacen'
SELECT @BloquearMoneda = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearMoneda'
SELECT @BloquearAgente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearAgente'
SELECT @BloquearFechaEmision = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearFechaEmision'
SELECT @BloquearProyecto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearProyecto'
SELECT @BloquearFormaPago = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearFormaPago'
SELECT @Oficina = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Oficina'
SELECT @DefArtTipo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DefArtTipo'
SELECT @DefUnidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DefUnidad'
SELECT @AbrirCajon = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AbrirCajon'
SELECT @BloquearCobroInmediato = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearCobroInmediato'
SELECT @ConsultarCompraPendiente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ConsultarCompraPendiente'
SELECT @AccesoTotalCuentas = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AccesoTotalCuentas'
SELECT @Estatus = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Estatus'
SELECT @UltimoCambio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'UltimoCambio'
SELECT @Alta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Alta'
SELECT @Configuracion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Configuracion'
SELECT @Acceso = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Acceso'
SELECT @TieneMovimientos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TieneMovimientos'
SELECT @Refacturar = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Refacturar'
SELECT @DefListaPreciosEsp = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DefListaPreciosEsp'
SELECT @LimiteTableroControl = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'LimiteTableroControl'
SELECT @CteInfo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CteInfo'
SELECT @CteBloquearOtrosDatos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CteBloquearOtrosDatos'
SELECT @ArtBloquearOtrosDatos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ArtBloquearOtrosDatos'
SELECT @CteSucursalVenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CteSucursalVenta'
SELECT @CtaDineroInfo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CtaDineroInfo'
SELECT @ImpresionInmediata = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ImpresionInmediata'
SELECT @MostrarCampos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MostrarCampos'
SELECT @AsistentePrecios = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AsistentePrecios'
SELECT @CambioValidarCobertura = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CambioValidarCobertura'
SELECT @CambioNormatividad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CambioNormatividad'
SELECT @CambioEditarCobertura = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CambioEditarCobertura'
SELECT @CambioVerPosicionEmpresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CambioVerPosicionEmpresa'
SELECT @CambioVerPosicionSucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CambioVerPosicionSucursal'
SELECT @CambioVerPosicionOtraSucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CambioVerPosicionOtraSucursal'
SELECT @CambioAutorizarOperacionLimite = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CambioAutorizarOperacionLimite'
SELECT @AutoDobleCapturaPrecios = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AutoDobleCapturaPrecios'
SELECT @AutoArtGrupo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AutoArtGrupo'
SELECT @AutoAgregarRecaudacionConsumo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AutoAgregarRecaudacionConsumo'
SELECT @AutoDiesel = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AutoDiesel'
SELECT @BloquearActividad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearActividad'
SELECT @UEN = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'UEN'
SELECT @eMail = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'eMail'
SELECT @CteMov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CteMov'
SELECT @CteArt = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CteArt'
SELECT @ProvMov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ProvMov'
SELECT @ArtMov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ArtMov'
SELECT @DefContUso = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DefContUso'
SELECT @BloquearContUso = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearContUso'
SELECT @Observaciones = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Observaciones'
SELECT @TraspasarTodo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TraspasarTodo'
SELECT @BloquearNotasNegativas = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearNotasNegativas'
SELECT @ModificarSerieLoteProp = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarSerieLoteProp'
SELECT @NominaEliminacionParcial = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'NominaEliminacionParcial'
SELECT @ModificarPropiedadesLotes = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarPropiedadesLotes'
SELECT @PVAbrirCajonSiempre = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PVAbrirCajonSiempre'
SELECT @PVBloquearEgresos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PVBloquearEgresos'
SELECT @PVCobrarNotasEstatusBorrador = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PVCobrarNotasEstatusBorrador'
SELECT @PVModificarEstatusBorrador = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PVModificarEstatusBorrador'
SELECT @BloquearPersonalCfg = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearPersonalCfg'
SELECT @BloquearFacturacionDirecta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearFacturacionDirecta'
SELECT @BloquearInvSalidaDirecta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearInvSalidaDirecta'
SELECT @Idioma = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Idioma'
SELECT @ModificarDatosVIN = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarDatosVIN'
SELECT @ModificarDatosCliente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarDatosCliente'
SELECT @CxcExpress = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CxcExpress'
SELECT @CxpExpress = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CxpExpress'
SELECT @Cliente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cliente'
SELECT @SubModuloAtencion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SubModuloAtencion'
SELECT @BloquearCancelarFactura = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearCancelarFactura'
SELECT @CambioPresentacionExpress = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CambioPresentacionExpress'
SELECT @ModificarConsecutivos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarConsecutivos'
SELECT @ModificarVINFechaBaja = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarVINFechaBaja'
SELECT @ModificarVINFechaPago = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarVINFechaPago'
SELECT @ModificarVINAccesorio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarVINAccesorio'
SELECT @PVEditarNota = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PVEditarNota'
SELECT @ModificarDescGlobalImporte = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarDescGlobalImporte'
SELECT @ConsultarClientesOtrosAgentes = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ConsultarClientesOtrosAgentes'
SELECT @ACLCUsoEspecifico = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ACLCUsoEspecifico'
SELECT @ACEditarTablaAmortizacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ACEditarTablaAmortizacion'
SELECT @PlantillasOffice = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PlantillasOffice'
SELECT @ConfigPlantillasOffice = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ConfigPlantillasOffice'
SELECT @ACTasaGrupo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ACTasaGrupo'
SELECT @CambioAgregarBeneficiarios = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CambioAgregarBeneficiarios'
SELECT @AgregarConceptoExpress = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AgregarConceptoExpress'
SELECT @BloquearArtMaterial = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearArtMaterial'
SELECT @InfoPath = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'InfoPath'
SELECT @InfoPathExe = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'InfoPathExe'
SELECT @FEA = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FEA'
SELECT @FEACertificado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FEACertificado'
SELECT @FEALlave = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FEALlave'
SELECT @ContrasenaNuncaExpira = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ContrasenaNuncaExpira'
SELECT @Menu = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Menu'
SELECT @MenuAccesoTotal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MenuAccesoTotal'
SELECT @BloquearPDF = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearPDF'
SELECT @VerificarOrtografia = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'VerificarOrtografia'
SELECT @ContSinOrigen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ContSinOrigen'
SELECT @UnidadOrganizacional = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'UnidadOrganizacional'
SELECT @ProyectoMov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ProyectoMov'
SELECT @CompraDevTodo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CompraDevTodo'
SELECT @BloquearWebContenido = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearWebContenido'
SELECT @BloquearWebHTML = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearWebHTML'
SELECT @DBMailPerfil = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DBMailPerfil'
SELECT @UltimoAcceso = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'UltimoAcceso'
SELECT @BloquearSituacionUsuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BloquearSituacionUsuario'
SELECT @InformacionConfidencial = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'InformacionConfidencial'
SELECT @PerfilForma = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PerfilForma'
SELECT @Licenciamiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Licenciamiento'
SELECT @SituacionArea = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SituacionArea'
SELECT @ModificarTipoImpuesto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModificarTipoImpuesto'
SELECT @AgregarProvExpress = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AgregarProvExpress'
SELECT @ProyMov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ProyMov'
SELECT @Texto =(SELECT * FROM Usuario
WHERE ISNULL(Usuario,'' ) = ISNULL(ISNULL(@Usuario,Usuario),'')
AND ISNULL(Nombre,'' ) = ISNULL(ISNULL(@Nombre,Nombre),'')
AND ISNULL(Sucursal,'' ) = ISNULL(ISNULL(@Sucursal,Sucursal),'')
AND ISNULL(DefEmpresa,'' ) = ISNULL(ISNULL(@DefEmpresa,DefEmpresa),'')
AND ISNULL(GrupoTrabajo,'' ) = ISNULL(ISNULL(@GrupoTrabajo,GrupoTrabajo),'')
AND ISNULL(Departamento,'' ) = ISNULL(ISNULL(@Departamento,Departamento),'')
AND ISNULL(Contrasena,'' ) = ISNULL(ISNULL(@Contrasena,Contrasena),'')
AND ISNULL(ContrasenaConfirmacion,'' ) = ISNULL(ISNULL(@ContrasenaConfirmacion,ContrasenaConfirmacion),'')
AND ISNULL(ContrasenaFecha,'' ) = ISNULL(ISNULL(@ContrasenaFecha,ContrasenaFecha),'')
AND ISNULL(ContrasenaModificar,'' ) = ISNULL(ISNULL(@ContrasenaModificar,ContrasenaModificar),'')
AND ISNULL(Telefono,'' ) = ISNULL(ISNULL(@Telefono,Telefono),'')
AND ISNULL(Extencion,'' ) = ISNULL(ISNULL(@Extencion,Extencion),'')
AND ISNULL(DefAgente,'' ) = ISNULL(ISNULL(@DefAgente,DefAgente),'')
AND ISNULL(DefCajero,'' ) = ISNULL(ISNULL(@DefCajero,DefCajero),'')
AND ISNULL(DefAlmacen,'' ) = ISNULL(ISNULL(@DefAlmacen,DefAlmacen),'')
AND ISNULL(DefAlmacenTrans,'' ) = ISNULL(ISNULL(@DefAlmacenTrans,DefAlmacenTrans),'')
AND ISNULL(DefCtaDinero,'' ) = ISNULL(ISNULL(@DefCtaDinero,DefCtaDinero),'')
AND ISNULL(DefCtaDineroTrans,'' ) = ISNULL(ISNULL(@DefCtaDineroTrans,DefCtaDineroTrans),'')
AND ISNULL(DefMoneda,'' ) = ISNULL(ISNULL(@DefMoneda,DefMoneda),'')
AND ISNULL(DefProyecto,'' ) = ISNULL(ISNULL(@DefProyecto,DefProyecto),'')
AND ISNULL(DefLocalidad,'' ) = ISNULL(ISNULL(@DefLocalidad,DefLocalidad),'')
AND ISNULL(DefCliente,'' ) = ISNULL(ISNULL(@DefCliente,DefCliente),'')
AND ISNULL(DefActividad,'' ) = ISNULL(ISNULL(@DefActividad,DefActividad),'')
AND ISNULL(DefMovVentas,'' ) = ISNULL(ISNULL(@DefMovVentas,DefMovVentas),'')
AND ISNULL(DefZonaImpuesto,'' ) = ISNULL(ISNULL(@DefZonaImpuesto,DefZonaImpuesto),'')
AND ISNULL(DefFormaPago,'' ) = ISNULL(ISNULL(@DefFormaPago,DefFormaPago),'')
AND ISNULL(Afectar,'' ) = ISNULL(ISNULL(@Afectar,Afectar),'')
AND ISNULL(Cancelar,'' ) = ISNULL(ISNULL(@Cancelar,Cancelar),'')
AND ISNULL(Desafectar,'' ) = ISNULL(ISNULL(@Desafectar,Desafectar),'')
AND ISNULL(Autorizar,'' ) = ISNULL(ISNULL(@Autorizar,Autorizar),'')
AND ISNULL(AutorizarVenta,'' ) = ISNULL(ISNULL(@AutorizarVenta,AutorizarVenta),'')
AND ISNULL(AutorizarCxp,'' ) = ISNULL(ISNULL(@AutorizarCxp,AutorizarCxp),'')
AND ISNULL(AutorizarGasto,'' ) = ISNULL(ISNULL(@AutorizarGasto,AutorizarGasto),'')
AND ISNULL(AutorizarDinero,'' ) = ISNULL(ISNULL(@AutorizarDinero,AutorizarDinero),'')
AND ISNULL(AutorizarPV,'' ) = ISNULL(ISNULL(@AutorizarPV,AutorizarPV),'')
AND ISNULL(AutorizarCompra,'' ) = ISNULL(ISNULL(@AutorizarCompra,AutorizarCompra),'')
AND ISNULL(AutorizarGestion,'' ) = ISNULL(ISNULL(@AutorizarGestion,AutorizarGestion),'')
AND ISNULL(AutorizarSeriesLotes,'' ) = ISNULL(ISNULL(@AutorizarSeriesLotes,AutorizarSeriesLotes),'')
AND ISNULL(AfectarOtrosMovs,'' ) = ISNULL(ISNULL(@AfectarOtrosMovs,AfectarOtrosMovs),'')
AND ISNULL(CancelarOtrosMovs,'' ) = ISNULL(ISNULL(@CancelarOtrosMovs,CancelarOtrosMovs),'')
AND ISNULL(ConsultarOtrosMovs,'' ) = ISNULL(ISNULL(@ConsultarOtrosMovs,ConsultarOtrosMovs),'')
AND ISNULL(ConsultarOtrosMovsGrupo,'' ) = ISNULL(ISNULL(@ConsultarOtrosMovsGrupo,ConsultarOtrosMovsGrupo),'')
AND ISNULL(ConsultarOtrasEmpresas,'' ) = ISNULL(ISNULL(@ConsultarOtrasEmpresas,ConsultarOtrasEmpresas),'')
AND ISNULL(ConsultarOtrasSucursales,'' ) = ISNULL(ISNULL(@ConsultarOtrasSucursales,ConsultarOtrasSucursales),'')
AND ISNULL(AccesarOtrasSucursalesEnLinea,'' ) = ISNULL(ISNULL(@AccesarOtrasSucursalesEnLinea,AccesarOtrasSucursalesEnLinea),'')
AND ISNULL(AfectarOtrasSucursalesEnLinea,'' ) = ISNULL(ISNULL(@AfectarOtrasSucursalesEnLinea,AfectarOtrasSucursalesEnLinea),'')
AND ISNULL(ModificarOtrosMovs,'' ) = ISNULL(ISNULL(@ModificarOtrosMovs,ModificarOtrosMovs),'')
AND ISNULL(ModificarVencimientos,'' ) = ISNULL(ISNULL(@ModificarVencimientos,ModificarVencimientos),'')
AND ISNULL(ModificarEntregas,'' ) = ISNULL(ISNULL(@ModificarEntregas,ModificarEntregas),'')
AND ISNULL(ModificarFechaRequerida,'' ) = ISNULL(ISNULL(@ModificarFechaRequerida,ModificarFechaRequerida),'')
AND ISNULL(ModificarEnvios,'' ) = ISNULL(ISNULL(@ModificarEnvios,ModificarEnvios),'')
AND ISNULL(ModificarReferencias,'' ) = ISNULL(ISNULL(@ModificarReferencias,ModificarReferencias),'')
AND ISNULL(ModificarAlmacenEntregas,'' ) = ISNULL(ISNULL(@ModificarAlmacenEntregas,ModificarAlmacenEntregas),'')
AND ISNULL(ModificarSituacion,'' ) = ISNULL(ISNULL(@ModificarSituacion,ModificarSituacion),'')
AND ISNULL(ModificarAgente,'' ) = ISNULL(ISNULL(@ModificarAgente,ModificarAgente),'')
AND ISNULL(ModificarUsuario,'' ) = ISNULL(ISNULL(@ModificarUsuario,ModificarUsuario),'')
AND ISNULL(ModificarListaPrecios,'' ) = ISNULL(ISNULL(@ModificarListaPrecios,ModificarListaPrecios),'')
AND ISNULL(ModificarZonaImpuesto,'' ) = ISNULL(ISNULL(@ModificarZonaImpuesto,ModificarZonaImpuesto),'')
AND ISNULL(ModificarSucursalDestino,'' ) = ISNULL(ISNULL(@ModificarSucursalDestino,ModificarSucursalDestino),'')
AND ISNULL(ModificarProyUENActCC,'' ) = ISNULL(ISNULL(@ModificarProyUENActCC,ModificarProyUENActCC),'')
AND ISNULL(AgregarCteExpress,'' ) = ISNULL(ISNULL(@AgregarCteExpress,AgregarCteExpress),'')
AND ISNULL(AgregarArtExpress,'' ) = ISNULL(ISNULL(@AgregarArtExpress,AgregarArtExpress),'')
AND ISNULL(Costos,'' ) = ISNULL(ISNULL(@Costos,Costos),'')
AND ISNULL(BloquearCostos,'' ) = ISNULL(ISNULL(@BloquearCostos,BloquearCostos),'')
AND ISNULL(VerInfoDeudores,'' ) = ISNULL(ISNULL(@VerInfoDeudores,VerInfoDeudores),'')
AND ISNULL(VerInfoAcreedores,'' ) = ISNULL(ISNULL(@VerInfoAcreedores,VerInfoAcreedores),'')
AND ISNULL(VerComisionesPendientes,'' ) = ISNULL(ISNULL(@VerComisionesPendientes,VerComisionesPendientes),'')
AND ISNULL(BloquearEncabezadoVenta,'' ) = ISNULL(ISNULL(@BloquearEncabezadoVenta,BloquearEncabezadoVenta),'')
AND ISNULL(BloquearCxcCtaDinero,'' ) = ISNULL(ISNULL(@BloquearCxcCtaDinero,BloquearCxcCtaDinero),'')
AND ISNULL(BloquearCxpCtaDinero,'' ) = ISNULL(ISNULL(@BloquearCxpCtaDinero,BloquearCxpCtaDinero),'')
AND ISNULL(BloquearDineroCtaDinero,'' ) = ISNULL(ISNULL(@BloquearDineroCtaDinero,BloquearDineroCtaDinero),'')
AND ISNULL(EnviarExcel,'' ) = ISNULL(ISNULL(@EnviarExcel,EnviarExcel),'')
AND ISNULL(ImprimirMovs,'' ) = ISNULL(ISNULL(@ImprimirMovs,ImprimirMovs),'')
AND ISNULL(PreliminarMovs,'' ) = ISNULL(ISNULL(@PreliminarMovs,PreliminarMovs),'')
AND ISNULL(Reservar,'' ) = ISNULL(ISNULL(@Reservar,Reservar),'')
AND ISNULL(DesReservar,'' ) = ISNULL(ISNULL(@DesReservar,DesReservar),'')
AND ISNULL(Asignar,'' ) = ISNULL(ISNULL(@Asignar,Asignar),'')
AND ISNULL(DesAsignar,'' ) = ISNULL(ISNULL(@DesAsignar,DesAsignar),'')
AND ISNULL(ModificarAlmacenPedidos,'' ) = ISNULL(ISNULL(@ModificarAlmacenPedidos,ModificarAlmacenPedidos),'')
AND ISNULL(ModificarConceptos,'' ) = ISNULL(ISNULL(@ModificarConceptos,ModificarConceptos),'')
AND ISNULL(ModificarReferenciasSiempre,'' ) = ISNULL(ISNULL(@ModificarReferenciasSiempre,ModificarReferenciasSiempre),'')
AND ISNULL(ModificarAgenteCxcPendiente,'' ) = ISNULL(ISNULL(@ModificarAgenteCxcPendiente,ModificarAgenteCxcPendiente),'')
AND ISNULL(ModificarMovsNominaVigentes,'' ) = ISNULL(ISNULL(@ModificarMovsNominaVigentes,ModificarMovsNominaVigentes),'')
AND ISNULL(BloquearPrecios,'' ) = ISNULL(ISNULL(@BloquearPrecios,BloquearPrecios),'')
AND ISNULL(BloquearDescGlobal,'' ) = ISNULL(ISNULL(@BloquearDescGlobal,BloquearDescGlobal),'')
AND ISNULL(BloquearDescLinea,'' ) = ISNULL(ISNULL(@BloquearDescLinea,BloquearDescLinea),'')
AND ISNULL(BloquearCondiciones,'' ) = ISNULL(ISNULL(@BloquearCondiciones,BloquearCondiciones),'')
AND ISNULL(BloquearAlmacen,'' ) = ISNULL(ISNULL(@BloquearAlmacen,BloquearAlmacen),'')
AND ISNULL(BloquearMoneda,'' ) = ISNULL(ISNULL(@BloquearMoneda,BloquearMoneda),'')
AND ISNULL(BloquearAgente,'' ) = ISNULL(ISNULL(@BloquearAgente,BloquearAgente),'')
AND ISNULL(BloquearFechaEmision,'' ) = ISNULL(ISNULL(@BloquearFechaEmision,BloquearFechaEmision),'')
AND ISNULL(BloquearProyecto,'' ) = ISNULL(ISNULL(@BloquearProyecto,BloquearProyecto),'')
AND ISNULL(BloquearFormaPago,'' ) = ISNULL(ISNULL(@BloquearFormaPago,BloquearFormaPago),'')
AND ISNULL(Oficina,'' ) = ISNULL(ISNULL(@Oficina,Oficina),'')
AND ISNULL(DefArtTipo,'' ) = ISNULL(ISNULL(@DefArtTipo,DefArtTipo),'')
AND ISNULL(DefUnidad,'' ) = ISNULL(ISNULL(@DefUnidad,DefUnidad),'')
AND ISNULL(AbrirCajon,'' ) = ISNULL(ISNULL(@AbrirCajon,AbrirCajon),'')
AND ISNULL(BloquearCobroInmediato,'' ) = ISNULL(ISNULL(@BloquearCobroInmediato,BloquearCobroInmediato),'')
AND ISNULL(ConsultarCompraPendiente,'' ) = ISNULL(ISNULL(@ConsultarCompraPendiente,ConsultarCompraPendiente),'')
AND ISNULL(AccesoTotalCuentas,'' ) = ISNULL(ISNULL(@AccesoTotalCuentas,AccesoTotalCuentas),'')
AND ISNULL(Estatus,'' ) = ISNULL(ISNULL(@Estatus,Estatus),'')
AND ISNULL(UltimoCambio,'' ) = ISNULL(ISNULL(@UltimoCambio,UltimoCambio),'')
AND ISNULL(Alta,'' ) = ISNULL(ISNULL(@Alta,Alta),'')
AND ISNULL(Configuracion,'' ) = ISNULL(ISNULL(@Configuracion,Configuracion),'')
AND ISNULL(Acceso,'' ) = ISNULL(ISNULL(@Acceso,Acceso),'')
AND ISNULL(TieneMovimientos,'' ) = ISNULL(ISNULL(@TieneMovimientos,TieneMovimientos),'')
AND ISNULL(Refacturar,'' ) = ISNULL(ISNULL(@Refacturar,Refacturar),'')
AND ISNULL(DefListaPreciosEsp,'' ) = ISNULL(ISNULL(@DefListaPreciosEsp,DefListaPreciosEsp),'')
AND ISNULL(LimiteTableroControl,'' ) = ISNULL(ISNULL(@LimiteTableroControl,LimiteTableroControl),'')
AND ISNULL(CteInfo,'' ) = ISNULL(ISNULL(@CteInfo,CteInfo),'')
AND ISNULL(CteBloquearOtrosDatos,'' ) = ISNULL(ISNULL(@CteBloquearOtrosDatos,CteBloquearOtrosDatos),'')
AND ISNULL(ArtBloquearOtrosDatos,'' ) = ISNULL(ISNULL(@ArtBloquearOtrosDatos,ArtBloquearOtrosDatos),'')
AND ISNULL(CteSucursalVenta,'' ) = ISNULL(ISNULL(@CteSucursalVenta,CteSucursalVenta),'')
AND ISNULL(CtaDineroInfo,'' ) = ISNULL(ISNULL(@CtaDineroInfo,CtaDineroInfo),'')
AND ISNULL(ImpresionInmediata,'' ) = ISNULL(ISNULL(@ImpresionInmediata,ImpresionInmediata),'')
AND ISNULL(MostrarCampos,'' ) = ISNULL(ISNULL(@MostrarCampos,MostrarCampos),'')
AND ISNULL(AsistentePrecios,'' ) = ISNULL(ISNULL(@AsistentePrecios,AsistentePrecios),'')
AND ISNULL(CambioValidarCobertura,'' ) = ISNULL(ISNULL(@CambioValidarCobertura,CambioValidarCobertura),'')
AND ISNULL(CambioNormatividad,'' ) = ISNULL(ISNULL(@CambioNormatividad,CambioNormatividad),'')
AND ISNULL(CambioEditarCobertura,'' ) = ISNULL(ISNULL(@CambioEditarCobertura,CambioEditarCobertura),'')
AND ISNULL(CambioVerPosicionEmpresa,'' ) = ISNULL(ISNULL(@CambioVerPosicionEmpresa,CambioVerPosicionEmpresa),'')
AND ISNULL(CambioVerPosicionSucursal,'' ) = ISNULL(ISNULL(@CambioVerPosicionSucursal,CambioVerPosicionSucursal),'')
AND ISNULL(CambioVerPosicionOtraSucursal,'' ) = ISNULL(ISNULL(@CambioVerPosicionOtraSucursal,CambioVerPosicionOtraSucursal),'')
AND ISNULL(CambioAutorizarOperacionLimite,'' ) = ISNULL(ISNULL(@CambioAutorizarOperacionLimite,CambioAutorizarOperacionLimite),'')
AND ISNULL(AutoDobleCapturaPrecios,'' ) = ISNULL(ISNULL(@AutoDobleCapturaPrecios,AutoDobleCapturaPrecios),'')
AND ISNULL(AutoArtGrupo,'' ) = ISNULL(ISNULL(@AutoArtGrupo,AutoArtGrupo),'')
AND ISNULL(AutoAgregarRecaudacionConsumo,'' ) = ISNULL(ISNULL(@AutoAgregarRecaudacionConsumo,AutoAgregarRecaudacionConsumo),'')
AND ISNULL(AutoDiesel,'' ) = ISNULL(ISNULL(@AutoDiesel,AutoDiesel),'')
AND ISNULL(BloquearActividad,'' ) = ISNULL(ISNULL(@BloquearActividad,BloquearActividad),'')
AND ISNULL(UEN,'' ) = ISNULL(ISNULL(@UEN,UEN),'')
AND ISNULL(eMail,'' ) = ISNULL(ISNULL(@eMail,eMail),'')
AND ISNULL(CteMov,'' ) = ISNULL(ISNULL(@CteMov,CteMov),'')
AND ISNULL(CteArt,'' ) = ISNULL(ISNULL(@CteArt,CteArt),'')
AND ISNULL(ProvMov,'' ) = ISNULL(ISNULL(@ProvMov,ProvMov),'')
AND ISNULL(ArtMov,'' ) = ISNULL(ISNULL(@ArtMov,ArtMov),'')
AND ISNULL(DefContUso,'' ) = ISNULL(ISNULL(@DefContUso,DefContUso),'')
AND ISNULL(BloquearContUso,'' ) = ISNULL(ISNULL(@BloquearContUso,BloquearContUso),'')
AND ISNULL(Observaciones,'' ) = ISNULL(ISNULL(@Observaciones,Observaciones),'')
AND ISNULL(TraspasarTodo,'' ) = ISNULL(ISNULL(@TraspasarTodo,TraspasarTodo),'')
AND ISNULL(BloquearNotasNegativas,'' ) = ISNULL(ISNULL(@BloquearNotasNegativas,BloquearNotasNegativas),'')
AND ISNULL(ModificarSerieLoteProp,'' ) = ISNULL(ISNULL(@ModificarSerieLoteProp,ModificarSerieLoteProp),'')
AND ISNULL(NominaEliminacionParcial,'' ) = ISNULL(ISNULL(@NominaEliminacionParcial,NominaEliminacionParcial),'')
AND ISNULL(ModificarPropiedadesLotes,'' ) = ISNULL(ISNULL(@ModificarPropiedadesLotes,ModificarPropiedadesLotes),'')
AND ISNULL(PVAbrirCajonSiempre,'' ) = ISNULL(ISNULL(@PVAbrirCajonSiempre,PVAbrirCajonSiempre),'')
AND ISNULL(PVBloquearEgresos,'' ) = ISNULL(ISNULL(@PVBloquearEgresos,PVBloquearEgresos),'')
AND ISNULL(PVCobrarNotasEstatusBorrador,'' ) = ISNULL(ISNULL(@PVCobrarNotasEstatusBorrador,PVCobrarNotasEstatusBorrador),'')
AND ISNULL(PVModificarEstatusBorrador,'' ) = ISNULL(ISNULL(@PVModificarEstatusBorrador,PVModificarEstatusBorrador),'')
AND ISNULL(BloquearPersonalCfg,'' ) = ISNULL(ISNULL(@BloquearPersonalCfg,BloquearPersonalCfg),'')
AND ISNULL(BloquearFacturacionDirecta,'' ) = ISNULL(ISNULL(@BloquearFacturacionDirecta,BloquearFacturacionDirecta),'')
AND ISNULL(BloquearInvSalidaDirecta,'' ) = ISNULL(ISNULL(@BloquearInvSalidaDirecta,BloquearInvSalidaDirecta),'')
AND ISNULL(Idioma,'' ) = ISNULL(ISNULL(@Idioma,Idioma),'')
AND ISNULL(ModificarDatosVIN,'' ) = ISNULL(ISNULL(@ModificarDatosVIN,ModificarDatosVIN),'')
AND ISNULL(ModificarDatosCliente,'' ) = ISNULL(ISNULL(@ModificarDatosCliente,ModificarDatosCliente),'')
AND ISNULL(CxcExpress,'' ) = ISNULL(ISNULL(@CxcExpress,CxcExpress),'')
AND ISNULL(CxpExpress,'' ) = ISNULL(ISNULL(@CxpExpress,CxpExpress),'')
AND ISNULL(Cliente,'' ) = ISNULL(ISNULL(@Cliente,Cliente),'')
AND ISNULL(SubModuloAtencion,'' ) = ISNULL(ISNULL(@SubModuloAtencion,SubModuloAtencion),'')
AND ISNULL(BloquearCancelarFactura,'' ) = ISNULL(ISNULL(@BloquearCancelarFactura,BloquearCancelarFactura),'')
AND ISNULL(CambioPresentacionExpress,'' ) = ISNULL(ISNULL(@CambioPresentacionExpress,CambioPresentacionExpress),'')
AND ISNULL(ModificarConsecutivos,'' ) = ISNULL(ISNULL(@ModificarConsecutivos,ModificarConsecutivos),'')
AND ISNULL(ModificarVINFechaBaja,'' ) = ISNULL(ISNULL(@ModificarVINFechaBaja,ModificarVINFechaBaja),'')
AND ISNULL(ModificarVINFechaPago,'' ) = ISNULL(ISNULL(@ModificarVINFechaPago,ModificarVINFechaPago),'')
AND ISNULL(ModificarVINAccesorio,'' ) = ISNULL(ISNULL(@ModificarVINAccesorio,ModificarVINAccesorio),'')
AND ISNULL(PVEditarNota,'' ) = ISNULL(ISNULL(@PVEditarNota,PVEditarNota),'')
AND ISNULL(ModificarDescGlobalImporte,'' ) = ISNULL(ISNULL(@ModificarDescGlobalImporte,ModificarDescGlobalImporte),'')
AND ISNULL(ConsultarClientesOtrosAgentes,'' ) = ISNULL(ISNULL(@ConsultarClientesOtrosAgentes,ConsultarClientesOtrosAgentes),'')
AND ISNULL(ACLCUsoEspecifico,'' ) = ISNULL(ISNULL(@ACLCUsoEspecifico,ACLCUsoEspecifico),'')
AND ISNULL(ACEditarTablaAmortizacion,'' ) = ISNULL(ISNULL(@ACEditarTablaAmortizacion,ACEditarTablaAmortizacion),'')
AND ISNULL(PlantillasOffice,'' ) = ISNULL(ISNULL(@PlantillasOffice,PlantillasOffice),'')
AND ISNULL(ConfigPlantillasOffice,'' ) = ISNULL(ISNULL(@ConfigPlantillasOffice,ConfigPlantillasOffice),'')
AND ISNULL(ACTasaGrupo,'' ) = ISNULL(ISNULL(@ACTasaGrupo,ACTasaGrupo),'')
AND ISNULL(CambioAgregarBeneficiarios,'' ) = ISNULL(ISNULL(@CambioAgregarBeneficiarios,CambioAgregarBeneficiarios),'')
AND ISNULL(AgregarConceptoExpress,'' ) = ISNULL(ISNULL(@AgregarConceptoExpress,AgregarConceptoExpress),'')
AND ISNULL(BloquearArtMaterial,'' ) = ISNULL(ISNULL(@BloquearArtMaterial,BloquearArtMaterial),'')
AND ISNULL(InfoPath,'' ) = ISNULL(ISNULL(@InfoPath,InfoPath),'')
AND ISNULL(InfoPathExe,'' ) = ISNULL(ISNULL(@InfoPathExe,InfoPathExe),'')
AND ISNULL(FEA,'' ) = ISNULL(ISNULL(@FEA,FEA),'')
AND ISNULL(FEACertificado,'' ) = ISNULL(ISNULL(@FEACertificado,FEACertificado),'')
AND ISNULL(FEALlave,'' ) = ISNULL(ISNULL(@FEALlave,FEALlave),'')
AND ISNULL(ContrasenaNuncaExpira,'' ) = ISNULL(ISNULL(@ContrasenaNuncaExpira,ContrasenaNuncaExpira),'')
AND ISNULL(Menu,'' ) = ISNULL(ISNULL(@Menu,Menu),'')
AND ISNULL(MenuAccesoTotal,'' ) = ISNULL(ISNULL(@MenuAccesoTotal,MenuAccesoTotal),'')
AND ISNULL(BloquearPDF,'' ) = ISNULL(ISNULL(@BloquearPDF,BloquearPDF),'')
AND ISNULL(VerificarOrtografia,'' ) = ISNULL(ISNULL(@VerificarOrtografia,VerificarOrtografia),'')
AND ISNULL(ContSinOrigen,'' ) = ISNULL(ISNULL(@ContSinOrigen,ContSinOrigen),'')
AND ISNULL(UnidadOrganizacional,'' ) = ISNULL(ISNULL(@UnidadOrganizacional,UnidadOrganizacional),'')
AND ISNULL(ProyectoMov,'' ) = ISNULL(ISNULL(@ProyectoMov,ProyectoMov),'')
AND ISNULL(CompraDevTodo,'' ) = ISNULL(ISNULL(@CompraDevTodo,CompraDevTodo),'')
AND ISNULL(BloquearWebContenido,'' ) = ISNULL(ISNULL(@BloquearWebContenido,BloquearWebContenido),'')
AND ISNULL(BloquearWebHTML,'' ) = ISNULL(ISNULL(@BloquearWebHTML,BloquearWebHTML),'')
AND ISNULL(DBMailPerfil,'' ) = ISNULL(ISNULL(@DBMailPerfil,DBMailPerfil),'')
AND ISNULL(UltimoAcceso,'' ) = ISNULL(ISNULL(@UltimoAcceso,UltimoAcceso),'')
AND ISNULL(BloquearSituacionUsuario,'' ) = ISNULL(ISNULL(@BloquearSituacionUsuario,BloquearSituacionUsuario),'')
AND ISNULL(InformacionConfidencial,'' ) = ISNULL(ISNULL(@InformacionConfidencial,InformacionConfidencial),'')
AND ISNULL(PerfilForma,'' ) = ISNULL(ISNULL(@PerfilForma,PerfilForma),'')
AND ISNULL(Licenciamiento,'' ) = ISNULL(ISNULL(@Licenciamiento,Licenciamiento),'')
AND ISNULL(SituacionArea,'' ) = ISNULL(ISNULL(@SituacionArea,SituacionArea),'')
AND ISNULL(ModificarTipoImpuesto,'' ) = ISNULL(ISNULL(@ModificarTipoImpuesto,ModificarTipoImpuesto),'')
AND ISNULL(AgregarProvExpress,'' ) = ISNULL(ISNULL(@AgregarProvExpress,AgregarProvExpress),'')
AND ISNULL(ProyMov,'' ) = ISNULL(ISNULL(@ProyMov,ProyMov),'')
FOR XML AUTO)
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),@Texto) + '</Resultado></Intelisis>'
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

