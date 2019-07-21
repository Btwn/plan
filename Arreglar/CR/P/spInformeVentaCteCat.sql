SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInformeVentaCteCat
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
@Clave7					varchar(20),
@Clave8					varchar(20),
@Moneda					varchar(20),
@CostoTotal				money,
@ImporteTotal			money,
@Utilidad				money,
@CostoTotalMC			money,
@ImporteTotalMC			money,
@UtilidadMC				money,
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
DECLARE @InformeVentaCteCat TABLE
(
Estacion			int 	    	NOT	NULL,
IDInforme			int 	    	NOT NULL  IDENTITY(1,1),
Empresa				char(5)				NULL,
Moneda  			char(10)   			NULL,
Moneda2  			char(10)   			NULL,
Categoria  			varchar(50) 		NULL,
CostoTotal			money				NULL,
PrecioTotal			money				NULL,
Importe				money				NULL,
DescuentosTotales	money				NULL,
SubTotal			money				NULL,
Impuestos			money				NULL,
ImporteTotal		money				NULL,
Utilidad			money				NULL,
CostoTotalMC		money				NULL,
ImporteTotalMC		money				NULL,
UtilidadMC			money				NULL,
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
@Reporte = InfoRepVentas,
@Empresa = InfoEmpresa,
@Titulo = RepTitulo,
@GraficarFecha = ISNULL(InformeGraficarFecha,12),
@GraficarTipo = ISNULL(InformeGraficarTipo,  '(Todos)'),
@Etiqueta = ISNULL(InfoEtiqueta, @Falso),
@GraficarCantidad = ISNULL(InformeGraficarCantidad, 5),
@VerGraficaDetalle = ISNULL(VerGraficaDetalle,0)
FROM RepParam
WHERE Estacion = @EstacionTrabajo
SELECT @EmpresaNombre = (SELECT Nombre FROM Empresa WHERE Empresa = @Empresa)
IF @Reporte IN ('Ventas')
SELECT
@Clave1 = 'VTAS.F',
@Clave2 = 'VTAS.FAR',
@Clave3 = 'VTAS.FB',
@Clave4 = 'VTAS.FM',
@Clave5 = 'VTAS.F',
@Clave6 = 'VTAS.FAR',
@Clave7 = 'VTAS.FB'
IF @Reporte IN ('Devoluciones')
SELECT
@Clave1 = 'VTAS.D',
@Clave2 = 'VTAS.DF',
@Clave3 = 'VTAS.B',
@Clave4 = 'VTAS.D',
@Clave5 = 'VTAS.DF',
@Clave6 = 'VTAS.B',
@Clave7 = 'VTAS.D'
IF @Reporte IN ('Ventas y Devoluciones')
SELECT
@Clave1 = 'VTAS.F',
@Clave2 = 'VTAS.FAR',
@Clave3 = 'VTAS.FB',
@Clave4 = 'VTAS.FM',
@Clave5 = 'VTAS.D',
@Clave6 = 'VTAS.DF',
@Clave7 = 'VTAS.B'
INSERT INTO @InformeVentaCteCat(Estacion, Empresa, Moneda, Categoria, CostoTotal, PrecioTotal, Importe, DescuentosTotales, SubTotal, Impuestos, ImporteTotal, Utilidad, CostoTotalMC, ImporteTotalMC, UtilidadMC, ContMoneda)
SELECT Estacion, Empresa, Moneda, Categoria, SUM(ISNULL(CostoTotal,0.00)) as CostoTotal, SUM(ISNULL(PrecioTotal,0.00)) as PrecioTotal, SUM(ISNULL(Importe,0.00)) as Importe, SUM(ISNULL(DescuentosTotales,0.00)) as DescuentosTotales, SUM(ISNULL(SubTotal,0.00)) as SubTotal, SUM(ISNULL(Impuestos,0.00)) as Impuestos, SUM(ISNULL(ImporteTotal,0.00)) as ImporteTotal, SUM(ISNULL(Utilidad,0.00)) as Utilidad, SUM(ISNULL(CostoTotalMC,0.00)) as CostoTotalMC, SUM(ISNULL(ImporteTotalMC,0.00)) as ImporteTotalMC, SUM(ISNULL(UtilidadMC,0.00)) as UtilidadMC, ContMoneda
FROM
(
SELECT
'Estacion'			= @EstacionTrabajo,
'Empresa'           = v.Empresa,
'Moneda'            = v.Moneda,
'Categoria'         = CASE WHEN ISNULL(c.Categoria,'(Sin Categoría)') = '' THEN '(Sin Categoría)' ELSE ISNULL(c.Categoria,'(Sin Categoría)') END,
'CostoTotal'        = SUM(v.CostoTotal*mt.Factor),
'PrecioTotal'       = SUM(v.PrecioTotal*mt.Factor),
'Importe'           = SUM(v.Importe*mt.Factor),
'DescuentosTotales' = SUM(v.DescuentosTotales*mt.Factor),
'SubTotal'          = SUM(v.SubTotal*mt.Factor),
'Impuestos'         = SUM(v.Impuestos*mt.Factor),
'ImporteTotal'      = SUM(v.ImporteTotal*mt.Factor),
'Utilidad'		    = SUM(v.SubTotal*mt.Factor) - SUM(v.CostoTotal*mt.Factor),
'CostoTotalMC'      = (SUM(v.CostoTotal*mt.Factor)) * dbo.fnTipoCambio(v.Moneda),
'ImporteTotalMC'    = (SUM(v.ImporteTotal*mt.Factor)) * dbo.fnTipoCambio(v.Moneda),
'UtilidadMC'		= (SUM(v.SubTotal*mt.Factor) - SUM(v.CostoTotal*mt.Factor)) * dbo.fnTipoCambio(v.Moneda),
'ContMoneda'		= e.ContMoneda
FROM VentaCalc v
JOIN Cte c ON v.Cliente = c.Cliente
JOIN MovTipo mt ON v.Mov = mt.Mov AND mt.Modulo = 'VTAS'
JOIN EmpresaCfg e ON e.Empresa = v.Empresa
WHERE v.Estatus = 'CONCLUIDO'
AND v.Empresa = @Empresa
AND v.FechaEmision BETWEEN @FechaD AND @FechaA
AND mt.Clave in(@Clave1, @Clave2, @Clave3, @Clave4, @Clave5, @Clave6, @Clave7)
GROUP BY v.Moneda, ISNULL(c.Categoria,'(Sin Categoría)'), dbo.fnTipoCambio(v.Moneda), e.ContMoneda, v.Empresa
) AS x
GROUP BY Moneda, Categoria, Estacion, Empresa, ContMoneda
INSERT INTO @InformeVentaCteCat  (Estacion, Moneda2, Categoria, Grafica1,   Grafica2, SaldoDescripcion,  SaldoImporte,		              Reporte,  FechaGrafica, Ejercicio, Periodo)
SELECT                           Estacion, Moneda2, Categoria, @Verdadero, @Falso,   Categoria,         SUM(ISNULL(ImporteTotal,0.00)), @Reporte, Fecha, Ejercicio, Periodo
FROM
(
SELECT
'Estacion'			= @EstacionTrabajo,
'Moneda2'           = v.Moneda,
'Categoria'         = CASE WHEN ISNULL(c.Categoria,'') = '' THEN '(Sin Categoría)' ELSE c.Categoria END,
'ImporteTotal'      = SUM(v.ImporteTotal*mt.Factor),
'Fecha'				= dbo.fnMesNumeroNombre(DATEPART(MONTH,v.FechaEmision)) + ' ' + CONVERT(varchar,DATEPART(YEAR,v.FechaEmision)),
'Ejercicio'			= DATEPART(YEAR,v.FechaEmision),
'Periodo'			= DATEPART(MONTH,v.FechaEmision)
FROM VentaCalc v
JOIN Cte c ON v.Cliente = c.Cliente
JOIN MovTipo mt ON v.Mov = mt.Mov AND mt.Modulo = 'VTAS'
JOIN EmpresaCfg e ON e.Empresa = v.Empresa
WHERE v.Estatus = 'CONCLUIDO'
AND v.Empresa = @Empresa
AND v.FechaEmision BETWEEN @FechaD AND @FechaA
AND mt.Clave in(@Clave1, @Clave2, @Clave3, @Clave4, @Clave5, @Clave6, @Clave7)
GROUP BY v.Moneda,  c.Categoria, DATEPART(YEAR,v.FechaEmision), DATEPART(MONTH,v.FechaEmision), v.Empresa, dbo.fnTipoCambio(v.Moneda), e.ContMoneda, dbo.fnMesNumeroNombre(DATEPART(MONTH,v.FechaEmision)) + ' ' + CONVERT(varchar,DATEPART(YEAR,v.FechaEmision))
) AS x
GROUP BY x.Estacion, x.Moneda2, x.Categoria, x.Ejercicio, x.Periodo, x.Fecha
ORDER BY x.Estacion, x.Moneda2, x.Categoria, x.Ejercicio, x.Periodo, x.Fecha
INSERT INTO @InformeVentaCteCat  (Estacion, ContMoneda, Moneda2, Categoria, Grafica1,   Grafica2,   SaldoDescripcionMC,  SaldoImporteMC,		          Reporte,  FechaGrafica, Ejercicio, Periodo)
SELECT                           Estacion, ContMoneda, Moneda2, Categoria, @Verdadero, @Verdadero, Categoria,         SUM(ISNULL(ImporteTotalMC,0.00)), @Reporte, Fecha, Ejercicio, Periodo
FROM
(
SELECT
'Estacion'			= @EstacionTrabajo,
'ContMoneda'		= e.ContMoneda,
'Moneda2'           = e.ContMoneda,
'Categoria'         = CASE WHEN ISNULL(c.Categoria,'') = '' THEN '(Sin Categoría)' ELSE c.Categoria END,
'ImporteTotalMC'    = (SUM(v.ImporteTotal*mt.Factor)) * dbo.fnTipoCambio(v.Moneda),
'Fecha'				= dbo.fnMesNumeroNombre(DATEPART(MONTH,v.FechaEmision)) + ' ' + CONVERT(varchar,DATEPART(YEAR,v.FechaEmision)),
'Ejercicio'			= DATEPART(YEAR,v.FechaEmision),
'Periodo'			= DATEPART(MONTH,v.FechaEmision)
FROM VentaCalc v
JOIN Cte c ON v.Cliente = c.Cliente
JOIN MovTipo mt ON v.Mov = mt.Mov AND mt.Modulo = 'VTAS'
JOIN EmpresaCfg e ON e.Empresa = v.Empresa
WHERE v.Estatus = 'CONCLUIDO'
AND v.Empresa = @Empresa
AND v.FechaEmision BETWEEN @FechaD AND @FechaA
AND mt.Clave in(@Clave1, @Clave2, @Clave3, @Clave4, @Clave5, @Clave6, @Clave7)
GROUP BY v.Moneda,  c.Categoria, DATEPART(YEAR,v.FechaEmision), DATEPART(MONTH,v.FechaEmision), v.Empresa, dbo.fnTipoCambio(v.Moneda), e.ContMoneda, dbo.fnMesNumeroNombre(DATEPART(MONTH,v.FechaEmision)) + ' ' + CONVERT(varchar,DATEPART(YEAR,v.FechaEmision))
) AS x
GROUP BY x.Estacion, x.Moneda2, x.Categoria, x.Ejercicio, x.Periodo, x.Fecha, x.ContMoneda
ORDER BY x.Estacion, x.Moneda2, x.Categoria, x.Ejercicio, x.Periodo, x.Fecha, x.ContMoneda
DECLARE crGraficar CURSOR FAST_FORWARD FOR
SELECT Moneda2, Grafica2
FROM @InformeVentaCteCat
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 1
GROUP BY Moneda2, Grafica2
OPEN crGraficar
FETCH NEXT FROM crGraficar INTO @Moneda, @Grafica2
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Graficar = NULL
SELECT @Graficar = COUNT(DISTINCT FechaGrafica)
FROM @InformeVentaCteCat
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = @Grafica2
AND Moneda2 = @Moneda
IF @Graficar > @GraficarFecha
DELETE @InformeVentaCteCat
WHERE FechaGrafica IN(
SELECT TOP (@Graficar - @GraficarFecha) FechaGrafica
FROM @InformeVentaCteCat
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
FROM @InformeVentaCteCat
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 0
AND @Moneda = CASE WHEN @Grafica2 = 0 THEN Moneda ELSE ContMoneda END
IF @GraficarTipo = 'Mas Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @InformeVentaCteCat
WHERE Categoria NOT IN(
SELECT  TOP (@GraficarCantidad) Categoria
FROM
(
SELECT
'Categoria'         = Categoria,
'SaldoImporte'      = SUM(SaldoImporte)+ SUM(SaldoImporteMC)
FROM @InformeVentaCteCat
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
DELETE @InformeVentaCteCat
WHERE Categoria NOT IN(
SELECT  TOP (@GraficarCantidad) Categoria
FROM
(
SELECT
'Categoria'         = Categoria,
'SaldoImporte'      = SUM(SaldoImporte)+ SUM(SaldoImporteMC)
FROM @InformeVentaCteCat
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
FETCH NEXT FROM crGraficar INTO @Moneda, @Grafica2
END
CLOSE crGraficar
DEALLOCATE crGraficar
UPDATE @InformeVentaCteCat SET FechaDesde = @FechaD, FechaHasta = @FechaA, Titulo = @Titulo, EmpresaNombre = @EmpresaNombre, Etiqueta = @Etiqueta, Reporte = @Reporte WHERE Estacion = @EstacionTrabajo
SELECT * , @VerGraficaDetalle as VerGraficaDetalle FROM @InformeVentaCteCat WHERE Estacion = @EstacionTrabajo ORDER BY IDInforme
END

