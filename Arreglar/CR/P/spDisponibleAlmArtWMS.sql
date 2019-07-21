SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spDisponibleAlmArtWMS
@Empresa    VARCHAR(20),
@Estacion   INT,
@ArticuloD  VARCHAR(20),
@ArticuloA  VARCHAR(20),
@Almacen    VARCHAR(50),
@Categoria  VARCHAR(50),
@Grupo      VARCHAR(50),
@Familia    VARCHAR(50)

AS
BEGIN
IF @Categoria IN ('(Todos)', '(TODOS)', '', 'NULL')  SELECT @Categoria = NULL
IF @Grupo     IN ('(Todos)', '(TODOS)', '', 'NULL')  SELECT @Grupo = NULL
IF @Familia   IN ('(Todos)', '(TODOS)', '', 'NULL')  SELECT @Familia = NULL
CREATE TABLE #RepExitenciaArtWMS
(
Articulo			VARCHAR(20)  NULL,
Descripcion         VARCHAR(255) NULL,
Almacen             VARCHAR(20)  NULL,
Existencia			FLOAT NULL,
Reservado			FLOAT NULL,
Comprometido		FLOAT NULL,
/*CantidadSolicitada	FLOAT NULL,*/
TarimaBaja          FLOAT NULL,
Categoria           VARCHAR(100) NULL,
Grupo               VARCHAR(100) NULL,
Familia             VARCHAR(100) NULL,
Disponible			AS (ISNULL(Existencia,0)-ISNULL(Reservado,0)-ISNULL(Comprometido,0)/*ISNULL(CantidadSolicitada,0)*/-ISNULL(TarimaBaja,0))
)
SELECT b.Articulo, SUM(ISNULL(b.CantidadPendiente,0)) CantidadComprometida
INTO #VentaComprometido
FROM Venta a
LEFT OUTER JOIN VentaD b ON b.ID=a.ID
JOIN Alm c ON c.Almacen=a.Almacen
WHERE a.Estatus IN ('PENDIENTE')
AND WMS=1
AND a.Mov IN (SELECT Movimiento FROM WMSModuloMovimiento WHERE Modulo='VTAS')
AND a.Almacen=@Almacen
GROUP BY b.Articulo
SELECT b.Articulo, SUM(ISNULL(b.CantidadPendiente,0)) CantidadComprometida
INTO #InvComprometido
FROM Inv a
LEFT OUTER JOIN InvD b ON b.ID=a.ID
JOIN Alm c ON c.Almacen=a.Almacen
WHERE a.Estatus IN ('PENDIENTE')
AND WMS=1
AND a.Mov IN (SELECT Movimiento FROM WMSModuloMovimiento WHERE Modulo='INV')
AND a.Almacen=@Almacen
GROUP BY b.Articulo
SELECT b.Articulo, SUM(ISNULL(b.CantidadPendiente,0)) CantidadComprometida
INTO #CompraComprometido
FROM Compra a
LEFT OUTER JOIN CompraD b ON b.ID=a.ID
JOIN Alm c ON c.Almacen=a.Almacen
WHERE a.Estatus IN ('PENDIENTE')
AND WMS=1
AND a.Mov IN (SELECT Movimiento FROM WMSModuloMovimiento WHERE Modulo='COMS')
AND a.Almacen=@Almacen
GROUP BY b.Articulo
SELECT * INTO #TotalComprometidoPre FROM #InvComprometido
UNION ALL
SELECT * FROM #VentaComprometido
UNION ALL
SELECT * FROM #CompraComprometido
SELECT Articulo, SUM(ISNULL(CantidadComprometida,0)) CantidadComprometida
INTO #TotalComprometido
FROM #TotalComprometidoPre
GROUP BY Articulo
INSERT INTO #RepExitenciaArtWMS
(Articulo,  Descripcion,    Almacen,   Existencia,    Reservado,   Comprometido,           Categoria,   Grupo,   Familia,  TarimaBaja)
SELECT b.Articulo, b.Descripcion1, a.Almacen, a.Existencias, a.Reservado, c.CantidadComprometida, b.Categoria, b.Grupo, b.Familia,
(
SELECT ISNULL(SUM(Disponible),0)
FROM ArtDisponibleTarima z
JOIN Tarima x ON x.Tarima=z.Tarima AND z.Almacen=x.Almacen AND z.Almacen=a.Almacen
WHERE z.Articulo=b.Articulo
AND x.Estatus='BAJA'
)
FROM Art b
LEFT OUTER JOIN ArtExistenciaReservado a ON a.Articulo=b.Articulo
LEFT OUTER JOIN #TotalComprometido c ON c.Articulo=b.Articulo
WHERE  
((@Almacen IS NULL)   OR (@Almacen <>   NULL AND a.Almacen = @Almacen))
AND ((@Categoria IS NULL) OR (@Categoria <> NULL AND b.Categoria = @Categoria))
AND ((@Grupo IS NULL)     OR (@Grupo <>     NULL AND b.Grupo = @Grupo))
AND ((@Familia IS NULL)   OR (@Familia <>   NULL AND b.Familia = @Familia))
AND b.Articulo BETWEEN @ArticuloD AND @ArticuloA
SELECT Articulo,  Descripcion,    Almacen,   ISNULL(Existencia,0) Existencia,    ISNULL(Reservado,0) Reservado,   ISNULL(Comprometido,0) Comprometido,           Categoria,   Grupo,   Familia,  TarimaBaja, Disponible
FROM #RepExitenciaArtWMS
ORDER BY Disponible ASC
RETURN
END

