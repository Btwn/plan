SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpTimbrarCFDIDespues
@Modulo				char(5),
@ID					int,
@Documento			varchar(max),
@CadenaOriginal		varchar(max)
AS BEGIN
DECLARE
@OkRef		varchar(255),
@versionCFD	varchar(10),
@Empresa		varchar(10),
@iDatos					int,
@DocumentoXML			xml,
@PrefijoCFDI			varchar(255),
@RutaCFDI				varchar(255),
@UUID					varchar(50),
@SelloSAT				varchar(max),
@TFDVersion				varchar(max),
@FechaTimbrado			varchar(max),
@noCertificadoSAT		varchar(max),
@TFDCadenaOriginal		varchar(max),
@Mov					varchar(20),
@MovId				varchar(20),
@Timbrado				bit,
@Ok					int,
@SelloCFD			varchar(max)
EXEC spMovInfo @ID, @Modulo, @Empresa = @Empresa OUTPUT, @Mov = @Mov OUTPUT, @MovID = @MovID OUTPUT
SELECT @VersionCFD = Version FROM EmpresaCFD WHERE Empresa = @Empresa
SELECT @OkRef = NULL
IF NULLIF(LTRIM(RTRIM(@Documento)),'') IS NULL
BEGIN
SELECT @OkRef = 'IntelisisTimbrar.exe - El Resultado del Documento XML a Timbrar Esta Vacio'
SELECT @OkRef
RETURN
END
EXEC xpCFDIRegistrarlog 'DESPUES DE TIMBRAR (INICIO)', @Empresa, @Modulo, @ID, @Mov, @MovID, @Documento, NULL, @Ok, @OkRef, NULL
SELECT @DocumentoXML = CONVERT(XML,REPLACE(REPLACE(@Documento,'encoding="UTF-8"','encoding="Windows-1252"'),'?<?xml','<?xml'))
EXEC sp_xml_preparedocument @iDatos OUTPUT, @DocumentoXML
SELECT @OkRef = MENSAJE FROM OPENXML (@iDatos, '/ERROR',2) WITH (MENSAJE  varchar(255))
EXEC sp_xml_removedocument @iDatos
IF @OkRef IS NULL
BEGIN
SET @PrefijoCFDI = '<ns xmlns' + CHAR(58) + 'cfdi="http' + CHAR(58) + '//www.sat.gob.mx/cfd/3" xmlns' + CHAR(58) + 'tfd="http' + CHAR(58) + '//www.sat.gob.mx/TimbreFiscalDigital"/>'
EXEC sp_xml_preparedocument @iDatos OUTPUT, @DocumentoXML, @PrefijoCFDI
SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Complemento/tfd' + CHAR(58) + 'TimbreFiscalDigital'
SELECT
@UUID = UUID
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (UUID uniqueidentifier)
SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Complemento/tfd' + CHAR(58) + 'TimbreFiscalDigital'
SELECT
@SelloSAT = SelloSAT
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (selloSAT varchar(max))
SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Complemento/tfd' + CHAR(58) + 'TimbreFiscalDigital'
SELECT
@SelloCFD = selloCFD
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (selloCFD varchar(max))
SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Complemento/tfd' + CHAR(58) + 'TimbreFiscalDigital'
SELECT
@TFDVersion = version
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (version varchar(max))
SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Complemento/tfd' + CHAR(58) + 'TimbreFiscalDigital'
SELECT
@FechaTimbrado = FechaTimbrado
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (FechaTimbrado varchar(max))
SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Complemento/tfd' + CHAR(58) + 'TimbreFiscalDigital'
SELECT
@noCertificadoSAT = noCertificadoSAT
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (noCertificadoSAT varchar(max))
IF @SelloSAT IS NOT NULL SELECT @Timbrado = 1 ELSE SELECT @Timbrado = 0
SELECT @TFDCadenaOriginal = '||'+@TFDVersion+'|'+@UUID+'|'+@FechaTimbrado+'|'+@SelloCFD+'|'+@noCertificadoSAT+'||'
UPDATE CFD
SET
SelloCFD = @SelloCFD,
SelloSAT = @SelloSAT,
FechaTimbrado = @FechaTimbrado,
UUID = @UUID,
TFDversion = @TFDVersion,
noCertificadoSAT = @noCertificadoSAT,
TFDCadenaOriginal = @TFDCadenaOriginal,
Timbrado = @Timbrado
FROM CFD
JOIN EmpresaCFD cfg ON cfg.Empresa=@Empresa
WHERE cfd.Modulo = @Modulo AND cfd.ModuloID = @ID
IF @Modulo ='VTAS'
UPDATE Venta SET CFDTimbrado = @Timbrado WHERE ID =@ID
IF @Modulo ='CXC'
UPDATE Cxc SET CFDTimbrado = @Timbrado WHERE ID =@ID
EXEC sp_xml_removedocument @iDatos
END
EXEC xpCFDIRegistrarlog 'DESPUES DE TIMBRAR (FIN)', @Empresa, @Modulo, @ID, @Mov, @MovID, @Documento, @Timbrado, @Ok, @OkRef, @UUID
IF @OkRef IS NOT NULL
SELECT ' - '+@OkRef
ELSE
SELECT ''
RETURN
END

