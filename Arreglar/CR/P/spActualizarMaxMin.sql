SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spActualizarMaxMin
@Empresa                   char(5)

AS BEGIN
DECLARE
@Tipo                				varchar(50),
@Hoy                 				datetime,
@DiasVenta           				float,
@DiasInventario      				float,
@FactorCrecimiento   				float,
@HoyMesAnterior      				datetime,
@HoyAnioAtras        				datetime,
@HoyMesAnioAtras     				datetime,
@HoyAnioAtrasA						datetime,
@HoyMesSiguienteAnioAtras			datetime,
@Articulo            				varchar(20),
@SubCuenta           				varchar(20),
@Almacen             				varchar(10),
@Maximo              				float,
@Minimo              				float,
@PuntoOrden          				float,
@AOrdenar            				float,
@ABC                 				char(1),
@Porcentaje          				float,
@PeriodoA			 				bit,
@PeriodoB			 				bit,
@PeriodoC			 				bit,
@MesesPeriodoA		 				int,
@MesesPeriodoB		 				int,
@MesesPeriodoC		 				int,
@PrimerDiaMesActual					datetime,
@UltimoDiaMesAnterior				datetime,
@Semanas							int,
@UltimoDiaSemanaPasada				datetime,
@ComienzoSemanaCerrada				datetime,
@ComienzoDiasNaturales				datetime
SET @Hoy	=	DATEADD(d,-0,dbo.fnFechaSinHora(GETDATE()))
SELECT @Tipo				 = Tipo,
@DiasVenta            = DiasVenta,
@Semanas				 = Semanas,
@DiasInventario       = ISNULL(DiasInventario,0),
@FactorCrecimiento    = ISNULL(FactorCrecimiento,0),
@PeriodoA			 = ISNULL(PeriodoA,0),
@MesesPeriodoA		 = ISNULL(MesesPeriodoA,0),
@PeriodoB			 = ISNULL(PeriodoB,0),
@MesesPeriodoB		 = ISNULL(MesesPeriodoB,0),
@PeriodoC			 = ISNULL(PeriodoC,0),
@MesesPeriodoC		 = ISNULL(MesesPeriodoC,0)
FROM PlanArtMaxMinCfg
WHERE Empresa = @Empresa
CREATE TABLE #VentaAVGGeneral(
Empresa                    char(5),
Articulo                   varchar(20),
SubCuenta                  varchar(20)  NULL,
Almacen                    varchar(10),
Cantidad                   float,
Factor                     float,
IncrementoPRC              float,
TiempoEntrega              int,
TiempoEntregaUnidad        varchar(10),
TiempoEntregaSeg           float        NULL,
TiempoEntregaSegUnidad     varchar(10)  NULL,
DiasInventario             float        NULL,
UnidadTraspaso             varchar(50)  NULL,
UnidadCompra               varchar(50)  NULL
)
CREATE NONCLUSTERED INDEX Temp3 ON #VentaAVGGeneral(Empresa,Articulo,SubCuenta,Almacen)
CREATE TABLE #ArtAlm(
Empresa                    char(5),
Articulo                   varchar(20),
SubCuenta                  varchar(20),
Almacen                    varchar(10),
Maximo                     float,
Minimo                     float NULL,
ABC						 varchar(50) NULL,
VentaPromedio				 float
)
CREATE NONCLUSTERED INDEX Temp ON #ArtAlm (Articulo, SubCuenta, Almacen, Empresa)
UPDATE ArtAlm SET Maximo=0,Minimo=0,PuntoOrden=0,PuntoOrdenOrdenar=0,ABC='',VentaPromedio=0
WHERE Almacen NOT IN(SELECT Almacen FROM alm WHERE ExcluirPlaneacion=1)
IF @Tipo = 'DIAS NATURALES' AND @DiasVenta > 0
BEGIN
SET @ComienzoDiasNaturales = DATEADD(DAY, -(@DiasVenta), @Hoy)
INSERT #VentaAVGGeneral(
Empresa, Articulo, SubCuenta, Almacen, Cantidad, Factor,
IncrementoPRC, TiempoEntrega, TiempoEntregaUnidad, TiempoEntregaSeg, TiempoEntregaSegUnidad,
UnidadTraspaso, UnidadCompra, DiasInventario)
SELECT v.Empresa, d.Articulo, ISNULL(d.SubCuenta,''), d.Almacen, CASE WHEN t.Clave IN ('VTAS.D', 'VTAS.VP') THEN ISNULL(SUM(d.Cantidad*d.Factor),0)*-1 ELSE ISNULL(SUM(d.Cantidad*d.Factor),0) END, ISNULL(0,0),
0.00, ISNULL(a.TiempoEntrega,1), ISNULL(a.TiempoEntregaUnidad,'Dias'), ISNULL(a.TiempoEntregaSeg,1),ISNULL(a.TiempoEntregaSegUnidad,'Dias'),
a.UnidadTraspaso, a.UnidadCompra, @DiasInventario
FROM Venta v
JOIN VentaD d ON v.ID = d.ID
JOIN MovTipo t ON v.Mov = t.Mov AND t.Modulo = 'VTAS'
JOIN Art a ON d.Articulo = a.Articulo
JOIN Alm l ON d.Almacen = l.Almacen
LEFT JOIN ArtFam f ON a.Familia = f.Familia
LEFT JOIN ArtCat c ON a.Categoria = c.Categoria
WHERE t.Clave IN ('VTAS.F', 'VTAS.D','VTAS.VP')
AND v.Estatus IN ('CONCLUIDO')
AND UPPER(a.Tipo) <> 'SERVICIO'
AND v.FechaEmision BETWEEN @ComienzoDiasNaturales AND @Hoy
AND v.Empresa = @Empresa
AND ISNULL(l.ExcluirPlaneacion,0) = 0
AND a.Tipo <> 'JUEGO'
GROUP BY v.Empresa, d.Articulo, d.SubCuenta, d.Almacen, t.Clave, a.TiempoEntrega, a.TiempoEntregaUnidad,
a.TiempoEntregaSeg, a.TiempoEntregaSegUnidad, a.UnidadTraspaso, a.UnidadCompra
END	
IF @Tipo = 'SEMANAS CERRADAS' AND @Semanas > 0
BEGIN
SET @UltimoDiaSemanaPasada = DATEADD(WK,DATEDIFF(WK,7,@Hoy),6) 
SET @ComienzoSemanaCerrada = DATEADD(WK, -@Semanas, @UltimoDiaSemanaPasada)
SET @ComienzoSemanaCerrada = DATEADD(DAY,+1,@ComienzoSemanaCerrada)
INSERT #VentaAVGGeneral(
Empresa, Articulo, SubCuenta, Almacen, Cantidad, Factor,
IncrementoPRC, TiempoEntrega, TiempoEntregaUnidad, TiempoEntregaSeg, TiempoEntregaSegUnidad,
UnidadTraspaso, UnidadCompra, DiasInventario)
SELECT v.Empresa, d.Articulo, ISNULL(d.SubCuenta,''), d.Almacen, CASE WHEN t.Clave IN ('VTAS.D', 'VTAS.VP') THEN ISNULL(SUM(d.Cantidad*d.Factor),0)*-1 ELSE ISNULL(SUM(d.Cantidad*d.Factor),0) END, ISNULL(0,0),
0.00, ISNULL(a.TiempoEntrega,1), ISNULL(a.TiempoEntregaUnidad,'Dias'), ISNULL(a.TiempoEntregaSeg,1),ISNULL(a.TiempoEntregaSegUnidad,'Dias'),
a.UnidadTraspaso, a.UnidadCompra, @DiasInventario
FROM Venta v
JOIN VentaD d ON v.ID = d.ID
JOIN MovTipo t ON v.Mov = t.Mov AND t.Modulo = 'VTAS'
JOIN Art a ON d.Articulo = a.Articulo
JOIN ArtFam f ON a.Familia = f.Familia
JOIN ArtCat c ON a.Categoria = c.Categoria
JOIN Alm l ON d.Almacen = l.Almacen
WHERE t.Clave IN ('VTAS.F', 'VTAS.D','VTAS.VP')
AND v.Estatus IN ('CONCLUIDO')
AND UPPER(a.Tipo) <> 'SERVICIO'
AND v.FechaEmision BETWEEN @ComienzoSemanaCerrada AND @UltimoDiaSemanaPasada
AND v.Empresa = @Empresa
AND ISNULL(l.ExcluirPlaneacion,0) = 0
GROUP BY v.Empresa, d.Articulo, d.SubCuenta, d.Almacen, t.Clave, a.TiempoEntrega, a.TiempoEntregaUnidad,
a.TiempoEntregaSeg, a.TiempoEntregaSegUnidad, a.UnidadTraspaso, a.UnidadCompra
SET @DiasVenta = DATEDIFF(day, @ComienzoSemanaCerrada, @UltimoDiaSemanaPasada)
END 
IF @Tipo = 'MESES CERRADOS'
BEGIN
CREATE TABLE #VentaAVGPeriodoA(
Empresa                    char(5),
Articulo                   varchar(20),
SubCuenta                  varchar(20)  NULL,
Almacen                    varchar(10),
Cantidad                   float,
Factor                     float,
IncrementoPRC              float,
TiempoEntrega              int,
TiempoEntregaUnidad        varchar(10),
TiempoEntregaSeg           float        NULL,
TiempoEntregaSegUnidad     varchar(10)  NULL,
DiasInventario             float        NULL,
UnidadTraspaso             varchar(50)  NULL,
UnidadCompra               varchar(50)  NULL
)
CREATE NONCLUSTERED INDEX VentaAVGPA ON #VentaAVGPeriodoA(Empresa,Articulo,SubCuenta,Almacen)
CREATE TABLE #VentaAVGPeriodoB(
Empresa                    char(5),
Articulo                   varchar(20),
SubCuenta                  varchar(20)  NULL,
Almacen                    varchar(10),
Cantidad                   float,
Factor                     float,
IncrementoPRC              float,
TiempoEntrega              int,
TiempoEntregaUnidad        varchar(10),
TiempoEntregaSeg           float        NULL,
TiempoEntregaSegUnidad     varchar(10)  NULL,
DiasInventario             float        NULL,
UnidadTraspaso             varchar(50)  NULL,
UnidadCompra               varchar(50)  NULL
)
CREATE NONCLUSTERED INDEX VentaAVGPB ON #VentaAVGPeriodoB(Empresa,Articulo,SubCuenta,Almacen)
CREATE TABLE #VentaAVGPeriodoC(
Empresa                    char(5),
Articulo                   varchar(20),
SubCuenta                  varchar(20)  NULL,
Almacen                    varchar(10),
Cantidad                   float,
Factor                     float,
IncrementoPRC              float,
TiempoEntrega              int,
TiempoEntregaUnidad        varchar(10),
TiempoEntregaSeg           float        NULL,
TiempoEntregaSegUnidad     varchar(10)  NULL,
DiasInventario             float        NULL,
UnidadTraspaso             varchar(50)  NULL,
UnidadCompra               varchar(50)  NULL
)
CREATE NONCLUSTERED INDEX VentaAVGPC ON #VentaAVGPeriodoC(Empresa,Articulo,SubCuenta,Almacen)
IF @PeriodoA = 1 AND @MesesPeriodoA > 0
BEGIN
SET @PrimerDiaMesActual = DATEADD(MONTH, DATEDIFF(MONTH, 0, @Hoy), 0)
SET @HoyMesAnterior = DATEADD(MONTH,-(@MesesPeriodoA) ,@PrimerDiaMesActual)
SET @UltimoDiaMesAnterior = DATEADD(MONTH,+1,@HoyMesAnterior)
SET @UltimoDiaMesAnterior = DATEADD(DAY,-1,@UltimoDiaMesAnterior)
INSERT #VentaAVGPeriodoA(
Empresa, Articulo, SubCuenta, Almacen, Cantidad, Factor,
IncrementoPRC, TiempoEntrega, TiempoEntregaUnidad, TiempoEntregaSeg, TiempoEntregaSegUnidad,
UnidadTraspaso, UnidadCompra, DiasInventario)
SELECT v.Empresa, d.Articulo, ISNULL(d.SubCuenta,''), d.Almacen, CASE WHEN t.Clave IN ('VTAS.D', 'VTAS.VP') THEN ISNULL(SUM(d.Cantidad*d.Factor),0)*-1 ELSE ISNULL(SUM(d.Cantidad*d.Factor),0) END, ISNULL(0,0),
0.00, ISNULL(a.TiempoEntrega,1), ISNULL(a.TiempoEntregaUnidad,'Dias'), ISNULL(a.TiempoEntregaSeg,1),ISNULL(a.TiempoEntregaSegUnidad,'Dias'),
a.UnidadTraspaso, a.UnidadCompra, @DiasInventario
FROM Venta v
JOIN VentaD d ON v.ID = d.ID
JOIN MovTipo t ON v.Mov = t.Mov AND t.Modulo = 'VTAS'
JOIN Art a ON d.Articulo = a.Articulo
JOIN ArtFam f ON a.Familia = f.Familia
JOIN ArtCat c ON a.Categoria = c.Categoria
JOIN Alm l ON d.Almacen = l.Almacen
WHERE t.Clave IN ('VTAS.F', 'VTAS.D','VTAS.VP')
AND v.Estatus IN ('CONCLUIDO')
AND UPPER(a.Tipo) <> 'SERVICIO'
AND v.FechaEmision BETWEEN @HoyMesAnterior AND @UltimoDiaMesAnterior
AND v.Empresa = @Empresa
AND ISNULL(l.ExcluirPlaneacion,0) = 0
GROUP BY v.Empresa, d.Articulo, d.SubCuenta, d.Almacen, t.Clave, a.TiempoEntrega, a.TiempoEntregaUnidad,
a.TiempoEntregaSeg, a.TiempoEntregaSegUnidad, a.UnidadTraspaso, a.UnidadCompra
SET @DiasVenta += DATEDIFF(day, @HoyMesAnterior, @UltimoDiaMesAnterior)
END 
IF @PeriodoB = 1 AND @MesesPeriodoB > 0
BEGIN
SET @PrimerDiaMesActual = DATEADD(MONTH, DATEDIFF(MONTH, 0, @Hoy), 0)
SET @HoyMesAnterior = DATEADD(MONTH,-(@MesesPeriodoB) ,@PrimerDiaMesActual)
SET @UltimoDiaMesAnterior = DATEADD(MONTH,+1,@HoyMesAnterior)
SET @UltimoDiaMesAnterior = DATEADD(DAY,-1,@UltimoDiaMesAnterior)
INSERT #VentaAVGPeriodoB(
Empresa, Articulo, SubCuenta, Almacen, Cantidad, Factor,
IncrementoPRC, TiempoEntrega, TiempoEntregaUnidad, TiempoEntregaSeg, TiempoEntregaSegUnidad,
UnidadTraspaso, UnidadCompra, DiasInventario)
SELECT v.Empresa, d.Articulo, ISNULL(d.SubCuenta,''), d.Almacen, CASE WHEN t.Clave IN ('VTAS.D', 'VTAS.VP') THEN ISNULL(SUM(d.Cantidad*d.Factor),0)*-1 ELSE ISNULL(SUM(d.Cantidad*d.Factor),0) END, ISNULL(0,0),
0.00, ISNULL(a.TiempoEntrega,1), ISNULL(a.TiempoEntregaUnidad,'Dias'), ISNULL(a.TiempoEntregaSeg,1),ISNULL(a.TiempoEntregaSegUnidad,'Dias'),
a.UnidadTraspaso, a.UnidadCompra, @DiasInventario
FROM Venta v
JOIN VentaD d ON v.ID = d.ID
JOIN MovTipo t ON v.Mov = t.Mov AND t.Modulo = 'VTAS'
JOIN Art a ON d.Articulo = a.Articulo
JOIN ArtFam f ON a.Familia = f.Familia
JOIN ArtCat c ON a.Categoria = c.Categoria
JOIN Alm l ON d.Almacen = l.Almacen
WHERE t.Clave IN ('VTAS.F', 'VTAS.D','VTAS.VP')
AND v.Estatus IN ('CONCLUIDO')
AND UPPER(a.Tipo) <> 'SERVICIO'
AND v.FechaEmision BETWEEN @HoyMesAnterior AND @UltimoDiaMesAnterior
AND v.Empresa = @Empresa
AND ISNULL(l.ExcluirPlaneacion,0) = 0
GROUP BY v.Empresa, d.Articulo, d.SubCuenta, d.Almacen, t.Clave, a.TiempoEntrega, a.TiempoEntregaUnidad,
a.TiempoEntregaSeg, a.TiempoEntregaSegUnidad, a.UnidadTraspaso, a.UnidadCompra
SET @DiasVenta += DATEDIFF(day, @HoyMesAnterior, @UltimoDiaMesAnterior)
END 
IF @PeriodoC = 1 AND @MesesPeriodoC > 0
BEGIN
SET @PrimerDiaMesActual = DATEADD(MONTH, DATEDIFF(MONTH, 0, @Hoy), 0)
SET @HoyMesAnterior = DATEADD(MONTH,-(@MesesPeriodoC) ,@PrimerDiaMesActual)
SET @UltimoDiaMesAnterior = DATEADD(MONTH,+1,@HoyMesAnterior)
SET @UltimoDiaMesAnterior = DATEADD(DAY,-1,@UltimoDiaMesAnterior)
INSERT #VentaAVGPeriodoC(
Empresa, Articulo, SubCuenta, Almacen, Cantidad, Factor,
IncrementoPRC, TiempoEntrega, TiempoEntregaUnidad, TiempoEntregaSeg, TiempoEntregaSegUnidad,
UnidadTraspaso, UnidadCompra, DiasInventario)
SELECT v.Empresa, d.Articulo, ISNULL(d.SubCuenta,''), d.Almacen, CASE WHEN t.Clave IN ('VTAS.D', 'VTAS.VP') THEN ISNULL(SUM(d.Cantidad*d.Factor),0)*-1 ELSE ISNULL(SUM(d.Cantidad*d.Factor),0) END, ISNULL(0,0),
0.00, ISNULL(a.TiempoEntrega,1), ISNULL(a.TiempoEntregaUnidad,'Dias'), ISNULL(a.TiempoEntregaSeg,1),ISNULL(a.TiempoEntregaSegUnidad,'Dias'),
a.UnidadTraspaso, a.UnidadCompra, @DiasInventario
FROM Venta v
JOIN VentaD d ON v.ID = d.ID
JOIN MovTipo t ON v.Mov = t.Mov AND t.Modulo = 'VTAS'
JOIN Art a ON d.Articulo = a.Articulo
JOIN ArtFam f ON a.Familia = f.Familia
JOIN ArtCat c ON a.Categoria = c.Categoria
JOIN Alm l ON d.Almacen = l.Almacen
WHERE t.Clave IN ('VTAS.F', 'VTAS.D','VTAS.VP')
AND v.Estatus IN ('CONCLUIDO')
AND UPPER(a.Tipo) <> 'SERVICIO'
AND v.FechaEmision BETWEEN @HoyMesAnterior AND @UltimoDiaMesAnterior
AND v.Empresa = @Empresa
AND ISNULL(l.ExcluirPlaneacion,0) = 0
GROUP BY v.Empresa, d.Articulo, d.SubCuenta, d.Almacen, t.Clave, a.TiempoEntrega, a.TiempoEntregaUnidad,
a.TiempoEntregaSeg, a.TiempoEntregaSegUnidad, a.UnidadTraspaso, a.UnidadCompra
SET @DiasVenta += DATEDIFF(day, @HoyMesAnterior, @UltimoDiaMesAnterior)
END 
INSERT #VentaAVGGeneral(
Empresa, Articulo, SubCuenta, Almacen, Cantidad, Factor,
IncrementoPRC, TiempoEntrega, TiempoEntregaUnidad, TiempoEntregaSeg, TiempoEntregaSegUnidad,
UnidadTraspaso, UnidadCompra, DiasInventario)
SELECT a.Empresa, a.Articulo, a.SubCuenta, a.Almacen, SUM(ISNULL(a.Cantidad,0.0) + ISNULL(b.Cantidad,0.0) + ISNULL(c.Cantidad,0.0)), a.Factor,
a.IncrementoPRC, a.TiempoEntrega, a.TiempoEntregaUnidad, a.TiempoEntregaSeg, a.TiempoEntregaSegUnidad,
a.UnidadTraspaso, a.UnidadCompra, a.DiasInventario
FROM #VentaAVGPeriodoA a
LEFT JOIN #VentaAVGPeriodoB b ON b.Empresa = a.Empresa AND b.Articulo = a.Articulo
AND b.SubCuenta = a.SubCuenta AND b.Almacen = a.Almacen
LEFT JOIN #VentaAVGPeriodoC c ON c.Empresa = b.Empresa AND c.Articulo = b.Articulo
AND c.SubCuenta = b.SubCuenta AND c.Almacen = b.Almacen
GROUP BY a.Empresa, a.Articulo, a.SubCuenta, a.Almacen, a.Factor,
a.IncrementoPRC, a.TiempoEntrega, a.TiempoEntregaUnidad, a.TiempoEntregaSeg, a.TiempoEntregaSegUnidad,
a.UnidadTraspaso,a.UnidadCompra, a.DiasInventario
ORDER BY a.Articulo, a.SubCuenta, a.Almacen, a.Empresa DESC
END 
INSERT #ArtAlm (Empresa, Articulo, SubCuenta, Almacen, Maximo, VentaPromedio)
SELECT a.Empresa, a.Articulo, ISNULL(a.SubCuenta,''), a.Almacen,
Maximo = ISNULL(dbo.fnMaximo(a.Cantidad , 0, 0 , a.IncrementoPRC, @DiasVenta, 1, a.TiempoEntrega, a.TiempoEntregaUnidad, a.TiempoEntregaSeg, a.TiempoEntregaSegUnidad, a.DiasInventario),0),
VentaPromedio = (a.Cantidad)/@DiasVenta
FROM #VentaAVGGeneral a
WHERE (a.Cantidad/@DiasVenta) > .5
UPDATE #ArtAlm
SET Maximo = dbo.fnRedondeaMaxMin(Maximo),
Minimo = dbo.fnRedondeaMaxMin(Maximo/2),
VentaPromedio = dbo.fnRedondeaMaxMin(VentaPromedio),
ABC = ISNULL(dbo.fnClasificaABC(dbo.fnRedondeaMaxMin(VentaPromedio)),'')
UPDATE ArtAlm SET Minimo = ISNULL(b.Minimo,0), Maximo = ISNULL(b.Maximo,0), ABC = ISNULL(b.ABC,''), VentaPromedio = ISNULL(b.VentaPromedio,0)
FROM ArtAlm a
JOIN (SELECT Empresa, Almacen, Articulo, SubCuenta, SUM(Minimo)As Minimo, Sum(Maximo) AS Maximo, ABC, VentaPromedio
FROM #ArtAlm GROUP BY Empresa, Almacen, Articulo, SubCuenta, ABC, VentaPromedio) b
ON (a.Empresa = b.Empresa AND A.Almacen = B.Almacen AND a.Articulo = b.Articulo AND ISNULL(a.SubCuenta,'') = ISNULL(b.SubCuenta,''))
INSERT INTO ArtAlm (Empresa, Articulo, SubCuenta, Almacen, Minimo, Maximo, ABC, VentaPromedio)
SELECT a.Empresa, a.Articulo, a.SubCuenta, a.Almacen, a.Minimo, a.Maximo, a.ABC, a.VentaPromedio
FROM #ArtAlm a
LEFT JOIN ArtAlm b ON(a.Empresa = b.Empresa AND a.Articulo = b.Articulo AND ISNULL(a.SubCuenta,'') = ISNULL(b.Subcuenta,'') AND a.Almacen = b.Almacen)
WHERE b.Empresa IS NULL OR b.Articulo IS NULL
END

