SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisInterfazInforTransferenciaUnidad
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Unidad     				        varchar(50),
@Datos								varchar(max),
@Solicitud							varchar(max),
@ReferenciaIS						varchar(100),
@SubReferencia						varchar(100),
@IDNuevo							int,
@Datos2								varchar(max),
@Resultado2							varchar(max),
@Usuario							varchar(10),
@Contrasena							varchar(32),
@Verificar							int,
@ReferenciaIntelisisService			varchar(50)
DECLARE
@Tabla			 table
(
Unidad					    	 varchar(50),
Clave					    	 varchar(3),
Descripcion					 varchar(30),
ReferenciaIntelisisService      varchar(50)
)
SELECT @ReferenciaIS = Referencia ,@Usuario = Usuario , @SubReferencia = SubReferencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Contrasena = Contrasena
FROM Usuario
WHERE Usuario = @Usuario
IF @Ok IS NULL
BEGIN
SELECT @Unidad = Unidad FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Unidad')
WITH (Unidad varchar(255))
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,ISNULL(@ID,'')),'') + CHAR(34) +  ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,ISNULL(@Ok,'')),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(ISNULL(@OkRef,''),'') + CHAR(34) + '/></Intelisis>'
SET @Datos='<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Cuenta.Unidad.Listado" SubReferencia="'+ISNULL(@SubReferencia,'')+'" Version="1.0"><Solicitud><Parametro Campo="Unidad" Valor="'+@Unidad+'"/></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos,@Resultado,@Ok Output,@OkRef Output,1,0,@IDnuevo Output
IF @Ok IS NULL
SELECT @Solicitud = Resultado
FROM IntelisisService
WHERE ID = @IDNuevo
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
IF @@ERROR <> 0 SET @Ok = 1
INSERT @Tabla (Unidad,Descripcion, ReferenciaIntelisisService, Clave)
SELECT         Clave, Unidad,      ReferenciaIntelisisService, Clave
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/Unidad',1)
WITH (Unidad varchar(100), INFORDescripcion varchar(100),ReferenciaIntelisisService varchar(100), Clave varchar(3))
IF @@ERROR <> 0 SET @Ok = 1
EXEC sp_xml_removedocument @iSolicitud
IF @@ERROR <> 0 SET @Ok = 1
SELECT @ReferenciaIntelisisService = ReferenciaIntelisisService from @Tabla
SET @Resultado2 = CONVERT(varchar(max) ,(SELECT * FROM @Tabla oUnidad FOR XML AUTO))
SET @Datos2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia=' + CHAR(34) +'Infor.Cuenta.Unidad.Mantenimiento' + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Solicitud IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')   + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)+ ' ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+ ' >' + @Resultado2 + '</Solicitud></Intelisis>'
END
ELSE
BEGIN
SET @Datos2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia=' + CHAR(34) +'Infor.Cuenta.Unidad.Mantenimiento' + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Solicitud><ERROR Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)  + '/></Solicitud></Intelisis>'
END
EXEC spIntelisisService @Usuario,@Contrasena,@Datos2,@Resultado2,@Ok Output,@OkRef Output,0,0,@IDNuevo Output
END

