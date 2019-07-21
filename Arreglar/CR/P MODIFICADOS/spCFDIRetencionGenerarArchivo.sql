SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDIRetencionGenerarArchivo
@Empresa		varchar(5),
@Archivo		varchar(255),
@XML			varchar(max),
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@ManejadorObjeto			int,
@IDArchivo					int,
@RutaANSIToUTF				varchar(255),
@Shell						varchar(8000),
@UsarTimbrarRetencion		bit
DECLARE @Datos TABLE(Datos		varchar(255))
SELECT @ManejadorObjeto = NULL, @IDArchivo = NULL
SELECT @UsarTimbrarRetencion= UsarTimbrarRetencion FROM EmpresaCFD WITH (NOLOCK) WHERE Empresa = @Empresa
IF @UsarTimbrarRetencion = 0
SELECT @RutaANSIToUTF = RutaANSIToUTF FROM EmpresaCFD WITH (NOLOCK) WHERE Empresa = @Empresa
ELSE
SELECT @RutaANSIToUTF = RutaANSIToUTF FROM EmpresaCFDRetencion WITH (NOLOCK) WHERE Empresa = @Empresa
IF @Ok IS NULL
EXEC spEliminarArchivo @Archivo, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spCrearArchivo @Archivo, @ManejadorObjeto OUTPUT, @IDArchivo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spInsertaEnArchivo2 @IDArchivo, @XML, @Ok
IF @Ok IS NULL
EXEC spCerrarArchivo @IDArchivo, @ManejadorObjeto, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SET @Shell = CHAR(34) + CHAR(34) + RTRIM(LTRIM(@RutaANSIToUTF)) + CHAR(34) + ' A2U ' + CHAR(34) + LTRIM(RTRIM(@Archivo)) + CHAR(34) + CHAR(34)
EXEC xp_cmdshell @Shell, no_output
IF EXISTS(SELECT Datos FROM @Datos WHERE RTRIM(LTRIM(Datos)) = '1' ) SELECT @Ok = 71610, @OkRef = ISNULL(@Archivo,'')
END
END

