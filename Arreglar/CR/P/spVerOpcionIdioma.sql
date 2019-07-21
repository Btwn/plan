SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerOpcionIdioma
@Modulo		varchar(5),
@ID			int,
@Articulo	varchar(20)

AS BEGIN
DECLARE
@Idioma				varchar(50),
@Opcion				char(1),
@ListaEspecifica	varchar(50)
DECLARE @Traduccion TABLE
(
TextoOriginal			varchar(255),
Traduccion			varchar(255)
)
IF @Modulo IN ('COMS','VTAS')
BEGIN
IF @Modulo = 'VTAS' SELECT @Idioma = c.Idioma FROM Cte c JOIN Venta v   ON v.Cliente = c.Cliente     WHERE v.ID = @ID ELSE
IF @Modulo = 'COMS' SELECT @Idioma = p.Idioma FROM Prov p JOIN Compra c ON c.Proveedor = p.Proveedor WHERE c.ID = @ID
DECLARE crArtOpcion CURSOR FOR
SELECT ao.Opcion, NULLIF(RTRIM(ao.ListaEspecifica), '')
FROM ArtOpcion ao, Opcion o
WHERE o.Opcion = ao.Opcion AND ao.Articulo = @Articulo AND o.TieneDetalle = 1
OPEN crArtOpcion
FETCH NEXT FROM crArtOpcion INTO @Opcion, @ListaEspecifica
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF UPPER(@ListaEspecifica) IN (NULL, '(TODAS)')
INSERT @Traduccion (TextoOriginal, Traduccion)
SELECT d.Nombre, ie.Nombre
FROM OpcionD d JOIN IdiomaEtiqueta ie
ON ie.Etiqueta = d.Nombre
WHERE d.Opcion = @Opcion
AND ie.Idioma = @Idioma
ELSE
IF UPPER(@ListaEspecifica) = '(ESPECIAL)'
INSERT @Traduccion (TextoOriginal, Traduccion)
SELECT d.Nombre, ie.Nombre
FROM ArtOpcionD l JOIN OpcionD d
ON d.Opcion = l.Opcion AND d.Numero = l.Numero JOIN IdiomaEtiqueta ie
ON ie.Etiqueta = d.Nombre
WHERE l.Opcion = @Opcion
AND l.Articulo = @Articulo
AND ie.Idioma = @Idioma
ELSE
INSERT @Traduccion (TextoOriginal, Traduccion)
SELECT d.Nombre, ie.Nombre
FROM OpcionLista l JOIN OpcionListaD ld
ON ld.Opcion = l.Opcion AND ld.Lista = l.Lista JOIN OpcionD d
ON d.Opcion = l.Opcion AND d.Numero = ld.Numero JOIN IdiomaEtiqueta ie
ON ie.Etiqueta = d.Nombre
WHERE l.Opcion = @Opcion
AND l.Lista = @ListaEspecifica
AND ie.Idioma = @Idioma
END
FETCH NEXT FROM crArtOpcion INTO @Opcion, @ListaEspecifica
END
CLOSE crArtOpcion
DEALLOCATE crArtOpcion
END
SELECT * FROM @Traduccion
END

