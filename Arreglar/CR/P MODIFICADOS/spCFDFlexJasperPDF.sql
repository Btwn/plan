SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexJasperPDF
@Empresa		varchar(5),
@Modulo			varchar(5),
@ID				int,
@Temporal		varchar(255),
@Imagen			varchar(255),
@Reporte		varchar(50),
@RutaDatosXML	varchar(255) OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@XML					varchar(max),
@JaseperPDF				varchar(max),
@ImporteConLetra		varchar(max),
@Comentario1			varchar(255),
@Comentario2			varchar(255),
@Comentario3			varchar(255),
@Comentario4			varchar(255),
@Comentario5			varchar(255),
@PlantillaJasper		varchar(255),
@eDocEstatus			varchar(15),
@Mov					varchar(20),
@ContMoneda				varchar(20),
@EmpresaNoInterior		varchar(20),
@ReceptorNoInterior		varchar(20),
@Receptor				varchar(50),
@TFDCadenaOriginal		varchar(max),
@EsCFDI					bit,
@Estatus				varchar(15),
@SAT_MN					bit
SET @EsCFDI = 0
IF @Modulo = 'VTAS'
BEGIN
SELECT @Mov = RTRIM(LTRIM(ISNULL(v.Mov,''))),
@Receptor = RTRIM(LTRIM(ISNULL(v.Cliente,''))),
@Estatus = RTRIM(LTRIM(ISNULL(v.Estatus,''))),
@SAT_MN = ISNULL(mt.SAT_MN, ec.SAT_MN)
FROM Venta v WITH (NOLOCK)
JOIN EmpresaCFD ec WITH (NOLOCK)
ON v.Empresa = ec.Empresa
JOIN MovTipo mt WITH (NOLOCK)
ON v.Mov = mt.Mov AND mt.Modulo = @Modulo
WHERE v.ID = @ID
SELECT @ReceptorNoInterior = RTRIM(LTRIM(ISNULL(DireccionNumeroInt,''))) FROM Cte WITH (NOLOCK) WHERE Cliente = @Receptor
END
ELSE
IF @Modulo = 'COMS'
BEGIN
SELECT @Mov = RTRIM(LTRIM(ISNULL(c.Mov,''))),
@Receptor = RTRIM(LTRIM(ISNULL(c.Proveedor,''))),
@Estatus = RTRIM(LTRIM(ISNULL(c.Estatus,''))),
@SAT_MN = ISNULL(mt.SAT_MN, ec.SAT_MN)
FROM Compra c WITH (NOLOCK)
JOIN EmpresaCFD ec WITH (NOLOCK)
ON c.Empresa = ec.Empresa
JOIN MovTipo mt WITH (NOLOCK)
ON c.Mov = mt.Mov AND mt.Modulo = @Modulo
WHERE c.ID = @ID
SELECT @ReceptorNoInterior = RTRIM(LTRIM(ISNULL(DireccionNumeroInt,''))) FROM Prov WITH (NOLOCK) WHERE Proveedor = @Receptor
END
ELSE
IF @Modulo = 'CXC'
BEGIN
SELECT @Mov = RTRIM(LTRIM(ISNULL(Cxc.Mov,''))),
@Receptor = RTRIM(LTRIM(ISNULL(Cxc.Cliente,''))),
@Estatus = RTRIM(LTRIM(ISNULL(Cxc.Estatus,''))),
@SAT_MN = ISNULL(mt.SAT_MN, ec.SAT_MN)
FROM Cxc WITH (NOLOCK)
JOIN EmpresaCFD ec WITH (NOLOCK)
ON Cxc.Empresa = ec.Empresa
JOIN MovTipo mt WITH (NOLOCK)
ON Cxc.Mov = mt.Mov AND mt.Modulo = @Modulo
WHERE Cxc.ID = @ID
SELECT @ReceptorNoInterior = RTRIM(LTRIM(ISNULL(DireccionNumeroInt,''))) FROM Cte WITH (NOLOCK) WHERE Cliente = @Receptor
END
ELSE
IF @Modulo = 'CXP'
BEGIN
SELECT @Mov = RTRIM(LTRIM(ISNULL(Cxp.Mov,''))),
@Receptor = RTRIM(LTRIM(ISNULL(Cxp.Proveedor,''))),
@Estatus = RTRIM(LTRIM(ISNULL(Cxp.Estatus,''))),
@SAT_MN = ISNULL(mt.SAT_MN, ec.SAT_MN)
FROM Cxp WITH (NOLOCK)
JOIN EmpresaCFD ec WITH (NOLOCK)
ON Cxp.Empresa = ec.Empresa
JOIN MovTipo mt WITH (NOLOCK)
ON Cxp.Mov = mt.Mov AND mt.Modulo = @Modulo
WHERE Cxp.ID = @ID
SELECT @ReceptorNoInterior = RTRIM(LTRIM(ISNULL(DireccionNumeroInt,''))) FROM Prov WITH (NOLOCK) WHERE Proveedor = @Receptor
END
SELECT @ContMoneda = RTRIM(LTRIM(ISNULL(ContMoneda,''))) FROM EmpresaCfg WITH (NOLOCK) WHERE Empresa = @Empresa
SELECT @EmpresaNoInterior = RTRIM(LTRIM(ISNULL(DireccionNumeroInt,''))) FROM Empresa WITH (NOLOCK) WHERE Empresa = @Empresa
UPDATE CFD WITH (ROWLOCK)
SET TFDCadenaOriginal = dbo.fnCFDFlexCadenaOriginalTFDI(@Modulo, @ID)
WHERE Modulo = @Modulo
AND ModuloID = @ID
SELECT @XML = ISNULL(Documento,''),
@TFDCadenaOriginal = ISNULL(TFDCadenaOriginal,'')
FROM CFD WITH (NOLOCK)
WHERE Modulo = @Modulo
AND ModuloID = @ID
IF @Modulo = 'VTAS'
SELECT
@ImporteConLetra = RTRIM(LTRIM(ISNULL(dbo.fnNumeroEnEspanol(VentaTotal,CASE WHEN @SAT_MN = 1 THEN @ContMoneda ELSE VentaMoneda END),''))),
@ImporteConLetra = CASE WHEN @SAT_MN = 1 THEN '(' + @ImporteConLetra +  + ' M.N.)' ELSE
CASE WHEN @ContMoneda = VentaMoneda THEN '(' + @ImporteConLetra +  + ' M.N.)' ELSE '(' + @ImporteConLetra +  + ')' END END
FROM CFDVenta WITH (NOLOCK)
WHERE ID = @ID
ELSE
IF @Modulo = 'CXC'
SELECT
@ImporteConLetra = RTRIM(LTRIM(ISNULL(dbo.fnNumeroEnEspanol(CxcTotal,CASE WHEN @SAT_MN = 1 THEN @ContMoneda ELSE CXCMoneda END),''))),
@ImporteConLetra = CASE WHEN @SAT_MN = 1 THEN '(' + @ImporteConLetra +  + ' M.N.)' ELSE
CASE WHEN @ContMoneda = CXCMoneda THEN '(' + @ImporteConLetra +  + ' M.N.)' ELSE '(' + @ImporteConLetra +  + ')' END END
FROM CFDCxc WITH (NOLOCK)
WHERE ID = @ID
SELECT @Comentario1		=	RTRIM(LTRIM(ISNULL(Comentario1,''))),
@Comentario2		=	RTRIM(LTRIM(ISNULL(Comentario2,''))),
@Comentario3		=	RTRIM(LTRIM(ISNULL(Comentario3,''))),
@Comentario4		=	RTRIM(LTRIM(ISNULL(Comentario4,''))),
@Comentario5		=	RTRIM(LTRIM(ISNULL(Comentario5,''))),
@PlantillaJasper	=	RTRIM(LTRIM(ISNULL(PlantillaJasper,'')))
FROM EmpresaCFDJasperReports WITH (NOLOCK)
WHERE Empresa = @Empresa AND Reporte = @Reporte
IF NULLIF(@Receptor,'') IS NULL SET @Receptor = '(Todos)'
SELECT
@eDocEstatus = NULLIF(Estatus,'')
FROM MovTipoCFDFlex WITH (NOLOCK)
WHERE Modulo = @Modulo
AND Mov = @Mov
AND Contacto = @Receptor
IF NULLIF(@eDocEstatus,'') IS NULL
BEGIN
SELECT
@eDocEstatus = NULLIF(Estatus,'')
FROM MovTipoCFDFlex WITH (NOLOCK)
WHERE Modulo = @Modulo
AND Mov = @Mov
AND ISNULL(NULLIF(ISNULL(NULLIF(Contacto,''),'(Todos)'),'(Todos)'),@Receptor) = @Receptor
END
IF @XML LIKE '%<cfdi:Comprobante%' SET @EsCFDI = 1
IF @Ok IS NULL
EXEC speDocXML @@SPID, @Empresa, @Modulo, '', @ID, @PlantillaJasper, @eDocEstatus, 0, 1, @XML OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, 0, 1
SELECT @JaseperPDF = 'Movimiento="' + @Mov + '" ' +
'ImporteConLetra="' + @ImporteConLetra + '" ' +
'Estatus="' + @Estatus + '" ' +
'EmpresaNoInterior="' + dbo.fneDocXmlAUTF8Min(@EmpresaNoInterior,0,1) + '" ' +
'ReceptorNoInterior="'+ dbo.fneDocXmlAUTF8Min(@ReceptorNoInterior,0,1) + '" ' +
'Comentario1="' + dbo.fneDocXmlAUTF8Min(@Comentario1,0,1) + '" ' + 
'Comentario2="' + dbo.fneDocXmlAUTF8Min(@Comentario2,0,1) + '" ' + 
'Comentario3="' + dbo.fneDocXmlAUTF8Min(@Comentario3,0,1) + '" ' + 
'Comentario4="' + dbo.fneDocXmlAUTF8Min(@Comentario4,0,1) + '" ' + 
'Comentario5="' + dbo.fneDocXmlAUTF8Min(@Comentario5,0,1) + '" ' + 
'TFDCadenaOriginal="' + @TFDCadenaOriginal + '" ' +
'CFDModulo=" '
SELECT @XML = REPLACE(@XML, 'CFDModulo="', @JaseperPDF)
EXEC spCFDFlexRegenerarArchivo @Empresa, @Temporal, @XML, @Ok OUTPUT, @OkRef OUTPUT
IF @EsCFDI = 1
EXEC spCFDFlexQRCode @Empresa, @Modulo, @ID, @Imagen
IF CHARINDEX('<FactDocGT xmlns' + CHAR(58) + 'xsi="http' + CHAR(58) + '//www.w3.org/2001/XMLSchema-instance" xmlns="http' + CHAR(58) + '//www.fact.com.mx/schema/gt"', @XML) = 0
SELECT @RutaDatosXML = '/Comprobante/Conceptos/Concepto'
ELSE
SELECT @RutaDatosXML = '/FactDocGT/Detalles/Detalle'
END

