SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFAVentaDpreCalc2

AS
SELECT
d.ID,
d.Renglon,
d.RenglonSub,
d.Impuesto3Base,
d.Impuesto2Base,
d.Impuesto1Base,
d.Impuesto2BaseImpuesto1,
d.RedondeoMonetarios,
d.Retencion2BaseImpuesto1,
"preImporte2" = CASE
WHEN cfg.VentaPrecioMoneda = 1 THEN preImporte*PrecioTipoCambio/v.TipoCambio
ELSE preImporte
END,
"DescuentoLineal" = CASE
WHEN cfg.VentaPrecioMoneda = 1 THEN CantidadSinObsequios*Precio*PrecioTipoCambio/v.TipoCambio*(DescuentoLinea/100.0)
ELSE CantidadSinObsequios*Precio*(DescuentoLinea/100.0)
END,
d.AnticipoFacturado,
d.ImpuestosImporte,
d.Retencion1,
d.Retencion2,
d.ImpuestosPorcentaje
FROM
Venta v
JOIN MFAVentaDpreCalc d ON d.ID = v.ID
JOIN EmpresaCfg cfg ON cfg.Empresa = v.Empresa

