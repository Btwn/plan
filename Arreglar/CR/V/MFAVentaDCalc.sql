SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFAVentaDCalc

AS
SELECT
d.ID,
d.Renglon,
d.RenglonSub,
d.Impuesto2Base,
d.Impuesto1Base,
d.Impuesto2BaseImpuesto1,
d.RedondeoMonetarios,
d.Retencion2BaseImpuesto1,
"Importe" = CASE
WHEN cfg.VentaPreciosImpuestoIncluido = 1 THEN (preImporte2-ISNULL(d.Impuesto3Base,0.0))/ (1.0 + (ISNULL(d.Impuesto2Base, 0.0)/100) + ((ISNULL(d.Impuesto1Base,0.0)/100) * (1+(ISNULL(d.Impuesto2BaseImpuesto1, 0.0)/100))))
ELSE preImporte2
END,
d.AnticipoFacturado,
d.ImpuestosImporte,
d.Retencion1,
d.Retencion2,
d.ImpuestosPorcentaje
FROM
Venta v
JOIN MFAVentaDpreCalc2 d ON d.ID = v.ID
JOIN EmpresaCfg cfg ON cfg.Empresa = v.Empresa

