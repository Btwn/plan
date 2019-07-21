SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSRegenerarReporteJasper
@Empresa	    varchar(5),
@Sucursal		int,
@Cliente        varchar(10),
@Modulo	        varchar(20),
@ID	            int,
@MovCFD         varchar(20),
@XML		    varchar(max),
@NomArch        varchar(255),
@Ok             int = NULL  OUTPUT,
@OkRef          varchar(255) = NULL  OUTPUT

AS
BEGIN
DECLARE
@RutaJasper			varchar(255),
@RutaTemporal		varchar(255),
@AlmacenarRuta		varchar(255),
@Ruta				varchar(255),
@RutaLogo			varchar(255),
@ArchivoXML			varchar(255),
@ArchivoBMP			varchar(255),
@Archivo			varchar(255),
@Jasper				bit,
@Reporte			varchar(50),
@Shell				varchar(8000),
@EsCFDI				bit,
@RutaDatosXML		varchar(255),
@Nailgun			bit,
@RutaNG				varchar(255)
DECLARE @Datos TABLE (
Datos	varchar(255))
SET @EsCFDI = 0
IF @XML LIKE '%<cfdi:Comprobante%'
SET @EsCFDI = 1
SELECT
@RutaJasper = RTRIM(LTRIM(ISNULL(RutaJasper,''))),
@Jasper = ISNULL(Jasper,0),
@RutaTemporal = RTRIM(LTRIM(ISNULL(RutaTemporal,''))),
@AlmacenarRuta = AlmacenarRuta,
@Nailgun = ISNULL(Nailgun,0),
@RutaNG = REPLACE(@RutaJasper,'IntelisisJReport.exe', 'ng com.intelisis.JReport.IntelisisJReport') 
FROM EmpresaCFD
WHERE Empresa = @Empresa
SELECT @Reporte = NULLIF(ReporteJasper,'')
FROM EmpresaCFDReporte
WHERE Empresa = @Empresa AND Modulo = @Modulo AND Mov = @MovCFD
SELECT
@Ruta = RTRIM(LTRIM(ISNULL(Ruta,''))),
@RutaLogo = RTRIM(LTRIM(ISNULL(RutaLogo,'')))
FROM EmpresaCFDJasperReports
WHERE Empresa = @Empresa AND Reporte = @Reporte
SET @ArchivoXML = @AlmacenarRuta + '\' + @NomArch + 'Jasper.XML'
SET @ArchivoBMP = @RutaTemporal + '\' + @NomArch + '.BMP'
SET @Archivo = @AlmacenarRuta+ '\' + @NomArch +'.PDF'
SELECT @ArchivoXML = REPLACE(@ArchivoXML, '<Cliente>', LTRIM(RTRIM(ISNULL(@Cliente,''))))
SELECT @ArchivoXML = REPLACE(@ArchivoXML, '<Ejercicio>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, YEAR(GETDATE())),''))))
SELECT @ArchivoXML = REPLACE(@ArchivoXML, '<Periodo>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, MONTH(GETDATE())),''))))
SELECT @ArchivoXML = REPLACE(@ArchivoXML, '<Empresa>', LTRIM(RTRIM(ISNULL(@Empresa,''))))
SELECT @ArchivoXML = REPLACE(@ArchivoXML, '<Sucursal>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, @Sucursal),''))))
SELECT @ArchivoBMP = REPLACE(@ArchivoBMP, '<Cliente>', LTRIM(RTRIM(ISNULL(@Cliente,''))))
SELECT @ArchivoBMP = REPLACE(@ArchivoBMP, '<Ejercicio>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, YEAR(GETDATE())),''))))
SELECT @ArchivoBMP = REPLACE(@ArchivoBMP, '<Periodo>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, MONTH(GETDATE())),''))))
SELECT @ArchivoBMP = REPLACE(@ArchivoBMP, '<Empresa>', LTRIM(RTRIM(ISNULL(@Empresa,''))))
SELECT @ArchivoBMP = REPLACE(@ArchivoBMP, '<Sucursal>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, @Sucursal),''))))
SELECT @Archivo = REPLACE(@Archivo, '<Cliente>', LTRIM(RTRIM(ISNULL(@Cliente,''))))
SELECT @Archivo = REPLACE(@Archivo, '<Ejercicio>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, YEAR(GETDATE())),''))))
SELECT @Archivo = REPLACE(@Archivo, '<Periodo>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, MONTH(GETDATE())),''))))
SELECT @Archivo = REPLACE(@Archivo, '<Empresa>', LTRIM(RTRIM(ISNULL(@Empresa,''))))
SELECT @Archivo = REPLACE(@Archivo, '<Sucursal>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, @Sucursal),''))))
EXEC spCFDFlexRegenerarArchivo @Empresa, @ArchivoXML, @XML, @Ok OUTPUT, @OkRef OUTPUT
IF @EsCFDI = 1
EXEC spCFDFlexQRCode @Empresa, @Modulo, @ID, @ArchivoBMP
IF CHARINDEX('<FactDocGT xmlns' + CHAR(58) + 'xsi="http' + CHAR(58) + '//www.w3.org/2001/XMLSchema-instance" xmlns="http' +
CHAR(58) + '//www.fact.com.mx/schema/gt"', @XML) = 0
SELECT @RutaDatosXML = '/Comprobante/Conceptos/Concepto'
ELSE
SELECT @RutaDatosXML = '/FactDocGT/Detalles/Detalle'
IF @Nailgun = 0
SET @Shell = @RutaJasper + ' ' + CHAR(34) + @ArchivoXML + CHAR(34) + ' ' + CHAR(34) + @Ruta + CHAR(34) + ' ' + CHAR(34) + @RutaLogo + CHAR(34) + ' ' +
CHAR(34) + @ArchivoBMP + CHAR(34) + ' " " ' + CHAR(34) + @RutaDatosXML + CHAR(34) + ' ' + CHAR(34) + @Archivo + CHAR(34)+ ' ' +
CHAR(34) + @RutaJasper + CHAR(34)
ELSE
SET @Shell = @RutaNG + ' ' + CHAR(34) + @ArchivoXML + CHAR(34) + ' ' + CHAR(34) + @Ruta + CHAR(34) + ' ' + CHAR(34) + @RutaLogo + CHAR(34) + ' ' +
CHAR(34) + @ArchivoBMP + CHAR(34) + ' " " ' + CHAR(34) + @RutaDatosXML + CHAR(34) + ' ' + CHAR(34) + @Archivo + CHAR(34) + ' ' +
CHAR(34) + @RutaJasper + CHAR(34)
INSERT @Datos
EXEC xp_cmdshell @Shell
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = @Modulo AND ID = @ID AND CFD = 1 AND Nombre LIKE '%.pdf')
INSERT AnexoMov (
Sucursal, Rama, ID, Nombre, Direccion, Tipo, Icono, CFD)
VALUES (
@Sucursal, @Modulo, @ID, @NomArch+'.pdf', @Archivo, 'Archivo', 745,   1)
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = @Modulo AND ID = @ID AND CFD = 1 AND Nombre LIKE '%.xml')
INSERT AnexoMov (
Sucursal, Rama, ID, Nombre, Direccion, Tipo, Icono, CFD)
VALUES (
@Sucursal, @Modulo, @ID, @NomArch+'.xml', REPLACE(@ArchivoXML,'Jasper',''), 'Archivo', 17, 1)
RETURN
END

