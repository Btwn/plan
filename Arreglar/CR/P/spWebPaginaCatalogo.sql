SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebPaginaCatalogo
@SesionID     Uniqueidentifier = null,
@Origen       varchar(255) = null,
@Pagina       Varchar(20) = NULL,
@Articulo     Varchar(20) = NULL,
@Valor        smallint = NULL

AS BEGIN
DECLARE @vtipoFiltro AS BIT,@vFiltro AS VARCHAR(50),@vSP AS VARCHAR(50)
IF UPPER(@Origen)='CALIFICAARTICULO'
BEGIN
UPDATE Art SET calificacion=@Valor WHERE articulo=@Articulo
END
IF UPPER(@Origen)='OBTIENECALIFICACIONARTICULO'
BEGIN
SELECT Calificacion FROM Art WHERE articulo=@Articulo
END
IF UPPER(@Origen)='COMPRARAPIDA'
BEGIN
SELECT COUNT(articulo) FROM WebPaginaArticulo WHERE pagina=@Pagina AND SesionID=@SesionID
END
IF UPPER(@Origen)='RAMAS_CLASIFICACION'
BEGIN
SELECT @vtipoFiltro=CatalogoRama  from webpagina WHERE pagina=@Pagina
IF @vtipoFiltro=1
BEGIN
PRINT 'rama'
PRINT @Articulo
SELECT * FROM art left JOIN Anexocta ON art.Articulo=Anexocta.cuenta
WHERE   wMostrar=1 AND UPPER(art.Rama)=UPPER(@Articulo)
END
ELSE
BEGIN
SELECT @vtipoFiltro=CatalogoClasificacion,@vFiltro=TipoClasificacion from webpagina WHERE pagina=@Pagina
IF @vtipoFiltro=1
BEGIN
IF @vFiltro='Grupos'
SELECT * FROM art left JOIN Anexocta ON art.Articulo=Anexocta.cuenta
WHERE   wMostrar=1 AND (art.Grupo IS NOT NULL ) AND (art.Grupo <> '') AND UPPER(art.Grupo)=UPPER(@Articulo)
IF @vFiltro='Categorias'
SELECT * FROM art left JOIN Anexocta ON art.Articulo=Anexocta.cuenta
WHERE   wMostrar=1 AND (art.Categoria IS NOT NULL ) AND (art.Categoria <> '') AND UPPER(art.Categoria)=UPPER(@Articulo)
IF @vFiltro='Familias'
SELECT * FROM art left JOIN Anexocta ON art.Articulo=Anexocta.cuenta
WHERE   wMostrar=1 AND (art.Familia IS NOT NULL ) AND (art.Familia <> '') AND UPPER(art.Familia)=UPPER(@Articulo)
IF @vFiltro='Lineas'
SELECT * FROM art left JOIN Anexocta ON art.Articulo=Anexocta.cuenta
WHERE   wMostrar=1 AND (art.Linea IS NOT NULL ) AND (art.Linea <> '') AND UPPER(art.Linea)=UPPER(@Articulo)
IF @vFiltro='Fabricantes'
SELECT * FROM art left JOIN Anexocta ON art.Articulo=Anexocta.cuenta
WHERE   wMostrar=1 AND (art.Fabricante IS NOT NULL ) AND (art.Fabricante <> '') AND UPPER(art.Fabricante)=UPPER(@Articulo)
End
ELSE
BEGIN
SELECT @vtipoFiltro=CatalogoSP,@vSP=sp from webpagina WHERE pagina=@Pagina
IF @vtipoFiltro=1
EXEC @vSP @SesionID , @Articulo, @Pagina
End
END
END
END

