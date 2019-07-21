SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDVentaMovImpuestoEst AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaTCalc.ID))))) + RTRIM(LTRIM(CONVERT(varchar,VentaTCalc.ID))) +
REPLICATE('0',12) +
REPLICATE('0',7) +
REPLICATE(' ',50)
OrdenExportacion,
VentaTCalc.ID ID,
CONVERT(varchar(50),'IVA') Impuesto,
CONVERT(varchar(50),'VAT') ImpuestoClave,
ISNULL(VentaTCalc.Impuesto1,0.00) Tasa,
SUM(ISNULL(VentaTCalc.Impuesto1Total,0.00)*ISNULL(dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)),0.00)) Importe,
'TRANSFERIDO' CategoriaImpuesto
FROM VentaTCalc
JOIN Venta ON VentaTCalc.ID = Venta.ID
JOIN EmpresaCFD ON Venta.Empresa = EmpresaCFD.Empresa
JOIN MovTipo mt ON mt.Modulo = 'VTAS' AND mt.Mov = Venta.Mov
WHERE NULLIF(VentaTCalc.Impuesto1Total,0.0) IS NOT NULL
GROUP BY VentaTCalc.ID, VentaTCalc.Impuesto1
UNION ALL
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaTCalc.ID))))) + RTRIM(LTRIM(CONVERT(varchar,VentaTCalc.ID))) +
REPLICATE('0',12) +
REPLICATE('0',7) +
REPLICATE(' ',50)
OrdenExportacion,
VentaTCalc.ID ID,
CONVERT(varchar(50),'IEPS') Impuesto,
CONVERT(varchar(50),'GST') ImpuestoClave,
ISNULL(VentaTCalc.Impuesto2,0.00) Tasa,
SUM(ISNULL(VentaTCalc.Impuesto2Total,0.00)*ISNULL(dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)),0.00)) Importe,
'TRANSFERIDO' CategoriaImpuesto
FROM VentaTCalc
JOIN Venta ON VentaTCalc.ID = Venta.ID
JOIN EmpresaCFD ON Venta.Empresa = EmpresaCFD.Empresa
JOIN MovTipo mt ON mt.Modulo = 'VTAS' AND mt.Mov = Venta.Mov
WHERE NULLIF(VentaTCalc.Impuesto2Total,0.0) IS NOT NULL
GROUP BY VentaTCalc.ID, VentaTCalc.Impuesto2

