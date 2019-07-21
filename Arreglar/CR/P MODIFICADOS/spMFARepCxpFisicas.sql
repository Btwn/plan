	SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spMFARepCxpFisicas
@Empresa		varchar(5),
@FechaD			datetime,
@FechaA			datetime,
@Estatus		varchar(15),
@Procesar		bit		 = 0,
@FechaCierreD	datetime = NULL,
@FechaCierreA	datetime = NULL

AS BEGIN
DECLARE @Reporte		int,
@ClaveBC		int,
@Concepto		varchar(100),
@Fecha		datetime,
@Ejercicio	int,
@SQL			varchar(max)
CREATE TABLE #Movimentos(
RID				int				IDENTITY,
Modulo			varchar(20)		COLLATE Database_Default	NULL,
ModuloID		int				NULL,
Empresa			varchar(5)		COLLATE Database_Default	NULL,
Estatus			varchar(15)		COLLATE Database_Default	NULL,
Mov				varchar(20)		COLLATE Database_Default	NULL,
MovID			varchar(20)		COLLATE Database_Default	NULL,
Proveedor		varchar(10)		COLLATE Database_Default	NULL,
Nombre			varchar(100)	COLLATE Database_Default	NULL,
FiscalRegimen	varchar(30)		COLLATE Database_Default	NULL,
Ejercicio		int				NULL,
Periodo			int				NULL,
FechaEmision	datetime		NULL,
Importe			float			NULL,
Impuestos		float			NULL,
Aplica			varchar(20)		COLLATE Database_Default	NULL,
AplicaID		varchar(20)		COLLATE Database_Default	NULL,
FechaAplica		datetime		NULL,
EjercicioAplica	int				NULL,
PeriodoAplica	int				NULL
)
IF @Estatus  = 'Pendientes' SELECT @Estatus = 'PENDIENTE', @Ejercicio = YEAR(@FechaD)
IF @Estatus  = 'Concluidos' SELECT @Estatus = 'CONCLUIDO', @Ejercicio = YEAR(@FechaD) - 1
IF @Estatus IN('PENDIENTE', '(Todos)')
BEGIN
IF @Estatus  = '(Todos)'
SELECT @Ejercicio = YEAR(@FechaD)
/************** Movimientos de Cxp con Origen de Compras **************/
INSERT INTO #Movimentos(
Modulo,   ModuloID,   Empresa,   Mov,   MovID,   Proveedor,   Nombre,   FiscalRegimen,   Ejercicio,   Periodo,   FechaEmision,   Importe,                Impuestos,                Estatus)
SELECT 'COMS', c.ID,       d.Empresa, d.Mov, d.MovID, d.Proveedor, p.Nombre, p.FiscalRegimen, d.Ejercicio, d.Periodo, d.FechaEmision, d.Importe*d.TipoCambio, d.Impuestos*d.TipoCambio, d.Estatus
FROM Cxp d WITH (NOLOCK) 
JOIN Compra c  WITH (NOLOCK) ON d.Origen = c.Mov AND d.OrigenID = c.MovID AND d.OrigenTipo = 'COMS'
JOIN MovTipo mt  WITH (NOLOCK) ON c.Mov = mt.Mov AND mt.Modulo = 'COMS'
JOIN Prov p  WITH (NOLOCK) ON d.Proveedor = p.Proveedor
JOIN MFARepCxpFisicasFiscalRegimen mtmfr WITH (NOLOCK)  ON p.FiscalRegimen = mtmfr.FiscalRegimen
LEFT OUTER JOIN MFARepCxpFisicasAdicion mtmda  WITH (NOLOCK) ON mtmda.Modulo = 'COMS' AND mtmda.Mov = c.Mov
LEFT OUTER JOIN MFARepCxpFisicasExcepcion mtmde  WITH (NOLOCK) ON mtmde.Modulo = 'COMS' AND mtmde.Mov = c.Mov
WHERE mtmde.Modulo IS NULL
AND (mt.Clave IN ('COMS.F', 'COMS.OP', 'COMS.FL', 'COMS.CC', 'COMS.CA', 'COMS.GX') OR (mtmda.Modulo IS NOT NULL))
AND d.Ejercicio     = CASE d.Estatus WHEN 'PENDIENTE' THEN d.Ejercicio WHEN 'CONCLUIDO' THEN @Ejercicio END
AND d.FechaEmision >= CASE d.Estatus WHEN 'PENDIENTE' THEN @FechaD WHEN 'CONCLUIDO' THEN d.FechaEmision END
AND d.FechaEmision <= CASE d.Estatus WHEN 'PENDIENTE' THEN @FechaA WHEN 'CONCLUIDO' THEN d.FechaEmision END
AND d.Estatus IN('PENDIENTE')
AND d.Empresa = @Empresa
/************** Movimientos de Cxp con Origen de Gastos **************/
INSERT INTO #Movimentos(
Modulo,  ModuloID,   Empresa,   Mov,   MovID,   Proveedor,   Nombre,   FiscalRegimen,   Ejercicio,   Periodo,   FechaEmision,   Importe,                Impuestos,                Estatus)
SELECT 'GAS', c.ID,       d.Empresa, d.Mov, d.MovID, d.Proveedor, p.Nombre, p.FiscalRegimen, d.Ejercicio, d.Periodo, d.FechaEmision, d.Importe*d.TipoCambio, d.Impuestos*d.TipoCambio, d.Estatus
FROM Cxp d WITH (NOLOCK) 
JOIN Gasto c  WITH (NOLOCK) ON d.Origen = c.Mov AND d.OrigenID = c.MovID AND d.OrigenTipo = 'GAS'
JOIN MovTipo mt  WITH (NOLOCK) ON c.Mov = mt.Mov AND mt.Modulo = 'GAS'
JOIN Prov p  WITH (NOLOCK) ON d.Proveedor = p.Proveedor
JOIN MFARepCxpFisicasFiscalRegimen mtmfr  WITH (NOLOCK) ON p.FiscalRegimen = mtmfr.FiscalRegimen
LEFT OUTER JOIN MFARepCxpFisicasClaseSubClase mfcs  WITH (NOLOCK) ON ISNULL(mfcs.Clase, '') = ISNULL(c.Clase, '') AND ISNULL(mfcs.Subclase, '') = ISNULL(c.Subclase, '')
LEFT OUTER JOIN MFARepCxpFisicasAdicion mtmda  WITH (NOLOCK) ON mtmda.Modulo = 'GAS' AND mtmda.Mov = c.Mov
LEFT OUTER JOIN MFARepCxpFisicasExcepcion mtmde WITH (NOLOCK)  ON mtmde.Modulo = 'GAS' AND mtmde.Mov = c.Mov
WHERE mtmde.Modulo IS NULL
AND (mt.Clave IN ('GAS.G', 'GAS.GP', 'GAS.A', 'GAS.ASC', 'GAS.G', 'GAS.GTC', 'GAS.GP', 'GAS.CP', 'GAS.GR') OR (mtmda.Modulo IS NOT NULL))
AND d.Ejercicio     = CASE d.Estatus WHEN 'PENDIENTE' THEN d.Ejercicio WHEN 'CONCLUIDO' THEN @Ejercicio END
AND d.FechaEmision >= CASE d.Estatus WHEN 'PENDIENTE' THEN @FechaD WHEN 'CONCLUIDO' THEN d.FechaEmision END
AND d.FechaEmision <= CASE d.Estatus WHEN 'PENDIENTE' THEN @FechaA WHEN 'CONCLUIDO' THEN d.FechaEmision END
AND d.Estatus IN('PENDIENTE')
AND d.Empresa = @Empresa
AND mfcs.RID IS NOT NULL
/************** Devoluciones y Creditos **************/
INSERT INTO #Movimentos(
Modulo,  ModuloID,   Empresa,   Mov,   MovID,   Proveedor,   Nombre,   FiscalRegimen,   Ejercicio,   Periodo,   FechaEmision,   Importe,                 Impuestos,   Estatus,   Aplica,   AplicaID,   FechaAplica,    EjercicioAplica,   PeriodoAplica)
SELECT 'CXP', c.ID,       c.Empresa, c.Mov, c.MovID, c.Proveedor, p.Nombre, p.FiscalRegimen, c.Ejercicio, c.Periodo, c.FechaEmision, d.Importe*c.TipoCambio*-1, 0,         c.Estatus, d.Aplica, d.AplicaID, o.FechaEmision, o.Ejercicio,       o.Periodo
FROM Cxp c WITH (NOLOCK) 
JOIN CxpD d  WITH (NOLOCK) ON c.ID = d.ID
JOIN Cxp o  WITH (NOLOCK) ON c.Empresa = o.Empresa AND d.Aplica = o.Mov AND d.AplicaID = o.MovID
JOIN MovTipo mt WITH (NOLOCK)  ON c.Mov = mt.Mov AND mt.Modulo = 'CXP'
JOIN MovTipo mt2  WITH (NOLOCK) ON o.Mov = mt2.Mov AND mt2.Modulo = 'CXP'
JOIN Prov p  WITH (NOLOCK) ON c.Proveedor = p.Proveedor
JOIN MFARepCxpFisicasFiscalRegimen mtmfr  WITH (NOLOCK) ON p.FiscalRegimen = mtmfr.FiscalRegimen
LEFT OUTER JOIN MFARepCxpFisicasDevAdicion mtmda  WITH (NOLOCK) ON mtmda.Modulo = 'CXP' AND mtmda.Mov = c.Mov
LEFT OUTER JOIN MFARepCxpFisicasDevExcepcion mtmde  WITH (NOLOCK) ON mtmde.Modulo = 'CXP' AND mtmde.Mov = c.Mov
LEFT OUTER JOIN MFARepCxpFisicasDevExcepcion mtmdeo  WITH (NOLOCK) ON mtmdeo.Modulo = 'CXP' AND mtmdeo.Mov = c.Mov
WHERE mtmde.Modulo IS NULL
AND mtmdeo.Modulo IS NULL
AND (mt.Clave IN ('CXP.DC', 'CXP.NC') OR (mtmda.Modulo IS NOT NULL))
AND (mt2.Clave IN ('CXP.F'))
AND ((NULLIF(c.Origen,'') IS NULL AND NULLIF(c.OrigenTipo,'') IS NULL AND NULLIF(c.OrigenID,'') IS NULL) OR (c.OrigenTipo = 'CXP'))
AND c.Ejercicio     = CASE o.Estatus WHEN 'PENDIENTE' THEN c.Ejercicio WHEN 'CONCLUIDO' THEN @Ejercicio END
AND c.FechaEmision >= CASE o.Estatus WHEN 'PENDIENTE' THEN @FechaD WHEN 'CONCLUIDO' THEN c.FechaEmision END
AND c.FechaEmision <= CASE o.Estatus WHEN 'PENDIENTE' THEN @FechaA WHEN 'CONCLUIDO' THEN c.FechaEmision END
AND c.Estatus =('CONCLUIDO')
AND o.Estatus =('PENDIENTE')
AND c.Empresa = @Empresa
/************** Neteos y Aplicaciones **************/
INSERT INTO #Movimentos(
Modulo,  ModuloID,   Empresa,   Mov,   MovID,   Proveedor,   Nombre,   FiscalRegimen,   Ejercicio,   Periodo,   FechaEmision,  Importe,                                                                Impuestos,    Estatus,   Aplica,   AplicaID,   FechaAplica,    EjercicioAplica,   PeriodoAplica)
SELECT 'CXP', c.ID,       c.Empresa, c.Mov, c.MovID, c.Proveedor, p.Nombre, p.FiscalRegimen, c.Ejercicio, c.Periodo, c.FechaEmision, (d.Importe)/(1+((((o.Impuestos*100.0)/o.Importe))/100.0))*c.TipoCambio*-1, 0,          c.Estatus, d.Aplica, d.AplicaID, o.FechaEmision, o.Ejercicio,       o.Periodo
FROM Cxp c WITH (NOLOCK) 
JOIN CxpD d  WITH (NOLOCK) ON c.ID = d.ID
JOIN Cxp o  WITH (NOLOCK) ON c.Empresa = o.Empresa AND d.Aplica = o.Mov AND d.AplicaID = o.MovID
JOIN MovTipo mt WITH (NOLOCK)  ON c.Mov = mt.Mov AND mt.Modulo = 'CXP'
JOIN MovTipo mt2  WITH (NOLOCK) ON o.Mov = mt2.Mov AND mt2.Modulo = 'CXP'
JOIN Prov p  WITH (NOLOCK) ON c.Proveedor = p.Proveedor
JOIN MFARepCxpFisicasFiscalRegimen mtmfr WITH (NOLOCK)  ON p.FiscalRegimen = mtmfr.FiscalRegimen
LEFT OUTER JOIN MFARepCxpFisicasDevAdicion mtmda WITH (NOLOCK) ON mtmda.Modulo = 'CXP' AND mtmda.Mov = c.Mov
LEFT OUTER JOIN MFARepCxpFisicasDevExcepcion mtmde  WITH (NOLOCK) ON mtmde.Modulo = 'CXP' AND mtmde.Mov = c.Mov
LEFT OUTER JOIN MFARepCxpFisicasDevExcepcion mtmdeo  WITH (NOLOCK) ON mtmdeo.Modulo = 'CXP' AND mtmdeo.Mov = c.Mov
WHERE mtmde.Modulo IS NULL
AND mtmdeo.Modulo IS NULL
AND (mt.Clave IN ('CXP.NET', 'CXP.ANC') OR (mtmda.Modulo IS NOT NULL))
AND (mt2.Clave IN ('CXP.F'))
AND ((NULLIF(c.Origen,'') IS NULL AND NULLIF(c.OrigenTipo,'') IS NULL AND NULLIF(c.OrigenID,'') IS NULL) OR (c.OrigenTipo = 'CXP'))
AND c.Ejercicio     = CASE o.Estatus WHEN 'PENDIENTE' THEN c.Ejercicio WHEN 'CONCLUIDO' THEN @Ejercicio END
AND c.FechaEmision >= CASE o.Estatus WHEN 'PENDIENTE' THEN @FechaD WHEN 'CONCLUIDO' THEN c.FechaEmision END
AND c.FechaEmision <= CASE o.Estatus WHEN 'PENDIENTE' THEN @FechaA WHEN 'CONCLUIDO' THEN c.FechaEmision END
AND c.Estatus =('CONCLUIDO')
AND o.Estatus IN('PENDIENTE')
AND c.Empresa = @Empresa
/************** Pagos **************/
INSERT INTO #Movimentos(
Modulo,  ModuloID,   Empresa,   Mov,   MovID,   Proveedor,   Nombre,   FiscalRegimen,   Ejercicio,   Periodo,   FechaEmision,  Importe,                                                                Impuestos,    Estatus,   Aplica,   AplicaID,   FechaAplica,    EjercicioAplica,   PeriodoAplica)
SELECT 'CXP', c.ID,       c.Empresa, c.Mov, c.MovID, c.Proveedor, p.Nombre, p.FiscalRegimen, c.Ejercicio, c.Periodo, c.FechaEmision, (d.Importe)/(1+((((o.Impuestos*100.0)/o.Importe))/100.0))*c.TipoCambio*-1, 0,          c.Estatus, d.Aplica, d.AplicaID, o.FechaEmision, o.Ejercicio,       o.Periodo
FROM Cxp c WITH (NOLOCK) 
JOIN CxpD d  WITH (NOLOCK) ON c.ID = d.ID
JOIN Cxp o  WITH (NOLOCK) ON c.Empresa = o.Empresa AND d.Aplica = o.Mov AND d.AplicaID = o.MovID
JOIN MovTipo mt WITH (NOLOCK)  ON c.Mov = mt.Mov AND mt.Modulo = 'CXP'
JOIN MovTipo mt2  WITH (NOLOCK) ON o.Mov = mt2.Mov AND mt2.Modulo = 'CXP'
JOIN Prov p  WITH (NOLOCK) ON c.Proveedor = p.Proveedor
JOIN MFARepCxpFisicasFiscalRegimen mtmfr  WITH (NOLOCK) ON p.FiscalRegimen = mtmfr.FiscalRegimen
LEFT OUTER JOIN MFARepCxpFisicasDevAdicion mtmda  WITH (NOLOCK) ON mtmda.Modulo = 'CXP' AND mtmda.Mov = c.Mov
LEFT OUTER JOIN MFARepCxpFisicasDevExcepcion mtmde  WITH (NOLOCK) ON mtmde.Modulo = 'CXP' AND mtmde.Mov = c.Mov
LEFT OUTER JOIN MFARepCxpFisicasDevExcepcion mtmdeo WITH (NOLOCK)  ON mtmdeo.Modulo = 'CXP' AND mtmdeo.Mov = c.Mov
WHERE mtmde.Modulo IS NULL
AND mtmdeo.Modulo IS NULL
AND (mt.Clave IN ('CXP.P','CXP.NCP','CXP.DP') OR (mtmda.Modulo IS NOT NULL))
AND (mt2.Clave IN ('CXP.F'))
AND ((NULLIF(c.Origen,'') IS NULL AND NULLIF(c.OrigenTipo,'') IS NULL AND NULLIF(c.OrigenID,'') IS NULL) OR (c.OrigenTipo = 'CXP'))
AND c.Ejercicio     = CASE o.Estatus WHEN 'PENDIENTE' THEN c.Ejercicio WHEN 'CONCLUIDO' THEN @Ejercicio END
AND c.FechaEmision >= CASE o.Estatus WHEN 'PENDIENTE' THEN @FechaD WHEN 'CONCLUIDO' THEN c.FechaEmision END
AND c.FechaEmision <= CASE o.Estatus WHEN 'PENDIENTE' THEN @FechaA WHEN 'CONCLUIDO' THEN c.FechaEmision END
AND c.Estatus =('CONCLUIDO')
AND o.Estatus IN('PENDIENTE')
AND c.Empresa = @Empresa
END
IF @Estatus IN('CONCLUIDO', '(Todos)')
BEGIN
IF @Estatus = '(Todos)'
SELECT @FechaD = @FechaCierreD, @FechaA = @FechaCierreA, @Ejercicio = YEAR(@FechaCierreD) - 1
/************** Pagos **************/
INSERT INTO #Movimentos(
Modulo,  ModuloID,  Empresa,   Mov,   MovID,   Proveedor,   Nombre,   FiscalRegimen,   Ejercicio,   Periodo,   FechaEmision, Importe,                                                                                                                                                                                                                                                                                                                                          Impuestos,   Estatus,   Aplica,   AplicaID,   FechaAplica,    EjercicioAplica,   PeriodoAplica)
SELECT 'CXP', c.ID,      c.Empresa, c.Mov, c.MovID, c.Proveedor, p.Nombre, p.FiscalRegimen, c.Ejercicio, c.Periodo, c.FechaEmision, CASE ISNULL(o.Retencion, 0)+ISNULL(o.Retencion2, 0)+ISNULL(o.Retencion3, 0) WHEN 0 THEN (d.Importe)/(1+((((o.Impuestos*100.0)/o.Importe))/100.0))*c.TipoCambio ELSE ROUND((o.Importe*((d.Importe*100.0)/(o.Importe-(ISNULL(o.Retencion, 0)+ISNULL(o.Retencion2, 0)+ISNULL(o.Retencion3, 0))+ISNULL(o.Impuestos, 0))/100.0))*c.TipoCambio, 2) END, 0,         c.Estatus, d.Aplica, d.AplicaID, o.FechaEmision, o.Ejercicio,       o.Periodo
FROM Cxp c WITH (NOLOCK) 
JOIN CxpD d  WITH (NOLOCK) ON c.ID = d.ID
JOIN Cxp o WITH (NOLOCK)  ON c.Empresa = o.Empresa AND d.Aplica = o.Mov AND d.AplicaID = o.MovID
JOIN MovTipo mt  WITH (NOLOCK) ON c.Mov = mt.Mov AND mt.Modulo = 'CXP'
JOIN Prov p  WITH (NOLOCK) ON c.Proveedor = p.Proveedor
JOIN MFARepCxpFisicasFiscalRegimen mtmfr WITH (NOLOCK)  ON p.FiscalRegimen = mtmfr.FiscalRegimen
LEFT OUTER JOIN MFARepCxpFisicasPagoAdicion mtmda  WITH (NOLOCK) ON mtmda.Modulo = 'CXP' AND mtmda.Mov = c.Mov
LEFT OUTER JOIN MFARepCxpFisicasPagoExcepcion mtmde   WITH (NOLOCK) ON mtmde.Modulo = 'CXP' AND mtmde.Mov = c.Mov
LEFT OUTER JOIN MFARepCxpFisicasPagoExcepcion mtmdeo WITH (NOLOCK)  ON mtmdeo.Modulo = 'CXP' AND mtmdeo.Mov = d.Aplica
WHERE mtmde.Modulo IS NULL
AND mtmdeo.Modulo IS NULL
AND (mt.Clave IN ('CXP.P','CXP.NCP','CXP.DP') OR (mtmda.Modulo IS NOT NULL))
AND ((NULLIF(c.Origen,'') IS NULL AND NULLIF(c.OrigenTipo,'') IS NULL AND NULLIF(c.OrigenID,'') IS NULL) OR (c.OrigenTipo = 'CXP'))
AND c.FechaEmision BETWEEN @FechaD AND @FechaA
AND o.Ejercicio <= @Ejercicio
AND c.Estatus =('CONCLUIDO')
AND o.Estatus IN('PENDIENTE', 'CONCLUIDO')
AND c.Empresa = @Empresa
/************** Neteos y Aplicaciones **************/
INSERT INTO #Movimentos(
Modulo,  ModuloID,   Empresa,   Mov,   MovID,   Proveedor,   Nombre,   FiscalRegimen,   Ejercicio,   Periodo,   FechaEmision,    Importe,                                                             Impuestos,    Estatus,   Aplica,   AplicaID,   FechaAplica,    EjercicioAplica,   PeriodoAplica)
SELECT 'CXP', c.ID,       c.Empresa, c.Mov, c.MovID, c.Proveedor, p.Nombre, p.FiscalRegimen, c.Ejercicio, c.Periodo, c.FechaEmision, (d.Importe)/(1+((((o.Impuestos*100.0)/o.Importe))/100.0))*c.TipoCambio, 0,          c.Estatus, d.Aplica, d.AplicaID, o.FechaEmision, o.Ejercicio,       o.Periodo
FROM Cxp c WITH (NOLOCK) 
JOIN CxpD d  WITH (NOLOCK) ON c.ID = d.ID
JOIN Cxp o  WITH (NOLOCK) ON c.Empresa = o.Empresa AND d.Aplica = o.Mov AND d.AplicaID = o.MovID
JOIN MovTipo mt  WITH (NOLOCK) ON c.Mov = mt.Mov AND mt.Modulo = 'CXP'
JOIN MovTipo mt2  WITH (NOLOCK) ON o.Mov = mt2.Mov AND mt2.Modulo = 'CXP'
JOIN Prov p  WITH (NOLOCK) ON c.Proveedor = p.Proveedor
JOIN MFARepCxpFisicasFiscalRegimen mtmfr  WITH (NOLOCK) ON p.FiscalRegimen = mtmfr.FiscalRegimen
LEFT OUTER JOIN MFARepCxpFisicasDevAdicion mtmda  WITH (NOLOCK) ON mtmda.Modulo = 'CXP' AND mtmda.Mov = c.Mov
LEFT OUTER JOIN MFARepCxpFisicasDevExcepcion mtmde  WITH (NOLOCK) ON mtmde.Modulo = 'CXP' AND mtmde.Mov = c.Mov
LEFT OUTER JOIN MFARepCxpFisicasDevExcepcion mtmdeo WITH (NOLOCK)  ON mtmdeo.Modulo = 'CXP' AND mtmdeo.Mov = c.Mov
WHERE mtmde.Modulo IS NULL
AND mtmdeo.Modulo IS NULL
AND (mt.Clave IN ('CXP.NET') OR (mtmda.Modulo IS NOT NULL))
AND (mt2.Clave IN ('CXP.F'))
AND ((NULLIF(c.Origen,'') IS NULL AND NULLIF(c.OrigenTipo,'') IS NULL AND NULLIF(c.OrigenID,'') IS NULL) OR (c.OrigenTipo = 'CXP'))
AND c.FechaEmision BETWEEN @FechaD AND @FechaA
AND o.Ejercicio <= @Ejercicio
AND c.Estatus =('CONCLUIDO')
AND o.Estatus IN('PENDIENTE', 'CONCLUIDO')
AND c.Empresa = @Empresa
END
IF @Procesar = 0
SELECT * FROM #Movimentos ORDER BY Proveedor, Modulo
ELSE IF @Procesar = 1 AND @Estatus IN('PENDIENTE', 'CONCLUIDO', '(Todos)')
BEGIN
SELECT @Fecha = GETDATE()
IF @Estatus = 'PENDIENTE'
SELECT @Reporte = 40, @ClaveBC = 28, @Concepto = Concepto FROM MFARepCxpFisicas WITH (NOLOCK)  WHERE Empresa = @Empresa AND Estatus = @Estatus
ELSE IF @Estatus = 'CONCLUIDO'
SELECT @Reporte = 40, @ClaveBC = 50, @Concepto = Concepto FROM MFARepCxpFisicas WITH (NOLOCK)  WHERE Empresa = @Empresa AND Estatus = @Estatus
ELSE IF @Estatus = '(Todos)'
SELECT @Reporte = 40, @ClaveBC = 28, @Concepto = Concepto FROM MFARepCxpFisicas WITH (NOLOCK)  WHERE Empresa = @Empresa AND Estatus = 'PENDIENTE'
DELETE MFAAjustesCalculo WHERE Empresa = @Empresa AND Ejercicio = YEAR(@Fecha) AND Reporte = @Reporte AND ClaveBC = @ClaveBC
INSERT INTO MFAAjustesCalculo(
Empresa,  Reporte,  ClaveBC,  Fecha,  Ejercicio,   Periodo, Importe,                  Concepto)
SELECT @Empresa, @Reporte, @ClaveBC, @Fecha, YEAR(@Fecha), 12,      ISNULL(SUM(Importe), 0), @Concepto
FROM #Movimentos
SELECT 'Proceso Concluido'
END
RETURN
END

