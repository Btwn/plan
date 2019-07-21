SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW VentaDCalc

AS
SELECT
d.*,
"Importe" = CASE
WHEN cfg.VentaPreciosImpuestoIncluido = 1 THEN (preImporte2-ISNULL(d.Impuesto3Base,0.0))/ (1.0 + (ISNULL(d.Impuesto2Base, 0.0)/100) + ((ISNULL(d.Impuesto1Base,0.0)/100) * (1+(ISNULL(d.Impuesto2BaseImpuesto1, 0.0)/100))))
ELSE preImporte2
END,
"ImporteSinDL" = CASE
WHEN cfg.VentaPreciosImpuestoIncluido = 1 THEN (preImporte2SinDL-ISNULL(d.Impuesto3Base,0.0))/ (1.0 + (ISNULL(d.Impuesto2Base, 0.0)/100) + ((ISNULL(d.Impuesto1Base,0.0)/100) * (1+(ISNULL(d.Impuesto2BaseImpuesto1, 0.0)/100))))
ELSE preImporte2SinDL
END,
"PrecioSinDL" = CASE
WHEN cfg.VentaPreciosImpuestoIncluido = 1 THEN (prePrecioSinDL-ISNULL(d.Impuesto3Base,0.0))/ (1.0 + (ISNULL(d.Impuesto2Base, 0.0)/100) + ((ISNULL(d.Impuesto1Base,0.0)/100) * (1+(ISNULL(d.Impuesto2BaseImpuesto1, 0.0)/100))))
ELSE prePrecioSinDL
END,
"ImpIncImporte" = CASE
WHEN cfg.VentaPreciosImpuestoIncluido = 1 THEN (ImpIncpreImporte2-ISNULL(d.Impuesto3Base,0.0))/ (1.0 + (ISNULL(d.Impuesto2Base, 0.0)/100) + ((ISNULL(d.Impuesto1Base,0.0)/100) * (1+(ISNULL(d.Impuesto2BaseImpuesto1, 0.0)/100))))
ELSE ImpIncpreImporte2
END,
"ImpIncPrecio" = CASE
WHEN cfg.VentaPreciosImpuestoIncluido = 1 THEN (ImpIncprePrecio-ISNULL(d.Impuesto3Base,0.0))/ (1.0 + (ISNULL(d.Impuesto2Base, 0.0)/100) + ((ISNULL(d.Impuesto1Base,0.0)/100) * (1+(ISNULL(d.Impuesto2BaseImpuesto1, 0.0)/100))))
ELSE ImpIncprePrecio
END
FROM Venta v
JOIN VentaDpreCalc2 d ON v.ID = d.ID
JOIN EmpresaCfg cfg ON v.Empresa = cfg.Empresa

