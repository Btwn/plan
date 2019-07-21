SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexValidarXML
(
@Modulo		varchar(5),
@Mov			varchar(20),
@Contacto		varchar(10),
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
@Error				int,
@ErrorRef			varchar(255),
@Clave				varchar(50)
SELECT @Clave = XSD FROM MovTipoCFDFlex WHERE Modulo = @Modulo AND Mov = @Mov AND ISNULL(NULLIF(ISNULL(NULLIF(Contacto,''),'(Todos)'),'(Todos)'),@Contacto) = @Contacto
SET @IDSQL = @Clave
IF EXISTS (SELECT * FROM sys.xml_schema_collections WHERE name = @IDSQL)
BEGIN
SET @Validacion = 'DECLARE @x XML (' + '[' + RTRIM(@IDSQL) + ']' + ') ' + 'BEGIN TRY SET @x = @XML END TRY BEGIN CATCH SELECT @Error = @@ERROR,  @ErrorRef = ERROR_MESSAGE() END CATCH'
SET @Parametros = '@XML varchar(max), @Error int OUTPUT, @ErrorRef varchar(255) OUTPUT'
EXEC xpCFDFlexValidarXML @XML, @Ok OUTPUT,@OkRef OUTPUT
EXECUTE sp_executesql @Validacion, @Parametros, @XML = @XML, @Error = @Error OUTPUT, @ErrorRef = @ErrorRef OUTPUT
IF @Error IS NOT NULL SELECT @Ok = @Error, @OkRef = @ErrorRef
END
END

