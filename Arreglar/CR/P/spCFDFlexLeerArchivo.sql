SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexLeerArchivo
@RutaArchivoXML	varchar(255),
@ArchivoXML		varchar(max) OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Codigo		int,
@SQL		nvarchar(max),
@Campo		varchar(max),
@Existe		bit
SET @Codigo = '1252'
SET @ArchivoXML = ''
IF (OBJECT_ID('Tempdb..#CFDFlexLeerArchivo')) IS NOT NULL
DROP TABLE #CFDFlexLeerArchivo
CREATE TABLE #CFDFlexLeerArchivo
(
ArchivoXML varchar(max) NULL
)
EXEC spVerificarArchivo @RutaArchivoXML, @Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SET @SQL = N'BULK INSERT #CFDFlexLeerArchivo
FROM ''' +  @RutaArchivoXML + '''
WITH (CODEPAGE = ' + CONVERT(varchar, @Codigo) + ')'
IF @Existe = 1
EXEC (@SQL)
IF NOT EXISTS(SELECT * FROM #CFDFlexLeerArchivo)  AND @Ok IS NULL
BEGIN
SELECT @OK = 71525
SELECT @OkRef = (SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok)
SELECT @OkRef = @OkRef + ' ' + @RutaArchivoXML
END
DECLARE crArchivoXML CURSOR FOR
SELECT ISNULL(ArchivoXML, '')
FROM #CFDFlexLeerArchivo
OPEN crArchivoXML
FETCH NEXT FROM crArchivoXML INTO @Campo
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @ArchivoXML = @ArchivoXML + @Campo
FETCH NEXT FROM crArchivoXML INTO @Campo
END
CLOSE crArchivoXML
DEALLOCATE crArchivoXML
END

