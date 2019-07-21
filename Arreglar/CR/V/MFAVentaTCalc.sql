SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFAVentaTCalc

AS
SELECT
v.ID,
v.Empresa,
d.Renglon,
d.RenglonSub,
d.Retencion2BaseImpuesto1,
d.Impuesto2BaseImpuesto1,
d.RedondeoMonetarios,
"SubTotal"               = Convert(float, ROUND(dbo.fnSubTotal(d.Importe, (ISNULL(v.DescuentoGlobal,0.0)), v.SobrePrecio), d.RedondeoMonetarios)),
"Impuesto1Total"         = Convert(float, ROUND(dbo.fnSubTotal(ISNULL(d.Importe,0.0), (ISNULL(v.DescuentoGlobal,0.0)), v.SobrePrecio) * (1.0+(ISNULL(d.Impuesto2BaseImpuesto1, 0.0)/100.0))*(ISNULL(Impuesto1Base, 0.0)/100.0), d.RedondeoMonetarios)),
"Impuesto2Total"         = Convert(float, ROUND(dbo.fnSubTotal(d.Importe, (ISNULL(v.DescuentoGlobal,0.0)), v.SobrePrecio) * (ISNULL(Impuesto2Base, 0.0)/100.0), d.RedondeoMonetarios)),
dinero				   = v.Dinero,
dinero_id				   = v.DineroID,
"ImporteDescuentoGlobal" = convert(float, ROUND((d.Importe*(CASE WHEN ISNULL(d.AnticipoFacturado, 0) = 0 THEN ISNULL(v.DescuentoGlobal,0.0) ELSE 0 END)/100.0), ISNULL(vs.RedondeoMonetarios,0))),
"DescuentosTotales" = (Convert(money, ROUND((v.Importe*ISNULL(v.DescuentoGlobal, 0.0)/100.0), ISNULL(vs.RedondeoMonetarios,0)))+ISNULL(v.DescuentoLineal, 0.0)),
"ImporteSobrePrecio"= (Convert(money, ROUND((v.Importe*ISNULL(v.SobrePrecio, 0.0)/100.0), ISNULL(vs.RedondeoMonetarios,0)))),
"Impuesto3Total"         = ISNULL(ImpuestosImporte, 0.0),
"Retencion1Total"        = Convert(float, ROUND(dbo.fnSubTotal(ISNULL(d.Importe,0.0), (CASE WHEN ISNULL(d.AnticipoFacturado, 0) = 0 THEN ISNULL(v.DescuentoGlobal,0.0) ELSE 0 END), v.SobrePrecio) *(ISNULL(d.Retencion1, 0.0)/100.0), ISNULL(vs.RedondeoMonetarios,0))),
"Retencion2Total"        = Convert(float, ROUND((CASE WHEN d.Retencion2BaseImpuesto1 = 0 THEN dbo.fnSubTotal(ISNULL(d.Importe,0.0), (CASE WHEN ISNULL(d.AnticipoFacturado, 0) = 0 THEN ISNULL(v.DescuentoGlobal,0.0) ELSE 0 END), v.SobrePrecio) ELSE Convert(float, ROUND(dbo.fnSubTotal(ISNULL(d.Importe,0.0), (CASE WHEN ISNULL(d.AnticipoFacturado, 0) = 0 THEN ISNULL(v.DescuentoGlobal,0.0) ELSE 0 END), v.SobrePrecio) * (1.0+(ISNULL(d.Impuesto2BaseImpuesto1, 0.0)/100.0))*(ISNULL(Impuesto1Base, 0.0)/100.0), ISNULL(vs.RedondeoMonetarios,0))) END) *(ISNULL(d.Retencion2, 0.0)/100.0), ISNULL(vs.RedondeoMonetarios,0))),
"Impuestos" 	           = ISNULL(ImpuestosImporte, 0.0) + Convert(float, ROUND(dbo.fnSubTotal(d.Importe, (CASE WHEN ISNULL(d.AnticipoFacturado, 0) = 0 THEN ISNULL(v.DescuentoGlobal,0.0) ELSE 0 END), v.SobrePrecio) * (ISNULL(ImpuestosPorcentaje, 0.0)/100.0), ISNULL(vs.RedondeoMonetarios,0))),
v.Retencion,
"ImporteTotal"      = Convert(money, ROUND(dbo.fnSubTotal(v.Importe, v.DescuentoGlobal, v.SobrePrecio) + ISNULL(v.Impuestos, 0.0), ISNULL(vs.RedondeoMonetarios,0))),
"TotalNeto"         = Convert(money, ROUND(dbo.fnSubTotal(v.Importe, v.DescuentoGlobal, v.SobrePrecio) + ISNULL(v.Impuestos, 0.0) - ISNULL(v.AnticiposFacturados, 0.0) - ISNULL(v.Retencion, 0.0), ISNULL(vs.RedondeoMonetarios,0)))
FROM
Venta v
JOIN MFAVentaDCalc d ON d.ID = v.id
JOIN Version vs ON 1=1

