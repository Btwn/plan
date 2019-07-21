SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spDIOTObtenerPago
@Estacion		int,
@Empresa		varchar(5),
@FechaD			datetime,
@FechaA			datetime

AS
BEGIN
EXEC xpDIOTObtenerPago @Estacion, @Empresa, @FechaD, @FechaA
IF NOT EXISTS (SELECT 1 FROM #Pagos WHERE TipoInsert = 1)
INSERT INTO #Tesoreria( Empresa, ID, Mov, MovID, RID, FormaPago,
Importe,FechaEmision, OrigenTipo, OrigenIID, Origen,
OrigenMID,ContID, ContMov, ContMovID)
SELECT A.Empresa, A.IDRaiz, A.MovRaiz, A.MovIDRaiz, C.Renglon,ISNULL(C.FormaPago,B.FormaPago),
ISNULL(C.Importe,ISNULL(B.Importe,0)),B.FechaEmision, A.OModulo, E.ID, A.OMov,
A.OID, B.ContID, D.Mov, D.MovID
FROM #Movtos A
LEFT JOIN Dinero B ON A.IDRaiz = B.ID
LEFT JOIN DineroD C ON A.IDRaiz = C.ID AND B.Origen = C.Aplica AND B.OrigenID = C.AplicaID
LEFT JOIN Cont D ON B.ContID = D.ID
LEFT JOIN Cxp E ON A.Empresa = E.Empresa
AND A.OModulo = 'CXP'
AND A.OID= E.ID
EXCEPT
SELECT Empresa, ID, Mov, MovID, RID, FormaPago,
Importe,FechaEmision, OrigenTipo, OrigenIID, Origen,
OrigenMID,ContID, ContMov, ContMovID
FROM #Tesoreria
INSERT INTO #Pagos(ID, Empresa, Mov, MovID, Ejercicio, Periodo, FechaEmision, Aplica, AplicaID, Importe,
TipoCambio, Dinero, DineroID, FechaConciliacion, DineroMov, DineroMovID,
DineroMov2, DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID,TipoInsert
)
SELECT c.ID, c.Empresa, c.Mov, c.MovID, c.Ejercicio, c.Periodo, CASE ISNULL(mtdc.Mov, '') WHEN '' THEN c.FechaEmision ELSE c.DineroFechaConciliacion END, d.Aplica, d.AplicaID, d.Importe*c.TipoCambio,
c.TipoCambio, c.Dinero, c.DineroID, c.DineroFechaConciliacion, c.Dinero, c.DineroID,
t.Mov, t.MovID, t.FormaPago, t.Importe,t.ContID, t.ContMov, t.ContMovID,1
FROM Cxp c
JOIN #Tesoreria t ON c.ID = t.OrigenIID AND c.Dinero = t.Mov AND c.DineroID = t.MovID
JOIN CxpD d ON c.ID = d.ID
JOIN Cxp o ON c.Empresa = o.Empresa AND d.Aplica = o.Mov AND d.AplicaID = o.MovID
JOIN MovTipo mt ON c.Mov = mt.Mov AND mt.Modulo = 'CXP'
JOIN Prov p ON c.Proveedor = p.Proveedor
LEFT OUTER JOIN DIOTPagoAdicion mtmda ON mtmda.Mov = c.Mov AND ISNULL(mtmda.Aplica, d.Aplica) = d.Aplica
LEFT OUTER JOIN DIOTPagoExcepcion mtmde ON mtmde.Mov = c.Mov AND ISNULL(mtmde.Aplica, d.Aplica) = d.Aplica
LEFT OUTER JOIN DIOTPagoConciliado mtdc ON mtdc.Mov = c.Mov AND ISNULL(mtdc.Aplica, d.Aplica) = d.Aplica
JOIN DIOTCfg ON c.Empresa = DIOTCfg.Empresa
WHERE mtmde.Mov IS NULL
AND (mt.Clave IN (SELECT Clave FROM DIOTPagoClave) OR (mtmda.Mov IS NOT NULL))
AND ((NULLIF(c.Origen,'') IS NULL AND NULLIF(c.OrigenTipo,'') IS NULL AND NULLIF(c.OrigenID,'') IS NULL) OR (c.OrigenTipo = 'CXP'))
AND CASE ISNULL(mtdc.Mov, '') WHEN '' THEN c.FechaEmision ELSE c.DineroFechaConciliacion END BETWEEN @FechaD AND @FechaA
AND c.Empresa = @Empresa
INSERT INTO #Pagos(ID, Empresa, Mov, MovID, Ejercicio, Periodo, FechaEmision, Aplica, AplicaID, Importe,
TipoCambio, Dinero, DineroID, FechaConciliacion, DineroMov, DineroMovID,
DineroMov2, DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID,TipoInsert
)
SELECT c.ID, c.Empresa, c.Mov, c.MovID, c.Ejercicio, c.Periodo, CASE mtmda.Mov WHEN NULL THEN c.FechaEmision ELSE c2.FechaEmision END, d.Aplica, d.AplicaID, d.Importe*c.TipoCambio,
c.TipoCambio, c.Dinero, c.DineroID, CASE mtmda.Mov WHEN NULL THEN c.DineroFechaConciliacion ELSE c2.DineroFechaConciliacion END,  c.Dinero,	 c.DineroID,
NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1
FROM Cxp c
JOIN CxpD d ON c.ID = d.ID
JOIN Cxp o ON c.Empresa = o.Empresa AND d.Aplica = o.Mov AND d.AplicaID = o.MovID
JOIN MovTipo mt ON c.Mov = mt.Mov AND mt.Modulo = 'CXP'
JOIN Prov p ON c.Proveedor = p.Proveedor
LEFT OUTER JOIN MovTipo mt2 ON mt2.Modulo = c.OrigenTipo AND mt2.Mov = c.Origen
LEFT OUTER JOIN CxpD d2 ON d2.Aplica = c.Mov AND d2.AplicaID = c.MovID
LEFT OUTER JOIN Cxp c2 ON c2.ID = d2.ID AND c2.Empresa = c.Empresa
LEFT OUTER JOIN DIOTPagoAdicion mtmda ON mtmda.Mov = c.Mov AND ISNULL(mtmda.Aplica, d.Aplica) = d.Aplica
LEFT OUTER JOIN DIOTPagoExcepcion mtmde ON mtmde.Mov = c.Mov AND ISNULL(mtmde.Aplica, d.Aplica) = d.Aplica
LEFT OUTER JOIN DIOTPagoConciliado mtdc ON mtdc.Mov = c.Mov AND ISNULL(mtdc.Aplica, d.Aplica) = d.Aplica
JOIN DIOTCfg ON c.Empresa = DIOTCfg.Empresa
WHERE mtmde.Mov IS NULL
AND (mt.Clave IN (SELECT Clave FROM DIOTPagoClave) OR (mtmda.Mov IS NOT NULL))
AND mt.Clave = 'CXP.ANC'
AND mt2.Clave NOT IN ('CXP.NC')
AND ((NULLIF(c.Origen,'') IS NULL AND NULLIF(c.OrigenTipo,'') IS NULL AND NULLIF(c.OrigenID,'') IS NULL) OR (c.OrigenTipo = 'CXP'))
AND CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mtmda.Mov WHEN NULL THEN c.FechaEmision ELSE c2.FechaEmision END ELSE CASE mtmda.Mov WHEN NULL THEN c.DineroFechaConciliacion ELSE c2.DineroFechaConciliacion END END BETWEEN @FechaD AND @FechaA
AND c.Estatus =('CONCLUIDO')
AND o.Estatus IN('PENDIENTE', 'CONCLUIDO')
AND ISNULL(c2.Estatus, 'CONCLUIDO') = 'CONCLUIDO'
AND c.Empresa = @Empresa
INSERT INTO #Pagos(ID, Empresa, Mov, MovID, Ejercicio, Periodo, FechaEmision, Aplica, AplicaID, Importe,
TipoCambio, Dinero, DineroID, FechaConciliacion, DineroMov, DineroMovID,
DineroMov2, DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID,TipoInsert
)
SELECT c.ID, c.Empresa, c.Mov, c.MovID, c.Ejercicio, c.Periodo, CASE mtmda.Mov WHEN NULL THEN c.FechaEmision ELSE c2.FechaEmision END, c.Origen, c.OrigenID, d.Importe*c.TipoCambio,
c.TipoCambio, c.Dinero, c.DineroID, CASE mtmda.Mov WHEN NULL THEN c.DineroFechaConciliacion ELSE c2.DineroFechaConciliacion END,  c.Dinero,	 c.DineroID,
NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1
FROM Cxp c
JOIN CxpD d ON c.ID = d.ID
JOIN Cxp o ON c.Empresa = o.Empresa AND d.Aplica = o.Mov AND d.AplicaID = o.MovID
JOIN MovTipo mt ON c.Mov = mt.Mov AND mt.Modulo = 'CXP'
JOIN Prov p ON c.Proveedor = p.Proveedor
LEFT OUTER JOIN MovTipo mt2 ON mt2.Modulo = c.OrigenTipo AND mt2.Mov = c.Origen
LEFT OUTER JOIN CxpD d2 ON d2.Aplica = c.Mov AND d2.AplicaID = c.MovID
LEFT OUTER JOIN Cxp c2 ON c2.ID = d2.ID AND c2.Empresa = c.Empresa
LEFT OUTER JOIN DIOTPagoAdicion mtmda ON mtmda.Mov = c.Mov AND ISNULL(mtmda.Aplica, d.Aplica) = d.Aplica
LEFT OUTER JOIN DIOTPagoExcepcion mtmde ON mtmde.Mov = c.Mov AND ISNULL(mtmde.Aplica, d.Aplica) = d.Aplica
LEFT OUTER JOIN DIOTPagoConciliado mtdc ON mtdc.Mov = c.Mov AND ISNULL(mtdc.Aplica, d.Aplica) = d.Aplica
JOIN DIOTCfg ON c.Empresa = DIOTCfg.Empresa
WHERE mtmde.Mov IS NULL
AND (mt.Clave IN (SELECT Clave FROM DIOTPagoClave) OR (mtmda.Mov IS NOT NULL))
AND mt.Clave = 'CXP.ANC'
AND mt2.Clave IN ('CXP.NC')
AND ((NULLIF(c.Origen,'') IS NULL AND NULLIF(c.OrigenTipo,'') IS NULL AND NULLIF(c.OrigenID,'') IS NULL) OR (c.OrigenTipo = 'CXP'))
AND CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mtmda.Mov WHEN NULL THEN c.FechaEmision ELSE c2.FechaEmision END ELSE CASE mtmda.Mov WHEN NULL THEN c.DineroFechaConciliacion ELSE c2.DineroFechaConciliacion END END BETWEEN @FechaD AND @FechaA
AND c.Estatus =('CONCLUIDO')
AND o.Estatus IN('PENDIENTE', 'CONCLUIDO')
AND ISNULL(c2.Estatus, 'CONCLUIDO') = 'CONCLUIDO'
AND c.Empresa = @Empresa
RETURN
END

