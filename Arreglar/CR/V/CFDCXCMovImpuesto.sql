SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDCXCMovImpuesto AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,MovImpuesto.ModuloID))))) + RTRIM(LTRIM(CONVERT(varchar,MovImpuesto.ModuloID))) +
REPLICATE(' ',12) +
REPLICATE(' ',7) +
REPLICATE(' ',50)
OrdenExportacion,
MovImpuesto.ModuloID ID,
CONVERT(varchar(50),'IVA') Impuesto,
CONVERT(varchar(50),'VAT') ImpuestoClave,
MovImpuesto.Impuesto1 Tasa,
SUM(MovImpuesto.Importe1*dbo.fnCFDTipoCambioMN(Cxc.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN))) Importe,
'TRANSFERIDO' CategoriaImpuesto
FROM MovImpuesto
JOIN CXC ON MovImpuesto.Modulo = 'Cxc' AND MovImpuesto.ModuloId = Cxc.ID
JOIN EmpresaCFD ON Cxc.Empresa = EmpresaCFD.Empresa
JOIN MovTipo mt ON mt.Modulo = 'CXC' AND mt.Mov = Cxc.Mov
WHERE MovImpuesto.Modulo = 'CXC'
AND NULLIF(MovImpuesto.Importe1,0.0) IS NOT NULL
AND ISNULL(MovImpuesto.Excento1,0) <> 1
GROUP BY
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,MovImpuesto.ModuloID))))) + RTRIM(LTRIM(CONVERT(varchar,MovImpuesto.ModuloID))) +
REPLICATE('0',12) +
REPLICATE('0',7) +
REPLICATE(' ',50),
MovImpuesto.ModuloID,
MovImpuesto.Impuesto1
UNION ALL
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,MovImpuesto.ModuloID))))) + RTRIM(LTRIM(CONVERT(varchar,MovImpuesto.ModuloID))) +
REPLICATE(' ',12) +
REPLICATE(' ',7) +
REPLICATE(' ',50)
OrdenExportacion,
MovImpuesto.ModuloID ID,
CONVERT(varchar(50),'IEPS') Impuesto,
CONVERT(varchar(50),'GST') ImpuestoClave,
MovImpuesto.Impuesto2 Tasa,
SUM(MovImpuesto.Importe2*dbo.fnCFDTipoCambioMN(Cxc.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN))) Importe,
'TRANSFERIDO' CategoriaImpuesto
FROM MovImpuesto
JOIN CXC ON MovImpuesto.Modulo = 'Cxc' AND MovImpuesto.ModuloId = Cxc.ID
JOIN EmpresaCFD ON Cxc.Empresa = EmpresaCFD.Empresa
JOIN MovTipo mt ON mt.Modulo = 'CXC' AND mt.Mov = Cxc.Mov
WHERE MovImpuesto.Modulo = 'CXC'
AND NULLIF(MovImpuesto.Importe2,0.0) IS NOT NULL
AND ISNULL(MovImpuesto.Excento2,0) <> 1
GROUP BY
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,MovImpuesto.ModuloID))))) + RTRIM(LTRIM(CONVERT(varchar,MovImpuesto.ModuloID))) +
REPLICATE('0',12) +
REPLICATE('0',7) +
REPLICATE(' ',50),
MovImpuesto.ModuloID,
MovImpuesto.Impuesto2
/*
UNION ALL
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,MovImpuesto.ModuloID))))) + RTRIM(LTRIM(CONVERT(varchar,MovImpuesto.ModuloID))) +
REPLICATE(' ',12) +
REPLICATE(' ',7) +
REPLICATE(' ',50)
OrdenExportacion,
MovImpuesto.ModuloID ID,
CONVERT(varchar(50),'IVA') Impuesto,
CONVERT(varchar(50),'VAT') ImpuestoClave,
MovImpuesto.Impuesto1 Tasa,
MovImpuesto.Importe1*dbo.fnCFDTipoCambioMN(Cxc.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)) Importe,
'RETENIDO' CategoriaImpuesto
FROM MovImpuesto
JOIN CXC ON MovImpuesto.Modulo = 'Cxc' AND MovImpuesto.ModuloId = Cxc.ID
JOIN EmpresaCFD ON Cxc.Empresa = EmpresaCFD.Empresa
JOIN cte ON Cte.cliente = Cxc.Cliente
WHERE MovImpuesto.Modulo = 'CXC'
AND NULLIF(MovImpuesto.Importe1,0.0) IS NOT NULL
AND NULLIF(Cxc.Retencion,0.0) IS NOT NULL AND NULLIF(Cte.Pitex,'') IS NOT NULL
*/

