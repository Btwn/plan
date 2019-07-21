SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexInsertarCertificadoXML
@Estacion				int,
@Empresa				varchar(5),
@Sucursal				int,
@Tipo					varchar(20),
@Certificar				bit = 1,
@Temporal				varchar(255) = NULL,
@XML					varchar(max) = NULL OUTPUT,
@Ok						int = NULL OUTPUT,
@OkRef					varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@RutaFirmaSAT			varchar(255),
@RutaCertificado		varchar(255),
@Shell					varchar(8000),
@CampoDatos				varchar(max),
@NoCertificado			varchar(20),
@ContrasenaSello		varchar(100),
@CertificadoBase64		varchar(max),
@RutaLlave				varchar(255),
@SucursalCFDFlex		bit,
@TemporalCertificado	varchar(255),
@RutaTemporal			varchar(255),
@r						int,
@RenglonDatos			varchar(255),
@RID					int,
@textoDatos				varchar(max)
DECLARE @Datos TABLE (ID int identity(1,1), Datos varchar(255))
SELECT @SucursalCFDFlex = ISNULL(CFDFlex, 0) FROM Sucursal WHERE Sucursal = @Sucursal
SELECT @Tipo = ISNULL(NULLIF(@Tipo, ''), 'Empresa')
EXEC spCFDFlexInfo @Estacion, @Empresa, @Sucursal, @Tipo, @NoCertificado OUTPUT, @ContrasenaSello OUTPUT, @CertificadoBase64 OUTPUT, @RutaLlave OUTPUT, @RutaCertificado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SELECT @CertificadoBase64 = NULLIF(@CertificadoBase64,'')
IF @CertificadoBase64 IS NULL OR @Certificar = 0
BEGIN
SELECT
@RutaFirmaSAT = RutaFirmaSAT,
@RutaTemporal = RutaTemporal
FROM EmpresaCFD
WHERE Empresa = @Empresa
IF @Temporal IS NULL
SELECT @Temporal = @RutaTemporal + CASE WHEN SUBSTRING(REVERSE(@RutaTemporal),1,1) <> '\' THEN '\' ELSE '' END + 'Temporal' + CONVERT(varchar,@Estacion) + '.XML'
SET @TemporalCertificado = REPLACE(@Temporal,'.XML','')
SET @TemporalCertificado = @TemporalCertificado + 'Certificado.TXT'
SET @Shell = CHAR(34) + CHAR(34) + @RutaFirmaSAT + CHAR(34) + ' CERTSTRING ' + CHAR(34) + @RutaCertificado + CHAR(34) + CHAR(34)
INSERT @Datos
EXEC @r = xp_cmdshell @Shell
SELECT @TextoDatos = ''
IF @r = 0
BEGIN
DECLARE crResultadoXMl CURSOR FOR
SELECT Id, Datos FROM @Datos WHERE Datos IS NOT NULL ORDER BY ID Asc
OPEN crResultadoXMl
FETCH NEXT FROM crResultadoXMl INTO @RID, @RenglonDatos
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @TextoDatos = @TextoDatos + @RenglonDatos
END
FETCH NEXT FROM crResultadoXMl INTO @RID, @RenglonDatos
END
CLOSE crResultadoXMl
DEALLOCATE crResultadoXMl
END
SET @CertificadoBase64 = ''
IF @Ok IS NULL
BEGIN
SELECT @CampoDatos = @TextoDatos
IF @CampoDatos LIKE 'ERROR%' SELECT @Ok = 71580, @OkRef = @CampoDatos
IF @Ok IS NULL
SET @CertificadoBase64 = @CertificadoBase64 + ISNULL(@CampoDatos,'')
END
IF @Ok IS NULL
IF @Tipo = 'Sucursal' AND @SucursalCFDFlex = 1
UPDATE Sucursal SET CertificadoBase64 = @CertificadoBase64 WHERE Sucursal = @Sucursal
ELSE
UPDATE EmpresaCFD SET CertificadoBase64 = @CertificadoBase64 WHERE Empresa = @Empresa
END
IF @Ok IS NULL AND @Certificar = 0
EXEC spCFDFlexActualizarNoCertificado @Estacion, @Empresa, @Sucursal, @Tipo, @Temporal, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @Certificar = 1
SET @XML = REPLACE(@XML,'_CERTIFICADO_',@CertificadoBase64)
END

