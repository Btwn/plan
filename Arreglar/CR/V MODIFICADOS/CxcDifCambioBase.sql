SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CxcDifCambioBase

AS
SELECT c.Empresa, c.Mov, c.MovID, c.FechaEmision, c.Ejercicio, c.Periodo, c.Estatus, c.Cliente,
c.Moneda, c.TipoCambio, c.ClienteMoneda, c.ClienteTipoCambio, "Importe" = ABS(d.Importe),
"Aplica" = a.Mov, "AplicaID" = a.MovID, "AplicaMoneda" = a.Moneda, "AplicaTipoCambio" = a.TipoCambio, "AplicaImporteTotal" = (a.Importe+a.Impuestos), "AplicaFecha" = a.FechaEmision,
"Porcentaje" = ABS(convert(money, round(((d.Importe*c.TipoCambio/c.ClienteTipoCambio)*100)/(a.Importe+a.Impuestos), ISNULL(vs.RedondeoMonetarios,0))))
FROM Cxc c WITH (NOLOCK)
JOIN CxcD d WITH (NOLOCK) ON c.ID = d.ID
JOIN Cxc a WITH (NOLOCK) ON d.AplicaID = a.MovID AND d.Aplica = a.Mov AND c.Empresa = a.Empresa AND c.Sucursal = a.Sucursal
JOIN Version vs WITH (NOLOCK) ON 1 = 1
WHERE c.Estatus NOT IN ('SINAFECTAR', 'CANCELADO') AND c.ClienteTipoCambio <> 1.0 AND a.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')

