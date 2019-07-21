SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInformeVentaNeta
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
@FechaEmision			datetime,
@CostoTotal				money,
@ImporteTotal			money,
@Utilidad				money,
@ImporteTotalMC			money,
@FechaGrafica			varchar(100),
@Titulo					varchar(100),
@EmpresaNombre			varchar(100),
@Graficar				int,
@Grafica2				bit,
@GraficarFecha			int,
@Etiqueta				bit,
@VerGraficaDetalle		bit
DECLARE @InformeVentaNeta TABLE
(
Estacion			int 	    	NOT	NULL,
IDInforme			int 	    	NOT NULL  IDENTITY(1,1),
ID					int 	    		NULL,
Empresa				char(5)				NULL,
Mov 				char(20)			NULL,
MovID				char(20)       		NULL,
Moneda  			char(10)   			NULL,
TipoCambio			float				NULL,
FechaEmision 		datetime    		NULL,
Concepto			varchar(50)			NULL,
Referencia 			varchar(50) 		NULL,
Proyecto  			varchar(50)   		NULL,
FechaRequerida		datetime    		NULL,
Prioridad			char(10)			NULL,
Estatus 			char(15)   			NULL,
Situacion			varchar(50)			NULL,
SituacionFecha		datetime    		NULL,
Cliente 			char(10)   			NULL,
EnviarA				int	   				NULL,
Almacen				char(10)   			NULL,
Agente 				char(10)   			NULL,
FormaEnvio 			varchar(50)   		NULL,
Condicion 			varchar(50)   		NULL,
Vencimiento			datetime    		NULL,
Usuario 			char(10)   			NULL,
Observaciones 		varchar(100) 		NULL,
DescuentoGlobal		float 	    		NULL,
CostoTotal			money				NULL,
PrecioTotal			money				NULL,
Importe				money				NULL,
DescuentoLineal		float				NULL,
DescuentosTotales	money				NULL,
SubTotal			money				NULL,
Impuestos			money				NULL,
ImporteTotal		money				NULL,
Peso				float				NULL,
Volumen				float				NULL,
ClienteNombre		varchar(100)		NULL,
Utilidad			money				NULL,
Total				bit					NULL DEFAULT 0,
ContMoneda			char(10)			NULL,
ImporteTotalMC		money				NULL,
CostoTotalMC		money				NULL,
UtilidadMC			money				NULL,
FechaGrafica		varchar(100)		NULL,
Grafica1 			bit					NULL DEFAULT 0,
Grafica2 			bit					NULL DEFAULT 0,
Reporte				varchar(100)		NULL,
SaldoDescripcion	varchar(50)			NULL,
SaldoImporte		money				NULL DEFAULT 0.0,
Movimiento			varchar(50)			NULL,
SaldoDescripcionMC	varchar(50)			NULL,
SaldoImporteMC		money				NULL DEFAULT 0.0,
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
@Etiqueta = ISNULL(InfoEtiqueta, @Falso),
@VerGraficaDetalle = ISNULL(VerGraficaDetalle,0)
FROM RepParam WITH(NOLOCK)
WHERE Estacion = @EstacionTrabajo
SELECT @EmpresaNombre = (SELECT Nombre FROM Empresa WITH(NOLOCK) WHERE Empresa = @Empresa)
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
INSERT INTO @InformeVentaNeta
SELECT
'Estacion'			= @EstacionTrabajo,
v.ID,
v.Empresa,
v.Mov,
v.MovID,
UPPER(v.Moneda),
v.TipoCambio,
v.FechaEmision,
v.Concepto,
v.Referencia,
v.Proyecto,
v.FechaRequerida,
v.Prioridad,
v.Estatus,
v.Situacion,
v.SituacionFecha,
v.Cliente,
v.EnviarA,
v.Almacen,
v.Agente,
v.FormaEnvio,
v.Condicion,
v.Vencimiento,
v.Usuario,
v.Observaciones,
v.DescuentoGlobal,
'CostoTotal'        = v.CostoTotal*mt.Factor,
'PrecioTotal'       = v.PrecioTotal*mt.Factor,
'Importe'           = v.Importe*mt.Factor,
'DescuentoLineal'   = v.DescuentoLineal*mt.Factor,
'DescuentosTotales' = v.DescuentosTotales*mt.Factor,
'SubTotal'          = v.SubTotal*mt.Factor,
'Impuestos'         = v.Impuestos*mt.Factor,
'ImporteTotal'      = v.ImporteTotal*mt.Factor,
'Peso'              = v.Peso*mt.Factor,
'Volumen'           = v.Volumen*mt.Factor,
'ClienteNombre'     = Cte.Nombre,
'Utilidad'			= ((v.SubTotal*mt.Factor) - (v.CostoTotal*mt.Factor)),
'Total'				= @Falso,
'ContMoneda'		= UPPER(e.ContMoneda),
'ImporteTotalMC'    = CASE WHEN e.ContMoneda = v.Moneda THEN (v.ImporteTotal*mt.Factor) ELSE (v.ImporteTotal*mt.Factor) * dbo.fnTipoCambio(v.Moneda) END,
'CostoTotalMC'		= CASE WHEN e.ContMoneda = v.Moneda THEN (v.CostoTotal*mt.Factor) ELSE (v.CostoTotal*mt.Factor) * dbo.fnTipoCambio(v.Moneda) END,
'UtilidadlMC'		= CASE WHEN e.ContMoneda = v.Moneda THEN ((v.SubTotal*mt.Factor) - (v.CostoTotal*mt.Factor)) ELSE ((v.SubTotal*mt.Factor) - (v.CostoTotal*mt.Factor)) * dbo.fnTipoCambio(v.Moneda) END,
'FechaGrafica'		= NULL,
'Grafica1'			= @Falso,
'Grafica2'			= @Falso,
'Reporte'			= @Reporte,
'SaldoDescripcion'  = NULL,
'SaldoImporte'		= NULL,
'Movimiento'		= v.Mov + ' ' + v.MovID,
'SaldoDescripcionMC'= NULL,
'SaldoImporteMC'	= NULL,
'FechaDesde'		= @FechaD,
'FechaHasta'		= @FechaA,
'Titulo'			= @Titulo,
'EmpresaNombre'		= @EmpresaNombre,
'Ejercicio'			= NULL,
'Periodo'			= NULL,
'Etiqueta'			= @Etiqueta
FROM VentaCalc v
 WITH(NOLOCK) JOIN Cte  WITH(NOLOCK) ON v.Cliente = Cte.Cliente
JOIN MovTipo mt  WITH(NOLOCK) ON v.Mov = mt.Mov AND mt.Modulo = 'VTAS'
JOIN EmpresaCfg e  WITH(NOLOCK) ON e.Empresa = v.Empresa
WHERE v.Estatus = 'CONCLUIDO'
AND v.Empresa = @Empresa
AND v.FechaEmision BETWEEN @FechaD AND @FechaA
AND mt.Clave in(@Clave1, @Clave2, @Clave3, @Clave4, @Clave5, @Clave6, @Clave7)
INSERT INTO @InformeVentaNeta (Estacion, Moneda, FechaEmision, CostoTotal, PrecioTotal, Importe, DescuentoLineal, DescuentosTotales, SubTotal, Impuestos, ImporteTotal, Peso, Volumen, Utilidad, Total, ContMoneda, Grafica1, Grafica2, Reporte, FechaDesde, FechaHasta, CostoTotalMC, ImporteTotalMC, UtilidadMC)
SELECT
'Estacion'			= @EstacionTrabajo,
'Moneda'			= 'Total',
'FechaEmision'		= (SELECT MAX(FechaEmision) + 1 FROM VENTA),
'CostoTotal'        = SUM(CASE WHEN e.ContMoneda = v.Moneda THEN (v.CostoTotal*mt.Factor) ELSE (v.CostoTotal*mt.Factor) * dbo.fnTipoCambio(v.Moneda) END),
'PrecioTotal'       = SUM(CASE WHEN e.ContMoneda = v.Moneda THEN (v.PrecioTotal*mt.Factor) ELSE (v.PrecioTotal*mt.Factor) * dbo.fnTipoCambio(v.Moneda) END),
'Importe'           = SUM(CASE WHEN e.ContMoneda = v.Moneda THEN (v.Importe*mt.Factor) ELSE (v.Importe*mt.Factor) * dbo.fnTipoCambio(v.Moneda) END),
'DescuentoLineal'   = SUM(CASE WHEN e.ContMoneda = v.Moneda THEN (v.DescuentoLineal*mt.Factor) ELSE (v.DescuentoLineal*mt.Factor) * dbo.fnTipoCambio(v.Moneda) END),
'DescuentosTotales' = SUM(CASE WHEN e.ContMoneda = v.Moneda THEN (v.DescuentosTotales*mt.Factor) ELSE (v.DescuentosTotales*mt.Factor) * dbo.fnTipoCambio(v.Moneda) END),
'SubTotal'          = SUM(CASE WHEN e.ContMoneda = v.Moneda THEN (v.SubTotal*mt.Factor) ELSE (v.SubTotal*mt.Factor) * dbo.fnTipoCambio(v.Moneda) END),
'Impuestos'         = SUM(CASE WHEN e.ContMoneda = v.Moneda THEN (v.Impuestos*mt.Factor) ELSE (v.Impuestos*mt.Factor) * dbo.fnTipoCambio(v.Moneda) END),
'ImporteTotal'      = SUM(CASE WHEN e.ContMoneda = v.Moneda THEN (v.ImporteTotal*mt.Factor) ELSE (v.ImporteTotal*mt.Factor) * dbo.fnTipoCambio(v.Moneda) END),
'Peso'              = SUM(CASE WHEN e.ContMoneda = v.Moneda THEN (v.Peso*mt.Factor) ELSE (v.Peso*mt.Factor) * dbo.fnTipoCambio(v.Moneda) END),
'Volumen'           = SUM(CASE WHEN e.ContMoneda = v.Moneda THEN (v.Volumen*mt.Factor) ELSE (v.Volumen*mt.Factor) * dbo.fnTipoCambio(v.Moneda) END),
'Utilidad'			= SUM(CASE WHEN e.ContMoneda = v.Moneda THEN((v.SubTotal*mt.Factor) - (v.CostoTotal*mt.Factor)) ELSE ((v.SubTotal*mt.Factor) - (v.CostoTotal*mt.Factor)) * dbo.fnTipoCambio(v.Moneda) END),
'Total'				= @Verdadero,
'ContMoneda'        = UPPER(RTRIM(LTRIM(e.ContMoneda))),
'Grafica1'			= @Falso,
'Grafica2'			= @Falso,
'Reporte'			= @Reporte,
'FechaDesde'		= @FechaD,
'FechaHasta'		= @FechaA,
'CostoTotalMC'      = SUM(CASE WHEN e.ContMoneda = v.Moneda THEN (v.CostoTotal*mt.Factor) ELSE (v.CostoTotal*mt.Factor) * dbo.fnTipoCambio(v.Moneda) END),
'ImporteTotalMC'    = SUM(CASE WHEN e.ContMoneda = v.Moneda THEN (v.ImporteTotal*mt.Factor) ELSE (v.ImporteTotal*mt.Factor) * dbo.fnTipoCambio(v.Moneda) END),
'UtilidadMC'		= SUM(CASE WHEN e.ContMoneda = v.Moneda THEN((v.SubTotal*mt.Factor) - (v.CostoTotal*mt.Factor)) ELSE ((v.SubTotal*mt.Factor) - (v.CostoTotal*mt.Factor)) * dbo.fnTipoCambio(v.Moneda) END)
FROM VentaCalc v
 WITH(NOLOCK) JOIN Cte  WITH(NOLOCK) ON v.Cliente=Cte.Cliente
JOIN MovTipo mt  WITH(NOLOCK) ON v.Mov = mt.Mov AND mt.Modulo = 'VTAS'
JOIN EmpresaCfg e  WITH(NOLOCK) ON e.Empresa = v.Empresa
WHERE v.Estatus = 'CONCLUIDO'
AND v.Empresa = @Empresa
AND v.FechaEmision BETWEEN @FechaD AND @FechaA
AND mt.Clave in(@Clave1, @Clave2, @Clave3, @Clave4, @Clave5, @Clave6, @Clave7)
GROUP BY e.ContMoneda
DECLARE crGrafica CURSOR FAST_FORWARD FOR
SELECT UPPER(v.Moneda), (SELECT MAX(FechaEmision) + 2 FROM VENTA), SUM(v.CostoTotal*mt.Factor), SUM(v.ImporteTotal*mt.Factor), SUM(((v.ImporteTotal*mt.Factor) - (v.CostoTotal*mt.Factor))), dbo.fnMesNumeroNombre(DATEPART(MONTH,v.FechaEmision)) + ' ' + CONVERT(varchar,DATEPART(YEAR,v.FechaEmision))
FROM VentaCalc v
 WITH(NOLOCK) JOIN Cte  WITH(NOLOCK) ON v.Cliente=Cte.Cliente
JOIN MovTipo mt  WITH(NOLOCK) ON v.Mov = mt.Mov AND mt.Modulo = 'VTAS'
JOIN EmpresaCfg e  WITH(NOLOCK) ON e.Empresa = v.Empresa
WHERE v.Estatus = 'CONCLUIDO'
AND v.Empresa = @Empresa
AND v.FechaEmision BETWEEN @FechaD AND @FechaA
AND mt.Clave in(@Clave1, @Clave2, @Clave3, @Clave4, @Clave5, @Clave6, @Clave7)
GROUP BY DATEPART(MONTH,v.FechaEmision), DATEPART(YEAR,v.FechaEmision), UPPER(v.Moneda)
OPEN crGrafica
FETCH NEXT FROM crGrafica  INTO @Moneda, @FechaEmision, @CostoTotal, @ImporteTotal, @Utilidad, @FechaGrafica
WHILE @@FETCH_STATUS = 0 
BEGIN
INSERT INTO @InformeVentaNeta(Estacion,         Moneda,  FechaEmision,  FechaGrafica,  Grafica1,   SaldoDescripcion,  SaldoImporte)
SELECT                    @EstacionTrabajo, @Moneda, @FechaEmision, @FechaGrafica, @Verdadero, 'CostoTotal',      @CostoTotal
INSERT INTO @InformeVentaNeta(Estacion,         Moneda,  FechaEmision,  FechaGrafica,  Grafica1,   SaldoDescripcion,  SaldoImporte)
SELECT                    @EstacionTrabajo, @Moneda, @FechaEmision, @FechaGrafica, @Verdadero, 'ImporteTotal',    @ImporteTotal
INSERT INTO @InformeVentaNeta(Estacion,         Moneda,  FechaEmision,  FechaGrafica,  Grafica1,   SaldoDescripcion,  SaldoImporte)
SELECT                    @EstacionTrabajo, @Moneda, @FechaEmision, @FechaGrafica, @Verdadero, 'Utilidad',        @Utilidad
FETCH NEXT FROM crGrafica  INTO @Moneda, @FechaEmision, @CostoTotal, @ImporteTotal, @Utilidad, @FechaGrafica
END
CLOSE crGrafica
DEALLOCATE crGrafica
DECLARE crGrafica1 CURSOR FAST_FORWARD FOR
SELECT UPPER(RTRIM(LTRIM(e.ContMoneda))), (SELECT MAX(FechaEmision) + 2 FROM VENTA), SUM(CASE WHEN e.ContMoneda = v.Moneda THEN (v.CostoTotal*mt.Factor) ELSE (v.CostoTotal*mt.Factor) * dbo.fnTipoCambio(v.Moneda) END), SUM(CASE WHEN e.ContMoneda = v.Moneda THEN (v.ImporteTotal*mt.Factor) ELSE (v.ImporteTotal*mt.Factor) * dbo.fnTipoCambio(v.Moneda) END) - SUM(CASE WHEN e.ContMoneda = v.Moneda THEN (v.CostoTotal*mt.Factor) ELSE (v.CostoTotal*mt.Factor) * dbo.fnTipoCambio(v.Moneda) END), SUM(CASE WHEN e.ContMoneda = v.Moneda THEN (v.ImporteTotal*mt.Factor) ELSE (v.ImporteTotal*mt.Factor) * dbo.fnTipoCambio(v.Moneda) END), dbo.fnMesNumeroNombre(DATEPART(MONTH,v.FechaEmision)) + ' ' + CONVERT(varchar,DATEPART(YEAR,v.FechaEmision))
FROM VentaCalc v
 WITH(NOLOCK) JOIN Cte  WITH(NOLOCK) ON v.Cliente=Cte.Cliente
JOIN MovTipo mt  WITH(NOLOCK) ON v.Mov = mt.Mov AND mt.Modulo = 'VTAS'
JOIN EmpresaCfg e  WITH(NOLOCK) ON e.Empresa = v.Empresa
WHERE v.Estatus = 'CONCLUIDO'
AND v.Empresa = @Empresa
AND v.FechaEmision BETWEEN @FechaD AND @FechaA
AND mt.Clave in(@Clave1, @Clave2, @Clave3, @Clave4, @Clave5, @Clave6, @Clave7)
GROUP BY DATEPART(MONTH,v.FechaEmision), DATEPART(YEAR,v.FechaEmision), UPPER(RTRIM(LTRIM(e.ContMoneda)))
OPEN crGrafica1
FETCH NEXT FROM crGrafica1 INTO @Moneda, @FechaEmision, @CostoTotal, @Utilidad, @ImporteTotalMC, @FechaGrafica
WHILE @@FETCH_STATUS = 0 
BEGIN
INSERT INTO @InformeVentaNeta(Estacion,         Moneda,  FechaEmision,  FechaGrafica, Grafica1,   Grafica2,   SaldoDescripcionMC,  SaldoImporteMC)
SELECT                    @EstacionTrabajo, @Moneda, @FechaEmision, @FechaGrafica, @Verdadero, @Verdadero, 'Costo Total MC',    @CostoTotal
INSERT INTO @InformeVentaNeta(Estacion,         Moneda,  FechaEmision,  FechaGrafica, Grafica1,   Grafica2,   SaldoDescripcionMC,  SaldoImporteMC)
SELECT                    @EstacionTrabajo, @Moneda, @FechaEmision, @FechaGrafica, @Verdadero, @Verdadero, 'Importe Total MC',  @ImporteTotalMC
INSERT INTO @InformeVentaNeta(Estacion,         Moneda,  FechaEmision,  FechaGrafica, Grafica1,   Grafica2,   SaldoDescripcionMC,  SaldoImporteMC)
SELECT                    @EstacionTrabajo, @Moneda, @FechaEmision, @FechaGrafica, @Verdadero, @Verdadero, 'Utilidad MC',       @Utilidad
FETCH NEXT FROM crGrafica1 INTO @Moneda, @FechaEmision, @CostoTotal, @Utilidad, @ImporteTotalMC, @FechaGrafica
END
CLOSE crGrafica1
DEALLOCATE crGrafica1
DECLARE crGraficar CURSOR FAST_FORWARD FOR
SELECT Moneda, Grafica2
FROM @InformeVentaNeta
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 1
GROUP BY Moneda, Grafica2
OPEN crGraficar
FETCH NEXT FROM crGraficar  INTO @Moneda, @Grafica2
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Graficar = NULL
SELECT @Graficar = COUNT(DISTINCT FechaGrafica)
FROM @InformeVentaNeta
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = @Grafica2
AND Moneda = @Moneda
IF @Graficar > @GraficarFecha
DELETE @InformeVentaNeta
WHERE FechaGrafica IN(
SELECT TOP (@Graficar - @GraficarFecha) FechaGrafica
FROM @InformeVentaNeta
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = @Grafica2
AND Moneda = @Moneda
GROUP BY Ejercicio, Periodo, FechaGrafica
ORDER BY Ejercicio DESC, Periodo DESC, FechaGrafica DESC)
AND Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = @Grafica2
AND Moneda = @Moneda
FETCH NEXT FROM crGraficar  INTO @Moneda, @Grafica2
END
CLOSE crGraficar
DEALLOCATE crGraficar
UPDATE @InformeVentaNeta SET FechaDesde = @FechaD, FechaHasta = @FechaA, Titulo = @Titulo, EmpresaNombre = @EmpresaNombre, Etiqueta = @Etiqueta, Reporte = @Reporte WHERE Estacion = @EstacionTrabajo
SELECT * , @VerGraficaDetalle as VerGraficaDetalle FROM @InformeVentaNeta WHERE Estacion = @EstacionTrabajo ORDER BY IDInforme
END

