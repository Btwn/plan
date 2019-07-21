SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexInsertarPipeStringXML
@Estacion				int,
@Empresa				varchar(5),
@Temporal				varchar(255),
@XML					varchar(max) OUTPUT,
@CadenaOriginal			varchar(max) OUTPUT,
@Ok						int = NULL OUTPUT,
@OkRef					varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@RutaFirmaSAT				varchar(255),
@Shell						varchar(8000),
@PipeString					varchar(max),
@TemporalCadenaOriginal		varchar(255),
@TemporalCadenaOriginalANSI	varchar(255),
@RutaUTFTOANSI				varchar(255),
@ArchivoXML					varchar(max),
@ResultadoEjecucion			int,
@Existe                     int
SELECT
@RutaFirmaSAT = RutaFirmaSAT,
@RutaUTFTOANSI = RutaANSIToUTF
FROM EmpresaCFD WITH (NOLOCK)
WHERE Empresa = @Empresa
SET @TemporalCadenaOriginal = REPLACE(@Temporal,'.XML','.TXT')
SET @TemporalCadenaOriginalANSI = REPLACE(@Temporal,'.XML','ANSI.TXT')
EXEC spEliminarArchivo @TemporalCadenaOriginal, @Ok OUTPUT, @OkRef OUTPUT
EXEC spEliminarArchivo @TemporalCadenaOriginalANSI, @Ok OUTPUT, @OkRef OUTPUT
SET @Shell = CHAR(34) + CHAR(34) +  @RutaFirmaSAT + CHAR(34) + ' PIPESTRING -i ' + CHAR(34) + @Temporal + CHAR(34) + ' -o ' + CHAR(34) + @TemporalCadenaOriginal + CHAR(34) + CHAR(34)
EXEC xp_cmdshell @Shell, no_output
SET @Shell = CHAR(34)+CHAR(34)+@RutaUTFToAnsi +CHAR(34)+ ' U2A ' +CHAR(34)+ @TemporalCadenaOriginal + CHAR(34)+' ' +CHAR(34)+ @TemporalCadenaOriginalANSI + CHAR(34) + CHAR(34)
EXEC @ResultadoEjecucion = xp_cmdshell @Shell, no_output
IF @ResultadoEjecucion = 1 SELECT @Ok = 71610, @OkRef = 'Error al Ejecutar '+@RutaUTFToAnsi
IF @Ok IS NULL
BEGIN
EXEC spCFDFlexLeerArchivo @TemporalCadenaOriginalANSI, @ArchivoXML OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @ArchivoXML LIKE 'ERROR%' SELECT @Ok = 71590, @OkRef = @ArchivoXML
IF @Ok IS NULL
SET @PipeString =  @ArchivoXML
END
SET @CadenaOriginal = @PipeString
SET @XML = REPLACE(@XML,'_CADENAORIGINAL_',@PipeString)
IF @Ok IS NULL
EXEC spVerificarArchivo @TemporalCadenaOriginal, @Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF ISNULL(@Existe,0) = 1 AND @Ok IS NULL
EXEC spEliminarArchivo @TemporalCadenaOriginal, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spVerificarArchivo @TemporalCadenaOriginalANSI, @Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF ISNULL(@Existe,0) = 1 AND @Ok IS NULL
EXEC spEliminarArchivo @TemporalCadenaOriginalANSI, @Ok OUTPUT, @OkRef OUTPUT
END

