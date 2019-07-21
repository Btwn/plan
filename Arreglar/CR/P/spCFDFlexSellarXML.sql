SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexSellarXML
@Estacion				int,
@Empresa				varchar(5),
@Sucursal				int,
@Temporal				varchar(255),
@XML					varchar(max) OUTPUT,
@Ok						int = NULL OUTPUT,
@OkRef					varchar(255) = NULL OUTPUT,
@Encripcion				varchar(20) = NULL

AS BEGIN
DECLARE
@RutaFirmaSAT			varchar(255),
@RutaCertificado		varchar(255),
@RutaLlave				varchar(255),
@Shell					varchar(8000),
@ContrasenaSello		varchar(100),
@CampoDatos				varchar(max),
@Sello					varchar(max),
@NoCertificado			varchar(20),
@CertificadoBase64		varchar(max),
@TemporalSello			varchar(255),
@r						int,
@RenglonDatos			varchar(255),
@RID					int,
@textoDatos				varchar(max)
DECLARE @Datos TABLE (ID int identity(1,1), Datos varchar(255))
IF @Encripcion IS NULL
BEGIN
IF YEAR(GETDATE()) >= 2011
SET @Encripcion = ' -g sha1 '
ELSE
SET @Encripcion = ' -g md5 '
END ELSE
BEGIN
IF RTRIM(@Encripcion) IN ('md5','sha1')
BEGIN
SET @Encripcion = ' -g ' + RTRIM(@Encripcion)
END ELSE
BEGIN
SELECT @Ok = 71630, @OkRef = @RutaCertificado
END
END
SET @TemporalSello = REPLACE(@Temporal,'.XML','')
SET @TemporalSello = @TemporalSello + 'Sello.TXT'
EXEC spCFDFlexInfo @Estacion, @Empresa, @Sucursal, 'Sucursal', @NoCertificado OUTPUT, @ContrasenaSello OUTPUT, @CertificadoBase64 OUTPUT, @RutaLlave OUTPUT, @RutaCertificado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SELECT @RutaFirmaSAT = RutaFirmaSAT FROM EmpresaCFD WHERE Empresa = @Empresa
EXEC spEliminarArchivo @TemporalSello, @Ok OUTPUT, @OkRef OUTPUT
SET @Shell = CHAR(34) + CHAR(34) + @RutaFirmaSAT + CHAR(34) + ' MAKESIG ' + @Encripcion + ' -k ' + CHAR(34) + @RutaLlave + CHAR(34) + ' -p ' + CHAR(34) + @ContrasenaSello + CHAR(34) + ' ' + CHAR(34) + @Temporal + CHAR(34) + CHAR(34)
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
SET @Sello = ''
IF @Ok IS NULL
BEGIN
SELECT @CampoDatos= @TextoDatos
IF @CampoDatos LIKE 'ERROR%' SELECT @Ok = 71570, @OkRef = @CampoDatos
IF @Ok IS NULL
SET @Sello = ISNULL(@CampoDatos,'')
END
SET @XML = REPLACE(@XML,'_SELLO_',@Sello)
END

