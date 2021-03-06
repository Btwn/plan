SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisInterfazInforTransferenciaUsuario
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Usuario				varchar(10),
@Nombre					varchar(100),
@Datos					varchar(max),
@Solicitud				varchar(max),
@ReferenciaIS			varchar(100),
@SubReferencia			varchar(100),
@IDNuevo				int,
@Datos2					varchar(max),
@Resultado2				varchar(max),
@Usuario1				varchar(10),
@Contrasena				varchar(32),
@ReferenciaIntelisisService			varchar(50)
DECLARE
@Tabla			 table
(
Usuario		 			varchar(30),
Nombre		 			varchar(100),
FechaCreacion			datetime,
NumeroConec				int,
FechaUltAcceso			datetime,
TiempoConec		        float ,
FechaDeAlta				datetime,
FechaUltimaModificacion	datetime,
UsuarioAlta		 		varchar(10),
UsuarioModificacion		varchar(10),
Supervisor				int   ,
ClaveAccesoAccess 		varchar(10),
GrupoParaAccess			varchar(30),
Grupo		 			varchar(30),
GrupoObjeto	 			varchar(30),
IdCRM	  				varchar(50),
CRM		  				int ,
ReferenciaIntelisisService  varchar(50),
PerfilMES				varchar(20)
)
IF @Ok IS NULL
BEGIN
SELECT @Usuario = Usuario FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Usuario')
WITH (Usuario varchar(255))
SELECT @ReferenciaIS = Referencia ,@Usuario1 = Usuario , @SubReferencia = SubReferencia
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @ID
SELECT @Contrasena = Contrasena
FROM Usuario
WITH(NOLOCK) WHERE Usuario = @Usuario1
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
SET @Datos=
'<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Cuenta.Usuario.Listado" SubReferencia="'+@SubReferencia+'" Version="1.0"><Solicitud><Parametro Campo="Usuario" Valor="'+@Usuario+'"/></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario1,@Contrasena,@Datos,@Resultado,@Ok Output,@OkRef Output,1,0,@IDNuevo Output
SELECT @Solicitud = Resultado
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @IDNuevo
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @Tabla (	Usuario, Nombre,	FechaCreacion,             NumeroConec,     FechaUltAcceso,                   TiempoConec,     FechaDeAlta,            FechaUltimaModificacion, UsuarioAlta,        UsuarioModificacion,        Supervisor,      ClaveAccesoAccess,        GrupoParaAccess,        Grupo,        GrupoObjeto,        IdCRM,        CRM ,       ReferenciaIntelisisService ,PerfilMES  )
SELECT     Usuario, Nombre,	FechaCreacion = GETDATE(), NumeroConec = 0, ISNULL(UltimoAcceso,GETDATE()),   TiempoConec = 0, ISNULL(Alta,GETDATE()), UltimoCambio,            UsuarioAlta = Null, UsuarioModificacion = Null, INFORSupervisor, ClaveAccesoAccess = Null, GrupoParaAccess = Null, GrupoTrabajo, GrupoObjeto = Null, IdCRM = Null, CRM = Null, ReferenciaIntelisisService  ,INFORPerfil
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/Usuario',1)
WITH (Usuario    varchar(100), Nombre    varchar(100), UltimoAcceso    varchar(100), Alta  varchar(100), UltimoCambio  varchar(100), INFORSupervisor  varchar(100), GrupoTrabajo  varchar(100),ReferenciaIntelisisService  varchar(100),INFORPerfil  varchar(100))
EXEC sp_xml_removedocument @iSolicitud
SELECT @ReferenciaIntelisisService = ReferenciaIntelisisService from @Tabla
SET @Resultado2 = CONVERT(varchar(max) ,(SELECT * FROM @Tabla Usuario FOR XML AUTO))
SET @Datos2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia=' + CHAR(34) +'Infor.Cuenta.Usuario.Mantenimiento' + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Solicitud IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')   + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)  + ' ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+ ' >' + @Resultado2 + '</Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario1,@Contrasena,@Datos2,@Resultado2,@Ok Output,@OkRef Output,0,0,@IDNuevo Output
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
IF @@ERROR <> 0 SET @Ok = 1
END
END

