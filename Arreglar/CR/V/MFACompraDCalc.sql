SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFACompraDCalc

AS
SELECT
d.*,
v.RedondeoMonetarios,
"CantidadNeta" = (Cantidad-ISNULL(CantidadCancelada, 0.0)),
"CantidadFactor" = (Cantidad-ISNULL(CantidadCancelada, 0.0))*Factor,
"PendienteFactor" = CantidadPendiente*Factor,
"Impuesto1Base" = Impuesto1,
"Impuesto2Base" = CASE WHEN v.Impuesto2Info=1 THEN 0.0 ELSE Impuesto2 END,
"Impuesto3Base" = CASE WHEN v.Impuesto3Info=1 THEN 0.0 ELSE Impuesto3 END,
"Impuesto2BaseImpuesto1" = CASE WHEN v.Impuesto2Info=1 OR v.Impuesto2BaseImpuesto1=0 THEN 0.0 ELSE Impuesto2 END,
"ImpuestosPorcentaje" = convert(float, ROUND((100.0+ISNULL(CASE WHEN v.Impuesto2Info=1 OR v.Impuesto2BaseImpuesto1=0 THEN 0.0 ELSE Impuesto2 END, 0.0))*(1.0+((ISNULL(Impuesto1, 0.0)/*+ISNULL(Impuesto3, 0.0)*/)/100.0))-100, v.RedondeoMonetarios)),
"ImpuestosImporte"    = convert(money, ROUND((Cantidad-ISNULL(CantidadCancelada, 0.0))*ISNULL(CASE WHEN v.Impuesto3Info=1 THEN 0.0 ELSE Impuesto3 END, 0.0) /*+ ISNULL(Impuesto5,0.0)*/, v.RedondeoMonetarios)),
"Importe" = convert(money, ROUND(((Cantidad-ISNULL(CantidadCancelada, 0.0))*Costo)-ISNULL(case when DescuentoTipo='$' then ISNULL(DescuentoLinea, 0.0) else (Cantidad-ISNULL(CantidadCancelada, 0.0))*Costo*(ISNULL(DescuentoLinea, 0.0)/100.0) end, 0.0), v.RedondeoMonetarios)),
"DescuentoLineal" = convert(money, ROUND((case when DescuentoTipo='$' then DescuentoLinea else (Cantidad-ISNULL(CantidadCancelada, 0.0))*Costo*(DescuentoLinea/100.0) end), v.RedondeoMonetarios))
FROM
CompraD d, Version v

