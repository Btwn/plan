SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOfertaArtListaAceptar
@Estacion	int,
@ID		int

AS BEGIN
DECLARE
@Renglon			float,
@Articulo			varchar(20)
DECLARE crOfertaArtListaAceptar CURSOR LOCAL FOR
SELECT a.Articulo
FROM Art a
WHERE a.Articulo IN (SELECT Clave FROM ListaSt WHERE Estacion = @Estacion)
AND a.Articulo NOT IN (SELECT Articulo FROM OfertaD WHERE ID = @ID)
SELECT @Renglon = Max(Renglon) FROM OfertaD od WHERE od.ID = @ID
SELECT @Renglon = ISNULL(@Renglon, 0) + 2048
OPEN crOfertaArtListaAceptar
FETCH NEXT FROM crOfertaArtListaAceptar INTO @Articulo
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT OfertaD (ID, Renglon, Articulo)
VALUES(@ID, @Renglon, @Articulo)
SELECT @Renglon = @Renglon + 2048
FETCH NEXT FROM crOfertaArtListaAceptar INTO @Articulo
END
CLOSE crOfertaArtListaAceptar
DEALLOCATE crOfertaArtListaAceptar
RETURN
END

