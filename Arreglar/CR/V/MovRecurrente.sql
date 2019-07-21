SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MovRecurrente

AS
SELECT Modulo = CONVERT(char(5), 'VTAS'), m.ID, m.Empresa, m.Mov, m.MovID, m.FechaEmision, m.Vencimiento, m.Proyecto, m.UEN, m.Moneda, m.TipoCambio, m.Usuario, m.Situacion, m.Periodicidad, "Contacto" = m.Cliente, c.Nombre, m.Importe, m.Impuestos, m.ConVigencia, m.VigenciaDesde, m.VigenciaHasta
FROM Venta m
JOIN Cte c ON m.Cliente = c.Cliente
WHERE m.Estatus = 'RECURRENTE'
UNION ALL
SELECT Modulo = CONVERT(char(5), 'GAS'),  m.ID, m.Empresa, m.Mov, m.MovID, m.FechaEmision, m.Vencimiento, m.Proyecto, m.UEN, m.Moneda, m.TipoCambio, m.Usuario, m.Situacion, m.Periodicidad, "Contacto" = m.Acreedor, c.Nombre, m.Importe, m.Impuestos, m.ConVigencia, m.VigenciaDesde, m.VigenciaHasta
FROM Gasto m
JOIN Prov c ON  m.Acreedor = c.Proveedor
WHERE m.Estatus = 'RECURRENTE'

