SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW VentaCalc

AS
SELECT
v.*,
"DescuentosTotales" = (Convert(money, ROUND((v.Importe*ISNULL(v.DescuentoGlobal, 0.0)/100.0), ISNULL(vs.RedondeoMonetarios,0)))+ISNULL(v.DescuentoLineal, 0.0)),
"ImporteSobrePrecio"= (Convert(money, ROUND((v.Importe*ISNULL(v.SobrePrecio, 0.0)/100.0), ISNULL(vs.RedondeoMonetarios,0)))),
"SubTotal"          = Convert(money, ROUND(dbo.fnSubTotal(v.Importe, v.DescuentoGlobal, v.SobrePrecio), ISNULL(vs.RedondeoMonetarios,0))),
"ImporteTotal"      = Convert(money, ROUND(dbo.fnSubTotal(v.Importe, v.DescuentoGlobal, v.SobrePrecio) + ISNULL(v.Impuestos, 0.0), ISNULL(vs.RedondeoMonetarios,0))),
"TotalNeto"         = Convert(money, ROUND(dbo.fnSubTotal(v.Importe, v.DescuentoGlobal, v.SobrePrecio) + ISNULL(v.Impuestos, 0.0) - ISNULL(v.AnticiposFacturados, 0.0) - ISNULL(v.Retencion, 0.0), ISNULL(vs.RedondeoMonetarios,0)))
FROM Venta v
JOIN Version vs ON 1 = 1

