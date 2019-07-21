SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTMAVerificarContenidoTarima
@ID             int,
@Empresa		varchar(5),
@Tarima			varchar(20),
@Almacen		varchar(10),
@Posicion		varchar(20),
@Ok             int          OUTPUT,
@OkRef          varchar(255) OUTPUT

AS BEGIN
DECLARE
@Articulo		varchar(20),
@Categoria		varchar(50),
@Grupo			varchar(50),
@Familia		varchar(50),
@Tipo           varchar(20)
DECLARE @Contenido TABLE (Articulo varchar(20) NULL, Categoria varchar(50) NULL, Grupo varchar(50) NULL, Familia varchar(50) NULL)
SELECT @Tipo = a.Tipo
FROM AlmPos a
LEFT OUTER JOIN Tarima t ON a.Posicion = t.Posicion AND a.Almacen = @Almacen
WHERE a.Posicion = @Posicion
INSERT @Contenido (Articulo, Categoria, Grupo, Familia)
SELECT a.Articulo, a.Categoria, a.Grupo, a.Familia
FROM ArtExistenciaTarima e
JOIN Art a ON a.Articulo = e.Articulo
WHERE e.Empresa = @Empresa AND e.Almacen = @Almacen AND e.Tarima = @Tarima AND NULLIF(e.Existencia, 0) IS NOT NULL
GROUP BY a.Articulo, a.Categoria, a.Grupo, a.Familia
IF EXISTS(SELECT * FROM @Contenido)
BEGIN
SELECT
@Articulo		= NULLIF(RTRIM(ArticuloEsp), '')
FROM AlmPos
WHERE Almacen = @Almacen
AND Posicion = @Posicion
IF @Articulo <> 'NULL' AND @Articulo  IS NOT NULL AND EXISTS(SELECT * FROM @Contenido WHERE Articulo  <> @Articulo) AND @Tipo <> 'Cross Docking' SELECT @Ok = 13230, @OkRef = @Tarima+' - '+@Articulo 
END
RETURN
END

