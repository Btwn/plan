SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSRepCaducidad
@Estacion		int

AS BEGIN
DECLARE
@Tipo			varchar(50),
@Articulo		varchar(50),
@Almacen		varchar(50),
@Grupo		varchar(50),
@Familia		varchar(50),
@Categoria	varchar(50),
@FechaD		datetime,
@FechaA		datetime,
@DiaD			int,
@DiaA			int,
@TipoPos		varchar(50)
SELECT @FechaD = InfoCaducidadD,
@FechaA = InfoCaducidadA,
@DiaD = InfoCaducidadDiaD,
@DiaA = InfoCaducidadDiaA,
@TipoPos = InfoTipo,
@Tipo = InfoTipoCaducidad,
@Articulo = InfoArticuloCaducidad,
@Almacen = InfoAlmacenWMS,
@Grupo = InfoArtGrupo,
@Categoria = InfoArtCat,
@Familia = InfoArtFam
FROM RepParam
WHERE Estacion = @Estacion
IF RTRIM(LTRIM(@Articulo)) IN ('', '(Todos)','(Todas)') set @Articulo = NULL
IF RTRIM(LTRIM(@Almacen)) IN ('', '(Todos)','(Todas)') set @Almacen = NULL
IF RTRIM(LTRIM(ISNULL(@Grupo,''))) IN ('', '(Todos)','(Todas)') set @Grupo = NULL
IF RTRIM(LTRIM(ISNULL(@Familia,''))) IN ('', '(Todos)','(Todas)') set @Familia = NULL
IF RTRIM(LTRIM(ISNULL(@Categoria,''))) IN ('', '(Todos)','(Todas)') set @Categoria = NULL
IF RTRIM(LTRIM(ISNULL(@TipoPos,''))) IN ('', '(Todos)','(Todas)') set @TipoPos = NULL
IF @Tipo IN('Caducados', 'Por Día')
SELECT @FechaD = NULL
IF @Tipo = 'Caducados'
SELECT a.Articulo, a.Descripcion1, d.Tarima, d.Disponible, t.Posicion, p.Descripcion, p.Fila, p.Pasillo, p.Nivel, t.FechaCaducidad, DATEDIFF(DAY, GETDATE(), t.FechaCaducidad) as DiasCaducidad, @Tipo as Tipo, d.Almacen, ISNULL(a.Grupo,'') as Grupo, ISNULL(a.Familia,'') as Familia, ISNULL(a.Categoria,'') as Categoria, p.Tipo as TipoPosicion, @FechaD as FechaDesde, @FechaA as FechaHasta, @DiaD as DiaDesde, @DiaA as DiaHasta
FROM Art a
JOIN ArtDisponibleTarima d
ON a.Articulo = d.Articulo
JOIN Tarima t
ON d.Tarima = t.Tarima
JOIN AlmPos p
ON t.Posicion = p.Posicion
WHERE a.ControlArticulo = 'Caducidad'
AND d.Disponible > 0
AND d.Articulo = ISNULL(@Articulo, d.Articulo)
AND d.Almacen = ISNULL(@Almacen, d.Almacen)
AND ISNULL(a.Grupo,'') = ISNULL(@Grupo, ISNULL(a.Grupo,''))
AND ISNULL(a.Familia,'') = ISNULL(@Familia, ISNULL(a.Familia,''))
AND ISNULL(a.Categoria,'') = ISNULL(@Categoria, ISNULL(a.Categoria,''))
AND p.Tipo = ISNULL(@TipoPos, p.Tipo)
AND DATEDIFF(DAY, GETDATE(), t.FechaCaducidad) < 1
ORDER BY DATEDIFF(DAY, GETDATE(), t.FechaCaducidad)
ELSE
IF @Tipo = 'Por Fecha'
SELECT a.Articulo, a.Descripcion1, d.Tarima, d.Disponible, t.Posicion, p.Descripcion, p.Fila, p.Pasillo, p.Nivel, t.FechaCaducidad, DATEDIFF(DAY, GETDATE(), t.FechaCaducidad) as DiasCaducidad, @Tipo as Tipo, d.Almacen, ISNULL(a.Grupo,'') as Grupo, ISNULL(a.Familia,'') as Familia, ISNULL(a.Categoria,'') as Categoria, p.Tipo as TipoPosicion, @FechaD as FechaDesde, @FechaA as FechaHasta, @DiaD as DiaDesde, @DiaA as DiaHasta
FROM Art a
JOIN ArtDisponibleTarima d
ON a.Articulo = d.Articulo
JOIN Tarima t
ON d.Tarima = t.Tarima
JOIN AlmPos p
ON t.Posicion = p.Posicion
WHERE a.ControlArticulo = 'Caducidad'
AND d.Disponible > 0
AND t.FechaCaducidad BETWEEN @FechaD AND @FechaA
AND d.Articulo = ISNULL(@Articulo, d.Articulo)
AND d.Almacen = ISNULL(@Almacen, d.Almacen)
AND ISNULL(a.Grupo,'') = ISNULL(@Grupo, ISNULL(a.Grupo,''))
AND ISNULL(a.Familia,'') = ISNULL(@Familia, ISNULL(a.Familia,''))
AND ISNULL(a.Categoria,'') = ISNULL(@Categoria, ISNULL(a.Categoria,''))
AND p.Tipo = ISNULL(@TipoPos, p.Tipo)
ORDER BY DATEDIFF(DAY, GETDATE(), t.FechaCaducidad)
ELSE
IF @Tipo = 'Por Día'
SELECT a.Articulo, a.Descripcion1, d.Tarima, d.Disponible, t.Posicion, p.Descripcion, p.Fila, p.Pasillo, p.Nivel, t.FechaCaducidad, DATEDIFF(DAY, GETDATE(), t.FechaCaducidad) as DiasCaducidad, @Tipo as Tipo, d.Almacen, ISNULL(a.Grupo,'') as Grupo, ISNULL(a.Familia,'') as Familia, ISNULL(a.Categoria,'') as Categoria, p.Tipo as TipoPosicion, @FechaD as FechaDesde, @FechaA as FechaHasta, @DiaD as DiaDesde, @DiaA as DiaHasta
FROM Art a
JOIN ArtDisponibleTarima d
ON a.Articulo = d.Articulo
JOIN Tarima t
ON d.Tarima = t.Tarima
JOIN AlmPos p
ON t.Posicion = p.Posicion
WHERE a.ControlArticulo = 'Caducidad'
AND d.Disponible > 0
AND DATEDIFF(DAY,GETDATE(), t.FechaCaducidad) BETWEEN @DiaD AND @DiaA
AND d.Articulo = ISNULL(@Articulo, d.Articulo)
AND d.Almacen = ISNULL(@Almacen, d.Almacen)
AND ISNULL(a.Grupo,'') = ISNULL(@Grupo, ISNULL(a.Grupo,''))
AND ISNULL(a.Familia,'') = ISNULL(@Familia, ISNULL(a.Familia,''))
AND ISNULL(a.Categoria,'') = ISNULL(@Categoria, ISNULL(a.Categoria,''))
AND p.Tipo = ISNULL(@TipoPos, p.Tipo)
ORDER BY DATEDIFF(DAY, GETDATE(), t.FechaCaducidad)
ELSE
BEGIN
DECLARE @Float float, @Int int, @Fecha datetime
SELECT '' Articulo, '' Descripcion1, '' Tarima, @Float Disponible, '' Posicion, '' Descripcion, @Int Fila, @Int Pasillo, @Int Nivel, @Fecha FechaCaducidad, @Int DiasCaducidad, '' Tipo, '' Almacen, '' Grupo, '' Familia, '' Categoria, '' TipoPosicion, @Fecha FechaDesde, @Fecha FechaHasta, @Int DiaDesde, @Int DiaHasta
END
END

