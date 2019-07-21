SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisInterfazInforTransferenciaArtContadorLotes
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Articulo				varchar(20),
@Datos					varchar(max),
@Solicitud				varchar(max),
@ReferenciaIS			varchar(100),
@SubReferencia			varchar(100),
@IDNuevo				int,
@Datos2					varchar(max),
@Resultado2				varchar(max),
@Usuario				varchar(10),
@Contrasena				varchar(32),
@ReferenciaIntelisisService			varchar(50)
DECLARE
@Tabla			 table
(
TipoContador 			varchar(4),
Codigo  				varchar(20),
UltimoNumeroLote		int,
Prefijo  				varchar(20),
Sufijo  				varchar(20),
UnidadesMaxLote			int,
Formato					varchar(20),
CantidadPorLote         float ,
ImpresionEtiqueta		bit   ,
FechaUltimaAsignacion	datetime ,
FechaDeAlta				datetime ,
ReferenciaIntelisisService  varchar(100)
)
IF @Ok IS NULL
BEGIN
SELECT @Articulo = Articulo FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Art')
WITH (Articulo varchar(255))
SELECT @ReferenciaIS = Referencia ,@Usuario = Usuario , @SubReferencia = SubReferencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Contrasena = Contrasena
FROM Usuario
WHERE Usuario = @Usuario
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
SET @Datos=
'<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Cuenta.Articulo.Listado" SubReferencia="'+@SubReferencia+'" Version="1.0"><Solicitud><Parametro Campo="Articulo" Valor="'+@Articulo+'"/></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos,@Resultado,@Ok Output,@OkRef Output,1,0,@IDNuevo Output
SELECT @Solicitud = Resultado
FROM IntelisisService
WHERE ID = @IDNuevo
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @Tabla (TipoContador ,    Codigo,   UltimoNumeroLote,        Prefijo,      Sufijo,  CantidadPorLote,   ImpresionEtiqueta,    FechaUltimaAsignacion,           FechaDeAlta,           UnidadesMaxLote,          ReferenciaIntelisisService   )
SELECT TipoContador='A', Articulo, UltimoNumeroLote=0, INFORPrefijo, INFORSufijo,  CantidadPorLote=0, ImpresionEtiqueta=0,  FechaUltimaAsignacion=getdate(), FechaDeAlta=getdate(), INFORUnidadesMaximaLote , ReferenciaIntelisisService
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/Art',1)
WITH (Articulo    varchar(100), INFORPrefijo    varchar(100), INFORSufijo  varchar(100),ReferenciaIntelisisService  varchar(100), INFORUnidadesMaximaLote  varchar(100))
EXEC sp_xml_removedocument @iSolicitud
SELECT @ReferenciaIntelisisService = ReferenciaIntelisisService from @Tabla
SET @Resultado2 = CONVERT(varchar(max) ,(SELECT * FROM @Tabla oContadoresLotes FOR XML AUTO))
SET @Datos2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia=' + CHAR(34) +'Infor.Cuenta.ArtContadorLotes.Mantenimiento' + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Solicitud IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')   + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + ' ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+ ' >' + @Resultado2 + '</Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos2,@Resultado2,@Ok Output,@OkRef Output,0,0,@IDNuevo Output
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
IF @@ERROR <> 0 SET @Ok = 1
END
END

