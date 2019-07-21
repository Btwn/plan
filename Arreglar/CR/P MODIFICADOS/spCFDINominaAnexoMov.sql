SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaAnexoMov
@ID					int,
@Sucursal			int,
@Personal			varchar(10),
@Ruta				varchar(255),
@ArchivoQRCode		varchar(255),
@ArchivoXML			varchar(255),
@ArchivoPDF			varchar(255),
@EsPDF				bit,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @NomArchivoQRCode		varchar(255),
@NomArchivoXML		varchar(255),
@NomArchivoPDF		varchar(255)
SELECT @Ruta = @Ruta + '\'
SELECT @NomArchivoQRCode = REPLACE(@ArchivoQRCode, @Ruta, ''),
@NomArchivoXML	   = REPLACE(@ArchivoXML, @Ruta, ''),
@NomArchivoPDF	   = REPLACE(@ArchivoPDF, @Ruta, '')
IF @EsPDF = 1
IF NOT EXISTS(SELECT * FROM AnexoMov WITH (NOLOCK) WHERE Rama = 'NOM' AND ID = @ID AND CFD = 1 AND Nombre = @NomArchivoPDF)
INSERT AnexoMov (Sucursal, Rama,  ID,   Nombre,         Direccion,   Tipo,     Icono, CFD)
VALUES (@Sucursal, 'NOM', @ID, @NomArchivoPDF, @ArchivoPDF, 'Archivo', 745,   1)
IF NOT EXISTS(SELECT * FROM AnexoMov WITH (NOLOCK) WHERE Rama = 'NOM' AND ID = @ID AND CFD = 1 AND Nombre = @NomArchivoXML)
INSERT AnexoMov (Sucursal,  Rama,  ID,  Nombre,         Direccion,  Tipo,      Icono, CFD)
VALUES (@Sucursal, 'NOM', @ID, @NomArchivoXML, @ArchivoXML, 'Archivo', 17,    1)
RETURN
END

