SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spDIOTObtenerAnticipo
@Estacion		int,
@Empresa		varchar(5),
@FechaD			datetime,
@FechaA			datetime

AS
BEGIN
EXEC xpDIOTObtenerAnticipo @Estacion, @Empresa, @FechaD, @FechaA
IF NOT EXISTS (SELECT 1 FROM #Pagos WHERE TipoInsert = 2)
BEGIN
INSERT INTO #Pagos(ID,   Empresa,   Mov,   MovID,   Ejercicio,   Periodo,   FechaEmision,   Aplica,   AplicaID, Importe,
TipoCambio,   Dinero,   DineroID,   FechaConciliacion,       EsAnticipo,   DineroMov,   DineroMovID,
DineroMov2, DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID, TipoInsert
)
SELECT c.ID, c.Empresa, c.Mov, c.MovID, c.Ejercicio, c.Periodo, c.FechaEmision, c.Mov,    c.MovID,   (c.Importe+ISNULL(c.Impuestos, 0))*c.TipoCambio,
c.TipoCambio, c.Dinero, c.DineroID, c.DineroFechaConciliacion, 1,          d.Mov,       d.MovID,
t.Mov, t.MovID, t.FormaPago, t.Importe,t.ContID, t.ContMov, t.ContMovID, 2
FROM Dinero d
JOIN MovFlujo mf ON d.ID = mf.DID AND mf.OModulo = 'CXP' AND DModulo = 'DIN'
JOIN Cxp c ON d.OrigenTipo = 'CXP' AND d.Origen = c.Mov AND d.OrigenID = c.MovID AND d.Empresa = c.Empresa AND c.ID = mf.OID
JOIN #Tesoreria t ON d.ID = t.ID AND c.ID = t.OrigenIID
JOIN MovTipo mt ON mt.Mov = d.Mov AND mt.Modulo = 'DIN'
JOIN MovTipo mt2 ON mt2.Mov = c.Mov AND mt2.Modulo = 'CXP'
JOIN Version ver ON 1 = 1
LEFT OUTER JOIN DIOTPagoAdicion mtmda ON mtmda.Mov = c.Mov AND ISNULL(mtmda.Aplica, c.Mov) = c.Mov
LEFT OUTER JOIN DIOTPagoExcepcion mtmde ON mtmde.Mov = c.Mov AND ISNULL(mtmde.Aplica, c.Mov) = c.Mov
LEFT OUTER JOIN DIOTPagoConciliado mtdc ON mtdc.Mov = c.Mov AND ISNULL(mtdc.Aplica, c.Mov) = c.Mov
JOIN DIOTCfg ON c.Empresa = DIOTCfg.Empresa
WHERE c.Estatus IN ('PENDIENTE','CONCLUIDO')
AND d.Estatus IN ('PENDIENTE','CONCLUIDO', 'CONCILIADO')
AND (mt.Clave IN ('DIN.CH', 'DIN.CHE', 'DIN.D', 'DIN.DE', 'DIN.E'))
AND (mt2.Clave IN ('CXP.A'))
AND c.Empresa = @Empresa
EXCEPT
SELECT ID,   Empresa,   Mov,   MovID,   Ejercicio,   Periodo,   FechaEmision,   Aplica,   AplicaID, Importe,
TipoCambio,   Dinero,   DineroID,   FechaConciliacion,       EsAnticipo,   DineroMov,   DineroMovID,
DineroMov2, DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID, TipoInsert
FROM #Pagos
INSERT INTO #Pagos(ID, Empresa, Mov, MovID, Ejercicio, Periodo, FechaEmision, Aplica, AplicaID, Importe,
TipoCambio, Dinero, DineroID, FechaConciliacion, EsAnticipo, DineroMov, DineroMovID,
DineroMov2, DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID, TipoInsert)
SELECT c.ID, c.Empresa, c.Mov, c.MovID, c.Ejercicio, c.Periodo, c.FechaEmision, c.Mov, c.MovID, (c.Importe+ISNULL(c.Impuestos, 0))*c.TipoCambio,
c.TipoCambio, c.Dinero, c.DineroID, c.DineroFechaConciliacion, 1, d.Mov, d.MovID,
t.Mov, t.MovID, t.FormaPago, t.Importe,t.ContID, t.ContMov, t.ContMovID, 2
FROM Dinero d
JOIN MovFlujo mf ON d.ID = mf.DID AND mf.OModulo = 'DIN' AND DModulo = 'DIN'
JOIN Dinero d2 ON d2.ID = mf.OID
JOIN MovTipo mt ON mt.Mov = d.Mov AND mt.Modulo = 'DIN'
JOIN MovTipo mt2 ON mt2.Mov = d2.Mov AND mt2.Modulo = 'DIN'
JOIN Cxp c ON d2.OrigenTipo = 'CXP' AND d2.Origen = c.Mov AND d2.OrigenID = c.MovID AND d2.Empresa = c.Empresa
JOIN #Tesoreria t ON d.ID = t.ID AND c.ID = t.OrigenIID
JOIN MovTipo mt3 ON mt3.Mov = c.Mov AND mt3.Modulo = 'CXP'
JOIN Version ver ON 1 = 1
LEFT OUTER JOIN DIOTPagoAdicion mtmda ON mtmda.Mov = c.Mov AND ISNULL(mtmda.Aplica, c.Mov) = c.Mov
LEFT OUTER JOIN DIOTPagoExcepcion mtmde ON mtmde.Mov = c.Mov AND ISNULL(mtmde.Aplica, c.Mov) = c.Mov
LEFT OUTER JOIN DIOTPagoConciliado mtdc ON mtdc.Mov = c.Mov AND ISNULL(mtdc.Aplica, c.Mov) = c.Mov
JOIN DIOTCfg ON c.Empresa = DIOTCfg.Empresa
WHERE c.Estatus IN ('PENDIENTE','CONCLUIDO')
AND d2.Estatus IN ('PENDIENTE','CONCLUIDO')
AND d.Estatus IN ('PENDIENTE','CONCLUIDO', 'CONCILIADO')
AND (mt.Clave IN ('DIN.CH', 'DIN.CHE', 'DIN.D', 'DIN.DE'))
AND (mt2.Clave IN ('DIN.SCH', 'DIN.SD'))
AND (mt3.Clave IN ('CXP.A'))
AND c.Empresa = @Empresa
EXCEPT
SELECT ID,   Empresa,   Mov,   MovID,   Ejercicio,   Periodo,   FechaEmision,   Aplica,   AplicaID, Importe,
TipoCambio,   Dinero,   DineroID,   FechaConciliacion,       EsAnticipo,   DineroMov,   DineroMovID,
DineroMov2, DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID, TipoInsert
FROM #Pagos
END
END

