SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisInterfazInforTransferenciaPersonal
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Personal     				        varchar(10),
@Datos								varchar(max),
@Solicitud							varchar(max),
@ReferenciaIS						varchar(100),
@SubReferencia						varchar(100),
@IDNuevo							int,
@Datos2								varchar(max),
@Resultado2							varchar(max),
@Usuario							varchar(10),
@Contrasena							varchar(32),
@Verificar							int	,
@ReferenciaIntelisisService			varchar(50)
DECLARE
@Tabla			 table(
Operario					varchar(100),
ReferenciaIntelisisService	varchar(50),
Nombre						varchar(35),
Direccion					varchar(40),
Poblacion					varchar(40),
CodigoPostal				varchar(15),
Telefono					varchar(16),
LugarNacimiento				varchar(40),
EstadoCivil					varchar(1),
TipoContrato				varchar(40),
Inactivo						varchar(1)
)
SELECT @Personal = Personal FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Personal')
WITH (Personal varchar(255))
SELECT @ReferenciaIS = Referencia ,@Usuario = Usuario , @SubReferencia = SubReferencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Contrasena = Contrasena
FROM Usuario
WHERE Usuario = @Usuario
IF @Ok IS NULL
BEGIN
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,ISNULL(@ID,'')),'') + CHAR(34) +  ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,ISNULL(@Ok,'')),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(ISNULL(@OkRef,''),'') + CHAR(34) + '/></Intelisis>'
SET @Datos='<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Cuenta.Personal.Listado" SubReferencia="'+@SubReferencia+'" Version="1.0"><Solicitud><Parametro Campo="Personal" Valor="'+@Personal+'"/></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos,@Resultado,@Ok Output,@OkRef Output,1,0,@IDnuevo Output
IF @Ok IS NULL
SELECT @Solicitud = Resultado
FROM IntelisisService
WHERE ID = @IDNuevo
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
IF @@ERROR <> 0 SET @Ok = 1
INSERT @Tabla (       	Operario, ReferenciaIntelisisService, Nombre,													 Direccion,                           Poblacion,                 CodigoPostal,                 Telefono,                 LugarNacimiento,                 EstadoCivil,                TipoContrato,	           Inactivo)
SELECT 	            Personal, ReferenciaIntelisisService, SUBSTRING(ApellidoPaterno +' ' +ApellidoMaterno+' '+Nombre,1,35), SUBSTRING(Direccion,1,40), SUBSTRING(Poblacion,1,40), SUBSTRING(CodigoPostal,1,10), SUBSTRING(Telefono,1,16), SUBSTRING(LugarNacimiento,1,40), SUBSTRING(EstadoCivil,1,1), SUBSTRING(TipoContrato,1,40), CASE Estatus WHEN 'ALTA' THEN 0 ELSE 1 END
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/Personal',1)
WITH (Personal varchar(100), ReferenciaIntelisisService varchar(100),ApellidoPaterno varchar(100),ApellidoMaterno varchar(100),Nombre varchar(100),Direccion varchar(100),Poblacion varchar(100),CodigoPostal varchar(100),Telefono varchar(100),LugarNacimiento varchar(100),EstadoCivil varchar(100),TipoContrato varchar(100),Estatus varchar(100))
IF @@ERROR <> 0 SET @Ok = 1
EXEC sp_xml_removedocument @iSolicitud
IF @@ERROR <> 0 SET @Ok = 1
SELECT @ReferenciaIntelisisService = ReferenciaIntelisisService FROM @Tabla
SET @Resultado2 = CONVERT(varchar(max) ,(SELECT * FROM @Tabla oOperarios FOR XML AUTO))
SET @Datos2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia=' + CHAR(34) +'Infor.Cuenta.Personal.Mantenimiento' + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Solicitud IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')   + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)  + ' ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+' >' + @Resultado2 + '</Solicitud></Intelisis>'
END
ELSE
BEGIN
SET @Datos2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia=' + CHAR(34) +'Infor.Cuenta.Personal.Mantenimiento' + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Solicitud><ERROR Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)  + '/></Solicitud></Intelisis>'
END
EXEC spIntelisisService @Usuario,@Contrasena,@Datos2,@Resultado2,@Ok Output,@OkRef Output,0,0,@IDNuevo Output
END

