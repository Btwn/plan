SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW VentaDpreCalc2

AS
SELECT
d.*,
"preImporte2" = CASE
WHEN cfg.VentaPrecioMoneda = 1 THEN preImporte*PrecioTipoCambio/v.TipoCambio
ELSE preImporte
END,
"ImpIncpreImporte2" = CASE
WHEN cfg.VentaPrecioMoneda = 1 THEN ImpIncpreImporte*PrecioTipoCambio/v.TipoCambio
ELSE ImpIncpreImporte
END,
"ImpIncprePrecio" = CASE
WHEN cfg.VentaPrecioMoneda = 1 THEN Precio*PrecioTipoCambio/v.TipoCambio
ELSE Precio
END,
"preImporte2SinDL" = CASE
WHEN cfg.VentaPrecioMoneda = 1 THEN preImporteSinDL*PrecioTipoCambio/v.TipoCambio
ELSE preImporteSinDL
END,
"prePrecioSinDL" = CASE
WHEN cfg.VentaPrecioMoneda = 1 THEN Precio*PrecioTipoCambio/v.TipoCambio
ELSE Precio
END,
"DescuentoLineal" = CASE
WHEN cfg.VentaPrecioMoneda = 1 THEN CantidadSinObsequios*Precio*PrecioTipoCambio/v.TipoCambio*(DescuentoLinea/100.0)
ELSE CantidadSinObsequios*Precio*(DescuentoLinea/100.0)
END
FROM Venta v
JOIN VentaDpreCalc d ON v.ID = d.ID
JOIN EmpresaCfg cfg ON v.Empresa = cfg.Empresa

