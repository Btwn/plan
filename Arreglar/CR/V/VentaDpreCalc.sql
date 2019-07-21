SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW VentaDpreCalc

AS
SELECT
d.*,
"CantidadNeta" = Cantidad-ISNULL(CantidadCancelada, 0.0),
"CantidadSinObsequios" = Cantidad-ISNULL(CantidadCancelada, 0.0)-ISNULL(CantidadObsequio, 0.0),
"CantidadFactor" = (Cantidad-ISNULL(CantidadCancelada, 0.0))*Factor,
"ReservadaFactor" = CantidadReservada*Factor,
"OrdenadaFactor" = CantidadOrdenada*Factor,
"PendienteFactor" = CantidadPendiente*Factor,
"Impuesto1Base" = Impuesto1,
"Impuesto2Base" = CASE WHEN v.Impuesto2Info=1 THEN 0.0 ELSE Impuesto2 END,
"Impuesto3Base" = CASE WHEN v.Impuesto3Info=1 THEN 0.0 ELSE Impuesto3 END,
"Impuesto2BaseImpuesto1" = CASE WHEN v.Impuesto2Info=1 OR v.Impuesto2BaseImpuesto1=0 THEN 0.0 ELSE Impuesto2 END,
"Retencion2BaseImpuesto1" = CASE WHEN ISNULL(v.Retencion2BaseImpuesto1,0) = 0 THEN 0 ELSE 1 END, 
"ImpuestosPorcentaje" = convert(float, round((CASE WHEN v.Impuesto2Info=0 THEN ISNULL(Impuesto2,0.0) ELSE 0.0 END)+(ISNULL(Impuesto1, 0.0)*(1.0+((CASE WHEN v.Impuesto2Info=1 OR v.Impuesto2BaseImpuesto1=0 THEN 0.0 ELSE ISNULL(Impuesto2,0.0) END)/100))), 10.0)),
"ImpuestosImporte"    = convert(float, ROUND((Cantidad-ISNULL(CantidadCancelada, 0.0))*ISNULL(CASE WHEN v.Impuesto3Info=1 THEN 0.0 ELSE Impuesto3 END, 0.0), ISNULL(v.RedondeoMonetarios,0))),
"CostoTotal"          = convert(float, ROUND((Cantidad-ISNULL(CantidadCancelada, 0.0))*Costo, ISNULL(v.RedondeoMonetarios,0))),
"CostoActividadTotal" = convert(float, ROUND((Cantidad-ISNULL(CantidadCancelada, 0.0))*CostoActividad, ISNULL(v.RedondeoMonetarios,0))),
"PrecioTotal"         = convert(float, ROUND((Cantidad-ISNULL(CantidadCancelada, 0.0)-ISNULL(CantidadObsequio, 0.0))*Precio, ISNULL(v.RedondeoMonetarios,0))),
"preImporte"          = convert(float, ROUND(((Cantidad-ISNULL(CantidadCancelada, 0.0)-ISNULL(CantidadObsequio, 0.0))*Precio)-ISNULL(case when DescuentoTipo='$' then DescuentoLinea else (Cantidad-ISNULL(CantidadCancelada, 0.0)-ISNULL(CantidadObsequio, 0.0))*Precio*(DescuentoLinea/100.0) end, 0.0), ISNULL(v.RedondeoMonetarios,0))),
"preImporteSinDL"     = convert(float, ROUND(((Cantidad-ISNULL(CantidadCancelada, 0.0)-ISNULL(CantidadObsequio, 0.0))*Precio), ISNULL(v.RedondeoMonetarios,0))),
"ImpIncpreImporte"    = convert(float, ROUND(((Cantidad-ISNULL(CantidadCancelada, 0.0)-ISNULL(CantidadObsequio, 0.0))*Precio), ISNULL(v.RedondeoMonetarios,0)))
FROM VentaD d
JOIN Version v ON 1 = 1

