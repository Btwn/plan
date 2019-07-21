SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spIntelisisPHPWebService]
@Solicitud			varchar(max),
@Procesar				bit		= 1,
@EliminarProcesado	bit		= 1

AS BEGIN
SET NOCOUNT ON
DECLARE
@Usuario			varchar(10),
@Contrasena		varchar(32),
@Resultado		varchar(max),
@Ok				int,
@OkRef			varchar(255),
@ID				int,
@iSolicitud		int,
@Sistema			varchar(100),
@Contenido		varchar(100),
@Referencia		varchar(100),
@SubReferencia	varchar(100),
@Version			VARCHAR(100),
@Texto			varchar(max)
BEGIN TRY
EXEC  sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
END TRY
BEGIN CATCH
SET @Solicitud = '<?xml version="1.0" encoding="windows-1252"?>' +
CAST(dbo.JSON2XML(@Solicitud).query('Root/Intelisis') AS VARCHAR(MAX))
EXEC  sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
END CATCH
BEGIN TRY
SELECT @Sistema		= Sistema,
@Contenido		= 'Resultado',
@Referencia    = Referencia,
@SubReferencia = SubReferencia,
@Version		= Version
FROM OPENXML (@iSolicitud,'/Intelisis')
WITH (Sistema varchar(100), Referencia varchar(100), SubReferencia varchar(100), Version varchar(100))
SELECT
@Usuario    = Usuario,
@Contrasena = Contrasena
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud')
WITH (Usuario varchar(10), Contrasena varchar(32))
IF NOT EXISTS(SELECT Usuario FROM Usuario WITH(NOLOCK) WHERE Usuario = @Usuario AND (Contrasena = @Contrasena OR Contrasena = dbo.fnPassword(UPPER(RTRIM(@Contrasena)))))
SELECT @Ok = 3, @OkRef = ISNULL(@Usuario, 'N/A')
IF @Ok IS NULL
EXEC spIntelisisService @Usuario, @Contrasena, @Solicitud, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @Procesar, @EliminarProcesado, @ID OUTPUT
IF @Ok IS NOT NULL
BEGIN
IF @OkRef IS NULL
SET @OkRef = (SELECT dbo.fneDocXmlAUtf8(Descripcion,0,1) + ' - ' + @Usuario FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok)
END
EXEC sp_xml_removedocument @iSolicitud
END TRY
BEGIN CATCH
SELECT ERROR_MESSAGE()
END CATCH
BEGIN TRY
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_WARNINGS ON
SET ANSI_PADDING ON
DECLARE @XMLHead as XML, @XMLResult as XML
SET @Resultado = REPLACE(@Resultado, '"', '')
SET @XMLResult = CAST(@Resultado as XML)
SET @XMLHead = '<Intelisis/>'
SET @XMLHead.modify('insert attribute Sistema {sql:variable("@Sistema")} into /Intelisis[1]')
SET @XMLHead.modify('insert attribute Contenido {sql:variable("@Contenido")} into /Intelisis[1]')
SET @XMLHead.modify('insert attribute Referencia {sql:variable("@Referencia")} into /Intelisis[1]')
SET @XMLHead.modify('insert attribute SubReferencia {sql:variable("@SubReferencia")} into /Intelisis[1]')
SET @XMLHead.modify('insert attribute Version {sql:variable("@Version")} into /Intelisis[1]')
SET @XMLHead.modify('insert <Resultado/> as first into (/Intelisis)[1]');
SET @XMLHead.modify('insert attribute IntelisisServiceID {sql:variable("@ID")} into (/Intelisis/Resultado)[1]')
SET @XMLHead.modify('insert attribute Ok {sql:variable("@Ok")} into (/Intelisis/Resultado)[1]')
SET @XMLHead.modify('insert attribute OkRef {sql:variable("@OkRef")} into (/Intelisis/Resultado)[1]')
SET @XMLHead.modify('insert sql:variable("@XMLResult") as first into (/Intelisis/Resultado)[1]')
SET @Resultado = CAST(@XMLHead AS VARCHAR(MAX))
UPDATE IntelisisService
 WITH(ROWLOCK) SET Resultado = @Resultado
WHERE ID = @ID
SELECT @Referencia = REPLACE(REPLACE(@Referencia, 'Intelisis.', ''), '.', '')
SET @Resultado = dbo.XML2JSON(CAST(@Resultado as XML))
SELECT @Resultado Resultado
DECLARE @iPrint int
SET @iPrint = 0
WHILE @iPrint <= LEN(@Resultado)
BEGIN
PRINT SUBSTRING(@Resultado, @iPrint, 4000)
SET @iPrint = @iPrint + 4000
END
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
SET ANSI_WARNINGS OFF
SET ANSI_PADDING OFF
SET NOCOUNT OFF
END TRY
BEGIN CATCH
SELECT ERROR_MESSAGE()
END CATCH
RETURN
END

