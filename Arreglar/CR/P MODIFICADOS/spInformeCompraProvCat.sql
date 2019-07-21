SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInformeCompraProvCat
@EstacionTrabajo		int

AS BEGIN
DECLARE
@FechaD					datetime,
@FechaA					datetime,
@Reporte				varchar(30),
@Empresa				char(5),
@Verdadero				bit,
@Falso					bit,
@Clave1					varchar(20),
@Clave2					varchar(20),
@Clave3					varchar(20),
@Clave4					varchar(20),
@Clave5					varchar(20),
@Clave6					varchar(20),
@Moneda					varchar(20),
@ImporteTotal			money,
@ImporteTotalMC			money,
@Categoria				varchar(20),
@FechaGrafica			varchar(50),
@Periodo				int,
@Ejercicio				int,
@Titulo					varchar(100),
@EmpresaNombre			varchar(100),
@Graficar				int,
@Grafica2				bit,
@GraficarFecha			int,
@GraficarTipo			varchar(30),
@Etiqueta				bit,
@GraficarCantidad		int,
@VerGraficaDetalle		bit
DECLARE @InformeCompraProvCat TABLE
(
Estacion			int 	    	NOT	NULL,
IDInforme			int 	    	NOT NULL  IDENTITY(1,1),
Empresa				char(5)				NULL,
Moneda  			char(10)   			NULL,
Moneda2  			char(10)   			NULL,
Categoria  			varchar(50) 		NULL,
Importe				money				NULL,
DescuentosTotales	money				NULL,
SubTotal			money				NULL,
Impuestos			money				NULL,
ImporteTotal		money				NULL,
ImporteTotalMC		money				NULL,
SaldoDescripcion	varchar(50)			NULL,
SaldoImporte		money				NULL DEFAULT 0.0,
SaldoDescripcionMC	varchar(50)			NULL,
SaldoImporteMC		money				NULL DEFAULT 0.0,
Grafica1 			bit					NULL DEFAULT 0,
Grafica2 			bit					NULL DEFAULT 0,
Reporte				varchar(100)		NULL,
Total				bit					NULL DEFAULT 0,
ContMoneda			char(10)			NULL,
FechaGrafica		varchar(100)		NULL,
FechaDesde			datetime			NULL,
FechaHasta			datetime			NULL,
Titulo				varchar(100)		NULL,
EmpresaNombre		varchar(100)		NULL,
Periodo				int					NULL,
Ejercicio			int					NULL,
Etiqueta			bit					NULL  DEFAULT 0
)
SELECT @Verdadero = 1, @Falso = 0
SELECT
@FechaD  = InfoFechaD,
@FechaA  = InfoFechaA,
@Reporte = InfoRepCompras,
@Empresa = InfoEmpresa,
@Titulo = RepTitulo,
@GraficarFecha = ISNULL(InformeGraficarFecha,12),
@GraficarTipo = ISNULL(InformeGraficarTipo,  '(Todos)'),
@Etiqueta = ISNULL(InfoEtiqueta, @Falso),
@GraficarCantidad = ISNULL(InformeGraficarCantidad, 5),
@VerGraficaDetalle = ISNULL(VerGraficaDetalle,0)
FROM RepParam
WITH(NOLOCK) WHERE Estacion = @EstacionTrabajo
SELECT @EmpresaNombre = (SELECT Nombre FROM Empresa WITH(NOLOCK) WHERE Empresa = @Empresa)
IF @Reporte IN ('Entradas')
SELECT
@Clave1 = 'COMS.F',
@Clave2 = 'COMS.FL',
@Clave3 = 'COMS.EG',
@Clave4 = 'COMS.EI',
@Clave5 = 'COMS.F',
@Clave6 = 'COMS.FL'
IF @Reporte IN ('Devoluciones')
SELECT
@Clave1 = 'COMS.D',
@Clave2 = 'COMS.B',
@Clave3 = 'COMS.D',
@Clave4 = 'COMS.B',
@Clave5 = 'COMS.D',
@Clave6 = 'COMS.B'
IF @Reporte IN ('Entradas y Devoluciones')
SELECT
@Clave1 = 'COMS.F',
@Clave2 = 'COMS.FL',
@Clave3 = 'COMS.EG',
@Clave4 = 'COMS.EI',
@Clave5 = 'COMS.D',
@Clave6 = 'COMS.B'
INSERT INTO @InformeCompraProvCat (Estacion, Empresa, Moneda, Categoria, Importe, DescuentosTotales, SubTotal, Impuestos, ImporteTotal, ImporteTotalMC, ContMoneda)
SELECT Estacion, Empresa, Moneda, Categoria, SUM(ISNULL(Importe,0.00)) as Importe, SUM(ISNULL(DescuentosTotales,0.00)) as DescuentosTotales, SUM(ISNULL(SubTotal,0.00)) as SubTotal, SUM(ISNULL(Impuestos,0.00)) as Impuestos, SUM(ISNULL(ImporteTotal,0.00)) as ImporteTotal, SUM(ISNULL(ImporteTotalMC,0.00)) as ImporteTotalMC, ContMoneda
FROM
(
SELECT
'Estacion'			= @EstacionTrabajo,
'Empresa'           = c.Empresa,
'Moneda'            = c.Moneda,
'Categoria'         = CASE WHEN ISNULL(p.Categoria,'(Sin Categor�a)') = '' THEN '(Sin Categor�a)' ELSE ISNULL(p.Categoria,'(Sin Categor�a)') END,
'Importe'           = SUM(c.Importe*mt.Factor),
'DescuentosTotales' = SUM(c.DescuentosTotales*mt.Factor),
'SubTotal'          = SUM(c.SubTotal*mt.Factor),
'Impuestos'         = SUM(c.Impuestos*mt.Factor),
'ImporteTotal'      = SUM(c.ImporteTotal*mt.Factor),
'ImporteTotalMC'    = (SUM(c.ImporteTotal*mt.Factor)) * dbo.fnTipoCambio(c.Moneda),
'ContMoneda'		= e.ContMoneda
FROM CompraCalc c
 WITH(NOLOCK) JOIN Prov p  WITH(NOLOCK) ON p.Proveedor = c.Proveedor
JOIN MovTipo mt  WITH(NOLOCK) ON c.Mov = mt.Mov AND mt.Modulo = 'COMS'
JOIN EmpresaCfg e  WITH(NOLOCK) ON e.Empresa = c.Empresa
WHERE c.Estatus = 'CONCLUIDO'
AND c.Empresa = @Empresa
AND c.FechaEmision BETWEEN @FechaD AND @FechaA
AND mt.Clave in(@Clave1, @Clave2, @Clave3, @Clave4, @Clave5, @Clave6)
GROUP BY c.Moneda, ISNULL(p.Categoria,'(Sin Categor�a)'), dbo.fnTipoCambio(c.Moneda), e.ContMoneda, c.Empresa
) AS x
GROUP BY Moneda, Categoria, Estacion, Empresa, ContMoneda
INSERT INTO @InformeCompraProvCat(Estacion, Moneda2, Categoria, Grafica1,   Grafica2, SaldoDescripcion,  SaldoImporte,		              Reporte,  FechaGrafica, Ejercicio, Periodo)
SELECT                           Estacion, Moneda2, Categoria, @Verdadero, @Falso,   Categoria,         SUM(ISNULL(ImporteTotal,0.00)), @Reporte, Fecha, Ejercicio, Periodo
FROM
(
SELECT
'Estacion'			= @EstacionTrabajo,
'Moneda2'           = c.Moneda,
'Categoria'         = CASE WHEN ISNULL(p.Categoria,'') = '' THEN '(Sin Categor�a)' ELSE p.Categoria END,
'ImporteTotal'      = SUM(c.ImporteTotal*mt.Factor),
'Fecha'				= dbo.fnMesNumeroNombre(DATEPART(MONTH,c.FechaEmision)) + ' ' + CONVERT(varchar,DATEPART(YEAR,c.FechaEmision)),
'Ejercicio'			= DATEPART(YEAR,c.FechaEmision),
'Periodo'			= DATEPART(MONTH,c.FechaEmision)
FROM CompraCalc c
 WITH(NOLOCK) JOIN Prov p  WITH(NOLOCK) ON p.Proveedor = c.Proveedor
JOIN MovTipo mt  WITH(NOLOCK) ON c.Mov = mt.Mov AND mt.Modulo = 'COMS'
JOIN EmpresaCfg e  WITH(NOLOCK) ON e.Empresa = c.Empresa
WHERE c.Estatus = 'CONCLUIDO'
AND c.Empresa = @Empresa
AND c.FechaEmision BETWEEN @FechaD AND @FechaA
AND mt.Clave in(@Clave1, @Clave2, @Clave3, @Clave4, @Clave5, @Clave6)
GROUP BY c.Moneda,  p.Categoria, DATEPART(YEAR,c.FechaEmision), DATEPART(MONTH,c.FechaEmision), c.Empresa, dbo.fnTipoCambio(c.Moneda), e.ContMoneda, dbo.fnMesNumeroNombre(DATEPART(MONTH,c.FechaEmision)) + ' ' + CONVERT(varchar,DATEPART(YEAR,c.FechaEmision))
) AS x
GROUP BY x.Estacion, x.Moneda2, x.Categoria, x.Ejercicio, x.Periodo, x.Fecha
ORDER BY x.Estacion, x.Moneda2, x.Categoria, x.Ejercicio, x.Periodo, x.Fecha
INSERT INTO @InformeCompraProvCat(Estacion, ContMoneda, Moneda2, Categoria, Grafica1,   Grafica2,   SaldoDescripcionMC,  SaldoImporteMC,		          Reporte,  FechaGrafica, Ejercicio, Periodo)
SELECT                           Estacion, ContMoneda, Moneda2, Categoria, @Verdadero, @Verdadero, Categoria,         SUM(ISNULL(ImporteTotalMC,0.00)), @Reporte, Fecha, Ejercicio, Periodo
FROM
(
SELECT
'Estacion'			= @EstacionTrabajo,
'ContMoneda'		= e.ContMoneda,
'Moneda2'           = e.ContMoneda,
'Categoria'         = CASE WHEN ISNULL(p.Categoria,'') = '' THEN '(Sin Categor�a)' ELSE p.Categoria END,
'ImporteTotalMC'    = (SUM(c.ImporteTotal*mt.Factor)) * dbo.fnTipoCambio(c.Moneda),
'Fecha'				= dbo.fnMesNumeroNombre(DATEPART(MONTH,c.FechaEmision)) + ' ' + CONVERT(varchar,DATEPART(YEAR,c.FechaEmision)),
'Ejercicio'			= DATEPART(YEAR,c.FechaEmision),
'Periodo'			= DATEPART(MONTH,c.FechaEmision)
FROM CompraCalc c
 WITH(NOLOCK) JOIN Prov p  WITH(NOLOCK) ON p.Proveedor = c.Proveedor
JOIN MovTipo mt  WITH(NOLOCK) ON c.Mov = mt.Mov AND mt.Modulo = 'COMS'
JOIN EmpresaCfg e  WITH(NOLOCK) ON e.Empresa = c.Empresa
WHERE c.Estatus = 'CONCLUIDO'
AND c.Empresa = @Empresa
AND c.FechaEmision BETWEEN @FechaD AND @FechaA
AND mt.Clave in(@Clave1, @Clave2, @Clave3, @Clave4, @Clave5, @Clave6)
GROUP BY c.Moneda,  p.Categoria, DATEPART(YEAR,c.FechaEmision), DATEPART(MONTH,c.FechaEmision), c.Empresa, dbo.fnTipoCambio(c.Moneda), e.ContMoneda, dbo.fnMesNumeroNombre(DATEPART(MONTH,c.FechaEmision)) + ' ' + CONVERT(varchar,DATEPART(YEAR,c.FechaEmision))
) AS x
GROUP BY x.Estacion, x.Moneda2, x.Categoria, x.Ejercicio, x.Periodo, x.Fecha, x.ContMoneda
ORDER BY x.Estacion, x.Moneda2, x.Categoria, x.Ejercicio, x.Periodo, x.Fecha, x.ContMoneda
DECLARE crGraficar CURSOR FAST_FORWARD FOR
SELECT Moneda2, Grafica2
FROM @InformeCompraProvCat
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 1
GROUP BY Moneda2, Grafica2
OPEN crGraficar
FETCH NEXT FROM crGraficar  INTO @Moneda, @Grafica2
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Graficar = NULL
SELECT @Graficar = COUNT(DISTINCT FechaGrafica)
FROM @InformeCompraProvCat
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = @Grafica2
AND Moneda2 = @Moneda
IF @Graficar > @GraficarFecha
DELETE @InformeCompraProvCat
WHERE FechaGrafica IN(
SELECT TOP (@Graficar - @GraficarFecha) FechaGrafica
FROM @InformeCompraProvCat
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = @Grafica2
AND Moneda2 = @Moneda
GROUP BY Ejercicio, Periodo, FechaGrafica
ORDER BY Ejercicio DESC, Periodo DESC, FechaGrafica DESC)
AND Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = @Grafica2
AND Moneda2 = @Moneda
SELECT @Graficar = NULL
SELECT @Graficar = ISNULL(COUNT(DISTINCT Categoria),0)
FROM @InformeCompraProvCat
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 0
AND @Moneda = CASE WHEN @Grafica2 = 0 THEN Moneda ELSE ContMoneda END
IF @GraficarTipo = 'Mas Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @InformeCompraProvCat
WHERE Categoria NOT IN(
SELECT  TOP (@GraficarCantidad) Categoria
FROM
(
SELECT
'Categoria'         = Categoria,
'SaldoImporte'      = SUM(SaldoImporte)+ SUM(SaldoImporteMC)
FROM @InformeCompraProvCat
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = @Grafica2
AND Moneda2 = @Moneda
GROUP BY Moneda,  Categoria
) AS x
GROUP BY x.Categoria
ORDER BY SUM(ISNULL(x.SaldoImporte,0.00))DESC)
AND Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = @Grafica2
AND @Moneda = CASE WHEN @Grafica2 = 0 THEN Moneda2 ELSE ContMoneda END
IF @GraficarTipo = 'Menos Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @InformeCompraProvCat
WHERE Categoria NOT IN(
SELECT  TOP (@GraficarCantidad) Categoria
FROM
(
SELECT
'Categoria'         = Categoria,
'SaldoImporte'      = SUM(SaldoImporte)+ SUM(SaldoImporteMC)
FROM @InformeCompraProvCat
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = @Grafica2
AND @Moneda = CASE WHEN @Grafica2 = 0 THEN Moneda2 ELSE ContMoneda END
GROUP BY Moneda,  Categoria
) AS x
GROUP BY x.Categoria
ORDER BY SUM(ISNULL(x.SaldoImporte,0.00))ASC)
AND Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = @Grafica2
AND Moneda2 = @Moneda
FETCH NEXT FROM crGraficar  INTO @Moneda, @Grafica2
END
CLOSE crGraficar
DEALLOCATE crGraficar
UPDATE @InformeCompraProvCat SET FechaDesde = @FechaD, FechaHasta = @FechaA, Titulo = @Titulo, EmpresaNombre = @EmpresaNombre, Etiqueta = @Etiqueta, Reporte = @Reporte WHERE Estacion = @EstacionTrabajo
SELECT * , @VerGraficaDetalle as VerGraficaDetalle FROM @InformeCompraProvCat WHERE Estacion = @EstacionTrabajo ORDER BY IDInforme
END

