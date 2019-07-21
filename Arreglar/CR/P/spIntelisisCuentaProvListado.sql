SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisCuentaProvListado
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Proveedor				varchar(10),
@Rama					varchar(20),
@Nombre 				varchar(100),
@NombreCorto            varchar(20),
@Direccion				varchar(100),
@DireccionNumero		varchar(20),
@DireccionNumeroInt		varchar(20),
@Colonia     			varchar(100),
@Delegacion				varchar(100),
@Poblacion				varchar(100),
@Estado					varchar(30),
@Pais					varchar(30),
@CodigoPostal 			varchar(15),
@Grupo      			varchar(50),
@Categoria     			varchar(50),
@Familia     			varchar(50),
@Zona        			varchar(30),
@Ruta       			varchar(50),
@Tipo       			varchar(15),
@Sucursal     			int,
@Estatus    			varchar(15),
@DefMoneda				varchar(10),
@FormaPago				varchar(50),
@Alta       			datetime,
@Cuenta					varchar(20),
@Texto					xml,
@ReferenciaIS			varchar(100),
@SubReferencia			varchar(100)
SELECT @Proveedor = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Proveedor'
SELECT @Rama = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Rama'
SELECT @Nombre = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Nombre'
SELECT @NombreCorto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'NombreCorto'
SELECT @Direccion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Direccion'
SELECT @DireccionNumero = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DireccionNumero'
SELECT @DireccionNumeroInt = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DireccionNumeroInt'
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
SELECT @Categoria = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Categoria'
SELECT @Zona = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Zona'
SELECT @Ruta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Ruta'
SELECT @Tipo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tipo'
SELECT @Estatus = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Estatus'
SELECT @DefMoneda = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DefMoneda'
SELECT @FormaPago = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FormaPago'
SELECT @Alta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Alta'
SELECT @Cuenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cuenta'
SELECT @Texto =(SELECT
ISNULL(Proveedor, '') [Proveedor],
ISNULL(Rama, '') [Rama],
ISNULL(Nombre, '') [Nombre],
ISNULL(NombreCorto, '') [NombreCorto],
ISNULL(Direccion, '') [Direccion],
ISNULL(DireccionNumero, '') [DireccionNumero],
ISNULL(DireccionNumeroInt, '') [DireccionNumeroInt],
ISNULL(EntreCalles, '') [EntreCalles],
ISNULL(Plano, '') [Plano],
ISNULL(Observaciones, '') [Observaciones],
ISNULL(Delegacion, '') [Delegacion],
ISNULL(Colonia, '') [Colonia],
ISNULL(Poblacion, '') [Poblacion],
ISNULL(Estado, '') [Estado],
ISNULL(Zona, '') [Zona],
ISNULL(Ruta, '') [Ruta],
ISNULL(Pais, '') [Pais],
ISNULL(CodigoPostal, '') [CodigoPostal],
ISNULL(Telefonos, '') [Telefonos],
ISNULL(Fax, '') [Fax],
ISNULL(PedirTono, 0) [PedirTono],
ISNULL(DirInternet, '') [DirInternet],
ISNULL(Contacto1, '') [Contacto1],
ISNULL(Contacto2, '') [Contacto2],
ISNULL(Extencion1, '') [Extencion1],
ISNULL(Extencion2, '') [Extencion2],
ISNULL(eMail1, '') [eMail1],
ISNULL(eMail2, '') [eMail2],
ISNULL(RFC, '') [RFC],
ISNULL(CURP, '') [CURP],
ISNULL(Categoria, '') [Categoria],
ISNULL(Familia, '') [Familia],
ISNULL(ZonaImpuesto, '') [ZonaImpuesto],
ISNULL(FormaEnvio, '') [FormaEnvio],
ISNULL(Descuento, '') [Descuento],
ISNULL(Comprador, '') [Comprador],
ISNULL(Proyecto, '') [Proyecto],
ISNULL(Condicion, '') [Condicion],
ISNULL(CtaDinero, '') [CtaDinero],
ISNULL(Almacen, '') [Almacen],
ISNULL(DiaRevision1, '') [DiaRevision1],
ISNULL(DiaRevision2, '') [DiaRevision2],
ISNULL(HorarioRevision, '') [HorarioRevision],
ISNULL(DiaPago1, '') [DiaPago1],
ISNULL(DiaPago2, '') [DiaPago2],
ISNULL(HorarioPago, '') [HorarioPago],
ISNULL(Beneficiario, 0) [Beneficiario],
ISNULL(BeneficiarioNombre, '') [BeneficiarioNombre],
ISNULL(LeyendaCheque, '') [LeyendaCheque],
ISNULL(Agente, '') [Agente],
ISNULL(Situacion, '') [Situacion],
[SituacionFecha],
ISNULL(SituacionUsuario, '') [SituacionUsuario],
ISNULL(SituacionNota, '') [SituacionNota],
ISNULL(Clase, '') [Clase],
ISNULL(Estatus, '') [Estatus],
[UltimoCambio],
[Alta],
ISNULL(Conciliar, 0) [Conciliar],
ISNULL(Mensaje, '') [Mensaje],
ISNULL(Tipo, '') [Tipo],
ISNULL(ProntoPago, 0) [ProntoPago],
ISNULL(DefMoneda, '') [DefMoneda],
ISNULL(ProvBancoSucursal, '') [ProvBancoSucursal],
ISNULL(ProvCuenta, '') [ProvCuenta],
ISNULL(Logico1, 0) [Logico1],
ISNULL(Logico2, 0) [Logico2],
ISNULL(Logico3, 0) [Logico3],
ISNULL(TieneMovimientos, 0) [TieneMovimientos],
ISNULL(DescuentoRecargos, 0) [DescuentoRecargos],
ISNULL(CompraAutoCargosTipo, '') [CompraAutoCargosTipo],
ISNULL(CompraAutoCargos, 0) [CompraAutoCargos],
ISNULL(Pagares, 0) [Pagares],
ISNULL(Aforo, 0) [Aforo],
ISNULL(MaximoAplicacionPagos, 0) [MaximoAplicacionPagos],
ISNULL(NivelAcceso, '') [NivelAcceso],
ISNULL(Idioma, '') [Idioma],
ISNULL(ListaPreciosEsp, '') [ListaPreciosEsp],
ISNULL(Contrasena, '') [Contrasena],
ISNULL(AutoEndoso, '') [AutoEndoso],
ISNULL(Cuenta, '') [Cuenta],
ISNULL(CuentaRetencion, '') [CuentaRetencion],
ISNULL(FormaPago, '') [FormaPago],
ISNULL(wGastoSolicitud, 0) [wGastoSolicitud],
ISNULL(ConLimiteAnticipos, 0) [ConLimiteAnticipos],
ISNULL(LimiteAnticiposMN, 0) [LimiteAnticiposMN],
ISNULL(ChecarLimite, '') [ChecarLimite],
ISNULL(eMailAuto, 0) [eMailAuto],
ISNULL(FiscalRegimen, '') [FiscalRegimen],
ISNULL(FiscalZona, '') [FiscalZona],
ISNULL(Intercompania, 0) [Intercompania],
ISNULL(GarantiaCostos, 0) [GarantiaCostos],
ISNULL(GarantiaCostosPlazo, 0) [GarantiaCostosPlazo],
ISNULL(ImportadorRegimen, '') [ImportadorRegimen],
ISNULL(ImportadorRegistro, '') [ImportadorRegistro],
ISNULL(Comision, 0) [Comision],
ISNULL(Importe1, 0) [Importe1],
ISNULL(Importe2, 0) [Importe2],
ISNULL(Origen, '') [Origen],
ISNULL(OrigenID, '') [OrigenID],
ISNULL(MapaLatitud, 0) [MapaLatitud],
ISNULL(MapaLongitud, 0) [MapaLongitud],
ISNULL(MapaPrecision, 0) [MapaPrecision],
ISNULL(TipoRegistro, '') [TipoRegistro],
ISNULL(AutorizacionSRI, '') [AutorizacionSRI],
[VigenciaSRI],
ISNULL(FiscalGenerar, 0) [FiscalGenerar],
[SincroID],
ISNULL(SincroC, 0) [SincroC],
ISNULL(INFORTallerExterior, 0) [INFORTallerExterior],
ISNULL(INFORProveedorNal, 0) [INFORProveedorNal],
ISNULL(ReferenciaIntelisisService, '') [ReferenciaIntelisisService]
FROM Prov
WHERE ISNULL(Proveedor,'') = ISNULL(ISNULL(@Proveedor,Proveedor),'')
AND ISNULL(Rama,'') = ISNULL(ISNULL(@Rama,Rama),'')
AND ISNULL(Nombre,'') = ISNULL(ISNULL(@Nombre,Nombre),'')
AND ISNULL(NombreCorto,'') = ISNULL(ISNULL(@NombreCorto,NombreCorto),'')
AND ISNULL(Colonia,'') = ISNULL(ISNULL(@Colonia,Colonia),'')
AND ISNULL(Delegacion,'') =	ISNULL(ISNULL(@Delegacion,Delegacion),'')
AND ISNULL(Poblacion,'')  =	ISNULL(ISNULL(@Poblacion,Poblacion),'')
AND ISNULL(Estado,'') =	ISNULL(ISNULL(@Estado,Estado),'')
AND ISNULL(Pais,'') =	ISNULL(ISNULL(@Pais,Pais),'')
AND ISNULL(CodigoPostal,'') = ISNULL(ISNULL(@CodigoPostal,CodigoPostal),'')
AND ISNULL(Categoria,'') = ISNULL(ISNULL(@Categoria,Categoria),'')
AND ISNULL(Zona,'') = ISNULL(ISNULL(@Zona,Zona),'')
AND ISNULL(Ruta,'') = ISNULL(ISNULL(@Ruta,Ruta),'')
AND ISNULL(Tipo,'') = ISNULL(ISNULL(@Tipo,Tipo),'')
AND ISNULL(Estatus,'') = ISNULL(ISNULL(@Estatus,Estatus),'')
AND ISNULL(DefMoneda,'') = ISNULL(ISNULL(@DefMoneda,DefMoneda),'')
AND ISNULL(FormaPago,'') = ISNULL(ISNULL(@FormaPago,FormaPago),'')
AND ISNULL(Alta,'') = ISNULL(ISNULL(@Alta,Alta),'')
AND ISNULL(Cuenta,'') =ISNULL(ISNULL(@Cuenta,Cuenta),'')
FOR XML AUTO)
IF @@ERROR <> 0 SET @Ok = 1
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
SELECT @Resultado =REPLACE( '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),@Texto) + '</Resultado></Intelisis>','Ñ','N')
IF @@ERROR <> 0 SET @Ok = 1
END
END
END

