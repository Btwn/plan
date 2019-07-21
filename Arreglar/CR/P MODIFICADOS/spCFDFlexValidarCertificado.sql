SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexValidarCertificado
@Estacion				int,
@Empresa				varchar(5),
@Sucursal				int,
@Tipo					varchar(20),
@FechaRegistro			datetime,
@Temporal				varchar(255),
@Ok						int = NULL OUTPUT,
@OkRef					varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@RutaFirmaSAT			varchar(255),
@RutaCertificado		varchar(255),
@Shell					varchar(8000),
@FechaTexto				varchar(max),
@FechaVencimiento		datetime,
@Encripcion				varchar(20),
@NoCertificado			varchar(20),
@ContrasenaSello		varchar(100),
@CertificadoBase64		varchar(max),
@RutaLlave				varchar(255),
@r						int,
@VersionFirmaSAT		varchar(max),
@textoDatos				varchar(max),
@RutaFirmaSATHelp       varchar(255)
DECLARE @Datos TABLE (ID int identity(1,1), Datos varchar(255))
DECLARE @Datos1 TABLE (ID int identity(1,1), Datos varchar(255))
IF (OBJECT_ID('Tempdb..#CFDFlexLeerArchivo')) IS NOT NULL
DROP TABLE #CFDFlexLeerArchivo
CREATE TABLE #CFDFlexLeerArchivo
(
ArchivoXML varchar(max) NULL
)
EXEC spCFDFlexInfo @Estacion, @Empresa, @Sucursal, @Tipo, @NoCertificado OUTPUT, @ContrasenaSello OUTPUT, @CertificadoBase64 OUTPUT, @RutaLlave OUTPUT, @RutaCertificado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF YEAR(GETDATE()) >= 2011
SET @Encripcion = ' -g sha1 '
ELSE
SET @Encripcion = ' -g md5 '
SET @Temporal = REPLACE(@Temporal,'.XML','')
SET @Temporal = @Temporal + 'FechaCertificado.TXT'
SELECT @RutaFirmaSAT = RutaFirmaSAT FROM EmpresaCFD WITH (NOLOCK) WHERE Empresa = @Empresa
SELECT @RutaFirmaSATHelp = CHAR(34) + CHAR(34) + @RutaFirmaSAT + CHAR(34) + ' HELP' + CHAR(34)
INSERT @Datos1
EXEC @r = xp_cmdshell  @RutaFirmaSATHelp
SELECT TOP 1 @TextoDatos = Datos FROM @Datos1 WHERE ISNULL(Datos,'') LIKE '%QUERYCERT%' ORDER BY ID ASC
SELECT @VersionFirmaSAT = SUBSTRING(@textoDatos, 1,26)
IF ISNULL(@TextoDatos,'') <> '' 
SET @Shell = CHAR(34) + CHAR(34) + @RutaFirmaSAT + CHAR(34) + ' QUERYCERT -q notAfter ' + CHAR(34) + @RutaCertificado + CHAR(34) + CHAR(34)
ELSE
SET @Shell = CHAR(34) + CHAR(34) + @RutaFirmaSAT + CHAR(34) + ' DATENOTAFTER ' + CHAR(34) + @RutaCertificado + CHAR(34) + CHAR(34)
INSERT @Datos
EXEC @r = xp_cmdshell @Shell
IF @r = 0
SELECT TOP 1 @FechaTexto = Datos FROM @Datos WHERE Datos IS NOT NULL
SET @Shell = CHAR(34) + CHAR(34) + @RutaFirmaSAT + CHAR(34) + ' KEYCHECK' + @Encripcion + '-k ' + CHAR(34) + @RutaLlave + CHAR(34) + ' -p ' + CHAR(34) +  @ContrasenaSello + CHAR(34) + ' ' + CHAR(34) + @Temporal + CHAR(34) + CHAR(34)
INSERT #CFDFlexLeerArchivo
EXEC xp_cmdshell @Shell
IF EXISTS(SELECT * FROM #CFDFlexLeerArchivo WHERE ArchivoXML LIKE '%Error code -15: Decryption error/De error de descifrado:%') AND @Ok IS NULL
SELECT @Ok = 60230, @OkRef = @RutaLlave
ELSE
IF EXISTS(SELECT * FROM #CFDFlexLeerArchivo WHERE ArchivoXML LIKE '%Error code -1: Cannot open input file/%') AND @Ok IS NULL
SELECT @Ok = 71525, @OkRef = @RutaLlave
IF @Ok IS NULL
BEGIN
IF SUBSTRING(@FechaTexto,1,1) NOT IN ('0','1','2','3','4','5','6','7','8','9')
SELECT @Ok = 71550, @OkRef = @RutaCertificado
END
IF @Ok IS NULL
BEGIN
SELECT @FechaVencimiento = CONVERT(datetime,REPLACE(@FechaTexto,'Z',''))
IF @@ERROR <> 0 SET @Ok = 71550
END
IF @Ok IS NULL
BEGIN
IF @FechaVencimiento < @FechaRegistro SELECT @Ok = 71560, @OkRef = @FechaVencimiento
END
END

