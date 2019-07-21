SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepGASPresupuestoGastado
@Estacion	int

AS BEGIN
DECLARE @Empresa	    varchar(5),
@FechaD		datetime,
@FechaA		datetime,
@Concepto	    varchar(50),
@Moneda		varchar(15)
SELECT @Empresa = rp.InfoEmpresa,
@FechaD = rp.InfoFechaD,
@FechaA = rp.InfoFechaA,
@Concepto = rp.InfoConcepto,
@Moneda = rp.InfoMoneda
FROM RepParam rp
WHERE rp.Estacion = @Estacion
CREATE TABLE #Reporte (
Concepto			varchar(50)	COLLATE Database_Default null,
PresupuestoCantidad	float		null,
PresupuestoPrecio	money		null,
PresupuestoImporte	money		null,
DisminucionCantidad	float		null,
DisminucionPrecio	money		null,
DisminucionImporte	money		null,
GastadoCantidad		float		null,
GastadoPrecio		money		null,
GastadoImporte		money		null,
Moneda				varchar(15)	COLLATE Database_Default null)
CREATE TABLE #Presupuesto (
Concepto	varchar(50)	COLLATE Database_Default null,
Cantidad	float		null,
Precio		money		null,
Importe		money		null,
Moneda		varchar(15)	COLLATE Database_Default null)
CREATE TABLE #DisminucionPresupuesto (
Concepto	varchar(50)	COLLATE Database_Default null,
Cantidad	float		null,
Precio		money		null,
Importe		money		null,
Moneda		varchar(15)	COLLATE Database_Default null)
CREATE TABLE #PresupuestoGastado (
Concepto	varchar(50)	COLLATE Database_Default null,
Cantidad	float		null,
Precio		money		null,
Importe		money		null,
Moneda		varchar(15)	COLLATE Database_Default null)
IF @Concepto IN ('','(Todos)','(Todas)','NULL') SELECT @Concepto = NULL
IF @Moneda   IN ('','(Todos)','(Todas)','NULL') SELECT @Moneda = NULL
INSERT #Presupuesto
SELECT gd.Concepto,
SUM(ISNULL(gd.Cantidad, 0)),
SUM(ISNULL(gd.Precio, 0)),
SUM(ISNULL(gd.Importe, 0)),
g.Moneda
FROM Gasto g
INNER JOIN GastoD gd ON g.ID = gd.ID
INNER JOIN MovTipo mt ON g.Mov = mt.Mov
AND mt.Modulo = 'GAS'
AND mt.Clave = 'GAS.PR'
WHERE g.Empresa = @Empresa
AND g.Estatus = 'CONCLUIDO'
AND g.FechaEmision BETWEEN @FechaD AND @FechaA
AND ISNULL(gd.Concepto, '') = ISNULL(ISNULL(@Concepto, gd.Concepto), '')
AND ISNULL(g.Moneda, '') = ISNULL(ISNULL(@Moneda, g.Moneda), '')
GROUP BY g.Moneda,
gd.Concepto
INSERT #DisminucionPresupuesto
SELECT gd.Concepto,
SUM(ISNULL(gd.Cantidad, 0)),
SUM(ISNULL(gd.Precio, 0)),
SUM(ISNULL(gd.Importe, 0)),
g.Moneda
FROM Gasto g
INNER JOIN GastoD gd ON g.ID = gd.ID
INNER JOIN MovTipo mt ON g.Mov = mt.Mov
AND mt.Modulo = 'GAS'
AND mt.Clave = 'GAS.DPR'
WHERE g.Empresa = @Empresa
AND g.Estatus = 'CONCLUIDO'
AND g.FechaEmision BETWEEN @FechaD AND @FechaA
AND ISNULL(gd.Concepto, '') = ISNULL(ISNULL(@Concepto, gd.Concepto), '')
AND ISNULL(g.Moneda, '') = ISNULL(ISNULL(@Moneda, g.Moneda), '')
GROUP BY g.Moneda,
gd.Concepto
INSERT #PresupuestoGastado
SELECT gd.Concepto,
SUM(ISNULL(gd.Cantidad, 0)),
SUM(ISNULL(gd.Precio, 0)),
SUM(ISNULL(gd.Importe, 0)),
g.Moneda
FROM Gasto g
INNER JOIN GastoD gd ON g.ID = gd.ID
INNER JOIN MovTipo mt ON g.Mov = mt.Mov
AND mt.Modulo = 'GAS'
AND mt.Clave = 'GAS.G'
WHERE g.Empresa = @Empresa
AND g.Estatus = 'CONCLUIDO'
AND g.FechaEmision BETWEEN @FechaD AND @FechaA
AND ISNULL(gd.Concepto, '') = ISNULL(ISNULL(@Concepto, gd.Concepto), '')
AND ISNULL(g.Moneda, '') = ISNULL(ISNULL(@Moneda, g.Moneda), '')
GROUP BY g.Moneda,
gd.Concepto
INSERT #Reporte (Concepto, PresupuestoCantidad, PresupuestoPrecio, PresupuestoImporte, Moneda)
SELECT * FROM #Presupuesto
UPDATE #Reporte SET DisminucionCantidad = Cantidad,
DisminucionPrecio = Precio,
DisminucionImporte = Importe
FROM #DisminucionPresupuesto
WHERE #Reporte.Concepto = #DisminucionPresupuesto.Concepto
AND #Reporte.Moneda = #DisminucionPresupuesto.Moneda
UPDATE #Reporte SET GastadoCantidad = Cantidad,
GastadoPrecio = Precio,
GastadoImporte = Importe
FROM #PresupuestoGastado
WHERE #Reporte.Concepto = #PresupuestoGastado.Concepto
AND #Reporte.Moneda = #PresupuestoGastado.Moneda
SELECT *
FROM #Reporte
END

