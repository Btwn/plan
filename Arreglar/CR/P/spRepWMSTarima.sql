SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepWMSTarima
@Estacion		int

AS BEGIN
DECLARE
@TarimaD		varchar(20),
@TarimaA		varchar(20),
@Estatus		varchar(15),
@Orden			varchar(20),
@Tipo			varchar(20),
@FechaD			datetime,
@FechaA			datetime,
@CaducidadD		datetime,
@CaducidadA 	datetime,
@ArticuloD 		varchar(20),
@ArticuloA		varchar(20),
@Almacen		varchar(20),
@Titulo			varchar(100)
DECLARE @Reporte AS TABLE(Tarima			varchar(20) null,
Estatus			varchar(15) null,
Articulo			varchar(20) null,
Descripcion1		varchar(100) null,
Almacen			varchar(10) null,
Posicion			varchar(10) null,
Descripcion		varchar(100) null,
Tipo				varchar(20) null,
Disponible		float null,
Alta				datetime null,
FechaCaducidad	datetime null,
Titulo			varchar(100) null
)
SELECT @TarimaD		= InfoTarimaDRep,
@TarimaA		= InfoTarimaARep,
@Estatus		= InfoEstatusTarima,
@Orden			= InfoOrdenWMS,
@Tipo			= InfoTipo,
@FechaD		= InfoFechaD,
@FechaA		= InfoFechaA,
@CaducidadD	= InfoCaducidadD,
@CaducidadA	= InfoCaducidadA,
@ArticuloD		= InfoArticuloD,
@ArticuloA		= InfoArticuloA,
@Almacen		= InfoAlmacenWMS,
@Titulo		= RepTitulo
FROM RepParam
WHERE Estacion = @Estacion
IF LEN(@TarimaD) = 0 OR @TarimaD = '(Todos)' OR @TarimaD = 'Todos' SET @TarimaD = NULL
IF LEN(@TarimaA) = 0 OR @TarimaA = '(Todos)' OR @TarimaA = 'Todos' SET @TarimaA = NULL
IF LEN(@Estatus) = 0 OR @Estatus = '(Todos)' OR @Estatus = 'Todos' SET @Estatus = NULL
IF LEN(@Orden) = 0 OR @Orden = '(Todos)' OR @Orden = 'Todos' SET @Orden = NULL
IF LEN(@Tipo) = 0 OR @Tipo = '(Todos)' OR @Tipo = 'Todos' SET @Tipo = NULL
IF LEN(@FechaD) = 0 SET @FechaD = NULL
IF LEN(@FechaA) = 0 SET @FechaA = NULL
IF LEN(@CaducidadD) = 0 SET @CaducidadD = NULL
IF LEN(@CaducidadA) = 0 SET @CaducidadA = NULL
IF LEN(@ArticuloD) = 0 OR @ArticuloD = '(Todos)' OR @ArticuloD = 'Todos' SET @ArticuloD = NULL
IF LEN(@ArticuloA) = 0 OR @ArticuloA = '(Todos)' OR @ArticuloA = 'Todos' SET @ArticuloA = NULL
IF LEN(@Almacen) = 0 OR @Almacen = '(Todos)' OR @Almacen = 'Todos' SET @Almacen = NULL
IF @Orden <> 'Fecha de Caducidad'
SELECT @CaducidadD = NULL, @CaducidadA = NULL
INSERT @Reporte(Tarima, Estatus, Articulo, Descripcion1, Almacen, Posicion, Descripcion, Tipo, Disponible, Alta, FechaCaducidad, Titulo)
SELECT d.Tarima, t.Estatus, d.Articulo, a.Descripcion1, d.Almacen, t.Posicion, p.Descripcion, p.Tipo, d.Disponible, t.Alta, t.FechaCaducidad, @Titulo as Titulo
FROM Artdisponibletarima d
JOIN Art a ON a.Articulo = d.Articulo
JOIN Tarima t ON t.Tarima = d.Tarima
JOIN AlmPos p ON p.Posicion = t.Posicion
JOIN Alm l ON p.Almacen = l.Almacen AND l.WMS = 1
WHERE d.Tarima BETWEEN ISNULL(@TarimaD, d.Tarima) AND ISNULL(@TarimaA, d.Tarima)
AND t.Estatus = ISNULL(@Estatus, t.Estatus)
AND ISNULL(p.Almacen, '(Todas)') = ISNULL(@Almacen, ISNULL(p.Almacen, '(Todas)'))
AND p.Tipo = ISNULL(@Tipo, p.Tipo)
AND dbo.fnFechaSinHora(t.Alta) BETWEEN ISNULL(dbo.fnFechaSinHora(@FechaD), dbo.fnFechaSinHora(t.Alta)) AND ISNULL(dbo.fnFechaSinHora(@FechaA), dbo.fnFechaSinHora(t.Alta))
AND ISNULL(dbo.fnFechaSinHora(t.FechaCaducidad), '') BETWEEN ISNULL(dbo.fnFechaSinHora(@CaducidadD), ISNULL(dbo.fnFechaSinHora(t.FechaCaducidad), '')) AND ISNULL(dbo.fnFechaSinHora(@CaducidadA), ISNULL(dbo.fnFechaSinHora(t.FechaCaducidad), ''))
AND d.Articulo BETWEEN ISNULL(@ArticuloD, d.Articulo) AND ISNULL(@ArticuloA, d.Articulo)
ORDER BY CASE @Orden WHEN 'Tarima' THEN d.Tarima WHEN 'Articulo' THEN d.Articulo WHEN 'Posición' THEN t.Posicion WHEN 'Fecha de Entrada' THEN CONVERT(varchar,t.Alta) WHEN 'Fecha de Caducidad' THEN CONVERT(varchar,t.FechaCaducidad) END
DELETE FROM @Reporte WHERE Estatus = 'BAJA' AND Disponible <= 0
SELECT Tarima, Estatus, Articulo, Descripcion1, Almacen, Posicion, Descripcion, Tipo, Disponible, Alta, FechaCaducidad, Titulo
FROM @Reporte
ORDER BY FechaCaducidad, Posicion
RETURN
END

