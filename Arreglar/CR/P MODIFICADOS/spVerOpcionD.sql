SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerOpcionD
@Articulo		char(20),
@OpcionEspecifica	char(1) 	= NULL,
@Buscar			varchar(100) 	= NULL,
@Generar		bit		= 0,
@Estacion		int		= NULL

AS BEGIN
DECLARE
@Opcion		char(1),
@ListaEspecifica	varchar(50)
IF @Buscar IS NOT NULL
SELECT @Buscar = REPLACE(@Buscar,'*','%')
IF @Generar = 1
DECLARE crArtOpcion CURSOR FOR
SELECT ao.Opcion, NULLIF(RTRIM(ao.ListaEspecifica), '')
FROM ArtOpcion ao WITH(NOLOCK), Opcion o WITH(NOLOCK)
WHERE o.Opcion = ao.Opcion AND ao.Articulo = @Articulo AND o.TieneDetalle = 1
AND o.Opcion IN (SELECT Opcion FROM ArtOpcionWizard w WITH(NOLOCK) WHERE w.Estacion = @Estacion AND w.Generar = 1)
ELSE
BEGIN
CREATE TABLE #OpcionD (Opcion	char(1) COLLATE Database_Default NOT NULL, Numero int NULL, Nombre varchar(100) COLLATE Database_Default NULL, InformacionAdicional varchar(100) COLLATE Database_Default NULL, Imagen varchar(255) COLLATE Database_Default NULL) 
DECLARE crArtOpcion CURSOR FOR
SELECT ao.Opcion, NULLIF(RTRIM(ao.ListaEspecifica), '')
FROM ArtOpcion ao WITH(NOLOCK), Opcion o WITH(NOLOCK)
WHERE o.Opcion = ao.Opcion AND ao.Articulo = @Articulo AND o.TieneDetalle = 1
AND o.Opcion = ISNULL(@OpcionEspecifica, o.Opcion)
END
OPEN crArtOpcion
FETCH NEXT FROM crArtOpcion INTO @Opcion, @ListaEspecifica
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @OpcionEspecifica IS NULL
IF EXISTS(SELECT * FROM Opcion WITH(NOLOCK) WHERE Opcion = @Opcion AND UPPER(AyudaCaptura) = 'BUSCAR')
BEGIN
FETCH NEXT FROM crArtOpcion INTO @Opcion, @ListaEspecifica
CONTINUE
END
IF @Buscar IS NULL
BEGIN
IF UPPER(@ListaEspecifica) IN (NULL, '(TODAS)')
INSERT #OpcionD (Opcion, Numero, Nombre, InformacionAdicional, Imagen) 
SELECT Opcion, Numero, Nombre, InformacionAdicional, Imagen 
FROM OpcionD WITH(NOLOCK)
WHERE Opcion = @Opcion
AND ISNULL(Descontinuado,0) = 0
ELSE
IF UPPER(@ListaEspecifica) = '(ESPECIAL)'
INSERT #OpcionD (Opcion, Numero, Nombre, InformacionAdicional, Imagen) 
SELECT l.Opcion, l.Numero, d.Nombre, ISNULL(NULLIF(l.InformacionAdicional,''),d.InformacionAdicional), ISNULL(NULLIF(l.Imagen,''),d.Imagen) 
FROM ArtOpcionD l WITH(NOLOCK), OpcionD d WITH(NOLOCK)
WHERE l.Opcion = @Opcion AND l.Articulo = @Articulo
AND d.Opcion = l.Opcion AND d.Numero = l.Numero
AND ISNULL(d.Descontinuado,0) = 0 
ELSE
INSERT #OpcionD (Opcion, Numero, Nombre, InformacionAdicional, Imagen) 
SELECT ld.Opcion, ld.Numero, d.Nombre, d.InformacionAdicional, d.Imagen 
FROM OpcionLista l WITH(NOLOCK), OpcionListaD ld WITH(NOLOCK), OpcionD d WITH(NOLOCK)
WHERE l.Opcion = @Opcion AND l.Lista = @ListaEspecifica
AND ld.Opcion = l.Opcion AND ld.Lista = l.Lista
AND d.Opcion = l.Opcion AND d.Numero = ld.Numero
AND ISNULL(d.Descontinuado,0) = 0 
END ELSE
BEGIN
IF UPPER(@ListaEspecifica) IN (NULL, '(TODAS)')
INSERT #OpcionD (Opcion, Numero, Nombre, InformacionAdicional, Imagen) 
SELECT Opcion, Numero, Nombre, InformacionAdicional, Imagen 
FROM OpcionD WITH(NOLOCK)
WHERE Opcion = @Opcion
AND Nombre LIKE @Buscar
AND ISNULL(Descontinuado,0) = 0 
IF UPPER(@ListaEspecifica) = '(ESPECIAL)'
INSERT #OpcionD (Opcion, Numero, Nombre, InformacionAdicional, Imagen) 
SELECT l.Opcion, l.Numero, d.Nombre, ISNULL(NULLIF(l.InformacionAdicional,''),d.InformacionAdicional), ISNULL(NULLIF(l.Imagen,''),d.Imagen) 
FROM ArtOpcionD l WITH(NOLOCK), OpcionD d WITH(NOLOCK)
WHERE l.Opcion = @Opcion AND l.Articulo = @Articulo
AND d.Opcion = l.Opcion AND d.Numero = l.Numero
AND d.Nombre LIKE @Buscar
AND ISNULL(d.Descontinuado,0) = 0 
ELSE
INSERT #OpcionD (Opcion, Numero, Nombre, InformacionAdicional, Imagen) 
SELECT ld.Opcion, ld.Numero, d.Nombre, d.InformacionAdicional, d.Imagen 
FROM OpcionLista l WITH(NOLOCK), OpcionListaD ld WITH(NOLOCK), OpcionD d WITH(NOLOCK)
WHERE l.Opcion = @Opcion AND l.Lista = @ListaEspecifica
AND ld.Opcion = l.Opcion AND ld.Lista = l.Lista
AND d.Opcion = l.Opcion AND d.Numero = ld.Numero
AND d.Nombre LIKE @Buscar
AND ISNULL(Descontinuado,0) = 0 
END
END
FETCH NEXT FROM crArtOpcion INTO @Opcion, @ListaEspecifica
END
CLOSE crArtOpcion
DEALLOCATE crArtOpcion
IF @Generar = 0
BEGIN
IF @OpcionEspecifica IS NULL
SELECT * FROM #OpcionD
ELSE
SELECT Numero, Nombre FROM #OpcionD
END
RETURN
END

