SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionXMLVerificar
@Estacion			int,
@Empresa			varchar(5),
@Sucursal			int,
@Usuario			varchar(10),
@Proveedor			varchar(10),
@ConceptoSAT		varchar(2),
@Version			varchar(5),
@XML				varchar(max),
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @IDSQL			varchar(100),
@Validacion		nvarchar(max),
@Parametros		nvarchar(max),
@Error			int,
@ErrorRef			varchar(255),
@Clave			varchar(50)
SELECT @IDSQL = 'Retencion_' + @Version
IF EXISTS (SELECT * FROM sys.xml_schema_collections WHERE name = @IDSQL)
BEGIN
SET @Validacion = 'DECLARE @x XML (' + '[' + RTRIM(@IDSQL) + ']' + ') ' + 'BEGIN TRY SET @x = @XML END TRY BEGIN CATCH SELECT @Error = @@ERROR,  @ErrorRef = ERROR_MESSAGE() END CATCH'
SET @Parametros = '@XML varchar(max), @Error int OUTPUT, @ErrorRef varchar(255) OUTPUT'
EXECUTE sp_executesql @Validacion, @Parametros, @XML = @XML, @Error = @Error OUTPUT, @ErrorRef = @ErrorRef OUTPUT
IF @Error IS NOT NULL
SELECT @Ok = @Error, @OkRef = REPLACE(@ErrorRef, 'Esto puede ser consecuencia del uso de facetas de patr�n en tipos que no son string o restricciones de rango o enumeraciones en tipos de coma flotante. ', '')
END
RETURN
END

