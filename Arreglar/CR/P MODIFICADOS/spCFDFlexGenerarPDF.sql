SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexGenerarPDF
@Empresa			varchar(5),
@Modulo				varchar(5),
@Mov				varchar(20),
@ID					int,
@Usuario			varchar(10),
@Adicional			bit = 0,
@IDIS				int = NULL OUTPUT,
@Ok					int = NULL OUTPUT,
@OkRef				varchar(255) = NULL OUTPUT,
@HtaGenerarPDF         bit=0

AS BEGIN
DECLARE
@Datos					varchar(max),
@Procesado				bit,
@Reporte				varchar(100),
@Contacto				varchar(10),
@eMail					varchar(255),
@Para					varchar(255),
@Asunto					varchar(max),
@Mensaje				varchar(max),
@Contrasena				varchar(32),
@AlmacenarXML				bit,
@AlmacenarPDF				bit,
@EnviarXML				bit,
@EnviarPDF				bit,
@Archivo				varchar(255),
@NomArch				varchar(255),
@Ruta					varchar(255),
@Sucursal				int,
@PDFExiste				int,
@ArchivoPDF				varchar(255),
@Enviar					bit,
@JasperFueraLinea		bit, 
@Procesar				bit, 
@EnviarAlAfectar		bit
SELECT @Reporte = NULL, @Para = '', @Asunto = NULL, @Mensaje = NULL, @Contrasena = NULL, @EnviarXML = NULL, @EnviarPDF = NULL, @PDFExiste = 0, @Enviar = 0
SELECT @Contrasena = Contrasena FROM Usuario WITH (NOLOCK) WHERE Usuario = @Usuario
EXEC spCFDFlexAlmacenar @Modulo, @ID, @Usuario, @Adicional, @AlmacenarXML OUTPUT, @AlmacenarPDF OUTPUT, @Archivo OUTPUT, @Reporte OUTPUT, @Ruta OUTPUT, @Para OUTPUT, @Asunto OUTPUT, @Mensaje OUTPUT, @Contacto OUTPUT, @Sucursal OUTPUT , @Enviar OUTPUT, @EnviarXML OUTPUT, @EnviarPDF OUTPUT
SET @NomArch = @Archivo
SET @Archivo = @Ruta + '\' + @Archivo
SET @ArchivoPDF = @Archivo + '.PDF'
IF NULLIF(@Para,'') IS NULL AND @Enviar = 1 SELECT @Enviar = 0, @EnviarPDF = 0, @EnviarXML = 0
EXEC spVerificarArchivo @ArchivoPDF, @PDFExiste OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SELECT  @EnviarAlAfectar = EnviarAlAfectar FROM EmpresaCFD WITH (NOLOCK) WHERE Empresa = @Empresa
IF    @AlmacenarXML = 1 Or @HtaGenerarPDF =1 AND @Ok IS NULL
BEGIN
EXEC spCrearRuta @Ruta, @Ok OUTPUT, @OkRef OUTPUT
SET @Datos = '<?xml version="1.0" encoding="Windows-1252"?><Intelisis Sistema="SDK" Contenido="Solicitud" Referencia="SDK.ReportePDF" SubReferencia="" Version="1.0">' +
'  <Solicitud>' +
'    <Expresion>' + CASE WHEN (@AlmacenarPDF = 1) AND (@PDFExiste = 0) AND NULLIF(@Reporte,'') IS NOT NULL THEN '<![CDATA[ReportePDF(' + CHAR(39) + @Reporte + CHAR(39) + ',' + CONVERT(varchar,ISNULL(@ID,0)) + ',' + '<T>' + @Archivo + '<T>' + ')]]>' ELSE 'Asigna(Temp.Num,Temp.Num)' END + '</Expresion>' +  
'    <Empresa>' + dbo.fneDocXmlAUTF8Min(RTRIM(ISNULL(@Empresa,'')),0,1) + '</Empresa>' +
'    <Sucursal>' + RTRIM(ISNULL(CONVERT(varchar,@Sucursal),'')) + '</Sucursal>' +
'    <Modulo>' + RTRIM(ISNULL(@Modulo,'')) + '</Modulo>' +
'    <Mov>' + RTRIM(ISNULL(@Mov,'')) + '</Mov>' +
'    <ID>' + RTRIM(CONVERT(varchar,@ID)) + '</ID>' +
'    <NomArch>' + dbo.fneDocXmlAUTF8Min(RTRIM(ISNULL(@NomArch,'')),0,1) + '</NomArch>' +
'    <Archivo>' + dbo.fneDocXmlAUTF8Min(RTRIM(ISNULL(@Archivo,'')),0,1) + '</Archivo>' +
'    <Para>' + dbo.fneDocXmlAUTF8Min(RTRIM(ISNULL(@Para,'')),0,1) + '</Para>' +
'    <Asunto>' + dbo.fneDocXmlAUTF8Min(RTRIM(ISNULL(@Asunto,'')),0,1) + '</Asunto>' +
'    <Mensaje>' + dbo.fneDocXmlAUTF8Min(RTRIM(ISNULL(@Mensaje,'')),0,1) + '</Mensaje>' +
'    <AlmacenarPDF>' + CASE WHEN @AlmacenarPDF = 1 THEN 'SI' ELSE 'NO' END + '</AlmacenarPDF>' +
'    <AlmacenarXML>' + CASE WHEN @AlmacenarXML = 1 THEN 'SI' ELSE 'NO' END + '</AlmacenarXML>' +
'    <Enviar>' + CASE WHEN @Enviar = 1 THEN 'SI' ELSE 'NO' END + '</Enviar>' +
'    <EnviarPDF>' + CASE WHEN @EnviarPDF = 1 THEN 'SI' ELSE 'NO' END + '</EnviarPDF>' +
'    <EnviarXML>' + CASE WHEN @EnviarXML = 1 THEN 'SI' ELSE 'NO' END + '</EnviarXML>' +
'    <HtaGenerarPDF>' + CASE WHEN @HtaGenerarPDF  = 1 THEN 'SI' ELSE 'NO' END + '</HtaGenerarPDF>' +
'  </Solicitud>' +
'</Intelisis>'
SELECT @JasperFueraLinea = ISNULL(JasperFueraLinea,0) FROM EmpresaCFD WITH (NOLOCK) WHERE Empresa = @Empresa
IF @JasperFueraLinea = 1
SELECT @Procesar = 0
ELSE
SELECT @Procesar = 1
IF @Ok IS NULL
EXEC spIntelisisService @Usuario, @Contrasena, @Datos, NULL, @Ok OUTPUT, @OkRef OUTPUT, @Procesar, 0, @IDIS OUTPUT
END
END

