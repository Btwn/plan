SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisCuentaCteListado
@ID                        int,
@iSolicitud                           int,
@Version                              float,
@Resultado                         varchar(max) = NULL OUTPUT,
@Ok                                                      int = NULL OUTPUT,
@OkRef                                 varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto xml,
@ReferenciaIS varchar(100),
@SubReferencia varchar(100),
@SQL nvarchar(MAX),
@SQLVars nvarchar(MAX),
@SQLLeerXML nvarchar(MAX),
@SQLANDS nvarchar(MAX)
SELECT @SQLVars = '', @SQLLeerXML = '', @SQLANDS = ''
SELECT TOP 10
@SQLVars             = @SQLVars+'@' + COLUMN_NAME + ' ' + CASE WHEN DATA_TYPE LIKE '%char' THEN DATA_TYPE + '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS varchar(5)) + ')' else DATA_TYPE end + ',',
@SQLLeerXML    = @SQLLeerXML+'SELECT @' + COLUMN_NAME + ' = Valor FROM openxml (@iSolicitud,''/Intelisis/Solicitud/Parametro'') WITH (Campo varchar(255), Valor varchar(255)) WHERE Campo = ''' + COLUMN_NAME + '''' + NCHAR(13),
@SQLANDS          = @SQLANDS+'AND ISNULL(' + COLUMN_NAME + ','''') = ISNULL(ISNULL(@' + COLUMN_NAME + ',' + COLUMN_NAME + '),'''')'
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Cte' AND DATA_TYPE NOT IN ('text','timestamp')
ORDER BY ORDINAL_POSITION
SELECT
@SQLVars             = 'DECLARE ' + NCHAR(13) + REPLACE(REPLACE(@SQLVars + ':', ',:', ''), ',', ',' + NCHAR(13)) + NCHAR(13),
@SQLANDS          = 'SELECT @Texto =(SELECT * FROM Cte WHERE ' +
REPLACE(SUBSTRING(@SQLANDS, 5, LEN(@SQLANDS)),')AND ISNULL(',') AND' + NCHAR(13) + 'ISNULL(') + 'FOR XML AUTO)'
SELECT @SQL = @SQLVars + NCHAR(13) + @SQLLeerXML + NCHAR(13) + @SQLANDS
EXEC sp_executesql @SQL, N'@iSolicitud int, @Texto XML OUTPUT', @iSolicitud = @iSolicitud, @Texto = @Texto OUTPUT
IF @@ERROR <> 0 SET @Ok = 1
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),@Texto) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END
END
END

