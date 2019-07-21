SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInformeVentaTrimestral
@EstacionTrabajo		int

AS BEGIN
DECLARE
@Empresa				char(5),
@Moneda					char(10),
@Periodo				int,
@PeriodoD				int,
@PeriodoA				int,
@Ejercicio				int,
@Opcion					int,
@Folio					int,
@ArtCat					varchar(50),
@ArtGrupo				varchar(50),
@ArtFam					varchar(50),
@Fabricante				varchar(50),
@Verdadero				bit,
@Falso					bit,
@CostoTotal				money,
@ImporteTotal			money,
@Utilidad				money,
@CostoTotalMC			money,
@ImporteTotalMC			money,
@UtilidadMC				money,
@Categoria				varchar(20),
@FechaGrafica			varchar(50),
@Grupo					varchar(50),
@Familia				varchar(50),
@Mes1					float,
@Mes2					float,
@Mes3					float,
@Titulo					varchar(100),
@EmpresaNombre			varchar(100),
@Graficar				int,
@Grafica2				bit,
@Grafica3				bit,
@Grafica4				bit,
@GraficarTipo			varchar(30),
@Etiqueta				bit,
@GraficarCantidad		int,
@VerGraficaDetalle		bit
DECLARE @InformeVentaTrimestral TABLE
(
Estacion			int 	    	NOT	NULL,
IDInforme			int 	    	NOT NULL  IDENTITY(1,1),
Empresa				char(5)				NULL,
Moneda  			char(10)   			NULL,
Articulo			varchar(50)			NULL,
Descripcion1		varchar(100) 		NULL,
Categoria			varchar(50)			NULL,
Grupo				varchar(50)			NULL,
Familia				varchar(50)			NULL,
Fabricante			varchar(50)			NULL,
Mes1				float				NULL,
Cantidad1			float				NULL,
Mes2				float				NULL,
Cantidad2			float				NULL,
Mes3				float				NULL,
Cantidad3			float				NULL,
MonedaCosto			varchar(50)			NULL,
UltimoCosto			float				NULL,
CostoPromedio		float				NULL,
Disponible			float				NULL,
SaldoDescripcion	varchar(50)			NULL,
SaldoImporte		float				NULL DEFAULT 0.0,
Grafica1 			bit					NULL DEFAULT 0,
Grafica2 			bit					NULL DEFAULT 0,
Grafica3 			bit					NULL DEFAULT 0,
Grafica4 			bit					NULL DEFAULT 0,
Reporte				varchar(100)		NULL,
Total				bit					NULL DEFAULT 0,
FechaGrafica		varchar(100)		NULL,
Periodo				varchar(20)			NULL,
Ejercicio			int					NULL,
PeriodoD			varchar(20)			NULL,
Opcion				int					NULL,
PeriodoA			varchar(20)			NULL,
Folio				int					NULL,
Categoria2			varchar(50)			NULL,
Titulo				varchar(100)		NULL,
EmpresaNombre		varchar(100)		NULL,
Etiqueta			bit					NULL  DEFAULT 0
)
SELECT @Verdadero = 1, @Falso = 0
SELECT
@Empresa	 = InfoEmpresa,
@Moneda	 = InfoMoneda,
@Periodo	 = ISNULL(InfoPeriodoD,0),
@Ejercicio = InfoEjercicio,
@ArtCat	 = InfoArtCat,
@ArtGrupo	 = InfoArtGrupo,
@ArtFam	 = InfoArtFam,
@Fabricante= InfoFabricante,
@Titulo = RepTitulo,
@GraficarTipo = ISNULL(InformeGraficarTipo,  '(Todos)'),
@Etiqueta = ISNULL(InfoEtiqueta, @Falso),
@GraficarCantidad = ISNULL(InformeGraficarCantidad, 5),
@VerGraficaDetalle = ISNULL(VerGraficaDetalle,0)
FROM RepParam
WITH(NOLOCK) WHERE Estacion = @EstacionTrabajo
SELECT @EmpresaNombre = (SELECT Nombre FROM Empresa WITH(NOLOCK) WHERE Empresa = @Empresa)
IF @Periodo <=10
SELECT @PeriodoD = @Periodo + 1,
@PeriodoA = @Periodo + 2,
@Opcion	 = @Ejercicio,
@Folio	 = @Ejercicio
IF @Periodo =11
SELECT @PeriodoD = @Periodo + 1,
@PeriodoA = 1,
@Opcion	 = @Ejercicio,
@Folio	 = @Ejercicio + 1
IF @Periodo =12
SELECT @PeriodoD = 1,
@PeriodoA = 2,
@Opcion	 = @Ejercicio + 1,
@Folio	 = @Ejercicio + 1
IF @ArtCat	 IN('(Todas)', '') SELECT @ArtCat	  = NULL
IF @ArtGrupo   IN('(Todas)', '') SELECT @ArtGrupo   = NULL
IF @ArtFam	 IN('(Todas)', '') SELECT @ArtFam	  = NULL
IF @Fabricante IN('(Todas)', '') SELECT @Fabricante = NULL
INSERT INTO @InformeVentaTrimestral (Estacion, Empresa, Moneda, Articulo,Descripcion1, Categoria, Grupo, Familia, Fabricante, Mes1, Cantidad1, Mes2, Cantidad2, Mes3, Cantidad3, MonedaCosto, UltimoCosto, CostoPromedio, Disponible, Periodo, Ejercicio, PeriodoD, Opcion, PeriodoA, Folio)
SELECT Estacion, Empresa, Moneda, Articulo,Descripcion1, Categoria, Grupo, Familia, Fabricante, Mes1, Cantidad1, Mes2, Cantidad2, Mes3, Cantidad3, MonedaCosto, UltimoCosto, CostoPromedio, Disponible, Periodo, Ejercicio, PeriodoD, Opcion, PeriodoA, Folio
FROM
(
SELECT 'Estacion'		= @EstacionTrabajo,
'Empresa'		= aen.Empresa,
'Moneda'		= @Moneda,
a.Articulo,
a.Descripcion1,
'Categoria'	= CASE WHEN RTRIM(LTRIM(a.Categoria)) = '' THEN '(Sin Categor�a)' ELSE ISNULL(a.Categoria, '(Sin Categor�a)') END,
'Grupo'		= CASE WHEN RTRIM(LTRIM(a.Grupo)) = '' THEN '(Sin Grupo)' ELSE ISNULL(a.Grupo, '(Sin Grupo)') END,
'Familia'		= CASE WHEN RTRIM(LTRIM(a.Familia)) = '' THEN '(Sin Familia)' ELSE ISNULL(a.Familia, '(Sin Familia)') END,
'Fabricante'	= CASE WHEN RTRIM(LTRIM(a.Fabricante)) = '' THEN '(Sin Fabricante)' ELSE ISNULL(a.Fabricante, '(Sin Fabricante)') END,
'Mes1'			= (SELECT SUM(ISNULL(v.ImporteNeto,0.00))  FROM VentaArt v Where v.Articulo = a.Articulo AND v.Empresa=@Empresa AND v.Moneda = @Moneda AND v.Periodo = @Periodo  AND v.Ejercicio = @Ejercicio),
'Cantidad1'	= (SELECT SUM(ISNULL(v.CantidadNeta,0.00)) FROM VentaArt v Where v.Articulo = a.Articulo AND v.Empresa=@Empresa AND v.Moneda = @Moneda AND v.Periodo = @Periodo  AND v.Ejercicio = @Ejercicio),
'Mes2'			= (SELECT SUM(ISNULL(v.ImporteNeto,0.00))  FROM VentaArt v Where v.Articulo = a.Articulo AND v.Empresa=@Empresa AND v.Moneda = @Moneda AND v.Periodo = @PeriodoD AND v.Ejercicio = @Opcion),
'Cantidad2'	= (SELECT SUM(ISNULL(v.CantidadNeta,0.00)) FROM VentaArt v Where v.Articulo = a.Articulo AND v.Empresa=@Empresa AND v.Moneda = @Moneda AND v.Periodo = @PeriodoD AND v.Ejercicio = @Opcion),
'Mes3'			= (SELECT SUM(ISNULL(v.ImporteNeto,0.00))  FROM VentaArt v Where v.Articulo = a.Articulo AND v.Empresa=@Empresa AND v.Moneda = @Moneda AND v.Periodo = @PeriodoA AND v.Ejercicio = @Folio),
'Cantidad3'	= (SELECT SUM(ISNULL(v.CantidadNeta,0.00)) FROM VentaArt v Where v.Articulo = a.Articulo AND v.Empresa=@Empresa AND v.Moneda = @Moneda AND v.Periodo = @PeriodoA AND v.Ejercicio = @Folio),
'MonedaCosto'	= ISNULL(a.MonedaCosto,0.00),
'UltimoCosto'	= ISNULL(ac.UltimoCosto,0.00),
'CostoPromedio'= ISNULL(ac.CostoPromedio,0.00),
'Disponible'	= SUM(ISNULL(aen.Disponible,0.00)),
'Periodo'		= dbo.fnMesNumeroNombre(@Periodo),
'Ejercicio'	= @Ejercicio,
'PeriodoD'		= dbo.fnMesNumeroNombre(@PeriodoD),
'Opcion'		= @Opcion,
'PeriodoA'		= dbo.fnMesNumeroNombre(@PeriodoA),
'Folio'		= @Folio
FROM Art a
LEFT OUTER JOIN Artcosto ac  WITH(NOLOCK) ON a.Articulo = ac.Articulo AND ac.Empresa  = @Empresa
LEFT OUTER JOIN ArtDisponible aen  WITH(NOLOCK) ON a.Articulo = aen.Articulo AND aen.Empresa = @Empresa
WHERE ISNULL(a.Categoria,'') = ISNULL(@ArtCat, ISNULL(a.Categoria,''))
AND ISNULL(a.Grupo,'') = ISNULL(@ArtGrupo, ISNULL(a.Grupo,''))
AND ISNULL(a.Familia,'') = ISNULL(@ArtFam, ISNULL(a.Familia,''))
AND ISNULL(a.Fabricante,'') = ISNULL(@Fabricante, ISNULL(a.Fabricante,''))
AND aen.Empresa = @Empresa
GROUP BY a.articulo,
a.MonedaCosto,
a.Descripcion1,
ac.UltimoCosto,
ac.CostoPromedio,
a.Categoria,
a.Grupo,
a.Familia,
a.Fabricante,
aen.Empresa
) AS x
ORDER BY x.Categoria, x.Fabricante, x.Grupo, x.Familia
DECLARE crCategoria CURSOR FAST_FORWARD FOR
SELECT ISNULL(Categoria, '(Sin Categor�a)')
FROM @InformeVentaTrimestral
WHERE Estacion = @EstacionTrabajo
GROUP BY Categoria
OPEN crCategoria
FETCH NEXT FROM crCategoria  INTO @Categoria
WHILE @@FETCH_STATUS = 0 
BEGIN
INSERT INTO @InformeVentaTrimestral(Estacion, Moneda,  Categoria2,  Grafica1,   Grafica2, Grafica3, Grafica4, SaldoDescripcion,						SaldoImporte,           FechaGrafica)
SELECT       			   @EstacionTrabajo, @Moneda, @Categoria, @Verdadero, @Falso,   @Falso,   @Falso,   ISNULL(Fabricante, '(Sin Fabricante)'), SUM(ISNULL(Mes1,0.00)), dbo.fnMesNumeroNombre(@Periodo) + ' ' + CONVERT(varchar,@Ejercicio)
FROM @InformeVentaTrimestral
WHERE Categoria  = @Categoria
GROUP BY Fabricante
ORDER BY SUM(ISNULL(Mes1,0.00))
INSERT INTO @InformeVentaTrimestral(Estacion, Moneda,  Categoria2,  Grafica1,   Grafica2, Grafica3, Grafica4, SaldoDescripcion,						SaldoImporte,           FechaGrafica)
SELECT       			   @EstacionTrabajo, @Moneda, @Categoria, @Verdadero, @Falso,   @Falso,   @Falso,   ISNULL(Fabricante, '(Sin Fabricante)'), SUM(ISNULL(Mes2,0.00)), dbo.fnMesNumeroNombre(@PeriodoD) + ' ' + CONVERT(varchar,@Opcion)
FROM @InformeVentaTrimestral
WHERE Categoria  = @Categoria
GROUP BY Fabricante
ORDER BY SUM(ISNULL(Mes2,0.00))
INSERT INTO @InformeVentaTrimestral(Estacion, Moneda,  Categoria2,  Grafica1,   Grafica2, Grafica3, Grafica4, SaldoDescripcion,						SaldoImporte,           FechaGrafica)
SELECT       			   @EstacionTrabajo, @Moneda, @Categoria, @Verdadero, @Falso,   @Falso,   @Falso,   ISNULL(Fabricante, '(Sin Fabricante)'), SUM(ISNULL(Mes3,0.00)), dbo.fnMesNumeroNombre(@PeriodoA) + ' ' + CONVERT(varchar,@Folio)
FROM @InformeVentaTrimestral
WHERE Categoria  = @Categoria
GROUP BY Fabricante
ORDER BY SUM(ISNULL(Mes3,0.00))
INSERT INTO @InformeVentaTrimestral(Estacion, Moneda,  Categoria2,  Grafica1,   Grafica2,   Grafica3, Grafica4, SaldoDescripcion,				SaldoImporte,          FechaGrafica)
SELECT       			   @EstacionTrabajo, @Moneda, @Categoria, @Verdadero, @Verdadero, @Falso,   @Falso,   ISNULL(Grupo, '(Sin Grupo)'), SUM(ISNULL(Mes1,0.00)), dbo.fnMesNumeroNombre(@Periodo) + ' ' + CONVERT(varchar,@Ejercicio)
FROM @InformeVentaTrimestral
WHERE Categoria  = @Categoria
GROUP BY Grupo
ORDER BY SUM(ISNULL(Mes1,0.00))
INSERT INTO @InformeVentaTrimestral(Estacion, Moneda,  Categoria2,  Grafica1,   Grafica2,   Grafica3, Grafica4, SaldoDescripcion,				SaldoImporte,           FechaGrafica)
SELECT       			   @EstacionTrabajo, @Moneda, @Categoria, @Verdadero, @Verdadero, @Falso,   @Falso,   ISNULL(Grupo, '(Sin Grupo)'), SUM(ISNULL(Mes2,0.00)), dbo.fnMesNumeroNombre(@PeriodoD) + ' ' + CONVERT(varchar,@Opcion)
FROM @InformeVentaTrimestral
WHERE Categoria  = @Categoria
GROUP BY Grupo
ORDER BY SUM(ISNULL(Mes2,0.00))
INSERT INTO @InformeVentaTrimestral(Estacion, Moneda,  Categoria2,  Grafica1,   Grafica2,   Grafica3, Grafica4, SaldoDescripcion,				SaldoImporte,           FechaGrafica)
SELECT       			   @EstacionTrabajo, @Moneda, @Categoria, @Verdadero, @Verdadero, @Falso,   @Falso,   ISNULL(Grupo, '(Sin Grupo)'), SUM(ISNULL(Mes3,0.00)), dbo.fnMesNumeroNombre(@PeriodoA) + ' ' + CONVERT(varchar,@Folio)
FROM @InformeVentaTrimestral
WHERE Categoria  = @Categoria
GROUP BY Grupo
ORDER BY SUM(ISNULL(Mes3,0.00))
INSERT INTO @InformeVentaTrimestral(Estacion, Moneda,  Categoria2,  Grafica1,   Grafica2,   Grafica3,   Grafica4, SaldoDescripcion,				  SaldoImporte,           FechaGrafica)
SELECT       			   @EstacionTrabajo, @Moneda, @Categoria, @Verdadero, @Verdadero, @Verdadero, @Falso,   ISNULL(Familia, '(Sin Familia)'), SUM(ISNULL(Mes1,0.00)), dbo.fnMesNumeroNombre(@Periodo) + ' ' + CONVERT(varchar,@Ejercicio)
FROM @InformeVentaTrimestral
WHERE Categoria  = @Categoria
GROUP BY Familia
ORDER BY SUM(ISNULL(Mes1,0.00))
INSERT INTO @InformeVentaTrimestral(Estacion, Moneda,  Categoria2,  Grafica1,   Grafica2,   Grafica3,   Grafica4, SaldoDescripcion,				  SaldoImporte,           FechaGrafica)
SELECT       			   @EstacionTrabajo, @Moneda, @Categoria, @Verdadero, @Verdadero, @Verdadero, @Falso,   ISNULL(Familia, '(Sin Familia)'), SUM(ISNULL(Mes2,0.00)), dbo.fnMesNumeroNombre(@PeriodoD) + ' ' + CONVERT(varchar,@Opcion)
FROM @InformeVentaTrimestral
WHERE Categoria  = @Categoria
GROUP BY Familia
ORDER BY SUM(ISNULL(Mes2,0.00))
INSERT INTO @InformeVentaTrimestral(Estacion, Moneda,  Categoria2,  Grafica1,   Grafica2,   Grafica3,   Grafica4, SaldoDescripcion,				  SaldoImporte,           FechaGrafica)
SELECT       			   @EstacionTrabajo, @Moneda, @Categoria, @Verdadero, @Verdadero, @Verdadero, @Falso,   ISNULL(Familia, '(Sin Familia)'), SUM(ISNULL(Mes3,0.00)), dbo.fnMesNumeroNombre(@PeriodoA) + ' ' + CONVERT(varchar,@Folio)
FROM @InformeVentaTrimestral
WHERE Categoria  = @Categoria
GROUP BY Familia
ORDER BY SUM(ISNULL(Mes3,0.00))
INSERT INTO @InformeVentaTrimestral(Estacion, Moneda,  Categoria2,  Grafica1,   Grafica2,   Grafica3,   Grafica4,  SaldoDescripcion,				  SaldoImporte,           FechaGrafica)
SELECT       			   @EstacionTrabajo, @Moneda, @Categoria, @Verdadero, @Verdadero, @Verdadero, @Verdadero, ISNULL(Categoria, '(Sin Categoria)'), SUM(ISNULL(Mes1,0.00)), dbo.fnMesNumeroNombre(@Periodo) + ' ' + CONVERT(varchar,@Ejercicio)
FROM @InformeVentaTrimestral
WHERE Categoria  = @Categoria
GROUP BY Categoria
ORDER BY SUM(ISNULL(Mes1,0.00))
INSERT INTO @InformeVentaTrimestral(Estacion, Moneda,  Categoria2,  Grafica1,   Grafica2,   Grafica3,   Grafica4,  SaldoDescripcion,				  SaldoImporte,           FechaGrafica)
SELECT       			   @EstacionTrabajo, @Moneda, @Categoria, @Verdadero, @Verdadero, @Verdadero, @Verdadero, ISNULL(Categoria, '(Sin Categoria)'), SUM(ISNULL(Mes2,0.00)), dbo.fnMesNumeroNombre(@PeriodoD) + ' ' + CONVERT(varchar,@Opcion)
FROM @InformeVentaTrimestral
WHERE Categoria  = @Categoria
GROUP BY Categoria
ORDER BY SUM(ISNULL(Mes2,0.00))
INSERT INTO @InformeVentaTrimestral(Estacion, Moneda,  Categoria2,  Grafica1,   Grafica2,   Grafica3,   Grafica4,  SaldoDescripcion,				  SaldoImporte,           FechaGrafica)
SELECT       			   @EstacionTrabajo, @Moneda, @Categoria, @Verdadero, @Verdadero, @Verdadero, @Verdadero, ISNULL(Categoria, '(Sin Categoria)'), SUM(ISNULL(Mes3,0.00)), dbo.fnMesNumeroNombre(@PeriodoA) + ' ' + CONVERT(varchar,@Folio)
FROM @InformeVentaTrimestral
WHERE Categoria  = @Categoria
GROUP BY Categoria
ORDER BY SUM(ISNULL(Mes3,0.00))
FETCH NEXT FROM crCategoria  INTO @Categoria
END
CLOSE crCategoria
DEALLOCATE crCategoria
DECLARE crGraficar CURSOR FAST_FORWARD FOR
SELECT Moneda, Categoria2, Grafica2, Grafica3
FROM @InformeVentaTrimestral
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 1
GROUP BY Moneda, Categoria2, Grafica2, Grafica3
OPEN crGraficar
FETCH NEXT FROM crGraficar  INTO @Moneda, @Categoria, @Grafica2, @Grafica3
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Graficar = NULL
SELECT @Graficar = ISNULL(COUNT(DISTINCT SaldoDescripcion),0)
FROM @InformeVentaTrimestral
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = @Grafica2
AND Grafica3 = @Grafica3
AND @Moneda = Moneda
AND Categoria2 = @Categoria
IF @GraficarTipo = 'Mas Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @InformeVentaTrimestral
WHERE SaldoDescripcion NOT IN(
SELECT  TOP (@GraficarCantidad) SaldoDescripcion
FROM
(
SELECT
'SaldoDescripcion'  = SaldoDescripcion,
'SaldoImporte'      = SUM(SaldoImporte)
FROM @InformeVentaTrimestral
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = @Grafica2
AND Grafica3 = @Grafica3
AND Grafica4 = 0
AND @Moneda = Moneda
AND Categoria2 = @Categoria
GROUP BY Moneda,  SaldoDescripcion
) AS x
GROUP BY x.SaldoDescripcion
ORDER BY SUM(ISNULL(x.SaldoImporte,0.00))DESC)
AND Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = @Grafica2
AND Grafica3 = @Grafica3
AND Grafica4 = 0
AND @Moneda = Moneda
AND Categoria2 = @Categoria
IF @GraficarTipo = 'Menos Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @InformeVentaTrimestral
WHERE SaldoDescripcion NOT IN(
SELECT  TOP (@GraficarCantidad) SaldoDescripcion
FROM
(
SELECT
'SaldoDescripcion'  = SaldoDescripcion,
'SaldoImporte'      = SUM(SaldoImporte)
FROM @InformeVentaTrimestral
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = @Grafica2
AND Grafica3 = @Grafica3
AND Grafica4 = 0
AND @Moneda = Moneda
AND Categoria2 = @Categoria
GROUP BY Moneda,  SaldoDescripcion
) AS x
GROUP BY x.SaldoDescripcion
ORDER BY SUM(ISNULL(x.SaldoImporte,0.00))ASC)
AND Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = @Grafica2
AND Grafica3 = @Grafica3
AND Grafica4 = 0
AND @Moneda = Moneda
AND Categoria2 = @Categoria
FETCH NEXT FROM crGraficar  INTO @Moneda, @Categoria, @Grafica2, @Grafica3
END
CLOSE crGraficar
DEALLOCATE crGraficar
SELECT @Graficar = NULL
SELECT @Graficar = ISNULL(COUNT(DISTINCT SaldoDescripcion),0)
FROM @InformeVentaTrimestral
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = 1
AND Grafica3 = 1
AND Grafica4 = 1
IF @GraficarTipo = 'Mas Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @InformeVentaTrimestral
WHERE SaldoDescripcion NOT IN(
SELECT  TOP (@GraficarCantidad) SaldoDescripcion
FROM
(
SELECT
'SaldoDescripcion'  = SaldoDescripcion,
'SaldoImporte'      = SUM(SaldoImporte)
FROM @InformeVentaTrimestral
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = 1
AND Grafica3 = 1
AND Grafica4 = 1
GROUP BY SaldoDescripcion
) AS x
GROUP BY x.SaldoDescripcion
ORDER BY SUM(ISNULL(x.SaldoImporte,0.00))DESC)
AND Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = 1
AND Grafica3 = 1
AND Grafica4 = 1
IF @GraficarTipo = 'Menos Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @InformeVentaTrimestral
WHERE SaldoDescripcion NOT IN(
SELECT  TOP (@GraficarCantidad) SaldoDescripcion
FROM
(
SELECT
'SaldoDescripcion'  = SaldoDescripcion,
'SaldoImporte'      = SUM(SaldoImporte)
FROM @InformeVentaTrimestral
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = 1
AND Grafica3 = 1
AND Grafica4 = 1
GROUP BY SaldoDescripcion
) AS x
GROUP BY x.SaldoDescripcion
ORDER BY SUM(ISNULL(x.SaldoImporte,0.00))ASC)
AND Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = 1
AND Grafica3 = 1
AND Grafica4 = 1
UPDATE @InformeVentaTrimestral SET Titulo = @Titulo, EmpresaNombre = @EmpresaNombre, Etiqueta = @Etiqueta WHERE Estacion = @EstacionTrabajo
SELECT * , @VerGraficaDetalle as VerGraficaDetalle FROM @InformeVentaTrimestral WHERE Estacion = @EstacionTrabajo ORDER BY IDInforme
END

