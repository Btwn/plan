SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepWMSPorCorte
@Estacion		int

AS BEGIN
DECLARE
@FechaDesde		datetime,
@FechaHasta		datetime,
@ArticuloDesde	varchar(20),
@ArticuloHasta	varchar(20),
@Categoria		varchar(50),
@Familia		varchar(50),
@Grupo			varchar(50),
@Fabricante		varchar(50),
@Linea			varchar(50),
@Movimiento		varchar(25),
@Nivel			varchar(50),
@Almacen		varchar(20),
@Titulo			varchar(100)
SELECT @FechaDesde	= InfoFechaD,
@FechaHasta	= InfoFechaA,
@ArticuloDesde	= InfoArticuloD,
@ArticuloHasta	= InfoArticuloA,
@Categoria		= InfoArtCat,
@Familia		= InfoArtFam,
@Grupo			= InfoArtGrupo,
@Fabricante	= InfoArtFabricante,
@Linea			= InfoArtLinea,
@Movimiento	= InfoMovimientoEsp,
@Nivel			= InfoNivel,
@Almacen		= InfoAlmacenWMS,
@Titulo		= RepTitulo
FROM RepParam
WHERE Estacion = @Estacion
IF LEN(@ArticuloDesde) = 0 OR @ArticuloDesde = '(Todos)' OR @ArticuloDesde = 'Todos' SET @ArticuloDesde = NULL
IF LEN(@ArticuloHasta) = 0 OR @ArticuloHasta = '(Todos)' OR @ArticuloHasta = 'Todos' SET @ArticuloHasta = NULL
IF LEN(@Categoria) = 0 OR @Categoria = '(Todos)' OR @Categoria = 'Todos' SET @Categoria = NULL
IF LEN(@Familia) = 0 OR @Familia = '(Todos)' OR @Familia = 'Todos' SET @Familia = NULL
IF LEN(@Grupo) = 0 OR @Grupo = '(Todos)' OR @Grupo = 'Todos' SET @Grupo = NULL
IF LEN(@Fabricante) = 0 OR @Fabricante = '(Todos)' OR @Fabricante = 'Todos' SET @Fabricante = NULL
IF LEN(@Linea) = 0 OR @Linea = '(Todos)' OR @Linea = 'Todos' SET @Linea = NULL
IF LEN(@Almacen) = 0 OR @Almacen = '(Todos)' OR @Almacen = 'Todos' SET @Almacen = NULL
IF LEN(@Movimiento) = 0 OR @Movimiento = '(Todos)' OR @Movimiento = 'Todos' SET @Movimiento = NULL
SELECT a.Fecha, c.Articulo, c.Descripcion1, c.Categoria, c.Familia, c.Grupo, c.Fabricante, c.Linea, a.Grupo as Almacen,
a.Mov, a.MovID, a.SubCuenta, a.SubGrupo as Tarima, a.CargoU, a.AbonoU, a.EsCancelacion, a.ID, a.Rama, a.Moneda,
a.Cargo, a.Abono, r.CostoPromedio, r.UltimoCosto, c.CostoEstandar, c.CostoReposicion, c.PrecioLista,
c.Precio2, c.Precio3, c.Precio4, c.Precio5, c.Precio6, c.Precio7, c.Precio8, c.Precio9, c.Precio10,
@FechaDesde as FechaDesde, @FechaHasta as FechaHasta, @Movimiento as MovimientoEsp, @Titulo as Titulo
FROM Art c
LEFT OUTER JOIN AuxiliarU a
ON c.Articulo = a.Cuenta AND (CargoU IS NOT NULL OR AbonoU IS NOT NULL)
LEFT OUTER JOIN ArtConCosto r
ON c.Articulo = r.Articulo
JOIN Alm l ON a.Grupo = l.Almacen AND l.WMS = 1
WHERE ISNULL(c.Categoria, '(Todos)') = ISNULL(@Categoria, ISNULL(c.Categoria, '(Todos)'))
AND ISNULL(c.Familia, '(Todos)') = ISNULL(@Familia, ISNULL(c.Familia, '(Todos)'))
AND ISNULL(c.Grupo, '(Todos)') = ISNULL(@Grupo, ISNULL(c.Grupo, '(Todos)'))
AND ISNULL(c.Fabricante, '(Todos)') = ISNULL(@Fabricante, ISNULL(c.Fabricante, '(Todos)'))
AND ISNULL(c.Linea, '(Todos)') = ISNULL(@Linea, ISNULL(c.Linea, '(Todos)'))
AND ISNULL(a.Grupo, '(Todos)') = ISNULL(@Almacen, ISNULL(a.Grupo, '(Todos)'))
AND ISNULL(a.Mov, '(Todos)') = ISNULL(@Movimiento, ISNULL(a.Mov, '(Todos)'))
AND dbo.fnFechaSinHora(a.Fecha) BETWEEN ISNULL(dbo.fnFechaSinHora(@FechaDesde), dbo.fnFechaSinHora(a.Fecha)) AND ISNULL(dbo.fnFechaSinHora(@FechaHasta), dbo.fnFechaSinHora(a.Fecha))
AND c.Articulo BETWEEN ISNULL(@ArticuloDesde, c.Articulo) AND ISNULL(@ArticuloHasta, c.Articulo)
ORDER BY c.Articulo, a.Fecha, a.ID
RETURN
END

