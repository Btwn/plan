SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebArtInsertarImagenCombinacion
@IDCombinacion   int,
@Directorio      varchar(255),
@Nombre          varchar(255)

AS BEGIN
DECLARE
@Orden int
IF NULLIF(@Directorio,'') IS NULL OR @IDCombinacion IS NULL RETURN
UPDATE WebArtVariacionCombinacion SET Imagen = @Directorio, TipoArchivo = dbo.fnWebTipoArchivo(@Directorio), NombreImagen = @Nombre
WHERE ID = @IDCombinacion
END

