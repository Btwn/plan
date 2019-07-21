SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CxpDifCambioBase

AS
SELECT c.Empresa, c.Mov, c.MovID, c.FechaEmision, c.Ejercicio, c.Periodo, c.Estatus, c.Proveedor,
c.Moneda, c.TipoCambio, c.ProveedorMoneda, c.ProveedorTipoCambio, "Importe" = ABS(d.Importe),
"Aplica" = a.Mov, "AplicaID" = a.MovID, "AplicaMoneda" = a.Moneda, "AplicaTipoCambio" = a.TipoCambio, "AplicaImporteTotal" = (a.Importe+a.Impuestos),
"Porcentaje" = ABS(convert(money, round(((d.Importe*c.TipoCambio/c.ProveedorTipoCambio)*100)/(a.Importe+a.Impuestos), ISNULL(vs.RedondeoMonetarios,0))))
FROM Cxp c
JOIN CxpD d ON c.ID=d.ID
JOIN Cxp a ON d.AplicaID = a.MovID AND d.Aplica = a.Mov AND c.Empresa = a.Empresa AND c.Sucursal = a.Sucursal
JOIN Version vs ON 1 = 1
WHERE c.Estatus NOT IN ('SINAFECTAR', 'CANCELADO') AND c.ProveedorTipoCambio <> 1.0 AND a.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')

