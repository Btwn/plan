SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOrdenarWeb
@Estacion	int,
@Tabla	varchar(50)

AS BEGIN
DECLARE
@Orden		int,
@Clave		varchar(255),
@Actividad		varchar(10),
@ActividadID	int
SELECT @Tabla = UPPER(@Tabla)
BEGIN TRANSACTION
SELECT @Orden = 0
DECLARE crListaSt CURSOR FOR SELECT Clave FROM ListaSt WHERE Estacion = @Estacion ORDER BY ID
OPEN crListaSt
FETCH NEXT FROM crListaSt INTO @Clave
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Orden = @Orden + 1
IF @Tabla = 'WebArt'             UPDATE WebArt SET Orden = @Orden WHERE ID  = @Clave ELSE
IF @Tabla = 'WebCatArt'          UPDATE WebCatArt SET Orden = @Orden WHERE ID  = @Clave ELSE
IF @Tabla = 'WebArtVariacion'    UPDATE WebArtVariacion SET Orden = @Orden WHERE ID  = @Clave ELSE
IF @Tabla = 'WebArtMarca'        UPDATE WebArtMarca SET Orden = @Orden WHERE ID  = @Clave ELSE
IF @Tabla = 'WebArtImagen'       UPDATE WebArtImagen SET Orden = @Orden WHERE ID  = @Clave ELSE
IF @Tabla = 'WebArtOpcion'       UPDATE WebArtOpcion SET Orden = @Orden WHERE ID  = @Clave  ELSE
IF @Tabla = 'WebArtCamposConfigurables' UPDATE WebArtCamposConfigurables SET Orden = @Orden WHERE ID  = @Clave
END
FETCH NEXT FROM crListaSt INTO @Clave
END 
CLOSE crListaSt
DEALLOCATE crListaSt
COMMIT TRANSACTION
RETURN
END

