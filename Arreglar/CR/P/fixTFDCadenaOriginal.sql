SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.fixTFDCadenaOriginal
@Modulo				char(5) = NULL,
@ID					int = NULL

AS BEGIN
DECLARE
@Documento			varchar(max),
@CadenaOriginal		varchar(max),
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
@SelloCFD			varchar(max),
@CFDModulo		varchar(20),
@CFDID		int,
@VersionSAT	varchar(20)
DECLARE crDocumentoCFD CURSOR FOR
SELECT Modulo, ModuloID, Documento FROM CFD
WHERE Modulo = ISNULL(@Modulo, Modulo) AND ModuloID = ISNULL(@ID,ModuloID)
AND Documento IS NOT NULL AND UUID IS NOT NULL
OPEN crDocumentoCFD
FETCH NEXT FROM crDocumentoCFD INTO @CFDModulo, @CFDId, @Documento
WHILE @@FETCH_STATUS = 0
BEGIN
BEGIN TRY
EXEC spMovInfo @CFDID, @CFDModulo, @Empresa = @Empresa OUTPUT
SELECT @VersionCFD = Version FROM EmpresaCFD WHERE Empresa = @Empresa
SELECT @OkRef = NULL
SET @DocumentoXML = CONVERT(XML,@Documento)
SET @PrefijoCFDI = '<ns xmlns' + CHAR(58) + 'cfdi="http' + CHAR(58) + '//www.sat.gob.mx/cfd/3" xmlns' + CHAR(58) + 'tfd="http' + CHAR(58) + '//www.sat.gob.mx/TimbreFiscalDigital"/>'
EXEC sp_xml_preparedocument @iDatos OUTPUT, @DocumentoXML, @PrefijoCFDI
SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante'
SELECT @VersionSAT = version
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (version varchar(20))
IF @VersionSAT = '3.2'
BEGIN
SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Complemento/tfd' + CHAR(58) + 'TimbreFiscalDigital'
SELECT @UUID = UUID
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (UUID uniqueidentifier)
SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Complemento/tfd' + CHAR(58) + 'TimbreFiscalDigital'
SELECT @SelloSAT = SelloSAT
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (selloSAT varchar(max))
SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Complemento/tfd' + CHAR(58) + 'TimbreFiscalDigital'
SELECT @SelloCFD = selloCFD
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (selloCFD varchar(max))
SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Complemento/tfd' + CHAR(58) + 'TimbreFiscalDigital'
SELECT @TFDVersion = version
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (version varchar(max))
SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Complemento/tfd' + CHAR(58) + 'TimbreFiscalDigital'
SELECT @FechaTimbrado = FechaTimbrado
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (FechaTimbrado varchar(max))
SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Complemento/tfd' + CHAR(58) + 'TimbreFiscalDigital'
SELECT @noCertificadoSAT = noCertificadoSAT
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (noCertificadoSAT varchar(max))
SELECT @TFDCadenaOriginal = '||'+@TFDVersion+'|'+@UUID+'|'+@FechaTimbrado+'|'+@SelloCFD+'|'+@noCertificadoSAT+'||'
UPDATE CFD
SET SelloCFD = @SelloCFD, TFDCadenaOriginal = @TFDCadenaOriginal
WHERE Modulo = @CFDModulo AND ModuloID = @CFDID
END
EXEC sp_xml_removedocument @iDatos
END TRY
BEGIN CATCH
PRINT 'NO SE PUDO OBTENER LA CADENA ORIGINAL DEL TIMBRE FISCAL DIGITAL. Modulo = '+@CFDModulo+ ' ID = '+ convert(varchar(20),@CFDID)
END CATCH
FETCH NEXT FROM crDocumentoCFD INTO @CFDModulo, @CFDId, @Documento
END
CLOSE crDocumentoCFD
DEALLOCATE crDocumentoCFD
RETURN
END

