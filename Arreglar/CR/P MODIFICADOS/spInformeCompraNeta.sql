SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInformeCompraNeta
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
@FechaEmision			datetime,
@ImporteTotal			money,
@ImporteTotalMC			money,
@FechaGrafica			varchar(100),
@Titulo					varchar(100),
@EmpresaNombre			varchar(100),
@Graficar				int,
@Grafica2				bit,
@GraficarFecha			int,
@Etiqueta				bit,
@VerGraficaDetalle		bit
DECLARE @InformeCompraNeta TABLE
(
Estacion			int 	    	NOT	NULL,
IDInforme			int 	    	NOT NULL  IDENTITY(1,1),
ID					int 	    		NULL,
Empresa				char(5)				NULL,
Mov 				char(20)			NULL,
MovID				char(20)       		NULL,
Moneda  			char(10)   			NULL,
TipoCambio			float				NULL,
Concepto 			varchar(50) 		NULL,
Referencia 			varchar(50) 		NULL,
Proyecto  			varchar(50)   		NULL,
FechaEmision 		datetime    		NULL,
FechaRequerida		datetime    		NULL,
Prioridad			char(10)			NULL,
Estatus 			char(15)   			NULL,
Situacion			varchar(50)			NULL,
SituacionFecha		datetime    		NULL,
Proveedor 			char(10)   			NULL,
Almacen				char(10)   			NULL,
Agente 				char(10)   			NULL,
FormaEnvio 			varchar(50)   		NULL,
Condicion 			varchar(50)   		NULL,
Vencimiento			datetime    		NULL,
Usuario 			char(10)   			NULL,
Observaciones 		varchar(100) 		NULL,
DescuentoGlobal		float				NULL,
Importe				money				NULL,
DescuentoLineal		float				NULL,
DescuentosTotales	money				NULL,
SubTotal			money				NULL,
Impuestos			money				NULL,
ImporteTotal		money				NULL,
Peso				float				NULL,
Volumen				float				NULL,
ProveedorNombre		varchar(100)		NULL,
Total				bit					NULL DEFAULT 0,
ContMoneda			char(10)			NULL,
ImporteTotalMC		money				NULL,
FechaGrafica		varchar(100)		NULL,
Grafica1 			bit					NULL DEFAULT 0.0,
Grafica2 			bit					NULL DEFAULT 0.0,
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
@Reporte = InfoRepCompras,
@Empresa = InfoEmpresa,
@Titulo = RepTitulo,
@GraficarFecha = ISNULL(InformeGraficarFecha,12),
@Etiqueta = ISNULL(InfoEtiqueta, @Falso),
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
INSERT INTO @InformeCompraNeta
SELECT
'Estacion'			= @EstacionTrabajo,
c.ID,
c.Empresa,
c.Mov,
c.MovID,
UPPER(c.Moneda),
c.TipoCambio,
c.Concepto,
c.Referencia,
c.Proyecto,
c.FechaEmision,
c.FechaRequerida,
c.Prioridad,
c.Estatus,
c.Situacion,
c.SituacionFecha,
c.Proveedor,
c.Almacen,
c.Agente,
c.FormaEnvio,
c.Condicion,
c.Vencimiento,
c.Usuario,
c.Observaciones,
c.DescuentoGlobal,
'Importe'           = c.Importe*mt.Factor,
'DescuentoLineal'   = c.DescuentoLineal*mt.Factor,
'DescuentosTotales' = c.DescuentosTotales*mt.Factor,
'SubTotal'          = c.SubTotal*mt.Factor,
'Impuestos'         = c.Impuestos*mt.Factor,
'ImporteTotal'      = c.ImporteTotal*mt.Factor,
'Peso'              = c.Peso*mt.Factor,
'Volumen'           = c.Volumen*mt.Factor,
'ProveedorNombre'   = Prov.Nombre,
'Total'				= @Falso,
'ContMoneda'		= UPPER(e.ContMoneda),
'ImporteTotalMC'    = CASE WHEN e.ContMoneda = c.Moneda THEN (c.ImporteTotal*mt.Factor) ELSE (c.ImporteTotal*mt.Factor) * dbo.fnTipoCambio(c.Moneda) END,
'FechaGrafica'		= NULL,
'Grafica1'			= @Falso,
'Grafica2'			= @Falso,
'Reporte'			= @Reporte,
'SaldoDescripcion'  = NULL,
'SaldoImporte'		= NULL,
'Movimiento'		= c.Mov + ' ' + c.MovID,
'SaldoDescripcionMC'= NULL,
'SaldoImporteMC'	= NULL,
'FechaDesde'		= @FechaD,
'FechaHasta'		= @FechaA,
'Titulo'			= @Titulo,
'EmpresaNombre'		= @EmpresaNombre,
'Ejercicio'			= NULL,
'Periodo'			= NULL,
'Etiqueta'			= @Etiqueta
FROM CompraCalc c
 WITH(NOLOCK) JOIN Prov  WITH(NOLOCK) ON c.Proveedor=Prov.Proveedor
JOIN MovTipo mt  WITH(NOLOCK) ON c.Mov = mt.Mov AND mt.Modulo = 'COMS'
JOIN EmpresaCfg e  WITH(NOLOCK) ON e.Empresa = c.Empresa
WHERE c.Estatus = 'CONCLUIDO'
AND c.Empresa = @Empresa
AND c.FechaEmision BETWEEN @FechaD AND @FechaA
AND mt.Clave in(@Clave1, @Clave2, @Clave3, @Clave4, @Clave5, @Clave6)
INSERT INTO @InformeCompraNeta (Estacion, Moneda, FechaEmision, Importe, DescuentoLineal, DescuentosTotales, SubTotal, Impuestos, ImporteTotal, Peso, Volumen, Total, ContMoneda, Grafica1, Grafica2, Reporte, FechaDesde, FechaHasta)
SELECT
'Estacion'			= @EstacionTrabajo,
'Moneda'			= 'Total',
'FechaEmision'		= (SELECT MAX(FechaEmision) + 1 FROM VENTA),
'Importe'           = SUM(CASE WHEN e.ContMoneda = c.Moneda THEN (c.Importe*mt.Factor) ELSE (c.Importe*mt.Factor) * dbo.fnTipoCambio(c.Moneda) END),
'DescuentoLineal'   = SUM(CASE WHEN e.ContMoneda = c.Moneda THEN (c.DescuentoLineal*mt.Factor) ELSE (c.DescuentoLineal*mt.Factor) * dbo.fnTipoCambio(c.Moneda) END),
'DescuentosTotales' = SUM(CASE WHEN e.ContMoneda = c.Moneda THEN (c.DescuentosTotales*mt.Factor) ELSE (c.DescuentosTotales*mt.Factor) * dbo.fnTipoCambio(c.Moneda) END),
'SubTotal'          = SUM(CASE WHEN e.ContMoneda = c.Moneda THEN (c.SubTotal*mt.Factor) ELSE (c.SubTotal*mt.Factor) * dbo.fnTipoCambio(c.Moneda) END),
'Impuestos'         = SUM(CASE WHEN e.ContMoneda = c.Moneda THEN (c.Impuestos*mt.Factor) ELSE (c.Impuestos*mt.Factor) * dbo.fnTipoCambio(c.Moneda) END),
'ImporteTotal'      = SUM(CASE WHEN e.ContMoneda = c.Moneda THEN (c.ImporteTotal*mt.Factor) ELSE (c.ImporteTotal*mt.Factor) * dbo.fnTipoCambio(c.Moneda) END),
'Peso'              = SUM(CASE WHEN e.ContMoneda = c.Moneda THEN (c.Peso*mt.Factor) ELSE (c.Peso*mt.Factor) * dbo.fnTipoCambio(c.Moneda) END),
'Volumen'           = SUM(CASE WHEN e.ContMoneda = c.Moneda THEN (c.Volumen*mt.Factor) ELSE (c.Volumen*mt.Factor) * dbo.fnTipoCambio(c.Moneda) END),
'Total'				= @Verdadero,
'ContMoneda'        = UPPER(RTRIM(LTRIM(e.ContMoneda))),
'Grafica1'			= @Falso,
'Grafica2'			= @Falso,
'Reporte'			= @Reporte,
'FechaDesde'		= @FechaD,
'FechaHasta'		= @FechaA
FROM CompraCalc c
 WITH(NOLOCK) JOIN Prov  WITH(NOLOCK) ON c.Proveedor=Prov.Proveedor
JOIN MovTipo mt  WITH(NOLOCK) ON c.Mov = mt.Mov AND mt.Modulo = 'COMS'
JOIN EmpresaCfg e  WITH(NOLOCK) ON e.Empresa = c.Empresa
WHERE c.Estatus = 'CONCLUIDO'
AND c.Empresa = @Empresa
AND c.FechaEmision BETWEEN @FechaD AND @FechaA
AND mt.Clave in(@Clave1, @Clave2, @Clave3, @Clave4, @Clave5, @Clave6)
GROUP BY e.ContMoneda
DECLARE crGrafica CURSOR FAST_FORWARD FOR
SELECT Moneda, (SELECT MAX(FechaEmision) + 2 FROM Compra), SUM(ImporteTotal), dbo.fnMesNumeroNombre(DATEPART(MONTH,FechaEmision)) + ' ' + CONVERT(varchar,DATEPART(YEAR,FechaEmision))
FROM @InformeCompraNeta
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 0
AND Total = 0
AND FechaGrafica IS NULL
GROUP BY DATEPART(MONTH,FechaEmision), DATEPART(YEAR,FechaEmision), Moneda
OPEN crGrafica
FETCH NEXT FROM crGrafica  INTO @Moneda, @FechaEmision, @ImporteTotal, @FechaGrafica
WHILE @@FETCH_STATUS = 0 
BEGIN
INSERT INTO @InformeCompraNeta(Estacion,         Moneda,  FechaEmision,  FechaGrafica,  Grafica1,   SaldoDescripcion,  SaldoImporte)
SELECT                    @EstacionTrabajo, @Moneda, @FechaEmision, @FechaGrafica, @Verdadero, 'ImporteTotal',    @ImporteTotal
FETCH NEXT FROM crGrafica  INTO @Moneda, @FechaEmision, @ImporteTotal, @FechaGrafica
END
CLOSE crGrafica
DEALLOCATE crGrafica
DECLARE crGrafica1 CURSOR FAST_FORWARD FOR
SELECT RTRIM(LTRIM(ContMoneda)), (SELECT MAX(FechaEmision) + 3 FROM Compra), SUM(ImporteTotalMC), dbo.fnMesNumeroNombre(DATEPART(MONTH, FechaEmision)) + ' ' + CONVERT(varchar,DATEPART(YEAR, FechaEmision))
FROM @InformeCompraNeta
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 0
AND Total = 0
AND FechaGrafica IS NULL
GROUP BY DATEPART(MONTH, FechaEmision), DATEPART(YEAR, FechaEmision), ContMoneda
OPEN crGrafica1
FETCH NEXT FROM crGrafica1 INTO @Moneda, @FechaEmision, @ImporteTotalMC, @FechaGrafica
WHILE @@FETCH_STATUS = 0 
BEGIN
INSERT INTO @InformeCompraNeta(Estacion,         Moneda,  FechaEmision,  FechaGrafica, Grafica1,   Grafica2,   SaldoDescripcionMC,  SaldoImporteMC)
SELECT                    @EstacionTrabajo, @Moneda, @FechaEmision, @FechaGrafica, @Verdadero, @Verdadero, 'Importe Total MC',  @ImporteTotalMC
FETCH NEXT FROM crGrafica1 INTO @Moneda, @FechaEmision, @ImporteTotalMC, @FechaGrafica
END
CLOSE crGrafica1
DEALLOCATE crGrafica1
DECLARE crGraficar CURSOR FAST_FORWARD FOR
SELECT Moneda, Grafica2
FROM @InformeCompraNeta
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 1
GROUP BY Moneda, Grafica2
OPEN crGraficar
FETCH NEXT FROM crGraficar  INTO @Moneda, @Grafica2
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Graficar = NULL
SELECT @Graficar = COUNT(DISTINCT FechaGrafica)
FROM @InformeCompraNeta
WHERE Estacion = @EstacionTrabajo
AND Grafica1 = 1
AND Grafica2 = @Grafica2
AND Moneda = @Moneda
IF @Graficar > @GraficarFecha
DELETE @InformeCompraNeta
WHERE FechaGrafica IN(
SELECT TOP (@Graficar - @GraficarFecha) FechaGrafica
FROM @InformeCompraNeta
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
UPDATE @InformeCompraNeta SET FechaDesde = @FechaD, FechaHasta = @FechaA, Titulo = @Titulo, EmpresaNombre = @EmpresaNombre, Etiqueta = @Etiqueta, Reporte = @Reporte WHERE Estacion = @EstacionTrabajo
SELECT * , @VerGraficaDetalle as VerGraficaDetalle FROM @InformeCompraNeta WHERE Estacion = @EstacionTrabajo ORDER BY IDInforme
END

