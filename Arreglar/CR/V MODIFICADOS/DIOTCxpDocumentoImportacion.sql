SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW DIOTCxpDocumentoImportacion AS
SELECT
Origen				 = c.Origen,
OrigenID				 = c.OrigenID,
Estatus                = c.Estatus,
ID					 = RTRIM(LTRIM(CONVERT(varchar,c.ID))),
Empresa                = c.Empresa,
Cxp.Mov,
Cxp.MovID,
Cxp.FechaEmision,
Ejercicio              = Cxp.Ejercicio,
Periodo                = Cxp.Periodo,
Dia                    = DAY(Cxp.FechaEmision),
Cxp.Proveedor,
Concepto               = d.Concepto,
Importe                = Cxp.Importe*Cxp.TipoCambio,
Retencion1			 = 0.0,
Retencion2			 = Cxp.Retencion*Cxp.TipoCambio,
IVA                    = dbo.fnDIOTIVA(Cxp.Importe,Cxp.Impuestos)*Cxp.TipoCambio,
Tasa                   = dbo.fnDIOTIVATasa(Cxp.Empresa, Cxp.Importe,Cxp.Impuestos),
IEPS                   = (ISNULL(CONVERT(float,Cxp.Importe),0.0)/NULLIF((1.0-ISNULL(CONVERT(float,Cxp.IEPSFiscal),0.0)),0.0))*ISNULL(CONVERT(float,Cxp.IEPSFiscal),0.0)*Cxp.TipoCambio,
ISAN                   = 0.0
FROM Cxp WITH (NOLOCK)
JOIN Gasto c WITH (NOLOCK)   ON c.MovID = Cxp.OrigenID AND c.Mov = Cxp.Origen AND Cxp.OrigenTipo = 'GAS' AND C.Empresa = Cxp.Empresa
JOIN Compra com WITH (NOLOCK) ON com.MovID = c.OrigenID AND com.Mov = c.Origen AND c.OrigenTipo = 'COMS' AND com.Empresa = Cxp.Empresa
JOIN GastoD d WITH (NOLOCK)  ON c.ID = d.ID
JOIN MovTipo mt WITH (NOLOCK) ON mt.Mov = c.Mov AND mt.Modulo = 'CXP'
JOIN EmpresaGral eg WITH (NOLOCK) ON eg.Empresa = c.Empresa
JOIN Concepto co WITH (NOLOCK) ON co.Concepto = d.Concepto AND co.Modulo = 'COMSG'
JOIN Version ver WITH (NOLOCK) ON 1 = 1
JOIN DIOTCfg WITH (NOLOCK) ON Cxp.Empresa = DIOTCfg.Empresa
LEFT OUTER JOIN CxpD cd WITH (NOLOCK) ON cd.ID = c.ID
WHERE Cxp.Estatus IN ('PENDIENTE','CONCLUIDO')
AND (mt.Clave IN ('CXP.AF','CXP.CA','CXP.F','CXP.NC','CXP.CA','CXP.A','CXP.CD','CXP.D'))
AND Cxp.OrigenTipo IN ('GAS')
AND ISNULL(com.ProrrateoAplicaID, 0) = 0
UNION ALL
SELECT
Origen				 = c.Origen,
OrigenID				 = c.OrigenID,
Estatus                = c.Estatus,
ID					 = RTRIM(LTRIM(CONVERT(varchar,c.ID))),
Empresa                = c.Empresa,
c.Mov,
c.MovID,
c.FechaEmision,
Ejercicio              = c.Ejercicio,
Periodo                = c.Periodo,
Dia                    = DAY(c.FechaEmision),
c.Proveedor,
Concepto               = c.Concepto,
Importe                = c.Importe*c.TipoCambio,
Retencion1			 = 0.0,
Retencion2			 = c.Retencion*c.TipoCambio,
IVA                    = dbo.fnDIOTIVA(c.Importe,c.Impuestos)*c.TipoCambio,
Tasa                   = dbo.fnDIOTIVATasa(c.Empresa, c.Importe,c.Impuestos),
IEPS                   = (ISNULL(CONVERT(float,c.Importe),0.0)/NULLIF((1.0-ISNULL(CONVERT(float,c.IEPSFiscal),0.0)),0.0))*ISNULL(CONVERT(float,c.IEPSFiscal),0.0)*c.TipoCambio,
ISAN                   = 0.0
FROM Cxp c WITH (NOLOCK)
JOIN Compra com WITH (NOLOCK) ON com.MovID = c.OrigenID AND com.Mov = c.Origen AND c.OrigenTipo = 'COMS' AND com.Empresa = c.Empresa
JOIN MovTipo mt WITH (NOLOCK) ON mt.Mov = c.Mov AND mt.Modulo = 'CXP'
JOIN EmpresaGral eg WITH (NOLOCK) ON eg.Empresa = c.Empresa
JOIN Concepto co WITH (NOLOCK) ON co.Concepto = c.Concepto AND co.Modulo = 'COMSG'
JOIN Version ver WITH (NOLOCK) ON 1 = 1
JOIN DIOTCfg WITH (NOLOCK) ON c.Empresa = DIOTCfg.Empresa
LEFT OUTER JOIN CxpD cd WITH (NOLOCK) ON cd.ID = c.ID
WHERE c.Estatus IN ('PENDIENTE','CONCLUIDO')
AND (mt.Clave IN ('CXP.AF','CXP.CA','CXP.F','CXP.NC','CXP.CA','CXP.A','CXP.CD','CXP.D'))
AND c.OrigenTipo IN ('COMS')
AND ISNULL(com.ProrrateoAplicaID, 0) = 0
UNION ALL
SELECT
Origen				 = o.Mov,
OrigenID				 = o.MovID,
Estatus                = c.Estatus,
ID					 = RTRIM(LTRIM(CONVERT(varchar,c.ID))),
Empresa                = c.Empresa,
Cxp.Mov,
Cxp.MovID,
Cxp.FechaEmision,
Ejercicio              = Cxp.Ejercicio,
Periodo                = Cxp.Periodo,
Dia                    = DAY(Cxp.FechaEmision),
Cxp.Proveedor,
Concepto               = d.Concepto,
Importe                = Cxp.Importe*Cxp.TipoCambio,
Retencion1			 = 0.0,
Retencion2			 = Cxp.Retencion*Cxp.TipoCambio,
IVA                    = dbo.fnDIOTIVA(Cxp.Importe,Cxp.Impuestos)*Cxp.TipoCambio,
Tasa                   = dbo.fnDIOTIVATasa(Cxp.Empresa, Cxp.Importe,Cxp.Impuestos),
IEPS                   = (ISNULL(CONVERT(float,Cxp.Importe),0.0)/NULLIF((1.0-ISNULL(CONVERT(float,Cxp.IEPSFiscal),0.0)),0.0))*ISNULL(CONVERT(float,Cxp.IEPSFiscal),0.0)*Cxp.TipoCambio,
ISAN                   = 0.0
FROM Cxp WITH (NOLOCK)
JOIN Gasto c WITH (NOLOCK)   ON c.MovID = Cxp.OrigenID AND c.Mov = Cxp.Origen AND Cxp.OrigenTipo = 'GAS' AND C.Empresa = Cxp.Empresa
JOIN Compra com WITH (NOLOCK) ON com.MovID = c.OrigenID AND com.Mov = c.Origen AND c.OrigenTipo = 'COMS' AND com.Empresa = Cxp.Empresa
JOIN GastoD d WITH (NOLOCK)  ON c.ID = d.ID
JOIN Compra o WITH (NOLOCK)  ON O.ID = com.ProrrateoAplicaID
JOIN MovTipo mt WITH (NOLOCK) ON mt.Mov = c.Mov AND mt.Modulo = 'CXP'
JOIN EmpresaGral eg WITH (NOLOCK) ON eg.Empresa = c.Empresa
JOIN Concepto co WITH (NOLOCK) ON co.Concepto = d.Concepto AND co.Modulo = 'COMSG'
JOIN Version ver WITH (NOLOCK) ON 1 = 1
JOIN DIOTCfg WITH (NOLOCK) ON Cxp.Empresa = DIOTCfg.Empresa
LEFT OUTER JOIN CxpD cd WITH (NOLOCK) ON cd.ID = c.ID
WHERE Cxp.Estatus IN ('PENDIENTE','CONCLUIDO')
AND (mt.Clave IN ('CXP.AF','CXP.CA','CXP.F','CXP.NC','CXP.CA','CXP.A','CXP.CD','CXP.D'))
AND Cxp.OrigenTipo IN ('GAS')
AND ISNULL(com.ProrrateoAplicaID, 0) <> 0
UNION ALL
SELECT
Origen				 = o.Mov,
OrigenID				 = o.MovID,
Estatus                = c.Estatus,
ID					 = RTRIM(LTRIM(CONVERT(varchar,c.ID))),
Empresa                = c.Empresa,
c.Mov,
c.MovID,
c.FechaEmision,
Ejercicio              = c.Ejercicio,
Periodo                = c.Periodo,
Dia                    = DAY(c.FechaEmision),
c.Proveedor,
Concepto               = c.Concepto,
Importe                = c.Importe*c.TipoCambio,
Retencion1			 = 0.0,
Retencion2			 = c.Retencion*c.TipoCambio,
IVA                    = dbo.fnDIOTIVA(c.Importe,c.Impuestos)*c.TipoCambio,
Tasa                   = dbo.fnDIOTIVATasa(c.Empresa,c.Importe,c.Impuestos),
IEPS                   = (ISNULL(CONVERT(float,c.Importe),0.0)/NULLIF((1.0-ISNULL(CONVERT(float,c.IEPSFiscal),0.0)),0.0))*ISNULL(CONVERT(float,c.IEPSFiscal),0.0)*c.TipoCambio,
ISAN                   = 0.0
FROM Cxp c WITH (NOLOCK)
JOIN Compra com WITH (NOLOCK) ON com.MovID = c.OrigenID AND com.Mov = c.Origen AND c.OrigenTipo = 'COMS' AND com.Empresa = c.Empresa
JOIN Compra o WITH (NOLOCK)  ON o.ID = com.ProrrateoAplicaID
JOIN MovTipo mt WITH (NOLOCK) ON mt.Mov = c.Mov AND mt.Modulo = 'CXP'
JOIN EmpresaGral eg WITH (NOLOCK) ON eg.Empresa = c.Empresa
JOIN Concepto co WITH (NOLOCK) ON co.Concepto = c.Concepto AND co.Modulo = 'COMSG'
JOIN Version ver WITH (NOLOCK) ON 1 = 1
JOIN DIOTCfg WITH (NOLOCK) ON c.Empresa = DIOTCfg.Empresa
LEFT OUTER JOIN CxpD cd WITH (NOLOCK) ON cd.ID = c.ID
WHERE c.Estatus IN ('PENDIENTE','CONCLUIDO')
AND (mt.Clave IN ('CXP.AF','CXP.CA','CXP.F','CXP.NC','CXP.CA','CXP.A','CXP.CD','CXP.D'))
AND c.OrigenTipo IN ('COMS')
AND ISNULL(com.ProrrateoAplicaID, 0) <> 0

