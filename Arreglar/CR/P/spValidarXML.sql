SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spValidarXML
(
@Modulo		varchar(5),
@Mov			varchar(20),
@Exportacion	varchar(50),
@XML			varchar(MAX),
@Ok			int OUTPUT,
@OkRef		varchar(255) OUTPUT
)

AS
BEGIN
DECLARE
@IDSQL			varchar(100),
@Validacion			nvarchar(MAX),
@Parametros			nvarchar(MAX),
@Error			int
SET @IDSQL = RTRIM(@Modulo) + '_' + RTRIM(@Mov) + '_' + RTRIM(@Exportacion)
SET @Validacion = 'DECLARE @x XML (' + RTRIM(@IDSQL) + ') ' + 'BEGIN TRY SET @x = N' + CHAR(39) + RTRIM(@XML) + CHAR(39) + 'END TRY BEGIN CATCH SELECT ' + CHAR(39) + 'ERROR: ' + CHAR(39) + ' + CONVERT(varchar,@@ERROR) + ' + CHAR(39) + '. ' + CHAR(39) + ' + ISNULL(ERROR_MESSAGE(),' + CHAR(39) + '' + CHAR(39) + ')' + 'END CATCH'
SET @Parametros = '@Error int OUTPUT'
EXECUTE sp_executesql @Validacion, @Parametros, @Error = @Error OUTPUT
SET @Ok = @Error
END

