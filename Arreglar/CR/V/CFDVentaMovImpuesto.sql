SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDVentaMovImpuesto AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,MovImpuesto.ModuloID))))) + RTRIM(LTRIM(CONVERT(varchar,MovImpuesto.ModuloID))) +
REPLICATE(' ',12) +
REPLICATE(' ',7) +
REPLICATE(' ',50)
OrdenExportacion,
MovImpuesto.ModuloID ID,
CONVERT(varchar(50),'IVA') Impuesto,
CONVERT(varchar(50),'VAT') ImpuestoClave,
ISNULL(MovImpuesto.Impuesto1,0.00) Tasa,
SUM(ISNULL(MovImpuesto.Importe1,0.00)*ISNULL(dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)),0.00)) Importe,
'TRANSFERIDO' CategoriaImpuesto
FROM MovImpuesto
JOIN Venta ON MovImpuesto.Modulo = 'VTAS' AND MovImpuesto.ModuloId = Venta.ID
JOIN EmpresaCFD ON Venta.Empresa = EmpresaCFD.Empresa
JOIN MovTipo mt ON mt.Modulo = 'VTAS' AND mt.Mov = Venta.Mov
WHERE MovImpuesto.Modulo = 'VTAS'
AND ISNULL(MovImpuesto.Excento1,0) <> 1
GROUP BY MovImpuesto.ModuloID, MovImpuesto.Impuesto1
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
ISNULL(MovImpuesto.Impuesto2,0.00) Tasa,
SUM(ISNULL(MovImpuesto.Importe2,0.00)*ISNULL(dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)),0.00)) Importe,
'TRANSFERIDO' CategoriaImpuesto
FROM MovImpuesto
JOIN Venta ON MovImpuesto.Modulo = 'VTAS' AND MovImpuesto.ModuloId = Venta.ID
JOIN EmpresaCFD ON Venta.Empresa = EmpresaCFD.Empresa
JOIN MovTipo mt ON mt.Modulo = 'VTAS' AND mt.Mov = Venta.Mov
WHERE MovImpuesto.Modulo = 'VTAS'
AND ISNULL(MovImpuesto.Excento2,0) <> 1 and MovImpuesto.Impuesto2>0.00
GROUP BY MovImpuesto.ModuloID, MovImpuesto.Impuesto2
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
ISNULL(MovImpuesto.Impuesto3,0.00) Tasa,
SUM(ISNULL(MovImpuesto.Importe3,0.00)*ISNULL(dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)),0.00)) Importe,
'TRANSFERIDO' CategoriaImpuesto
FROM MovImpuesto
JOIN Venta ON MovImpuesto.Modulo = 'VTAS' AND MovImpuesto.ModuloId = Venta.ID
JOIN EmpresaCFD ON Venta.Empresa = EmpresaCFD.Empresa
JOIN MovTipo mt ON mt.Modulo = 'VTAS' AND mt.Mov = Venta.Mov
WHERE MovImpuesto.Modulo = 'VTAS'
AND ISNULL(MovImpuesto.Excento3,0) <> 1 and MovImpuesto.Impuesto3>0.00
GROUP BY MovImpuesto.ModuloID, MovImpuesto.Impuesto3

