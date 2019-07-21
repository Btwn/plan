SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebArtRama
@Empresa	char(5),
@Cliente	char(10),
@Rama		char(20),
@Buscar		varchar(100) = NULL

AS BEGIN
DECLARE
@Lista		varchar(20),
@Idioma		varchar(50),
@Moneda		char(10),
@TipoCambio	float,
@Articulo		varchar(20),
@Unidad		varchar(50),
@Precio		money,
@Codigo		char(20),
@Descripcion1	varchar(100)
SELECT @Cliente = NULLIF(RTRIM(@Cliente), ''), @Rama = NULLIF(RTRIM(@Rama), ''), @Buscar = NULLIF(RTRIM(@Buscar), '')
SELECT @Lista = ISNULL(NULLIF(RTRIM(c.ListaPreciosEsp), ''), '(Precio Lista)'),
@Moneda = NULLIF(RTRIM(c.DefMoneda), ''),
@TipoCambio = m.TipoCambio,
@Idioma = NULLIF(RTRIM(c.Idioma), '')
FROM Cte c, Mon m
WHERE c.Cliente = @Cliente AND m.Moneda = c.DefMoneda
IF @Buscar IS NULL
BEGIN
SELECT "Articulo" = RTRIM(Art.Articulo),
"Rama" = RTRIM(Art.Rama),
"Codigo" = RTRIM(Art.Articulo),
"Descripcion1" = RTRIM(Art.Descripcion1),
"Descripcion2" = RTRIM(Art.Descripcion2),
"Fabricante" = RTRIM(Fabricante),
"TipoArt" = RTRIM(Art.Tipo) ,
"Precio" = CONVERT(money, NULL),
"Moneda" = @Moneda,
"Nombre" = RTRIM(AnexoCta.Nombre),
"TipoAnexoCta" = RTRIM(AnexoCta.Tipo),
"Direccion" = RTRIM(AnexoCta.Direccion),
"Unidad" = RTRIM(Art.Unidad)
INTO #WebLista
FROM Art
LEFT OUTER JOIN AnexoCta ON Art.Articulo = AnexoCta.Cuenta AND (AnexoCta.Nombre = 'Imagen' OR AnexoCta.Nombre IS NULL) AND (AnexoCta.Tipo = 'Imagen' OR AnexoCta.Tipo IS NULL)
WHERE Art.Rama = @Rama
AND Art.Tipo <> 'Estructura'
AND wMostrar = 1
ORDER BY Art.Tipo, Art.Descripcion1, Art.Articulo, AnexoCta.Tipo
DECLARE crWebLista CURSOR FOR
SELECT Articulo, Unidad, Codigo, Descripcion1
FROM #WebLista
END ELSE
BEGIN
SELECT "Articulo" = RTRIM(Art.Articulo),
"Rama" = RTRIM(Art.Rama),
"Codigo" = RTRIM(Art.Articulo),
"Descripcion1" = RTRIM(Art.Descripcion1),
"Descripcion2" = RTRIM(Art.Descripcion2),
"Fabricante" = RTRIM(Fabricante),
"TipoArt" = RTRIM(Art.Tipo) ,
"Precio" = CONVERT(money, NULL),
"Moneda" = @Moneda,
"Nombre" = RTRIM(AnexoCta.Nombre),
"TipoAnexoCta" = RTRIM(AnexoCta.Tipo),
"Direccion" = RTRIM(AnexoCta.Direccion),
"Unidad" = RTRIM(Art.Unidad)
INTO #WebListaBuscar
FROM Art
LEFT OUTER JOIN AnexoCta ON Art.Articulo = AnexoCta.Cuenta AND (AnexoCta.Nombre = 'Imagen' OR AnexoCta.Nombre IS NULL) AND (AnexoCta.Tipo = 'Imagen' OR AnexoCta.Tipo IS NULL)
WHERE Art.Tipo <> 'Estructura'
AND (Descripcion1 LIKE @Buscar OR ClaveFabricante LIKE @Buscar OR Art.Articulo LIKE @Buscar)
AND wMostrar = 1
ORDER BY Art.Tipo, Art.Descripcion1, Art.Articulo, AnexoCta.Tipo
DECLARE crWebLista CURSOR FOR
SELECT Articulo, Unidad, Codigo, Descripcion1
FROM #WebListaBuscar
END
OPEN crWebLista
FETCH NEXT FROM crWebLista INTO @Articulo, @Unidad, @Codigo, @Descripcion1
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spPCGet 0, @Empresa, @Articulo, NULL, @Unidad, @Moneda, @TipoCambio, @Lista, @Precio OUTPUT
IF @Idioma IS NOT NULL
SELECT @Codigo = ISNULL(Codigo, @Codigo),
@Descripcion1 = ISNULL(Descripcion, @Descripcion1)
FROM ArtIdioma
WHERE Articulo = @Articulo AND Idioma = @Idioma
IF @Buscar IS NULL
UPDATE #WebLista
SET Codigo = @Codigo, Descripcion1 = @Descripcion1, Precio = @Precio
WHERE CURRENT OF crWebLista
ELSE
UPDATE #WebListaBuscar
SET Codigo = @Codigo, Descripcion1 = @Descripcion1, Precio = @Precio
WHERE CURRENT OF crWebLista
END
FETCH NEXT FROM crWebLista INTO @Articulo, @Unidad, @Codigo, @Descripcion1
END
CLOSE crWebLista
DEALLOCATE crWebLista
IF @Buscar IS NULL
SELECT * FROM #WebLista ORDER BY Articulo
ELSE
SELECT * FROM #WebListaBuscar ORDER BY Articulo
END

