SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spWebService
@Solicitud		varchar(max),
@EnSilencio		bit			 = 0,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int			 = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS
BEGIN
SET ANSI_NULL_DFLT_ON ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET QUOTED_IDENTIFIER ON
SET CONCAT_NULL_YIELDS_NULL ON
DECLARE @Usuario			varchar(10),
@Contrasena		varchar(32),
@ID				int,
@iSolicitud		int
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
SELECT @Usuario = Usuario, @Contrasena = Contrasena
FROM OPENXML (@iSolicitud, '/Intelisis',1)
WITH (Usuario varchar(10), Contrasena varchar(32) )
EXEC sp_xml_removedocument @iSolicitud
EXEC spIntelisisService @Usuario, @Contrasena, @Solicitud, @Resultado = @Resultado OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Procesar = 1, @EliminarProcesado = 0, @ID = @ID OUTPUT
IF @Ok IS NOT NULL AND @Resultado IS NULL
SELECT @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Resultado" Ok="' + CONVERT(varchar(max), @Ok) + '" OkRef="' + ISNULL(@OkRef, '') + '"> <Resultado></Resultado></Intelisis>'
IF @EnSilencio = 0
SELECT @Resultado
RETURN
END

