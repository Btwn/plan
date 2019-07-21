SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepWMSProducto
@Estacion		int

AS BEGIN
DECLARE
@ArticuloD 		varchar(20),
@ArticuloA		varchar(20),
@Categoria		varchar(50),
@Familia		varchar(50),
@Grupo			varchar(50),
@Fabricante		varchar(50),
@Linea			varchar(50),
@Estatus		varchar(15),
@Almacen		varchar(20),
@Orden			varchar(20),
@FechaD			datetime,
@FechaA			datetime,
@CaducidadD		datetime,
@CaducidadA 	datetime,
@Titulo			varchar(100)
SELECT
@ArticuloD		= InfoArticuloD,
@ArticuloA		= InfoArticuloA,
@Categoria		= InfoArtCat,
@Familia		= InfoArtFam,
@Grupo			= InfoArtGrupo,
@Fabricante	= InfoArtFabricante,
@Linea			= InfoArtLinea,
@Estatus		= InfoEstatusTarima,
@Almacen		= InfoAlmacenWMS,
@Orden			= InfoOrdenWMS,
@FechaD		= InfoFechaD,
@FechaA		= InfoFechaA,
@CaducidadD	= InfoCaducidadD,
@CaducidadA	= InfoCaducidadA,
@Titulo		= RepTitulo
FROM RepParam
WHERE Estacion = @Estacion
IF LEN(@ArticuloD) = 0 OR @ArticuloD = '(Todos)' OR @ArticuloD = 'Todos' SET @ArticuloD = NULL
IF LEN(@ArticuloA) = 0 OR @ArticuloA = '(Todos)' OR @ArticuloA = 'Todos' SET @ArticuloA = NULL
IF LEN(@Categoria) = 0 OR @Categoria = '(Todos)' OR @Categoria = 'Todos' SET @Categoria = NULL
IF LEN(@Familia) = 0 OR @Familia = '(Todos)' OR @Familia = 'Todos' SET @Familia = NULL
IF LEN(@Grupo) = 0 OR @Grupo = '(Todos)' OR @Grupo = 'Todos' SET @Grupo = NULL
IF LEN(@Fabricante) = 0 OR @Fabricante = '(Todos)' OR @Fabricante = 'Todos' SET @Fabricante = NULL
IF LEN(@Linea) = 0 OR @Linea = '(Todos)' OR @Linea = 'Todos' SET @Linea = NULL
IF LEN(@Estatus) = 0 OR @Estatus = '(Todos)' OR @Estatus = 'Todos' SET @Estatus = NULL
IF LEN(@Almacen) = 0 OR @Almacen = '(Todos)' OR @Almacen = 'Todos' SET @Almacen = NULL
IF LEN(@Orden) = 0 OR @Orden = '(Todos)' OR @Orden = 'Todos' SET @Orden = NULL
IF LEN(@FechaD) = 0 SET @FechaD = NULL
IF LEN(@FechaA) = 0 SET @FechaA = NULL
IF LEN(@CaducidadD) = 0 SET @CaducidadD = NULL
IF LEN(@CaducidadA) = 0 SET @CaducidadA = NULL
IF @Orden <> 'Fecha de Caducidad'
SELECT @CaducidadD = NULL, @CaducidadA = NULL
SELECT a.Articulo, a.Descripcion1, d.Tarima, t.Estatus, d.Almacen, t.Posicion, d.Disponible, t.Alta, t.FechaCaducidad, @Titulo as Titulo
FROM Artdisponibletarima d
JOIN Art a ON a.Articulo = d.Articulo
JOIN Tarima t ON t.Tarima = d.Tarima
JOIN AlmPos p ON p.Posicion = t.Posicion
JOIN Alm l ON p.Almacen = l.Almacen AND l.WMS = 1
WHERE d.Articulo BETWEEN ISNULL(@ArticuloD, d.Articulo) AND ISNULL(@ArticuloA, d.Articulo)
AND ISNULL(a.Categoria, '(Todos)') = ISNULL(@Categoria, ISNULL(a.Categoria, '(Todos)'))
AND ISNULL(a.Categoria, '(Todos)') = ISNULL(@Categoria, ISNULL(a.Categoria, '(Todos)'))
AND ISNULL(a.Familia, '(Todos)') = ISNULL(@Familia, ISNULL(a.Familia, '(Todos)'))
AND ISNULL(a.Grupo, '(Todos)') = ISNULL(@Grupo, ISNULL(a.Grupo, '(Todos)'))
AND ISNULL(a.Fabricante, '(Todos)') = ISNULL(@Fabricante, ISNULL(a.Fabricante, '(Todos)'))
AND ISNULL(a.Linea, '(Todos)') = ISNULL(@Linea, ISNULL(a.Linea, '(Todos)'))
AND t.Estatus = ISNULL(@Estatus, t.Estatus)
AND ISNULL(p.Almacen, '(Todas)') = ISNULL(@Almacen, ISNULL(p.Almacen, '(Todas)'))
AND dbo.fnFechaSinHora(t.Alta) BETWEEN ISNULL(dbo.fnFechaSinHora(@FechaD), dbo.fnFechaSinHora(t.Alta)) AND ISNULL(dbo.fnFechaSinHora(@FechaA), dbo.fnFechaSinHora(t.Alta))
AND ISNULL(dbo.fnFechaSinHora(t.FechaCaducidad), '') BETWEEN ISNULL(dbo.fnFechaSinHora(@CaducidadD), ISNULL(dbo.fnFechaSinHora(t.FechaCaducidad), '')) AND ISNULL(dbo.fnFechaSinHora(@CaducidadA), ISNULL(dbo.fnFechaSinHora(t.FechaCaducidad), ''))
ORDER BY a.Articulo, CASE @Orden WHEN 'Tarima' THEN d.Tarima WHEN 'Articulo' THEN d.Articulo WHEN 'Posición' THEN t.Posicion WHEN 'Fecha de Entrada' THEN CONVERT(varchar,t.Alta) WHEN 'Fecha de Caducidad' THEN CONVERT(varchar,t.FechaCaducidad) END
RETURN
END

