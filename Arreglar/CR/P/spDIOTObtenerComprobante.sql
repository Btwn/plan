SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spDIOTObtenerComprobante
@Estacion		int,
@Empresa		varchar(5),
@FechaD			datetime,
@FechaA			datetime

AS
BEGIN
EXEC xpDIOTObtenerComprobante @Estacion, @Empresa, @FechaD, @FechaA
IF NOT EXISTS (SELECT 1 FROM #Pagos WHERE TipoInsert = 3)
INSERT INTO #Pagos(ID, Empresa, Mov, MovID, Ejercicio, Periodo, FechaEmision, Aplica, AplicaID, Importe,
TipoCambio, Dinero, DineroID, FechaConciliacion, EsComprobante, DineroMov, DineroMovID,
DineroMov2, DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID, TipoInsert
)
SELECT c.ID, c.Empresa, c.Mov, c.MovID, c.Ejercicio, c.Periodo, c.FechaEmision, c.Mov, c.MovID, SUM((ISNULL(cd.Importe,0.0)+ISNULL(cd.Impuestos,0.0)+ISNULL(cd.Impuestos2,0.0)-ISNULL(cd.Retencion,0.0)-ISNULL(cd.Retencion2,0.0))*c.TipoCambio),
c.TipoCambio, c.Dinero, c.DineroID, c.DineroFechaConciliacion, 1, c.Dinero, c.DineroID,
t.Mov, t.MovID, t.FormaPago, t.Importe,t.ContID, t.ContMov, t.ContMovID, 3
FROM Gasto c
JOIN GastoD cd ON cd.ID = c.ID
JOIN #Tesoreria t ON t.OrigenTipo = 'GAS' AND t.OrigenMID = c.ID AND c.Dinero = t.Mov AND c.DineroID = t.MovID
JOIN MovTipo mt ON mt.Mov = c.Mov AND mt.Modulo = 'GAS'
JOIN DIOTConcepto co ON co.Concepto = cd.Concepto
LEFT OUTER JOIN DIOTPagoConciliado mtdc ON mtdc.Mov = c.Mov AND ISNULL(mtdc.Aplica, c.Mov) = c.Mov
JOIN DIOTCfg ON c.Empresa = DIOTCfg.Empresa
WHERE c.Estatus IN ('PENDIENTE','CONCLUIDO')
AND (mt.Clave IN ('GAS.C'))
AND cd.Importe IS NOT NULL
AND c.Empresa = @Empresa
GROUP BY c.ID, c.Empresa, c.Mov, c.MovID, c.Ejercicio, c.Periodo, c.FechaEmision, c.Mov, c.MovID,
c.TipoCambio, c.Dinero, c.DineroID, c.DineroFechaConciliacion, c.Dinero, c.DineroID,
t.Mov, t.MovID, t.FormaPago, t.Importe,t.ContID, t.ContMov, t.ContMovID
EXCEPT
SELECT ID, Empresa, Mov, MovID, Ejercicio, Periodo, FechaEmision, Aplica, AplicaID, Importe,
TipoCambio, Dinero, DineroID, FechaConciliacion, EsComprobante, DineroMov, DineroMovID,
DineroMov2, DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID, TipoInsert
FROM #Pagos
INSERT INTO #Documentos(ID, Empresa, Pago, PagoID, Mov, MovID, Ejercicio, Periodo, FechaEmision, Proveedor,
Nombre, RFC, ImportadorRegistro, Pais, Nacionalidad, TipoDocumento, TipoTercero,
Importe, BaseIVA, Tasa, IVA, ConceptoClave, Concepto, EsImportacion, EsExcento,
IEPS, ISAN, Retencion1, Retencion2, PorcentajeDeducible,
DineroMov2,	DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID, TipoInsert
)
SELECT c.ID, c.Empresa, c.Mov, c.MovID, c.Mov, c.MovID, c.Ejercicio, c.Periodo, c.FechaEmision, ISNULL(NULLIF(RTRIM(cd.AcreedorRef), ''), c.Acreedor),
p.Nombre, p.RFC, p.ImportadorRegistro, dp.Pais, dp.Nacionalidad, dbo.fnDIOTTipoDocumento('GAS', c.Mov), dbo.fnDIOTTipoTercero(c.Acreedor),
cd.Importe*c.TipoCambio, (ISNULL(cd.Importe,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(cd.Impuestos2,0.0) ELSE 0.0 END)*c.TipoCambio, CASE WHEN NULLIF(cd.Impuestos,0.0) IS NULL THEN NULL ELSE cd.Impuesto1 END, ISNULL(cd.Impuestos,0.0)*c.TipoCambio, cd.Concepto,   cd.Concepto, dbo.fnDIOTEsImportacion('GAS', c.Mov), ISNULL(Concepto.Impuesto1Excento,0), ISNULL(cd.Impuestos2,0.0)*c.TipoCambio, 0.0, cd.Retencion*c.TipoCambio, cd.Retencion2*c.TipoCambio, cd.PorcentajeDeducible,
t.Mov, t.MovID, t.FormaPago, t.Importe,t.ContID, t.ContMov, t.ContMovID, 3
FROM Gasto c
JOIN GastoD cd ON cd.ID = c.ID
JOIN #Tesoreria t ON t.OrigenTipo = 'GAS' AND t.OrigenMID = c.ID AND c.Dinero = t.Mov AND c.DineroID = t.MovID
JOIN MovTipo mt ON mt.Mov = c.Mov AND mt.Modulo = 'GAS'
JOIN Concepto ON cd.Concepto = Concepto.Concepto AND Concepto.Modulo = 'GAS'
JOIN DIOTConcepto co ON co.Concepto = cd.Concepto
JOIN Prov p ON p.Proveedor = ISNULL(NULLIF(RTRIM(cd.AcreedorRef), ''), c.Acreedor)
LEFT OUTER JOIN Pais ON p.Pais = Pais.Pais
LEFT OUTER JOIN DIOTPais dp ON Pais.Pais = dp.Pais
LEFT OUTER JOIN DIOTPagoConciliado mtdc ON mtdc.Mov = c.Mov AND ISNULL(mtdc.Aplica, c.Mov) = c.Mov
JOIN DIOTCfg ON c.Empresa = DIOTCfg.Empresa
JOIN Version ver ON 1=1
WHERE c.Estatus IN ('PENDIENTE','CONCLUIDO')
AND (mt.Clave IN ('GAS.C'))
AND cd.Importe IS NOT NULL
AND c.Empresa = @Empresa
END

