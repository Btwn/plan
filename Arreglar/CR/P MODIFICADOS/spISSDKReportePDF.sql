SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISSDKReportePDF
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT,
@CambiarEstatus	bit OUTPUT

AS BEGIN
DECLARE
@Expresion				varchar(max),
@XML					varchar(max),
@Sistema				varchar(100),
@Referencia				varchar(100),
@ArchivoXML				varchar(255),
@Empresa				varchar(5),
@Modulo					varchar(5),
@ModuloID				int,
@Archivo				varchar(255),
@iDatos					int,
@XMLExiste				int,
@Documento				varchar(max),
@Shell					varchar(8000),
@RutaJasper				varchar(255),
@Jasper					bit,
@Ruta					varchar(255),
@RutaTemporal			varchar(255),
@NomArch				varchar(255),
@ArchivoBMP				varchar(255),
@Mov					varchar(20),
@Reporte				varchar(50),
@RutaLogo				varchar(255),
@AlmacenarPDF			varchar(5),
@RutaDatosXML			varchar(255),
@JasperFueraLinea		bit,
@Nailgun				bit,
@RutaNG					varchar(255),
@HtaGenerarPDF			varchar(5),
@ReportBuilder          bit, 
@RutaReportBuilder      varchar(255),
@BaseArchivo            varchar(255),
@Movimiento             varchar(20),
@Sucursal               int,
@Usuario                char(10),
@Reporteador            varchar(30),
@ReporteIntelisis       bit, 
@RutaLog                varchar(255),
@Existe                 bit,
@EnviarAlAfectar		bit
DECLARE @Datos TABLE(Datos varchar(255) COLLATE DATABASE_DEFAULT NULL)
DECLARE @Tabla TABLE (IDIntelisisService		int,
Expresion				varchar(max) COLLATE DATABASE_DEFAULT NULL)
DELETE @Datos
DELETE @Tabla
INSERT @Tabla
EXEC xpEscucharSQLAntes @ID
SELECT @ArchivoXML = ''
SET @Jasper = 0
SET @ReportBuilder = 0
SET @ReporteIntelisis = 0 
SELECT @Empresa	= RTRIM(LTRIM(ISNULL(Empresa,''))),
@Modulo	= RTRIM(LTRIM(ISNULL(Modulo,''))),
@ModuloID	= ID,
@Archivo	= RTRIM(LTRIM(ISNULL(Archivo,''))),
@NomArch	= RTRIM(LTRIM(ISNULL(NomArch,''))),
@Mov		= RTRIM(LTRIM(ISNULL(Mov,''))),
@AlmacenarPDF = AlmacenarPDF,
@HtaGenerarPDF=HtaGenerarPDF
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud', 2) WITH (Empresa varchar(5), Modulo varchar(5), ID int, Archivo varchar(255), NomArch varchar(255), Mov varchar(20), AlmacenarPDF varchar(5),GenerarPdfAfectar varchar(5),HtaGenerarPDF varchar(5))
SELECT @Reporte = NULLIF(ReporteJasper,'') FROM EmpresaCFDReporte WITH (NOLOCK) WHERE Empresa = @Empresa AND Modulo = @Modulo AND Mov = @Mov
IF @Reporte IS NULL SELECT @Reporte = RTRIM(LTRIM(NULLIF(CFDReporteJasper,''))) FROM MovTipo WITH (NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov
SELECT @RutaJasper		= RTRIM(LTRIM(ISNULL(RutaJasper,''))),
@RutaReportBuilder = RTRIM(LTRIM(ISNULL(RutaReportBuilder,''))),
@Reporteador       = ISNULL(Reporteador,''),
@RutaTemporal		= RTRIM(LTRIM(ISNULL(RutaTemporal,''))),
@JasperFueraLinea	= ISNULL(JasperFueraLinea,0),
@Nailgun			= ISNULL(Nailgun,0),
@RutaNG			= REPLACE(@RutaJasper,'IntelisisJReport.exe', 'ng com.intelisis.JReport.IntelisisJReport') 
FROM EmpresaCFD WITH (NOLOCK) WHERE Empresa = @Empresa
IF @Reporteador = 'Jasper Reports' 
SET @Jasper = 1
IF @Reporteador = 'Report Builder' 
SET @ReportBuilder = 1
IF @Reporteador = 'Reporteador Intelisis'
SET @ReporteIntelisis = 1
SELECT @Ruta = RTRIM(LTRIM(ISNULL(Ruta,''))),
@RutaLogo = RTRIM(LTRIM(ISNULL(RutaLogo,'')))
FROM EmpresaCFDJasperReports WITH (NOLOCK)
WHERE Empresa = @Empresa AND Reporte = @Reporte
SELECT  @EnviarAlAfectar = EnviarAlAfectar FROM EmpresaCFD  WITH (NOLOCK) WHERE Empresa = @Empresa
IF ISNULL(@Jasper,0) = 1 OR ISNULL(@ReportBuilder,0) = 1 OR ISNULL(@ReporteIntelisis,0) = 1
BEGIN
IF @Jasper = 1 AND @ReportBuilder = 0 AND @ReporteIntelisis = 0
BEGIN
IF @Reporte IS NULL SELECT @OK = 71660, @OkRef = 'Falta Configurar Reporte Jasper'
EXEC xpCFDFlexAlmacenarPDF @Empresa, @Modulo, @ModuloID, @AlmacenarPDF OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
IF (@AlmacenarPDF = 'SI' and @EnviarAlAfectar =1) or @htaGenerarPDF ='SI'
BEGIN
SET @ArchivoXML = @RutaTemporal + '\' + @NomArch + 'Jasper.XML'
SET @ArchivoBMP = @RutaTemporal + '\' + @NomArch + '.BMP'
SET @Archivo = @Archivo + '.PDF'
EXEC spCFDFlexJasperPDF @Empresa, @Modulo, @ModuloID, @ArchivoXML, @ArchivoBMP, @Reporte, @RutaDatosXML OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Nailgun = 0
SET @Shell = @RutaJasper + ' ' + CHAR(34) + @ArchivoXML + CHAR(34) + ' ' + CHAR(34) + @Ruta + CHAR(34) + ' ' + CHAR(34) + @RutaLogo + CHAR(34) + ' ' + CHAR(34) + @ArchivoBMP + CHAR(34) + ' " " ' + CHAR(34) + @RutaDatosXML + CHAR(34) + ' ' + CHAR(34) + @Archivo + CHAR(34)+ ' ' + CHAR(34) + @RutaJasper + CHAR(34)
ELSE
SET @Shell = @RutaNG + ' ' + CHAR(34) + @ArchivoXML + CHAR(34) + ' ' + CHAR(34) + @Ruta + CHAR(34) + ' ' + CHAR(34) + @RutaLogo + CHAR(34) + ' ' + CHAR(34) + @ArchivoBMP + CHAR(34) + ' " " ' + CHAR(34) + @RutaDatosXML + CHAR(34) + ' ' + CHAR(34) + @Archivo + CHAR(34) + ' ' + CHAR(34) + @RutaJasper + CHAR(34)
INSERT @Datos
EXEC xp_cmdshell @Shell
IF EXISTS(SELECT Datos FROM @Datos WHERE Datos IS NOT NULL)
BEGIN
SELECT @Ok = 71660
SELECT @OkRef = (SELECT Top 1 Datos FROM @Datos WHERE Datos IS NOT NULL)
END
IF @Shell IS NULL
BEGIN
SELECT @Ok = 71660
SELECT @OkRef = (SELECT Descripcion FROM MensajeLista WITH (NOLOCK) WHERE Mensaje = @Ok)
END
END
END
IF @ReportBuilder = 1 AND @Jasper = 0 AND @ReporteIntelisis = 0
BEGIN
IF (@AlmacenarPDF = 'SI' and  @EnviarAlAfectar =1) or @htaGenerarPDF ='SI'
BEGIN
IF ISNULL(@RutaReportBuilder,'') <> ''
BEGIN
SET @RutaLog = LEFT(@RutaReportBuilder,LEN(@RutaReportBuilder)-4) + '_Log.txt'
EXEC spVerificarArchivo @RutaLog, @Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF ISNULL(@Existe,0) = 1
EXEC spEliminarArchivo @RutaLog, @Ok OUTPUT, @OkRef OUTPUT
END
UPDATE CFD  WITH (ROWLOCK) SET Documento = '<?xml version="1.0" encoding="UTF-8"?>'+convert(varchar(max),Documento) WHERE Modulo = @Modulo AND ModuloID = @ModuloID
SELECT @RutaReportBuilder = '''"'+@RutaReportBuilder+'" ' + CONVERT(VarChar,@ModuloID) + ' /EnSilencio '+LTRIM(RTRIM(@Modulo))+' XMLPDF '+''''
SET @Shell = 'EXEC xp_cmdshell ' + @RutaReportBuilder+' , no_output'
INSERT @Datos
EXEC(@Shell)
IF ISNULL(@RutaLog,'') <> ''
BEGIN
EXEC spVerificarArchivo @RutaLog, @Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF ISNULL(@Existe,0) = 1
BEGIN
SELECT @Ok = 71661
SELECT @OkRef = 'Error en origen de datos: Revisar archivo' + @RutaLog
END
END
IF EXISTS(SELECT * FROM CFDReportBuilderLog WITH (NOLOCK) WHERE Modulo = LTRIM(RTRIM(@Modulo)) AND ModuloID = @ModuloID)
BEGIN
SELECT @Ok = 71661
SELECT @OkRef = (SELECT TOP 1 Mensaje FROM CFDReportBuilderLog WITH (NOLOCK) WHERE Modulo = LTRIM(RTRIM(@Modulo)) AND ModuloID = @ModuloID)
END
END
END
IF @ReporteIntelisis = 1 AND @Jasper = 0 AND @ReportBuilder = 0 
BEGIN
SET @ID=@ID
END
IF @OK IS NULL AND (@ReporteIntelisis = 1 OR @ReportBuilder = 1)
EXEC xpPOSReporteReporteador @Empresa, @Modulo, @ModuloID, @ArchivoXML ,@NomArch
IF @OK IS NULL AND @Jasper = 1
EXEC xpPOSReporteJasper @Empresa, @Modulo, @ModuloID, @ArchivoXML ,@NomArch
EXEC xpEscucharSQLDespues @ID
END
ELSE
BEGIN
EXEC xpEscucharSQLDespues @ID
SET @CambiarEstatus = 0
UPDATE IntelisisService SET Estatus = 'SINPROCESAR' WHERE ID = @ID
END
END

