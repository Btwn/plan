SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaRegenerarXML
@ID			int,
@Personal	varchar(10)

AS
BEGIN
DECLARE @ArchivoXML		varchar(255),
@Ok				int,
@OkRef			varchar(255),
@Sucursal			int,
@DatosXML			varchar(max),
@Ruta				varchar(255),
@NombreArchivo	varchar(255)
SELECT @Sucursal = Sucursal FROM Nomina WHERE ID = @ID
SELECT @ArchivoXML = ArchivoXML FROM CFDINominaRecibo WHERE ID = @ID AND Personal = @Personal
SELECT @DatosXML = Documento FROM CFDNomina WHERE Modulo = 'NOM' AND ModuloID = @ID AND Personal = @Personal
SELECT @Ruta = dbo.fnCFDINominaObtenerRuta(@ArchivoXML)+ '\'
SELECT @NombreArchivo = REPLACE(@ArchivoXML, @Ruta, '')
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = 'NOM' AND ID = @ID AND CFD = 1 AND Direccion = @ArchivoXML)
INSERT AnexoMov ( Sucursal,  Rama,  ID,  Nombre,         Direccion,  Tipo,      Icono, CFD)
VALUES (@Sucursal, 'NOM', @ID, @NombreArchivo, @ArchivoXML, 'Archivo', 17,   1)
EXEC spCrearRuta @Ruta, @Ok OUTPUT, @OkRef OUTPUT
EXEC spRegenerarArchivo @ArchivoXML, @DatosXML, @Ok OUTPUT, @OkRef OUTPUT
SELECT NULL, NULL, NULL, NULL, NULL
RETURN
END

