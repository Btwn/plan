SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDIRetencionObtenerTimbre
@Empresa				varchar(5),
@ID					int,
@Proveedor			varchar(10),
@Documento			nvarchar(max),
@CadenaOriginal		varchar(max)	OUTPUT,
@SelloSAT			varchar(max)	OUTPUT,
@SelloCFD			varchar(max)    OUTPUT,
@FechaTimbrado		varchar(max)	OUTPUT,
@UUID				varchar(50)		OUTPUT,
@TFDVersion			varchar(max)	OUTPUT,
@noCertificadoSAT	varchar(max)	OUTPUT,
@TFDCadenaOriginal	varchar(max)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @versionCFD			varchar(10),
@iDatos				int,
@DocumentoXML			xml,
@PrefijoCFDI			varchar(255),
@RutaCFDI				varchar(255)
SELECT @VersionCFD = Version FROM EmpresaCFD WHERE Empresa = @Empresa
SELECT @OkRef = NULL
SELECT @Documento = REPLACE(@Documento, '<?xml version="1.0" encoding="UTF-8"?>', '')
EXEC sp_xml_preparedocument @iDatos OUTPUT, @Documento
SELECT @OkRef = MENSAJE FROM OPENXML (@iDatos, '/ERROR',2) WITH (MENSAJE  varchar(255))
IF @OkRef IS NOT NULL SELECT @OK = 71650
EXEC sp_xml_removedocument @iDatos
IF @OK IS NULL
BEGIN
SET @DocumentoXML = CONVERT(XML,@Documento)
SET @PrefijoCFDI = '<ns xmlns' + CHAR(58) + 'retenciones="http' + CHAR(58) + '//www.sat.gob.mx/esquemas/retencionpago/1" xmlns' + CHAR(58) + 'tfd="http' + CHAR(58) + '//www.sat.gob.mx/TimbreFiscalDigital"/>'
EXEC sp_xml_preparedocument @iDatos OUTPUT, @DocumentoXML, @PrefijoCFDI
SET @RutaCFDI = '/retenciones' + CHAR(58) + 'Retenciones/retenciones' + CHAR(58) + 'Complemento/tfd' + CHAR(58) + 'TimbreFiscalDigital'
SELECT
@UUID = UUID
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (UUID uniqueidentifier)
SELECT
@SelloSAT = SelloSAT
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (selloSAT varchar(max))
SELECT
@SelloCFD = selloCFD
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (selloCFD varchar(max))
SELECT
@TFDVersion = version
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (version varchar(max))
SELECT
@FechaTimbrado = FechaTimbrado
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (FechaTimbrado varchar(max))
SELECT
@noCertificadoSAT = noCertificadoSAT
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (noCertificadoSAT varchar(max))
SELECT @TFDCadenaOriginal = '||'+@TFDVersion+'|'+@UUID+'|'+@FechaTimbrado+'|'+@SelloCFD+'|'+@noCertificadoSAT+'||'
EXEC sp_xml_removedocument @iDatos
END
RETURN
END

