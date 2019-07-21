SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CompraCalc

AS
SELECT
v.*,
"DescuentosTotales" = (Convert(money, ROUND((v.Importe*ISNULL(v.DescuentoGlobal, 0.0)/100.0), ISNULL(vs.RedondeoMonetarios,0)))+ISNULL(v.DescuentoLineal, 0.0)),
"SubTotal"= Convert(money, ROUND((v.Importe*(100-ISNULL(v.DescuentoGlobal, 0.0))/100.0), ISNULL(vs.RedondeoMonetarios,0))),
"ImporteTotal"= Convert(money, ROUND((v.Importe*(100-ISNULL(v.DescuentoGlobal, 0.0))/100.0) + v.Impuestos, ISNULL(vs.RedondeoMonetarios,0)))
FROM Compra v
JOIN Version vs ON 1 = 1

