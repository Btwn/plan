SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER Procedure dbo.spPlanArtSabana
@Empresa                VARCHAR(5),
@EstacionOriginal       INT,
@Estacion               INT
As
BEGIN
DECLARE
@OperadorVenta          VARCHAR(10),
@Venta                  FLOAT,
@OperadorExistencia     VARCHAR(10),
@Existencia             FLOAT,
@FechaD                 DATETIME,
@FechaA                 DATETIME,
@SucursalGrupo          VARCHAR(20),
@Proveedor              VARCHAR(20),
@Departamento           VARCHAR(50),
@Seccion                VARCHAR(50),
@Fabricante             VARCHAR(50),
@Articulo               VARCHAR(20),
@CalcularPrecio         BIT,
@Sucursal               INT,
@Diferencia             FLOAT,
@SucursalOrigen         INT,
@ID                     INT,
@Requerido              INT,
@Factor                 INT,
@FechaCompra            DATETIME,
@Fecha                  DATETIME,
@Fecha2                 DATETIME,
@Fecha3                 DATETIME,
@Fecha4                 DATETIME,
@Factor1                INT,
@SQL                    VARCHAR(MAX),
@MostrarGrises          BIT,
@MostrarProvOmision     BIT,
@EstatusPlan            VARCHAR(30)
DELETE FROM SabanaVentasPaso WHERE Estacion =  @Estacion
DELETE FROM SabanaVentas WHERE Estacion =  @Estacion
DELETE FROM SabanaArt WHERE Estacion =  @Estacion
DELETE FROM SabanaSobrantes WHERE Estacion =  @Estacion
DELETE FROM SabanaTraspaso WHERE Estacion =  @Estacion
DELETE FROM SabanaCompras WHERE Estacion =  @Estacion
DELETE FROM SabanaTransito WHERE Estacion =  @Estacion
DELETE FROM Sabana WHERE Estacion =  @Estacion
DELETE FROM SabanaD WHERE Estacion =  @Estacion
DELETE FROM SabanaTraspasoP WHERE Estacion =  @Estacion
DELETE FROM SabanaDevoluciones WHERE Estacion =  @Estacion
SELECT @Fecha = dbo.fnFechaSinHora(GETDATE())
SELECT @OperadorVenta = OperadorVenta, @Venta = Venta, @OperadorExistencia = OperadorExistencia, @Existencia = Existencia,
@FechaD = FechaD, @FechaA = FechaA, @SucursalGrupo = SucursalGrupo, @Proveedor = Proveedor, @Departamento = Departamento,
@Seccion = Seccion, @Articulo = Articulo, @Fabricante = Fabricante, @MostrarProvOmision = MostrarProvOmision
FROM SabanaFiltro WITH(NOLOCK)
WHERE Estacion = @Estacion
SELECT @OperadorVenta = NULLIF(@OperadorVenta, '(TODOS)')
SELECT @OperadorExistencia = NULLIF(@OperadorExistencia, '(TODOS)')
IF @MostrarProvOmision = 0
BEGIN
IF NULLIF(@Articulo, '') IS NULL
BEGIN
IF NULLIF(@Seccion, '') IS NULL AND NULLIF(@Fabricante, '') IS NULL
INSERT SabanaArt
SELECT @Estacion, a.Articulo
FROM Art a
JOIN ArtProv ap ON a.Articulo = ap.Articulo
WHERE ap.Proveedor = @Proveedor
AND a.Categoria = @Departamento
AND a.Estatus = 'ALTA'
ELSE IF NULLIF(@Seccion, '') IS NOT NULL AND NULLIF(@Fabricante, '') IS NULL
INSERT SabanaArt
SELECT @Estacion, a.Articulo
FROM Art a
JOIN ArtProv ap ON a.Articulo = ap.Articulo
WHERE ap.Proveedor = @Proveedor
AND a.Categoria = @Departamento
AND a.Familia = @Seccion
AND a.Estatus = 'ALTA'
ELSE IF NULLIF(@Seccion, '') IS NULL AND NULLIF(@Fabricante, '') IS NOT NULL
INSERT SabanaArt
SELECT @Estacion, a.Articulo
FROM Art a
JOIN ArtProv ap ON a.Articulo = ap.Articulo
WHERE ap.Proveedor = @Proveedor
AND a.Categoria = @Departamento
AND a.Fabricante = @Fabricante
AND a.Estatus = 'ALTA'
ELSE IF NULLIF(@Seccion, '') IS NOT NULL AND NULLIF(@Fabricante, '') IS NOT NULL
INSERT SabanaArt
SELECT @Estacion, a.Articulo
FROM Art a
JOIN ArtProv ap ON a.Articulo = ap.Articulo
WHERE ap.Proveedor = @Proveedor
AND a.Categoria = @Departamento
AND a.Familia = @Seccion
AND a.Fabricante = @Fabricante
AND a.Estatus = 'ALTA'
END ELSE IF NULLIF(@Articulo, '') IS NOT NULL
BEGIN
SELECT @Proveedor = ISNULL(NULLIF(@Proveedor, ''), Proveedor) FROM Art WHERE Articulo = @Articulo
INSERT SabanaArt
SELECT @Estacion, a.Articulo
FROM Art a
JOIN ArtProv ap ON a.Articulo = ap.Articulo
WHERE a.Articulo = @Articulo
AND ap.Proveedor = @Proveedor
AND a.Estatus = 'ALTA'
END
END ELSE
BEGIN
IF NULLIF(@Articulo, '') IS NULL
BEGIN
IF NULLIF(@Seccion, '') IS NULL AND NULLIF(@Fabricante, '') IS NULL
INSERT SabanaArt
SELECT @Estacion, a.Articulo
FROM Art a
JOIN ArtProv ap ON a.Articulo = ap.Articulo AND a.Proveedor = ap.Proveedor
WHERE a.Proveedor = @Proveedor
AND a.Categoria = @Departamento
AND a.Estatus = 'ALTA'
ELSE IF NULLIF(@Seccion, '') IS NOT NULL AND NULLIF(@Fabricante, '') IS NULL
INSERT SabanaArt
SELECT @Estacion, a.Articulo
FROM Art a
JOIN ArtProv ap ON a.Articulo = ap.Articulo AND a.Proveedor = ap.Proveedor
WHERE a.Proveedor = @Proveedor
AND a.Categoria = @Departamento
AND a.Familia = @Seccion
AND a.Estatus = 'ALTA'
ELSE IF NULLIF(@Seccion, '') IS NULL AND NULLIF(@Fabricante, '') IS NOT NULL
INSERT SabanaArt
SELECT @Estacion, a.Articulo
FROM Art a
JOIN ArtProv ap ON a.Articulo = ap.Articulo AND a.Proveedor = ap.Proveedor
WHERE a.Proveedor = @Proveedor
AND a.Categoria = @Departamento
AND a.Fabricante = @Fabricante
AND a.Estatus = 'ALTA'
ELSE IF NULLIF(@Seccion, '') IS NOT NULL AND NULLIF(@Fabricante, '') IS NOT NULL
INSERT SabanaArt
SELECT @Estacion, a.Articulo
FROM Art a
JOIN ArtProv ap ON a.Articulo = ap.Articulo AND a.Proveedor = ap.Proveedor
WHERE a.Proveedor = @Proveedor
AND a.Categoria = @Departamento
AND a.Familia = @Seccion
AND a.Fabricante = @Fabricante
AND a.Estatus = 'ALTA'
END ELSE IF NULLIF(@Articulo, '') IS NOT NULL
BEGIN
SELECT @Proveedor = Proveedor FROM Art WHERE Articulo = @Articulo
INSERT SabanaArt
SELECT @Estacion, a.Articulo
FROM Art a
WHERE a.Articulo = @Articulo
AND a.Estatus = 'ALTA'
END
END
SELECT d.Articulo, a2.Sucursal AS Sucursal, a2.Almacen AS Almacen, Sum(d.Cantidad * d.Factor) AS Ventas, IsNull(ad.Disponible,0) AS Disponible
INTO #Ventas
FROM Venta v WITH(NOLOCK)
JOIN VentaD d WITH(NOLOCK) ON (v.ID = d.ID)
JOIN MovTipo mt ON v.Mov = mt.Mov  AND 'VTAS' = mt.Modulo
JOIN Art a  WITH(NOLOCK) ON d.Articulo = a.Articulo
JOIN Alm a2  WITH(NOLOCK) ON d.Almacen = a2.Almacen
LEFT OUTER JOIN ArtDisponible ad WITH(NOLOCK) ON d.Articulo = ad.Articulo AND v.Almacen = ad.Almacen
WHERE mt.Clave IN ('VTAS.F', 'VTAS.N')
AND a.Estatus = 'ALTA'
AND v.Estatus In ('CONCLUIDO','PROCESAR')
AND v.FechaEmision Between @FechaD And @FechaA
AND v.Sucursal IN (SELECT Sucursal FROM SabanaFiltroSucursal WHERE Estacion = @Estacion)
AND d.Articulo IN (SELECT Articulo FROM SabanaArt WHERE Estacion = @Estacion)
GROUP BY d.Articulo, a2.Sucursal, a2.Almacen, ad.Disponible
IF @OperadorExistencia IS NOT NULL AND @OperadorVenta IS NOT NULL
SELECT @SQL ='
INSERT SabanaVentas (Estacion, Articulo, Sucursal, Almacen, Disponible, Ventas, VentaOriginal)
SELECT ' + CONVERT(VARCHAR, @Estacion) + ', Articulo, Sucursal, Almacen, Disponible, SUM(Ventas), Ventas
FROM #Ventas
WHERE ISNULL(Ventas, 0) ' + RTRIM(@OperadorVenta) + ' ' + CONVERT(VARCHAR, ISNULL(@Venta, 0)) + '
AND ISNULL(Disponible, 0) ' + RTRIM(@OperadorExistencia) + ' ' + CONVERT(VARCHAR, ISNULL(@Existencia, 0)) + '
GROUP BY Articulo, Sucursal, Almacen, Disponible, Ventas'
ELSE IF @OperadorExistencia IS NULL AND @OperadorVenta IS NOT NULL
SELECT @SQL ='
INSERT SabanaVentas (Estacion, Articulo, Sucursal, Almacen, Disponible, Ventas, VentaOriginal)
SELECT ' + CONVERT(VARCHAR, @Estacion) + ', Articulo, Sucursal, Almacen, Disponible, SUM(Ventas), Ventas
FROM #Ventas
WHERE ISNULL(Ventas, 0) ' + RTRIM(@OperadorVenta) + ' ' + CONVERT(VARCHAR, ISNULL(@Venta, 0)) + '
GROUP BY Articulo, Sucursal, Almacen, Disponible, Ventas'
ELSE IF @OperadorExistencia IS NOT NULL AND @OperadorVenta IS NULL
SELECT @SQL ='
INSERT SabanaVentas (Estacion, Articulo, Sucursal, Almacen, Disponible, Ventas, VentaOriginal)
SELECT ' + CONVERT(VARCHAR, @Estacion) + ', Articulo, Sucursal, Almacen, Disponible, SUM(Ventas), Ventas
FROM #Ventas
WHERE ISNULL(Disponible, 0) ' + RTRIM(@OperadorExistencia) + ' ' + CONVERT(VARCHAR, ISNULL(@Existencia, 0)) + '
GROUP BY Articulo, Sucursal, Almacen, Disponible, Ventas'
ELSE IF @OperadorExistencia IS NULL AND @OperadorVenta IS NULL
SELECT @SQL ='
INSERT SabanaVentas (Estacion, Articulo, Sucursal, Almacen, Disponible, Ventas, VentaOriginal)
SELECT ' + CONVERT(VARCHAR, @Estacion) + ', Articulo, Sucursal, Almacen, Disponible, SUM(Ventas), Ventas
FROM #Ventas
GROUP BY Articulo, Sucursal, Almacen, Disponible, Ventas'
EXEC(@SQL)
INSERT SabanaVentasPaso(Estacion, Articulo, Sucursal, Almacen, Ventas, Disponible, VentaOriginal)
SELECT DISTINCT @Estacion, s.Articulo, a.Sucursal, a.Almacen, 0, 0, 0
FROM SabanaArt s WITH(NOLOCK)
LEFT OUTER JOIN Alm a ON 1= 1
WHERE Estacion = @Estacion
AND a.Sucursal IN (SELECT Sucursal FROM SabanaFiltroSucursal WHERE Estacion = @Estacion)
SELECT @SQL = NULL
IF @OperadorExistencia IS NOT NULL AND @OperadorVenta IS NOT NULL
SELECT @SQL ='
INSERT SabanaVentas (Estacion, Articulo, Sucursal, Almacen, Ventas, VentaOriginal, Disponible)
SELECT ' + CONVERT(VARCHAR, @Estacion) + ', gp.Articulo, gp.Sucursal, gp.Almacen, 0, 0, ad.Disponible
FROM SabanaVentasPaso gp WITH(NOLOCK)
LEFT OUTER JOIN SabanaVentas g  WITH(NOLOCK) ON gp.Estacion = g.Estacion AND gp.Articulo = g.Articulo AND gp.Sucursal = g.Sucursal
LEFT OUTER JOIN ArtDisponible ad WITH(NOLOCK) ON gp.Articulo = ad.Articulo AND gp.Almacen = ad.Almacen
WHERE gp.Estacion = ' + CONVERT(VARCHAR, ISNULL(@Estacion, 0)) + '
AND g.Articulo IS NULL AND ISNULL(gp.Ventas, 0) ' + RTRIM(@OperadorVenta) + ' ' + CONVERT(VARCHAR, ISNULL(@Venta, 0)) + '
AND ISNULL(ad.Disponible, 0) ' + RTRIM(@OperadorExistencia) + ' ' + CONVERT(VARCHAR, ISNULL(@Existencia, 0)) + '
GROUP BY gp.Articulo, gp.Sucursal, gp.Almacen, ad.Disponible'
IF @OperadorExistencia IS NULL AND @OperadorVenta IS NOT NULL
SELECT @SQL ='
INSERT SabanaVentas (Estacion, Articulo, Sucursal, Almacen, Ventas, VentaOriginal, Disponible)
SELECT ' + CONVERT(VARCHAR, @Estacion) + ', gp.Articulo, gp.Sucursal, gp.Almacen, 0, 0, ad.Disponible
FROM SabanaVentasPaso gp WITH(NOLOCK)
LEFT OUTER JOIN SabanaVentas g WITH(NOLOCK) ON gp.Estacion = g.Estacion AND gp.Articulo = g.Articulo AND gp.Sucursal = g.Sucursal
LEFT OUTER JOIN ArtDisponible ad WITH(NOLOCK) ON gp.Articulo = ad.Articulo AND gp.Almacen = ad.Almacen
WHERE gp.Estacion = ' + CONVERT(VARCHAR, ISNULL(@Estacion, 0)) + '
AND g.Articulo IS NULL AND ISNULL(gp.Ventas, 0) ' + RTRIM(@OperadorVenta) + ' ' + CONVERT(VARCHAR, ISNULL(@Venta, 0)) + '
GROUP BY gp.Articulo, gp.Sucursal, gp.Almacen, ad.Disponible'
IF @OperadorExistencia IS NOT NULL AND @OperadorVenta IS NULL
SELECT @SQL ='
INSERT SabanaVentas (Estacion, Articulo, Sucursal, Almacen, Ventas, VentaOriginal, Disponible)
SELECT ' + CONVERT(VARCHAR, @Estacion) + ', gp.Articulo, gp.Sucursal, gp.Almacen, 0, 0, ad.Disponible
FROM SabanaVentasPaso gp WITH(NOLOCK)
LEFT OUTER JOIN SabanaVentas g  WITH(NOLOCK) ON gp.Estacion = g.Estacion AND gp.Articulo = g.Articulo AND gp.Sucursal = g.Sucursal
LEFT OUTER JOIN ArtDisponible ad WITH(NOLOCK) ON gp.Articulo = ad.Articulo AND gp.Almacen = ad.Almacen
WHERE gp.Estacion = ' + CONVERT(VARCHAR, ISNULL(@Estacion, 0)) + '
AND g.Articulo IS NULL AND ISNULL(ad.Disponible, 0) ' + RTRIM(@OperadorExistencia) + ' ' + CONVERT(VARCHAR, ISNULL(@Existencia, 0)) + '
GROUP BY gp.Articulo, gp.Sucursal, gp.Almacen, ad.Disponible'
IF @OperadorExistencia IS NULL AND @OperadorVenta IS NULL
SELECT @SQL ='
INSERT SabanaVentas (Estacion, Articulo, Sucursal, Almacen, Ventas, VentaOriginal, Disponible)
SELECT ' + CONVERT(VARCHAR, @Estacion) + ', gp.Articulo, gp.Sucursal, gp.Almacen, 0, 0, ad.Disponible
FROM SabanaVentasPaso gp WITH(NOLOCK)
LEFT OUTER JOIN SabanaVentas g  WITH(NOLOCK) ON gp.Estacion = g.Estacion AND gp.Articulo = g.Articulo AND gp.Sucursal = g.Sucursal
LEFT OUTER JOIN ArtDisponible ad WITH(NOLOCK) ON gp.Articulo = ad.Articulo AND gp.Almacen = ad.Almacen
WHERE gp.Estacion = ' + CONVERT(VARCHAR, ISNULL(@Estacion, 0)) + '
AND g.Articulo IS NULL
GROUP BY gp.Articulo, gp.Sucursal, gp.Almacen, ad.Disponible'
EXEC(@SQL)
INSERT SabanaTransito(Estacion, Articulo, Almacen, Transito)
SELECT @Estacion, SKU, Almacen, SUM(InventarioUnidades)
FROM vsTransito2  WITH(NOLOCK)
WHERE SKU IN (SELECT Articulo FROM SabanaArt WHERE Estacion = @Estacion)
GROUP BY SKU, Almacen
UPDATE SabanaVentas SET PrimeraCompra = dbo.fnFechaPrimeraCompra(Articulo, Almacen) WHERE Estacion = @Estacion
UPDATE SabanaVentas SET UltimaCompra = dbo.fnFechaUltimaCompra(Articulo, Almacen) WHERE Estacion = @Estacion
UPDATE SabanaVentas SET Factor = ROUND(DATEDIFF(dd, PrimeraCompra, @FechaA) / 30, 0) WHERE Estacion = @Estacion
UPDATE SabanaVentas SET Factor=1 WHERE Factor=0
UPDATE SabanaVentas SET Ventas = ROUND(Ventas/Factor, 0) WHERE Estacion = @Estacion
UPDATE a
SET a.Transito = ISNULL(b.Transito, 0)
FROM SabanaVentas a
LEFT OUTER JOIN SabanaTransito b ON a.Articulo = b.Articulo AND a.Almacen = b.Almacen AND a.Estacion = b.Estacion
WHERE a.Estacion = @Estacion
INSERT SabanaCompras(Estacion, Articulo, Almacen, Compras)
SELECT @Estacion, SKU, Almacen, SUM(InventarioUnidades)
FROM vsCompras  WITH(NOLOCK)
WHERE SKU IN (SELECT Articulo FROM SabanaArt WHERE Estacion = @Estacion)
GROUP BY SKU, Almacen
UPDATE a
SET a.Compras = ISNULL(b.Compras, 0)
FROM SabanaVentas a
LEFT OUTER JOIN SabanaCompras b ON a.Articulo = b.Articulo AND a.Almacen = b.Almacen AND a.Estacion = b.Estacion
WHERE a.Estacion = @Estacion
INSERT SabanaDevoluciones(Estacion, Articulo, Almacen, Devoluciones)
SELECT @Estacion, SKU, Almacen, SUM(InventarioUnidades)
FROM vsDevoluciones  WITH(NOLOCK)
WHERE FechaTransaccion BETWEEN @FechaD And @FechaA
AND SKU IN (SELECT Articulo FROM SabanaArt WHERE Estacion = @Estacion)
GROUP BY SKU, Almacen
INSERT SabanaTraspasoP(Estacion, Articulo, Almacen, Traspaso)
SELECT @Estacion, SKU, Almacen, SUM(InventarioUnidades)
FROM vsTraspaso  WITH(NOLOCK)
WHERE SKU IN (SELECT Articulo FROM SabanaArt WHERE Estacion = @Estacion)
GROUP BY SKU, Almacen
UPDATE a
SET a.Traspaso = ISNULL(b.Traspaso, 0)
FROM SabanaVentas a
LEFT OUTER JOIN SabanaTraspasoP b ON a.Articulo = b.Articulo AND a.Almacen = b.Almacen AND a.Estacion = b.Estacion
WHERE a.Estacion = @Estacion
UPDATE SabanaVentas SET DisponibleOriginal = Disponible  WHERE Estacion = @Estacion
UPDATE a
SET a.Diferencia = b.CantidadOriginal
FROM SabanaVentas a
LEFT OUTER JOIN PlanArtOP b ON a.Articulo = b.Articulo AND a.Almacen = b.Almacen
WHERE a.Estacion = @Estacion
AND b.Accion = 'Comprar'
INSERT SabanaD(Estacion, Proveedor, Articulo, Sucursal, Almacen, PrimeraEntrada, UltimaEntrada, Venta, Existencia, Transito, Devuelto, Ordenado, TraspasoP, Sugerido, CantidadComprar)
SELECT @Estacion, @Proveedor, Articulo, Sucursal, Almacen, PrimeraCompra, UltimaCompra, VentaOriginal, ISNULL(DisponibleOriginal, 0), Transito, Devoluciones, Compras, Traspaso, Diferencia, 0
FROM SabanaVentas  WITH(NOLOCK) WHERE ISNULL(Diferencia, 0) < 0 AND Estacion = @Estacion
INSERT SabanaD(Estacion, Proveedor,  Articulo, Sucursal, Almacen, PrimeraEntrada, UltimaEntrada, Venta, Existencia, Transito, Devuelto, Ordenado, TraspasoP, Sugerido, CantidadComprar)
SELECT @Estacion, @Proveedor, Articulo, Sucursal, Almacen, PrimeraCompra, UltimaCompra, VentaOriginal, ISNULL(DisponibleOriginal, 0), Transito, Devoluciones, Compras, Traspaso, Diferencia, 0
FROM SabanaVentas  WITH(NOLOCK) WHERE ISNULL(Diferencia, 0) >= 0 AND Estacion = @Estacion
INSERT Sabana(Estacion, Articulo, VentaTotal, ExistenciaTotal, Proveedor, Grupo, FechaD, FechaA, UltimaEntrada)
SELECT @Estacion, Articulo, SUM(Venta), SUM(Existencia), @Proveedor, @SucursalGrupo, @FechaD, @FechaA, MAX(UltimaEntrada)
FROM SabanaD WITH(NOLOCK)
WHERE Estacion = @Estacion
GROUP BY Articulo
UPDATE a
SET a.ID = b.ID
FROM SabanaD a
LEFT OUTER JOIN Sabana b ON a.Articulo = b.Articulo AND a.Estacion = b.Estacion
WHERE a.Estacion = @Estacion;
WITH Orden (ID, RID) AS
(
SELECT
ID
, ROW_NUMBER() OVER (ORDER BY VentaTotal DESC, Articulo ASC) As [RID]
FROM
Sabana WHERE Estacion = @Estacion
)
UPDATE s
SET Orden = t.RID
FROM
Orden t
INNER JOIN
Sabana As s
On t.ID = s.ID
END

