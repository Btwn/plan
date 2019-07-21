SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexTextoQRCode
(
@Modulo                                                                             varchar(5),
@ModuloID                                                          int
)

AS BEGIN
DECLARE
@Resultado                                                     varchar(255),
@EmisorRFC                                                       varchar(50),
@ReceptorRFC                                    varchar(50),
@Importe                                                              float,
@UUID                                                                  varchar(50),
@XML                                                                   varchar(max),
@DocumentoXML                                xml,
@PrefijoCFDI                                       varchar(255),
@RutaCFDI                                                          varchar(255),
@iDatos                                                                int
SELECT
@XML = Documento
FROM CFD
WHERE Modulo = @Modulo
AND ModuloID = @ModuloID
SET @DocumentoXML = CONVERT(XML,REPLACE(REPLACE(@XML,'encoding="UTF-8"','encoding="Windows-1252"'),'?<?xml','<?xml'))
SET @PrefijoCFDI = '<ns xmlns' + CHAR(58) + 'cfdi="http' + CHAR(58) + '//www.sat.gob.mx/cfd/3" xmlns' + CHAR(58) + 'tfd="http' + CHAR(58) + '//www.sat.gob.mx/TimbreFiscalDigital"/>'
EXEC sp_xml_preparedocument @iDatos OUTPUT, @DocumentoXML, @PrefijoCFDI
SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante'
SELECT
@Importe = total
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (total float)
SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Receptor'
SELECT
@ReceptorRFC = rfc
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (rfc varchar(15))
SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Emisor'
SELECT
@EmisorRFC = rfc
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (rfc varchar(15))
SET @RutaCFDI = '/cfdi' + CHAR(58) + 'Comprobante/cfdi' + CHAR(58) + 'Complemento/tfd' + CHAR(58) + 'TimbreFiscalDigital'
SELECT
@UUID = UUID
FROM OPENXML (@iDatos, @RutaCFDI, 1) WITH (UUID uniqueidentifier)
EXEC sp_xml_removedocument @iDatos
SET @Resultado = '?re='+ISNULL(@EmisorRFC,'')+'&rr='+ISNULL(@ReceptorRFC,'')+'&tt='+dbo.fnCFDFlexFormatearImporte(@Importe,10,6)+'&id='+@UUID
SELECT @Resultado
END

