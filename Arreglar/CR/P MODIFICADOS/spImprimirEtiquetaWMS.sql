SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spImprimirEtiquetaWMS
@Estacion		int

AS BEGIN
DECLARE
@FechaD			datetime,
@FechaA			datetime,
@TarimaD		varchar(20),
@TarimaA		varchar(20),
@ArticuloD 		varchar(20),
@ArticuloA		varchar(20),
@Empresa		varchar(5)
SELECT @FechaD	= InfoFechaD,
@FechaA	= InfoFechaA,
@TarimaD	= InfoTarimaD,
@TarimaA	= InfoTarimaA,
@ArticuloD	= InfoArticuloD,
@ArticuloA	= InfoArticuloA,
@Empresa   = InfoEmpresa
FROM RepParam
WITH(NOLOCK) WHERE Estacion = @Estacion
IF LEN(@FechaD) = 0 SET @FechaD = NULL
IF LEN(@FechaA) = 0 SET @FechaA = NULL
IF LEN(@TarimaD) = 0 SET @TarimaD = NULL
IF LEN(@TarimaA) = 0 SET @TarimaA = NULL
IF LEN(@ArticuloD) = 0 SET @ArticuloD = NULL
IF LEN(@ArticuloA) = 0 SET @ArticuloA = NULL
SELECT
d.Articulo,
a.Descripcion1,
d.Almacen,
d.Tarima,
d.Disponible,
t.Alta,
t.FechaCaducidad,
a.Unidad,
cb.Codigo,
sl.SerieLote
FROM Artdisponibletarima d
 WITH(NOLOCK) JOIN Art a  WITH(NOLOCK) ON a.Articulo = d.Articulo
JOIN Tarima t  WITH(NOLOCK) ON t.Tarima = d.Tarima
LEFT JOIN CB cb  WITH(NOLOCK) ON TipoCuenta='Articulos' AND cb.Cuenta=a.Articulo
LEFT JOIN SerieLote sl  WITH(NOLOCK) ON d.Tarima=sl.Tarima AND d.Almacen=sl.Almacen AND d.Articulo=sl.Articulo AND sl.Empresa=@Empresa
WHERE ISNULL(@TarimaD, d.Tarima) < = ISNULL(d.Tarima, @TarimaD) AND ISNULL(@TarimaD, d.Tarima) < = ISNULL(d.Tarima, @TarimaA)
AND ISNULL(@TarimaA, d.Tarima) > = ISNULL(d.Tarima, @TarimaA) 
AND d.Articulo BETWEEN ISNULL(@ArticuloD, d.Articulo) AND ISNULL(@ArticuloA, d.Articulo)
AND dbo.fnFechaSinHora(ISNULL(@FechaD, t.Alta)) < = dbo.fnFechaSinHora(ISNULL(t.Alta, @FechaD))
AND dbo.fnFechaSinHora(ISNULL(@FechaA, t.Alta)) > = dbo.fnFechaSinHora(ISNULL(t.Alta, @FechaA))
AND t.Estatus = 'ALTA'
AND DISPONIBLE > 0
RETURN
END

