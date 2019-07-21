SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPNETConsultaVtasFactE
@Usuario		varchar(100),
@EstatusV1		varchar(max),
@Desde			date,
@Hasta			date
AS BEGIN
IF @EstatusV1 = '(Todos)'
BEGIN
SELECT	v.ID,
e.Nombre AS Empresa,
s.Nombre AS Sucursal,
RTRIM(v.Mov)+' '+RTRIM(ISNULL(v.MovID,'')) AS Movimiento,
CONVERT(VARCHAR(50),v.FechaEmision,121) AS FechaEmision,
v.Estatus,
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
CASE WHEN v.Estatus = 'PENDIENTE' THEN 1 WHEN v.Estatus = 'CONCLUIDO' THEN 2 WHEN v.Estatus = 'CANCELADO' THEN 3 ELSE 4 END Orden
FROM	Venta v
JOIN	MovTipo m ON v.Mov = m.Mov AND m.Modulo = 'VTAS'
JOIN	VentaCalc t ON v.ID = t.ID
LEFT	JOIN CFD f ON (v.ID = f.ModuloID AND f.Modulo = 'VTAS')
JOIN	Empresa e ON v.Empresa = e.Empresa
JOIN	Sucursal s ON v.Sucursal = s.Sucursal
WHERE	m.Clave IN ('VTAS.P','VTAS.F')
AND v.Cliente = @Usuario
AND v.FechaEmision BETWEEN @Desde AND @Hasta
AND v.Estatus IN ('CONCLUIDO','PENDIENTE')
GROUP	BY v.ID, V.Mov, v.MovID, v.FechaEmision, v.Estatus, v.Moneda, v.TipoCambio, v.Condicion, v.Concepto, v.Referencia, t.importe, t.DescuentosTotales, t.DescuentosTotales, t.DescuentoLineal, t.SubTotal, t.Impuestos, t.ImporteTotal, e.Nombre, s.Nombre
ORDER	BY Orden ASC, CONVERT(DATETIME,v.FechaEmision) DESC
END
ELSE
BEGIN
SELECT	v.ID,
e.Nombre AS Empresa,
s.Nombre AS Sucursal,
RTRIM(v.Mov)+' '+RTRIM(ISNULL(v.MovID,'')) AS Movimiento,
CONVERT(VARCHAR(50),v.FechaEmision,121) AS FechaEmision,
v.Estatus,
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
CASE WHEN v.Estatus = 'PENDIENTE' THEN 1 WHEN v.Estatus = 'CONCLUIDO' THEN 2 WHEN v.Estatus = 'CANCELADO' THEN 3 ELSE 4 END Orden
FROM	Venta v
JOIN	MovTipo m ON v.Mov = m.Mov AND m.Modulo = 'VTAS'
JOIN	VentaCalc t ON v.ID = t.ID
LEFT	JOIN CFD f ON (v.ID = f.ModuloID AND f.Modulo = 'VTAS')
JOIN	Empresa e ON v.Empresa = e.Empresa
JOIN	Sucursal s ON v.Sucursal = s.Sucursal
WHERE	m.Clave IN ('VTAS.P','VTAS.F')
AND v.Cliente = @Usuario
AND v.FechaEmision BETWEEN @Desde AND @Hasta
AND v.Estatus = ISNULL(@EstatusV1,'')
GROUP	BY v.ID, V.Mov, v.MovID, v.FechaEmision, v.Estatus, v.Moneda, v.TipoCambio, v.Condicion, v.Concepto, v.Referencia, t.importe, t.DescuentosTotales, t.DescuentosTotales, t.DescuentoLineal, t.SubTotal, t.Impuestos, t.ImporteTotal, e.Nombre, s.Nombre
ORDER	BY Orden ASC, CONVERT(DATETIME,v.FechaEmision) DESC
END
RETURN
END

