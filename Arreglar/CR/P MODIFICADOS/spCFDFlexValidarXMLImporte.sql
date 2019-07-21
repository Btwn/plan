SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexValidarXMLImporte
(
@Empresa		char(5),
@XML			varchar(MAX),
@RutaError	varchar(255),
@TipoCFDI		bit,
@Ok			int OUTPUT,
@OkRef		varchar(255) OUTPUT
)

AS
BEGIN
DECLARE
@Tolerancia					float,
@iDatos						int,
@Ruta						varchar(255),
@RutaXML					varchar(255),
@Prefijo					varchar(255),
@Impuesto					float,
@Retencion					float,
@TotalImpuestosRetenidos	float,
@TotalImpuestosTrasladados	float,
@Descuento					float,
@SubTotal					float,
@Total						float,
@Importe					float,
@fecha						datetime
SELECT @Tolerancia = ISNULL(ToleranciaCalculo,0.0) FROM EmpresaCFD WITH (NOLOCK) WHERE Empresa = @Empresa
DECLARE @Concepto TABLE
(
ValorUnitario				float,
Cantidad					float,
Importe						float,
Diferencia					float
)
IF @TipoCFDI = 0
BEGIN
SET @XML = REPLACE(@XML,'xmlns=','xmlns' + CHAR(58) + 'Temp=')
EXEC sp_xml_preparedocument @iDatos OUTPUT, @XML
SELECT @Ruta = '/'
END
ELSE
BEGIN
SET @Prefijo = '<ns xmlns' + CHAR(58) + 'cfdi="http' + CHAR(58) + '//www.sat.gob.mx/cfd/3" xmlns' + CHAR(58) + 'tfd="http' + CHAR(58) + '//www.sat.gob.mx/TimbreFiscalDigital"/>'
EXEC sp_xml_preparedocument @iDatos OUTPUT, @XML, @Prefijo
SET @Ruta = '/cfdi' + CHAR(58)
END
SET @RutaXML = @Ruta + 'Comprobante' + @Ruta + 'Conceptos' + @Ruta + 'Concepto'
INSERT @Concepto (ValorUnitario,            Cantidad,             Importe,             Diferencia)
SELECT ISNULL(ValorUnitario,0.0), ISNULL(Cantidad,0.0), ISNULL(importe,0.0), ABS(ISNULL(importe,0.0)-(ISNULL(ValorUnitario,0.0)*ISNULL(Cantidad,0.0)))
FROM OPENXML (@iDatos, @RutaXML, 1) WITH (valorUnitario float, cantidad float, importe float)
IF EXISTS(SELECT 1 FROM @Concepto WHERE Diferencia > @Tolerancia) SELECT @Ok = 25500, @OkRef = @RutaXML
SELECT @Importe = SUM(Importe) FROM @Concepto
IF @Ok IS NULL
BEGIN
SET @RutaXML = @Ruta + 'Comprobante' + @Ruta + 'Impuestos'
SELECT @TotalImpuestosRetenidos	= ISNULL(totalImpuestosRetenidos,0.00),
@TotalImpuestosTrasladados	= ISNULL(totalImpuestosTrasladados,0.00)
FROM OPENXML (@iDatos, @RutaXML, 1) WITH (totalImpuestosRetenidos float, totalImpuestosTrasladados float)
END
IF @Ok IS NULL
BEGIN
SET @RutaXML = @Ruta + 'Comprobante' + @Ruta + 'Impuestos' + @Ruta + 'Traslados' + @Ruta + 'Traslado'
SELECT @Impuesto	= ISNULL(SUM(importe),0.00)
FROM OPENXML (@iDatos, @RutaXML, 1) WITH (importe float)
IF (ABS(@TotalImpuestosTrasladados-@Impuesto) > @Tolerancia) SELECT @Ok = 25500, @OkRef = @RutaXML
END
IF @Ok IS NULL
BEGIN
SET @RutaXML = @Ruta + 'Comprobante' + @Ruta + 'Impuestos' + @Ruta + 'Retenciones' + @Ruta + 'Retencion'
SELECT @Retencion	= ISNULL(SUM(importe),0.00)
FROM OPENXML (@iDatos, @RutaXML, 1) WITH (importe float)
END
IF @Ok IS NULL
BEGIN
SET @RutaXML = @Ruta + 'Comprobante'
SELECT @Descuento	= ISNULL(descuento,0.00),
@SubTotal	= ISNULL(subTotal,0.00),
@Total		= ISNULL(total,0.00),
@Fecha		= fecha
FROM OPENXML (@iDatos, @RutaXML, 1) WITH (descuento float, subTotal float, total float, fecha varchar(100))
IF (ABS(@Importe-(@SubTotal/*- @Descuento*/)) > @Tolerancia) OR (ABS((@SubTotal- @Descuento) - @TotalImpuestosRetenidos + @Impuesto - @Total) > @Tolerancia) SELECT @Ok = 25500, @OkRef = @RutaXML
IF @TipoCFDI = 1 AND DATEDIFF(hour,@Fecha, getdate()) > 72 SELECT @Ok = 71650, @OkRef = 'Han Pasado Mas de 72 Horas Para Timbrar Este Comprobante'
END
END

