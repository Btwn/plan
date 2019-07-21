SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexValidarXMLImportefdgt
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
@RutaXML2					varchar(255),
@Prefijo					varchar(255),
@Impuesto					float,
@Retencion					float,
@TotalImpuestosRetenidos	float,
@TotalImpuestosTrasladados	float,
@Descuento					float,
@SubTotal					float,
@Total						float,
@Importe					float
SELECT @Tolerancia = ISNULL(ToleranciaCalculo,0.0) FROM EmpresaCFD WITH (NOLOCK) WHERE Empresa = @Empresa
DECLARE @Detalle TABLE
(
ValorUnitario				float,
Cantidad					float,
Importe						float,
Diferencia					float
)
DECLARE @Detalle2 TABLE
(
ID							int IDENTITY,
ValorUnitario				float,
Cantidad					float,
Importe						float,
Diferencia					float
)
DECLARE @DetalleCantidad TABLE
(
ID							int IDENTITY,
Cantidad					float
)
DECLARE @TotalImpuestos TABLE
(
ID							int IDENTITY,
TotalDeImpuestos			float,
TotalDeIVA					float
)
DECLARE @TotalImpuestos2 TABLE
(
ID							int IDENTITY,
TotalDeIVA					float,
Diferencia					float
)
DECLARE @Impuestos TABLE
(
ID							int IDENTITY,
Tipo						varchar(10),
Base						float,
Tasa						float,
Monto						float,
MontoReal					float,
Diferencia					float
)
DECLARE @Descuentos TABLE
(
ID							int IDENTITY,
Tipo						varchar(10),
Base						float,
Tasa						float,
Monto						float,
MontoReal					float,
Diferencia					float
)
IF @TipoCFDI = 1
BEGIN
SET @XML = REPLACE(@XML,'xmlns=','xmlns' + CHAR(58) + 'Temp=')
IF CHARINDEX('<?xml version="1.0" encoding="Windows-1252"?>', @XML) = 0
SET @XML = '<?xml version="1.0" encoding="Windows-1252"?>' + @XML
EXEC sp_xml_preparedocument @iDatos OUTPUT, @XML
SELECT @Ruta = '/'
END
SET @RutaXML = '/FactDocGT/Detalles/Detalle'
SET @RutaXML2 = '/FactDocGT/Detalles/Detalle/ValorSinDR'
INSERT @DetalleCantidad (Cantidad)
SELECT ISNULL(Cantidad,0.0)
FROM OPENXML (@iDatos, @RutaXML, 2) WITH (Precio float, Cantidad float, Monto float)
INSERT @Detalle2 (ValorUnitario,      Importe)
SELECT ISNULL(Precio,0.0), ISNULL(Monto,0.0)
FROM OPENXML (@iDatos, @RutaXML2, 2) WITH (Precio float, Cantidad float, Monto float)
INSERT @Detalle (ValorUnitario, Cantidad,   Importe,   Diferencia)
SELECT d.ValorUnitario, c.Cantidad, d.Importe, ABS(ISNULL(d.Importe,0.0)-(ISNULL(d.ValorUnitario,0.0)*ISNULL(c.Cantidad,0.0)))
FROM @Detalle2 d JOIN @detallecantidad c ON d.ID = c.ID
IF EXISTS(SELECT 1 FROM @Detalle WHERE Diferencia > @Tolerancia) SELECT @Ok = 25500, @OkRef = @RutaXML
IF @Ok IS NULL
BEGIN
SET @RutaXML = '/FactDocGT/Detalles/Detalle/Impuestos'
SET @RutaXML2 = '/FactDocGT/Detalles/Detalle/Impuestos/Impuesto'
INSERT @Impuestos(Tipo, Base, Tasa, Monto, MontoReal, Diferencia)
SELECT Tipo, Base, Tasa, Monto, (ISNULL(Base,0.0)*ISNULL(Tasa,0.0))/100, ABS(ISNULL(Monto,0.0)-((ISNULL(Base,0.0)*ISNULL(Tasa,0.0))/100))
FROM OPENXML (@iDatos, @RutaXML2, 2) WITH (Tipo varchar(10), Base float, Tasa float, Monto float)
WHERE Tipo = 'IVA'
IF EXISTS(SELECT 1 FROM @Impuestos WHERE Diferencia > @Tolerancia) SELECT @Ok = 25500, @OkRef = @RutaXML
END
IF @Ok IS NULL
BEGIN
INSERT @TotalImpuestos(TotalDeImpuestos, TotalDeIVA)
SELECT TotalDeImpuestos, TotalDeIVA
FROM OPENXML (@iDatos, @RutaXML, 2) WITH (TotalDeImpuestos float, TotalDeIVA float)
INSERT @TotalImpuestos2(Diferencia)
SELECT ABS(ISNULL(TotalDeIVA,0.0)-((ISNULL(Base,0.0)*ISNULL(Tasa,0.0))/100))
FROM @TotalImpuestos t JOIN @Impuestos i
ON t.ID = i.ID
IF EXISTS(SELECT 1 FROM @TotalImpuestos2 WHERE Diferencia > @Tolerancia) SELECT @Ok = 25500, @OkRef = @RutaXML
END
IF @Ok IS NULL
BEGIN
SET @RutaXML = '/FactDocGT/Detalles/Detalle/DescuentosYRecargos'
SET @RutaXML2 = '/FactDocGT/Detalles/Detalle/DescuentosYRecargos/DescuentoORecargo'
INSERT @Descuentos(Tipo, Base, Tasa, Monto, MontoReal, Diferencia)
SELECT 'Descuento', Base, Tasa, Monto, (ISNULL(Base,0.0)*ISNULL(Tasa/100,0.0)), ABS(ISNULL(Monto,0.0)-((ISNULL(Base,0.0)*ISNULL(Tasa/100,0.0))))
FROM OPENXML (@iDatos, @RutaXML2, 2) WITH (Base float, Tasa float, Monto float)
IF (ABS((SELECT SUM(SumaDeDescuentos) FROM OPENXML (@iDatos, @RutaXML, 2) WITH (SumaDeDescuentos float))- (SELECT SUM(MontoReal) FROM @Descuentos)) > @Tolerancia) SELECT @Ok = 25500, @OkRef = @RutaXML
END
IF @Ok IS NULL
BEGIN
SET @RutaXML = '/FactDocGT/Totales/Impuestos'
SET @RutaXML2 = '/FactDocGT/Totales'
IF (ABS((SELECT SUM(Base) + SUM(MontoReal) FROM @Impuestos WHERE Tipo = 'IVA')) - (SELECT Total FROM OPENXML (@iDatos, @RutaXML2, 2) WITH (Total float)) > @Tolerancia) SELECT @Ok = 25500, @OkRef = @RutaXML
END
IF @Ok IS NULL
BEGIN
SET @RutaXML = '/FactDocGT/Totales'
SET @RutaXML2 = '/FactDocGT/Totales/DescuentosYRecargos'
IF (ABS((SELECT (SubTotalSinDR - (SELECT SumaDeDescuentos FROM OPENXML (@iDatos, @RutaXML2, 2) WITH (SumaDeDescuentos float))) - SubTotalConDR FROM OPENXML (@iDatos, @RutaXML, 2) WITH (SubTotalSinDR float, SubTotalConDR float))) > @Tolerancia) SELECT @Ok = 25500, @OkRef = @RutaXML
END
END

