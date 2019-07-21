SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CompraDCalc

AS
SELECT
d.*,
"CantidadNeta" = (Cantidad-ISNULL(CantidadCancelada, 0.0)),
"CantidadFactor" = (Cantidad-ISNULL(CantidadCancelada, 0.0))*Factor,
"PendienteFactor" = CantidadPendiente*Factor,
"Impuesto1Base" = Impuesto1,
"Impuesto2Base" = CASE WHEN v.Impuesto2Info=1 THEN 0.0 ELSE Impuesto2 END,
"Impuesto3Base" = CASE WHEN v.Impuesto3Info=1 THEN 0.0 ELSE Impuesto3 END,
"Impuesto5Base" = Impuesto5,
"Impuesto2BaseImpuesto1" = CASE WHEN v.Impuesto2Info=1 OR v.Impuesto2BaseImpuesto1=0 THEN 0.0 ELSE Impuesto2 END,
"ImpuestosPorcentaje" = convert(float, ROUND((100.0+ISNULL(CASE WHEN v.Impuesto2Info=1 OR v.Impuesto2BaseImpuesto1=0 THEN 0.0 ELSE Impuesto2 END, 0.0))*(1.0+((ISNULL(Impuesto1, 0.0)/*+ISNULL(Impuesto3, 0.0)*/)/100.0))-100, ISNULL(v.RedondeoMonetarios,0))),
"ImpuestosImporte"    = convert(money, ROUND((Cantidad-ISNULL(CantidadCancelada, 0.0))*ISNULL(CASE WHEN v.Impuesto3Info=1 THEN 0.0 ELSE Impuesto3 END, 0.0) + ISNULL(Impuesto5,0.0), ISNULL(v.RedondeoMonetarios,0))),
"Importe" = convert(money, ROUND(((Cantidad-ISNULL(CantidadCancelada, 0.0))*Costo)-ISNULL(case when DescuentoTipo='$' then ISNULL(DescuentoLinea, 0.0) else (Cantidad-ISNULL(CantidadCancelada, 0.0))*Costo*(ISNULL(DescuentoLinea, 0.0)/100.0) end, 0.0), ISNULL(v.RedondeoMonetarios,0))),
"DescuentoLineal" = convert(money, ROUND((case when DescuentoTipo='$' then DescuentoLinea else (Cantidad-ISNULL(CantidadCancelada, 0.0))*Costo*(DescuentoLinea/100.0) end), ISNULL(v.RedondeoMonetarios,0)))
FROM CompraD d WITH (NOLOCK)
JOIN Version v WITH (NOLOCK) ON 1 = 1

