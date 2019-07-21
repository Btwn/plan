SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpEscucharSQLDespues
@ID	int
AS BEGIN
DECLARE
@XML					varchar(max),
@Empresa				varchar(5),
@Modulo					varchar(5),
@ModuloID				int,
@Mov					varchar(20),
@Archivo				varchar(255),
@Para					varchar(255),
@Asunto					varchar(255),
@Mensaje				varchar(255),
@iDatos					int,
@Sistema				varchar(100),
@Referencia				varchar(100),
@Existe					int,
@TiempoTranscurrido		bit,
@TiempoLimite			datetime,
@Enviar					bit,
@EnviarXML				bit,
@EnviarPDF				bit,
@AlmacenarXML			bit,
@AlmacenarPDF			bit,
@Sucursal				int,
@NomArch				varchar(255),
@ArchivoPDF				varchar(255),
@ArchivoXML				varchar(255),
@XMLExiste				int,
@Archivos				varchar(255),
@Documento				varchar(max),
@Ok						int,
@OkRef					varchar(255),
@HtaGenerarPDF			bit,
@Jasper					bit,
@ReportBuilder          bit, 
@Reporteador            varchar(30),
@ReporteIntelisis       bit,
@EnviarAlAfectar		bit
IF @ID IS NOT NULL
BEGIN
SELECT @ArchivoPDF = '', @ArchivoXML = '', @Archivos = '', @Existe = 0, @Ok = NULL, @OkRef = NULL, @XMLExiste = 0
SELECT @XML = Solicitud, @Sistema = Sistema,  @Referencia = Referencia FROM IntelisisService WHERE ID = @ID
IF @Sistema = 'SDK' AND @Referencia = 'SDK.ReportePDF'
BEGIN
EXEC sp_xml_preparedocument @iDatos OUTPUT, @XML
SELECT
@Empresa      = Empresa,
@Modulo       = Modulo,
@Mov          = Mov,
@ModuloID     = ID,
@NomArch      = NomArch,
@Archivo      = Archivo,
@Para         = Para,
@Asunto       = Asunto,
@Mensaje      = Mensaje,
@Sucursal     = Sucursal,
@Enviar       = CASE WHEN Enviar = 'SI'    THEN 1 ELSE 0 END,
@AlmacenarPDF = CASE WHEN AlmacenarPDF = 'SI' THEN 1 ELSE 0 END,
@AlmacenarXML = CASE WHEN AlmacenarXML = 'SI' THEN 1 ELSE 0 END,
@EnviarPDF    = CASE WHEN EnviarPDF = 'SI' THEN 1 ELSE 0 END,
@EnviarXML    = CASE WHEN EnviarXML = 'SI' THEN 1 ELSE 0 END,
@HtaGenerarPDF = CASE WHEN HtaGenerarPDF = 'SI' THEN 1 ELSE 0 END
FROM OPENXML (@iDatos, '/Intelisis/Solicitud', 2) WITH (Empresa varchar(5), Modulo varchar(5), Mov varchar(20), Archivo varchar(255), Para varchar(255), Asunto varchar(255), Mensaje varchar(255), EnviarPDF varchar(2), EnviarXML varchar(2), Sucursal int, NomArch varchar(255), ID int, Enviar varchar(2), AlmacenarXML varchar(2), AlmacenarPDF varchar(2),GenerarPdfAfectar varchar(3),HtaGenerarPDF varchar(3))
EXEC sp_xml_removedocument @iDatos
SELECT @Reporteador = Reporteador FROM EmpresaCFD WHERE Empresa = @Empresa
IF @Reporteador = 'Jasper Reports' 
SET @Jasper = 1
IF @Reporteador = 'Report Builder' 
SET @ReportBuilder = 1
IF @Reporteador = 'Reporteador Intelisis'
SET @ReporteIntelisis = 1
SELECT  @EnviarAlAfectar = EnviarAlAfectar FROM EmpresaCFD WHERE Empresa = @Empresa
IF (@AlmacenarPDF = 1  AND @EnviarAlAfectar=1) OR (@AlmacenarPDF=1 AND @HtaGenerarPDF =1)
BEGIN
SET @ArchivoPDF = @Archivo + '.PDF'
IF @Jasper = 0 AND @ReportBuilder = 0 AND @ReporteIntelisis = 0 
BEGIN
SELECT @TiempoTranscurrido = 0, @TiempoLimite = DATEADD(second,10,GETDATE())
WHILE @Existe = 0 AND @TiempoTranscurrido = 0
BEGIN
EXEC spVerificarArchivo @ArchivoPDF, @Existe OUTPUT
IF @TiempoLimite < GETDATE() AND @Existe = 0 SET @TiempoTranscurrido = 1
END
END ELSE
EXEC spVerificarArchivo @ArchivoPDF, @Existe OUTPUT
IF @Existe = 1
BEGIN
IF @EnviarPDF = 1 SET @Archivos = @ArchivoPDF + ';'
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = @Modulo AND ID = @ModuloID AND CFD = 1 AND Nombre LIKE '%.pdf')
INSERT AnexoMov (Sucursal,  Rama,    ID,        Nombre,          Direccion,   Tipo,      Icono, CFD)
VALUES (@Sucursal, @Modulo, @ModuloID, @NomArch+'.pdf', @ArchivoPDF, 'Archivo', 745,   1)
END
END
IF (@AlmacenarXML = 1  AND @EnviarAlAfectar=1) OR (@AlmacenarXML=1 AND @HtaGenerarPDF =1)
BEGIN
SET @ArchivoXML = @Archivo + '.XML'
SELECT @Documento = Documento FROM CFD WHERE Modulo = @Modulo AND ModuloID = @ModuloID
EXEC spVerificarArchivo @ArchivoXML, @XMLExiste OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @XMLExiste = 0 AND @Ok IS NULL
EXEC spCFDFlexRegenerarArchivo @Empresa, @ArchivoXML, @Documento, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @Existe = 1
IF @EnviarXML = 1 SELECT @Archivos = @Archivos + @ArchivoXML
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = @Modulo AND ID = @ModuloID AND CFD = 1 AND Nombre LIKE '%.xml')
INSERT AnexoMov (Sucursal,  Rama,    ID,        Nombre,          Direccion,    Tipo,      Icono, CFD)
VALUES (@Sucursal, @Modulo, @ModuloID, @NomArch+'.xml', @ArchivoXML, 'Archivo',  17,    1)
END
END
IF @Existe = 1
BEGIN
IF @Reporteador = 'Reporteador Intelisis' 
BEGIN
EXEC spVerificarArchivo @ArchivoPDF, @Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Existe = 0
SET @Enviar = 0
END
IF @Enviar = 1 AND NULLIF(@Archivos,'') IS NOT NULL
BEGIN
EXEC spCFDFlexEnviarCorreo @Empresa, @Para, @Asunto, @Mensaje, @Archivos
END
SET @XML = '<Intelisis Sistema="SDK" Contenido="Resultado" Referencia="SDK.ReportePDF" SubReferencia="" Version="">' +
'  <Resultado IntelisisServiceID="' + CONVERT(varchar,@ID) + '" Ok="" OkRef=""/>' +
'</Intelisis>'
UPDATE IntelisisService SET Estatus = 'PROCESADO', Resultado = @XML WHERE ID = @ID
END ELSE
BEGIN
UPDATE IntelisisService SET Estatus = 'ERROR', Resultado = @XML WHERE ID = @ID
END
END
END
RETURN
END

