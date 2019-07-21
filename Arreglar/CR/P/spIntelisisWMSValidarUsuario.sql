SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSValidarUsuario
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa            varchar(5),
@Sucursal2          varchar(100),
@Usuario			varchar(20),
@Texto				xml,
@ReferenciaIS		varchar(100),
@SubReferencia		varchar(100),
@UsuarioSucursal    bit,
@Verifica           int,
@Verifica2          int,
@Sucursal			int,
@MovilTarea			varchar(20),
@Descripcion        varchar(100),
@TipoAcomodador	    varchar(50) 
SELECT  @Empresa   = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT  @Sucursal2= Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT  @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @UsuarioSucursal = AccesarOtrasSucursalesEnLinea FROM Usuario WHERE Usuario = @Usuario
SELECT @Sucursal = Sucursal FROM Sucursal WHERE Nombre = @Sucursal2
SELECT @TipoAcomodador = WMSTipoAcomodador FROM EmpresaCfg WHERE Empresa = @Empresa 
IF NOT EXISTS(SELECT * FROM Agente a JOIN Usuario u ON u.DefAgente=a.Agente WHERE u.Usuario = @Usuario AND a.Tipo = @TipoAcomodador AND a.Estatus = 'ALTA' AND u.Estatus = 'ALTA') 
BEGIN
SELECT @Ok = 71025, @OkRef = @Usuario
END
IF @Ok IS NULL AND NOT EXISTS (SELECT * FROM UsuarioD WHERE Usuario = @Usuario AND Empresa = @Empresa ) SELECT @Ok = 45050, @OkRef = @Usuario 
IF @UsuarioSucursal = 0 
BEGIN
IF @Ok IS NULL AND EXISTS (SELECT * FROM UsuarioSucursalAcceso WHERE Usuario = @Usuario) AND NOT EXISTS (SELECT * FROM UsuarioSucursalAcceso WHERE Usuario = @Usuario AND Sucursal =@Sucursal) SELECT @Ok = 45060, @OkRef = @Usuario 
END
IF @Ok IS NULL
SELECT @MovilTarea = WMSMovilTarea FROM EmpresaCfg WHERE Empresa = @Empresa
IF @Ok IS NULL
SELECT @Texto =((SELECT Usuario FROM Usuario FOR XML AUTO) + (SELECT WMSMovilTarea FROM EmpresaCfg WHERE Empresa = @Empresa FOR XML AUTO))
IF @@ERROR <> 0 SET @Ok = 1
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NOT NULL SELECT @Descripcion = Descripcion FROM MensajeLista WHERE Mensaje = @Ok 
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + ' Descripcion="' + ISNULL(@Descripcion,'') +'">' + CONVERT(varchar(max),ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END
END

