SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocINValidarXMLTyped
(
@eDocIn       	varchar(50),
@Ruta                 varchar(50),
@XMLValidar	        varchar(MAX),
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
SELECT @Clave = XSD
FROM eDocInRuta
WHERE  eDocIn = @eDocIn AND Ruta = @Ruta
SET @IDSQL = @Clave
IF EXISTS (SELECT * FROM sys.xml_schema_collections WHERE name = @IDSQL)
BEGIN
SET @Validacion = N'DECLARE @x XML (' + '[' + RTRIM(@IDSQL) + ']' + ') ' +
N'BEGIN TRY ' +
N'  SET @x = ' + CHAR(39) + RTRIM(@XMLValidar) + CHAR(39) + ' ' +
N'END TRY ' +
N'BEGIN CATCH ' +
N'  SELECT @Error = @@ERROR,  @ErrorRef = ERROR_MESSAGE() ' +
N'  IF XACT_STATE() = -1 ' +
N'  BEGIN ' +
N'    ROLLBACK TRAN ' +
N'    SET @ErrorRef = ' + CHAR(39) + 'Error  ' + CHAR(39) + ' + CONVERT(varchar,@Error) + ' + CHAR(39) + ', ' + CHAR(39) + ' + @ErrorRef ' +
N'    RAISERROR(@ErrorRef,20,1) WITH LOG ' +
N'  END ' +
N'END CATCH '
SET @Parametros = N'@Error int OUTPUT, @ErrorRef varchar(255) OUTPUT'
BEGIN TRY
EXECUTE sp_executesql @Validacion, @Parametros, @Error = @Error OUTPUT, @ErrorRef = @ErrorRef OUTPUT
IF @Error IS NOT NULL SELECT @Ok = @Error, @OkRef = 'Error al validar el xml'+ @ErrorRef
END TRY
BEGIN CATCH
SELECT @Ok = @@ERROR,  @OkRef = ERROR_MESSAGE()
IF XACT_STATE() = -1
BEGIN
ROLLBACK TRAN
SET @OkRef = ' Error  ' + CONVERT(varchar,@Ok) + @OkRef
RAISERROR(@OkRef,20,1) WITH LOG
END
END CATCH
IF @OK IS NOT NULL
SET @OkRef = 'Error  al validar el xml(' + CONVERT(varchar,@Ok) +') '+ ', ' + @OkRef
END
END

