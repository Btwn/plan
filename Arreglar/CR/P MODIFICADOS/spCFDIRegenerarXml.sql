SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDIRegenerarXml
@Empresa		varchar(20),
@Mov		    varchar(20),
@ModuloID		varchar(20),
@Modulo			varchar(20),
@Ruta			varchar(255),
@AcuseCancelacion   bit,
@Ok				int = NULL ,
@OkRef			varchar(255) = NULL

AS BEGIN
DECLARE
@ManejadorObjeto	int,
@IDArchivo			int,
@RutaANSIToUTF		varchar(255),
@Shell				varchar(8000),
@Archivo			varchar(255),
@XML			    varchar(max)
DECLARE @Datos TABLE
(
Datos		varchar(255)
)
SELECT @Archivo =@Ruta
SELECT @Archivo= Direccion  from AnexoMov WITH (NOLOCK) where ID =@ModuloID  and Rama =@Modulo  and Nombre =@Archivo
IF  @AcuseCancelacion = 1
SELECT @XML= AcuseCancelado from CFD WITH (NOLOCK) WHERE Modulo =@Modulo  AND ModuloID =@ModuloID  AND Empresa =@Empresa
ELSE
SELECT @XML= documento from CFD WITH (NOLOCK) WHERE Modulo =@Modulo  AND ModuloID =@ModuloID  AND Empresa =@Empresa
SELECT @ManejadorObjeto = NULL, @IDArchivo = NULL
SELECT @RutaANSIToUTF =  RutaANSIToUTF FROM EmpresaCFD WITH (NOLOCK) WHERE Empresa = @Empresa
IF @Ok IS NULL
EXEC spEliminarArchivo @Archivo, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spCrearArchivo @Archivo, @ManejadorObjeto OUTPUT, @IDArchivo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spInsertaEnArchivo2  @IDArchivo, @XML, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spCerrarArchivo @IDArchivo, @ManejadorObjeto, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SET @Shell = CHAR(34) + CHAR(34) + RTRIM(LTRIM(@RutaANSIToUTF)) + CHAR(34) + ' A2U ' + CHAR(34) + LTRIM(RTRIM(@Archivo)) + CHAR(34) + CHAR(34)
EXEC xp_cmdshell @Shell, no_output
IF EXISTS(SELECT Datos FROM @Datos WHERE RTRIM(LTRIM(Datos)) = '1' ) SELECT @Ok = 71610, @OkRef = ISNULL(@Archivo,'')
END
END

