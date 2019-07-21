SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexInsertarNoCertificadoXML
@Estacion				int,
@Empresa				varchar(5),
@Sucursal				int,
@Tipo					varchar(20),
@Temporal				varchar(255),
@XML					varchar(max) OUTPUT,
@Ok						int = NULL OUTPUT,
@OkRef					varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@RutaFirmaSAT			varchar(255),
@Shell					varchar(8000),
@CampoDatos				varchar(max),
@NoCertificado			varchar(20),
@ContrasenaSello		varchar(100),
@CertificadoBase64		varchar(max),
@RutaLlave				varchar(255),
@RutaCertificado		varchar(255),
@TemporalNoCertificado	varchar(255),
@r						int
DECLARE @Datos TABLE (ID int identity(1,1), Datos varchar(255))
SET @TemporalNoCertificado = REPLACE(@Temporal,'.XML','')
SET @TemporalNoCertificado = @TemporalNoCertificado + 'NoCertificado.TXT'
EXEC spCFDFlexInfo @Estacion, @Empresa, @Sucursal, @Tipo, @NoCertificado OUTPUT, @ContrasenaSello OUTPUT, @CertificadoBase64 OUTPUT, @RutaLlave OUTPUT, @RutaCertificado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SELECT @NoCertificado = NULLIF(@NoCertificado,'')
IF @NoCertificado IS NULL
BEGIN
SELECT
@RutaFirmaSAT = RutaFirmaSAT
FROM EmpresaCFD
WHERE Empresa = @Empresa
EXEC spEliminarArchivo @TemporalNoCertificado, @Ok OUTPUT, @OkRef OUTPUT
SET @Shell = CHAR(34) + CHAR(34) + @RutaFirmaSAT + CHAR(34) + ' NUMBERCERT ' + CHAR(34) + @Temporal + CHAR(34) + CHAR(34)
INSERT @Datos
EXEC @r = xp_cmdshell @Shell
IF @r = 0
SELECT TOP 1 @CampoDatos = Datos FROM @Datos WHERE Datos IS NOT NULL
SET @NoCertificado = ''
IF @Ok IS NULL
BEGIN
IF @CampoDatos LIKE 'ERROR%' SELECT @Ok = 71590, @OkRef = @CampoDatos
IF @Ok IS NULL
SET @NoCertificado = @NoCertificado + ISNULL(@CampoDatos,'')
END
IF @Ok IS NULL
UPDATE EmpresaCFD SET NoCertificado = @NoCertificado WHERE Empresa = @Empresa
END
IF @Ok IS NULL
SET @XML = REPLACE(@XML,'_NOCERTIFICADO_',@NoCertificado)
END

