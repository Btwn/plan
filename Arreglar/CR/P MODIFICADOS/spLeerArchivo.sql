SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLeerArchivo
@RutaArchivo			varchar(255),
@Archivo				varchar(max) OUTPUT,
@Ok						int = NULL OUTPUT,
@OkRef					varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Codigo					int,
@SQL					nvarchar(max),
@Campo					varchar(max)
SET @Codigo = '1252'
SET @Archivo = ''
IF (OBJECT_ID('Tempdb..#NotificacionLeerArchivo')) IS NOT NULL
DROP TABLE #NotificacionLeerArchivo
CREATE TABLE #NotificacionLeerArchivo
(
ArchivoXML varchar(max) NOT NULL
)
SET @SQL = N'BULK INSERT #NotificacionLeerArchivo
FROM ''' +  @RutaArchivo + '''
WITH (CODEPAGE = ' + CONVERT(varchar, @Codigo) + ')'
EXEC (@SQL)
IF NOT EXISTS(SELECT * FROM #NotificacionLeerArchivo)
BEGIN
SELECT @OK = 71525
SELECT @OkRef = (SELECT Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok)
SELECT @OkRef = @OkRef + ' ' + @RutaArchivo
END
DECLARE crArchivoXML CURSOR FOR
SELECT ISNULL(ArchivoXML, '')
FROM #NotificacionLeerArchivo
OPEN crArchivoXML
FETCH NEXT FROM crArchivoXML INTO @Campo
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Archivo = @Archivo + @Campo
FETCH NEXT FROM crArchivoXML INTO @Campo
END
CLOSE crArchivoXML
DEALLOCATE crArchivoXML
END

