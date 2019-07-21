SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisConfigUsuarioVerificar
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Referencia			varchar(100),
@SubReferencia		varchar(100),
@Texto				varchar(max),
@Usuario				varchar(10),
@Contrasena			varchar(32)
SELECT
@Referencia    = Referencia,
@SubReferencia = SubReferencia
FROM OPENXML (@iSolicitud,'/Intelisis')
WITH (Referencia varchar(100), SubReferencia varchar(100))
SELECT
@Usuario    = Usuario,
@Contrasena = Contrasena
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Usuario varchar(10), Contrasena varchar(32))
IF NOT EXISTS (SELECT Usuario FROM Usuario WITH (NOLOCK) WHERE Usuario = @Usuario)
SELECT @Ok = 71020, @OkRef = (SELECT Descripcion + ' ' + @Usuario FROM MensajeLista WITH (NOLOCK) WHERE Mensaje = 71020)
ELSE
IF (SELECT Contrasena FROM Usuario WITH (NOLOCK) WHERE Usuario = @Usuario) <> @Contrasena
SELECT @Ok = 60230, @OkRef = (SELECT dbo.fneDocXmlAUtf8(Descripcion,0,0) + ' ' + @Usuario FROM MensajeLista WITH (NOLOCK) WHERE Mensaje = 60230)
IF @Ok IS NULL
SET @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@Referencia,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
ELSE
BEGIN
SET @OkRef = (SELECT dbo.fneDocXmlAUtf8(Descripcion,0,1) + ' ' + @Usuario FROM MensajeLista WITH (NOLOCK) WHERE Mensaje = @Ok)
SET @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@Referencia,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
END
END

