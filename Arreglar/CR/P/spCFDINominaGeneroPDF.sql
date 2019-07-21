SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaGeneroPDF
@ID			int,
@Personal	varchar(10)

AS
BEGIN
DECLARE @Sucursal			int,
@Ruta				varchar(255),
@ArchivoQRCode	varchar(255),
@ArchivoXML		varchar(255),
@ArchivoPDF		varchar(255),
@Ok				int,
@OkRef			varchar(255)
UPDATE CFDINominaRecibo SET PDFGenerado = 'Generado' WHERE ID = @ID AND Personal = @Personal
SELECT @Sucursal = Sucursal FROM Nomina WHERE ID = @ID
SELECT @ArchivoQRCode = ArchivoQRCode,
@ArchivoXML    = ArchivoXML,
@ArchivoPDF	= ArchivoPDF
FROM CFDINominaRecibo
WHERE ID = @ID
AND Personal = @Personal
SELECT @Ruta = dbo.fnCFDINominaObtenerRuta(@ArchivoPDF)
EXEC spCFDINominaAnexoMov @ID, @Sucursal, @Personal, @Ruta, @ArchivoQRCode, @ArchivoXML, @ArchivoPDF, 1, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

