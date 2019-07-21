SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFAVentaDpreCalc

AS
SELECT
d.ID,
d.Renglon,
d.RenglonSub,
d.Precio,
d.PrecioTipoCambio,
d.DescuentoLinea,
v.RedondeoMonetarios,
"CantidadSinObsequios" = Cantidad-ISNULL(CantidadCancelada, 0.0)-ISNULL(CantidadObsequio, 0.0),
"Impuesto1Base" = Impuesto1,
"Impuesto2Base" = CASE WHEN v.Impuesto2Info=1 THEN 0.0 ELSE Impuesto2 END,
"Impuesto3Base" = CASE WHEN v.Impuesto3Info=1 THEN 0.0 ELSE Impuesto3 END,
"Impuesto2BaseImpuesto1" = CASE WHEN v.Impuesto2Info=1 OR v.Impuesto2BaseImpuesto1=0 THEN 0.0 ELSE Impuesto2 END,
"preImporte"          = convert(float, ROUND(((Cantidad-ISNULL(CantidadCancelada, 0.0)-ISNULL(CantidadObsequio, 0.0))*Precio)-ISNULL(case when DescuentoTipo='$' then DescuentoLinea else (Cantidad-ISNULL(CantidadCancelada, 0.0)-ISNULL(CantidadObsequio, 0.0))*Precio*(DescuentoLinea/100.0) end, 0.0), v.RedondeoMonetarios)),
Retencion2BaseImpuesto1,
d.AnticipoFacturado,
"ImpuestosImporte"    = convert(float, ROUND((Cantidad-ISNULL(CantidadCancelada, 0.0))*ISNULL(CASE WHEN v.Impuesto3Info=1 THEN 0.0 ELSE Impuesto3 END, 0.0), ISNULL(v.RedondeoMonetarios,0))),
d.Retencion1,
d.Retencion2,
"ImpuestosPorcentaje" = convert(float, round((CASE WHEN v.Impuesto2Info=0 THEN ISNULL(Impuesto2,0.0) ELSE 0.0 END)+(ISNULL(Impuesto1, 0.0)*(1.0+((CASE WHEN v.Impuesto2Info=1 OR v.Impuesto2BaseImpuesto1=0 THEN 0.0 ELSE ISNULL(Impuesto2,0.0) END)/100))), 10.0))
FROM
VentaD d
JOIN Version v ON 1 = 1

