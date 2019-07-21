SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisCuentaEmpresaListado
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa			    varchar(5),
@Nombre                 varchar(100),
@Grupo                  varchar(100),
@Direccion              varchar(100),
@DireccionNumero        varchar(20),
@DireccionNumeroInt     varchar(20),
@Colonia                varchar(30),
@Poblacion              varchar(30),
@Estado                 varchar(30),
@Pais                   varchar(30),
@CodigoPostal           varchar(15),
@Telefonos              varchar(100),
@Fax                    varchar(50),
@Encabezado1            varchar(255),
@Encabezado2            varchar(255),
@Estatus                varchar(15),
@UltimoCambio           datetime   ,
@UltimaCorrida          datetime   ,
@Alta                   datetime   ,
@RFC                    varchar(20),
@RegistroPatronal       varchar(20),
@ClaveActividad         varchar(20),
@Representante          varchar(100),
@RepresentanteRFC       varchar(20),
@RepresentanteCURP      varchar(20),
@Zona                   varchar(50),
@Numero                 int   ,
@TieneMovimientos       bit   ,
@CambioBloquear         bit   ,
@Controladora           varchar(5),
@FactorIntegracion      float   ,
@Tipo                   varchar(20),
@ImportadorRegimen      varchar(30),
@ImportadorRegistro     varchar(30),
@ImportadorFechaD       datetime   ,
@ImportadorFechaA       datetime   ,
@Delegacion             varchar(100),
@GLN                    varchar(50),
@CFD                    bit   ,
@CFD_noCertificado      varchar(20),
@CFD_version            varchar(10),
@CFD_versionFecha       datetime   ,
@CFD_versionAnterior    varchar(10),
@CFD_EAN13              varchar(20),
@CFD_DUN14              varchar(20),
@CFD_SKU                varchar(20),
@CFD_SKUCodigoInterno   bit   ,
@CFD_Llave              varchar(255),
@CFD_Certificado        varchar(255),
@CFD_ContrasenaSello    varchar(100),
@FiscalRegimen          varchar(30),
@Organizacion           int   ,
@TipoRegistro           varchar(20),
@IdentificacionRepresentante   varchar(20),
@Contador               varchar(20),
@RFCContador            varchar(15),
@EsEcuador              bit   ,
@EsGuatemala            bit   ,
@GtImporteMinimoSinRetencion   float   ,
@EsColombia             bit   ,
@LongitudEstablecimiento   int   ,
@LongitudPuntoEmision   int   ,
@LongitudSecuencialSRI   int   ,
@LongitudAutorizacion   int   ,
@EcuadorRepresentantelegal   varchar(40),
@EcuadorNumeroidentificacion   varchar(15),
@EcuadorRepresentantelegalTipo   varchar(20),
@EcuadorRUCContadorTipo   varchar(20),
@Texto					xml,
@ReferenciaIS			varchar(100),
@SubReferencia			varchar(100)
BEGIN TRANSACTION
IF @Ok IS NULL
BEGIN
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Nombre = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Nombre'
SELECT @Grupo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Grupo'
SELECT @Direccion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Direccion'
SELECT @DireccionNumero = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DireccionNumero'
SELECT @DireccionNumeroInt = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = '@DireccionNumeroInt'
SELECT @Colonia = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Colonia'
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
SELECT @Telefonos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Telefonos'
SELECT @Fax = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Fax'
SELECT @Encabezado1 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Encabezado1'
SELECT @Encabezado2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Encabezado2'
SELECT @Estatus = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Estatus'
SELECT @UltimoCambio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'UltimoCambio'
SELECT @UltimaCorrida = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'UltimaCorrida'
SELECT @Alta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Alta'
SELECT @RFC = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RFC'
SELECT @RegistroPatronal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RegistroPatronal'
SELECT @Estatus = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
SELECT @ClaveActividad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ClaveActividad'
SELECT @Representante = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Representante'
SELECT @RepresentanteRFC = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RepresentanteRFC'
SELECT @RepresentanteCURP = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RepresentanteCURP'
SELECT @Zona = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Zona'
SELECT @Numero = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Numero'
SELECT @TieneMovimientos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TieneMovimientos'
SELECT @CambioBloquear = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CambioBloquear'
SELECT @Controladora = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Controladora'
SELECT @FactorIntegracion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FactorIntegracion'
SELECT @Tipo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tipo'
SELECT @ImportadorRegimen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ImportadorRegimen'
SELECT @ImportadorRegistro = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ImportadorRegistro'
SELECT @ImportadorFechaD = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ImportadorFechaD'
SELECT @ImportadorFechaA = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ImportadorFechaA'
SELECT @Delegacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Delegacion'
SELECT @GLN = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'GLN'
SELECT @CFD = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CFD'
SELECT @CFD_noCertificado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CFD_noCertificado'
SELECT @CFD_version = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CFD_version'
SELECT @CFD_versionFecha = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CFD_versionFecha'
SELECT @CFD_versionAnterior = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CFD_versionAnterior'
SELECT @CFD_EAN13 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CFD_EAN13'
SELECT @CFD_DUN14 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CFD_DUN14'
SELECT @CFD_SKU = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CFD_SKU'
SELECT @CFD_SKUCodigoInterno = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CFD_SKUCodigoInterno'
SELECT @CFD_Llave = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CFD_Llave'
SELECT @CFD_Certificado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CFD_Certificado'
SELECT @CFD_ContrasenaSello = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = '@CFD_ContrasenaSello'
SELECT @FiscalRegimen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FiscalRegimen'
SELECT @Organizacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Organizacion'
SELECT @TipoRegistro = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TipoRegistro'
SELECT @IdentificacionRepresentante = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'IdentificacionRepresentante'
SELECT @Contador = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Contador'
SELECT @RFCContador = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RFCContador'
SELECT @EsEcuador = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EsEcuador'
SELECT @EsGuatemala = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EsGuatemala'
SELECT @GtImporteMinimoSinRetencion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'GtImporteMinimoSinRetencion'
SELECT @EsColombia = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EsColombia'
SELECT @LongitudEstablecimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'LongitudEstablecimiento'
SELECT @LongitudPuntoEmision = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'LongitudPuntoEmision'
SELECT @LongitudSecuencialSRI = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'LongitudSecuencialSRI'
SELECT @LongitudAutorizacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'LongitudAutorizacion'
SELECT @EcuadorRepresentantelegal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EcuadorRepresentantelegal'
SELECT @EcuadorNumeroidentificacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EcuadorNumeroidentificacion'
SELECT @EcuadorRepresentantelegalTipo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EcuadorRepresentantelegalTipo'
SELECT @EcuadorRUCContadorTipo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EcuadorRUCContadorTipo'
SELECT @Texto =(SELECT * FROM Empresa
WHERE  ISNULL(Empresa,'') = ISNULL(ISNULL(@Empresa,Empresa),'')
AND ISNULL(Nombre,'') = ISNULL(ISNULL(@Nombre,Nombre),'')
AND ISNULL(Grupo,'') = ISNULL(ISNULL(@Grupo,Grupo),'')
AND ISNULL(Direccion,'') = ISNULL(ISNULL(@Direccion,Direccion),'')
AND ISNULL(DireccionNumero,'') = ISNULL(ISNULL(@DireccionNumero,DireccionNumero),'')
AND ISNULL(DireccionNumeroInt,'') = ISNULL(ISNULL(@DireccionNumeroInt,DireccionNumeroInt),'')
AND ISNULL(Colonia,'') = ISNULL(ISNULL(@Colonia,Colonia),'')
AND ISNULL(Poblacion,'') = ISNULL(ISNULL(@Poblacion,Poblacion),'')
AND ISNULL(Estado,'') = ISNULL(ISNULL(@Estado,Estado),'')
AND ISNULL(Pais,'') = ISNULL(ISNULL(@Pais,Pais),'')
AND ISNULL(CodigoPostal,'') = ISNULL(ISNULL(@CodigoPostal,CodigoPostal),'')
AND ISNULL(Telefonos,'') = ISNULL(ISNULL(@Telefonos,Telefonos),'')
AND ISNULL(Fax,'') = ISNULL(ISNULL(@Fax,Fax),'')
AND ISNULL(Encabezado1,'') = ISNULL(ISNULL(@Encabezado1,Encabezado1),'')
AND ISNULL(Encabezado2,'') = ISNULL(ISNULL(@Encabezado2,Encabezado2),'')
AND ISNULL(UltimoCambio,'') = ISNULL(ISNULL(@UltimoCambio,UltimoCambio),'')
AND ISNULL(UltimaCorrida,'') = ISNULL(ISNULL(@UltimaCorrida,UltimaCorrida),'')
AND ISNULL(Alta,'') = ISNULL(ISNULL(@Alta,Alta),'')
AND ISNULL(RFC,'') = ISNULL(ISNULL(@RFC,RFC),'')
AND ISNULL(RegistroPatronal,'') = ISNULL(ISNULL(@RegistroPatronal,RegistroPatronal),'')
AND ISNULL(ClaveActividad,'') = ISNULL(ISNULL(@ClaveActividad,ClaveActividad),'')
AND ISNULL(Representante,'') = ISNULL(ISNULL(@Representante,Representante),'')
AND ISNULL(RepresentanteRFC,'') = ISNULL(ISNULL(@RepresentanteRFC,RepresentanteRFC),'')
AND ISNULL(RepresentanteCURP,'') = ISNULL(ISNULL(@RepresentanteCURP,RepresentanteCURP),'')
AND ISNULL(Zona,'') = ISNULL(ISNULL(@Zona,Zona),'')
AND ISNULL(Numero,'') = ISNULL(ISNULL(@Numero,Numero),'')
AND ISNULL(TieneMovimientos,'') = ISNULL(ISNULL(@TieneMovimientos,TieneMovimientos),'')
AND ISNULL(CambioBloquear,'') = ISNULL(ISNULL(@CambioBloquear,CambioBloquear),'')
AND ISNULL(Controladora,'') = ISNULL(ISNULL(@Controladora,Controladora),'')
AND ISNULL(FactorIntegracion,'') = ISNULL(ISNULL(@FactorIntegracion,FactorIntegracion),'')
AND ISNULL(Tipo,'') = ISNULL(ISNULL(@Tipo,Tipo),'')
AND ISNULL(ImportadorRegimen,'') = ISNULL(ISNULL(@ImportadorRegimen,ImportadorRegimen),'')
AND ISNULL(ImportadorRegistro,'') = ISNULL(ISNULL(@ImportadorRegistro,ImportadorRegistro),'')
AND ISNULL(ImportadorFechaD,'') = ISNULL(ISNULL(@ImportadorFechaD,ImportadorFechaD),'')
AND ISNULL(ImportadorFechaA,'') = ISNULL(ISNULL(@ImportadorFechaA,ImportadorFechaA),'')
AND ISNULL(Delegacion,'') = ISNULL(ISNULL(@Delegacion,Delegacion),'')
AND ISNULL(GLN,'') = ISNULL(ISNULL(@GLN,GLN),'')
AND ISNULL(CFD,'') = ISNULL(ISNULL(@CFD,CFD),'')
AND ISNULL(CFD_noCertificado,'') = ISNULL(ISNULL(@CFD_noCertificado,CFD_noCertificado),'')
AND ISNULL(CFD_version,'') = ISNULL(ISNULL(@CFD_version,CFD_version),'')
AND ISNULL(CFD_versionFecha,'') = ISNULL(ISNULL(@CFD_versionFecha,CFD_versionFecha),'')
AND ISNULL(CFD_versionAnterior,'') = ISNULL(ISNULL(@CFD_versionAnterior,CFD_versionAnterior),'')
AND ISNULL(CFD_EAN13,'') = ISNULL(ISNULL(@CFD_EAN13,CFD_EAN13),'')
AND ISNULL(CFD_DUN14,'') = ISNULL(ISNULL(@CFD_DUN14,CFD_DUN14),'')
AND ISNULL(CFD_SKU,'') = ISNULL(ISNULL(@CFD_SKU,CFD_SKU),'')
AND ISNULL(CFD_SKUCodigoInterno,'') = ISNULL(ISNULL(@CFD_SKUCodigoInterno,CFD_SKUCodigoInterno),'')
AND ISNULL(CFD_Llave,'') = ISNULL(ISNULL(@CFD_Llave,CFD_Llave),'')
AND ISNULL(CFD_Certificado,'') = ISNULL(ISNULL(@CFD_Certificado,CFD_Certificado),'')
AND ISNULL(CFD_ContrasenaSello,'') = ISNULL(ISNULL(@CFD_ContrasenaSello,CFD_ContrasenaSello),'')
AND ISNULL(FiscalRegimen,'') = ISNULL(ISNULL(@FiscalRegimen,FiscalRegimen),'')
AND ISNULL(Organizacion,'') = ISNULL(ISNULL(@Organizacion,Organizacion),'')
AND ISNULL(TipoRegistro,'') = ISNULL(ISNULL(@TipoRegistro,TipoRegistro),'')
AND ISNULL(IdentificacionRepresentante,'') = ISNULL(ISNULL(@IdentificacionRepresentante,IdentificacionRepresentante),'')
AND ISNULL(Contador,'') = ISNULL(ISNULL(@Contador,Contador),'')
AND ISNULL(RFCContador,'') = ISNULL(ISNULL(@RFCContador,RFCContador),'')
AND ISNULL(EsEcuador,'') = ISNULL(ISNULL(@EsEcuador,EsEcuador),'')
AND ISNULL(EsGuatemala,'') = ISNULL(ISNULL(@EsGuatemala,EsGuatemala),'')
AND ISNULL(GtImporteMinimoSinRetencion,'') = ISNULL(ISNULL(@GtImporteMinimoSinRetencion,GtImporteMinimoSinRetencion),'')
AND ISNULL(LongitudEstablecimiento,'') = ISNULL(ISNULL(@LongitudEstablecimiento,LongitudEstablecimiento),'')
AND ISNULL(LongitudPuntoEmision,'') = ISNULL(ISNULL(@LongitudPuntoEmision,LongitudPuntoEmision),'')
AND ISNULL(LongitudSecuencialSRI,'') = ISNULL(ISNULL(@LongitudSecuencialSRI,LongitudSecuencialSRI),'')
AND ISNULL(LongitudAutorizacion,'') = ISNULL(ISNULL(@LongitudAutorizacion,LongitudAutorizacion),'')
AND ISNULL(EcuadorRepresentantelegal,'') = ISNULL(ISNULL(@EcuadorRepresentantelegal,EcuadorRepresentantelegal),'')
AND ISNULL(EcuadorNumeroidentificacion,'') = ISNULL(ISNULL(@EcuadorNumeroidentificacion,EcuadorNumeroidentificacion),'')
AND ISNULL(EcuadorRepresentantelegalTipo,'') = ISNULL(ISNULL(@EcuadorRepresentantelegalTipo,EcuadorRepresentantelegalTipo),'')
AND ISNULL(EcuadorRUCContadorTipo,'') = ISNULL(ISNULL(@EcuadorRUCContadorTipo,EcuadorRUCContadorTipo),'')
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

