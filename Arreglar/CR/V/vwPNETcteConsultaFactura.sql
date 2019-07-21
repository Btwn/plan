SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.vwPNETcteConsultaFactura
AS
SELECT ROW_NUMBER() OVER ( ORDER BY CASE WHEN v.Estatus = 'PENDIENTE' THEN 1 WHEN v.Estatus = 'CONCLUIDO' THEN 2 WHEN v.Estatus = 'CANCELADO' THEN 3 ELSE 4 END ASC, CONVERT(DATETIME,v.FechaEmision) DESC) AS RowIndex,
v.ID,
v.Cliente,
v.FechaEmision,
v.Estatus,
e.Nombre AS Empresa,
s.Nombre AS Sucursal,
RTRIM(v.Mov)+' '+RTRIM(ISNULL(v.MovID,'')) AS Movimiento,
v.Moneda,
v.TipoCambio,
v.Condicion CondicionPago,
v.Referencia,
v.Concepto,
t.importe,
CASE WHEN t.DescuentosTotales <> 0 THEN (ISNULL(t.DescuentosTotales,0)-ISNULL(t.DescuentoLineal,0)) ELSE 0 END AS Descuento,
t.SubTotal,
t.Impuestos,
t.ImporteTotal,
(CAST(v.ID AS VARCHAR(25)) + '|' + ISNULL(v.Cliente, '') + '|' + CONVERT (VARCHAR(21), v.FechaEmision, 103) + ' ' + CONVERT (VARCHAR(21), v.FechaEmision, 108) + '|' +
ISNULL(v.Estatus, '') + '|' + ISNULL(e.Nombre, '') + '|' + ISNULL(s.Nombre, '') + '|' + ISNULL(RTRIM(v.Mov)+' '+RTRIM(ISNULL(v.MovID,'')), '') + '|' + ISNULL(v.Moneda, '') + '|' +
CAST(v.TipoCambio AS VARCHAR(25)) + '|' + ISNULL(v.Condicion, '') + '|' + ISNULL(v.Referencia, '') + '|' + ISNULL(v.Concepto, '') + '|' + CAST(t.importe AS VARCHAR(25)) + '|' +
ISNULL(CAST(CASE WHEN t.DescuentosTotales <> 0 THEN (ISNULL(t.DescuentosTotales,0)-ISNULL(t.DescuentoLineal,0)) ELSE 0 END AS VARCHAR(25)), '') + '|' +
CAST(t.SubTotal AS VARCHAR(25)) + '|' + CAST(t.Impuestos AS VARCHAR(25)) + '|' + CAST(t.ImporteTotal AS VARCHAR(25))) AS Finder
FROM Venta v
JOIN MovTipo m ON v.Mov = m.Mov AND m.Modulo = 'VTAS'
JOIN VentaCalc t ON v.ID = t.ID
LEFT JOIN CFD f ON (v.ID = f.ModuloID AND f.Modulo = 'VTAS')
JOIN Empresa e ON v.Empresa = e.Empresa
JOIN Sucursal s ON v.Sucursal = s.Sucursal
WHERE m.Clave IN ('VTAS.P','VTAS.F')
AND v.Estatus IN ('CONCLUIDO','PENDIENTE')
GROUP BY v.ID, v.Cliente, v.FechaEmision, v.Estatus, V.Mov, v.MovID, v.Moneda, v.TipoCambio, v.Condicion, v.Concepto, v.Referencia, t.importe, t.DescuentosTotales, t.DescuentosTotales, t.DescuentoLineal, t.SubTotal, t.Impuestos, t.ImporteTotal, e.Nombre, s.Nombre,
(CAST(v.ID AS VARCHAR(25)) + '|' + ISNULL(v.Cliente, '') + '|' + CONVERT (VARCHAR(21), v.FechaEmision, 103) + ' ' + CONVERT (VARCHAR(21), v.FechaEmision, 108) + '|' +
ISNULL(v.Estatus, '') + '|' + ISNULL(e.Nombre, '') + '|' + ISNULL(s.Nombre, '') + '|' + ISNULL(RTRIM(v.Mov)+' '+RTRIM(ISNULL(v.MovID,'')), '') + '|' + ISNULL(v.Moneda, '') + '|' +
CAST(v.TipoCambio AS VARCHAR(25)) + '|' + ISNULL(v.Condicion, '') + '|' + ISNULL(v.Referencia, '') + '|' + ISNULL(v.Concepto, '') + '|' + CAST(t.importe AS VARCHAR(25)) + '|' +
ISNULL(CAST(CASE WHEN t.DescuentosTotales <> 0 THEN (ISNULL(t.DescuentosTotales,0)-ISNULL(t.DescuentoLineal,0)) ELSE 0 END AS VARCHAR(25)), '') + '|' +
CAST(t.SubTotal AS VARCHAR(25)) + '|' + CAST(t.Impuestos AS VARCHAR(25)) + '|' + CAST(t.ImporteTotal AS VARCHAR(25)))

