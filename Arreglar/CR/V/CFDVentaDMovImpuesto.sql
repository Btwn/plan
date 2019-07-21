SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDVentaDMovImpuesto AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.ID))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.ID))) +
REPLICATE('0',12-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.Renglon))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.Renglon))) +
REPLICATE('0',7-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.RenglonSub))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.RenglonSub))) +
'IMPUESTO1' + REPLICATE(' ',50 - LEN('IMPUESTO1'))
OrdenExportacion,
VentaD.ID,
'VAT' VentaDImpuestoClave,
ISNULL(VentaD.Impuesto1,0.0) VentaDImpuestoTasa,
CASE WHEN ISNULL(VentaD.Impuesto1,0.0) > 0.0 THEN (VentaD.Precio*(ISNULL(VentaD.Impuesto1,0.0)/100.0))*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)) ELSE 0.0 END VentaDImpuestoImporte,
'TRANSFERIDO' VentaDCategoriaImpuesto
FROM VentaD
JOIN Venta ON VentaD.ID = Venta.ID
JOIN EmpresaCFD ON Venta.Empresa = EmpresaCFD.Empresa
JOIN MovTipo mt ON mt.Modulo = 'VTAS' AND mt.Mov = Venta.Mov
UNION ALL
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.ID))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.ID))) +
REPLICATE('0',12-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.Renglon))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.Renglon))) +
REPLICATE('0',7-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.RenglonSub))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.RenglonSub))) +
'IMPUESTO2' + REPLICATE(' ',50 - LEN('IMPUESTO2'))
OrdenExportacion,
VentaD.ID,
'GST' VentaDImpuestoClave,
ISNULL(VentaD.Impuesto2,0.0) VentaDImpuestoTasa,
CASE WHEN ISNULL(VentaD.Impuesto2,0.0) > 0.0 THEN (VentaD.Precio/(ISNULL(VentaD.Impuesto2,0.0)/100.0))*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)) ELSE 0.0 END VentaDImpuestoImporte,
'TRANSFERIDO' VentaDCategoriaImpuesto
FROM VentaD
JOIN Venta ON VentaD.ID = Venta.ID
JOIN EmpresaCFD ON Venta.Empresa = EmpresaCFD.Empresa
JOIN MovTipo mt ON mt.Modulo = 'VTAS' AND mt.Mov = Venta.Mov

