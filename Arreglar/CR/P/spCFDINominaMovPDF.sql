SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaMovPDF
@ID			int,
@Archivo	varchar(255)

AS
BEGIN
DECLARE @Sucursal			int,
@Ruta				varchar(255),
@NomArchivoPDF	varchar(255),
@Ok				int,
@OkRef			varchar(255),
@Existe			int
EXEC spVerificarArchivo @Archivo, @Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @Existe = 1
BEGIN
SELECT @Sucursal = Sucursal FROM Nomina WHERE ID = @ID
SELECT @Ruta = dbo.fnCFDINominaObtenerRuta(@Archivo)
SELECT @Ruta = @Ruta + '\'
SELECT @NomArchivoPDF	= REPLACE(@Archivo, @Ruta, '')
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = 'NOM' AND ID = @ID AND CFD = 1 AND Nombre = @NomArchivoPDF)
INSERT AnexoMov (Sucursal, Rama,  ID,   Nombre,         Direccion, Tipo,      Icono, CFD)
VALUES (@Sucursal, 'NOM', @ID, @NomArchivoPDF, @Archivo,   'Archivo', 745,   1)
END
RETURN
END

