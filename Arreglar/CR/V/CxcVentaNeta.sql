SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CxcVentaNeta

AS
SELECT
Cxc.Empresa,
Cxc.FechaEmision,
Cxc.Cliente,
'EnviarA' = Cxc.ClienteEnviarA,
Cxc.Proyecto,
Cxc.UEN,
Cxc.Agente,
Cxc.Mov,
Cxc.Sucursal,
Cxc.Condicion,
'MovTipo' = MovTipo.Clave,
'Moneda' = Cxc.ClienteMoneda,
'Importe'= CASE WHEN MovTipo.Clave IN ('CXC.NC','CXC.DAC','CXC.NCD','CXC.NCF', 'CXC.DV', 'CXC.NCP', 'CXC.DFA') THEN -Cxc.Importe ELSE Cxc.Importe END,
'Impuestos'= CASE WHEN MovTipo.Clave IN ('CXC.NC','CXC.DAC','CXC.NCD','CXC.NCF', 'CXC.DV', 'CXC.NCP', 'CXC.DFA') THEN -Cxc.Impuestos ELSE Cxc.Impuestos END
FROM Cxc
JOIN MovTipo ON Cxc.Mov = MovTipo.Mov AND MovTipo.Modulo = 'CXC'
WHERE
MovTipo.Clave IN ('CXC.F', 'CXC.FA', 'CXC.DFA', 'CXC.AF', 'CXC.CA', 'CXC.CAD', 'CXC.CAP', 'CXC.VV', 'CXC.NC', 'CXC.DAC', 'CXC.NCD','CXC.NCF', 'CXC.DV', 'CXC.NCP') AND
Cxc.Estatus IN ('PENDIENTE','CONCLUIDO')
UNION ALL
SELECT
v.Empresa,
v.FechaEmision,
v.Cliente,
v.EnviarA,
v.Proyecto,
v.UEN,
v.Agente,
v.Mov,
v.Sucursal,
v.Condicion,
'MovTipo' = MovTipo.Clave,
'Moneda' = v.Moneda,
'Importe'= dbo.fnSubTotal(v.Importe, v.DescuentoGlobal, v.SobrePrecio),
'Impuestos' = v.Impuestos
FROM Venta v
JOIN MovTipo ON v.Mov = MovTipo.Mov AND MovTipo.Modulo = 'VTAS'
WHERE
(MovTipo.Clave = 'VTAS.FM' OR (MovTipo.Clave IN ('VTAS.F', 'VTAS.FB') AND v.OrigenTipo = 'VMOS')) AND v.Estatus = 'CONCLUIDO'
UNION ALL
SELECT
v.Empresa,
v.FechaEmision,
v.Cliente,
v.EnviarA,
v.Proyecto,
v.UEN,
v.Agente,
v.Mov,
v.Sucursal,
v.Condicion,
'MovTipo' = MovTipo.Clave,
'Moneda' = v.Moneda,
'Importe'   = CASE WHEN MovTipo.Clave IN ('VTAS.D', 'VTAS.DF') THEN -dbo.fnSubTotal(v.Importe, v.DescuentoGlobal, v.SobrePrecio) ELSE dbo.fnSubTotal(v.Importe, v.DescuentoGlobal, v.SobrePrecio) END,
'Impuestos' = CASE WHEN MovTipo.Clave IN ('VTAS.D', 'VTAS.DF') THEN -v.Impuestos ELSE v.Impuestos END
FROM Venta v
JOIN VentaCobro vc ON v.ID = vc.ID
JOIN MovTipo ON v.Mov = MovTipo.Mov AND MovTipo.Modulo = 'VTAS'
WHERE
MovTipo.Clave IN ('VTAS.F', 'VTAS.D', 'VTAS.DF')
AND NULLIF(vc.TotalCobrado, 0) IS NOT NULL AND
v.Estatus = 'CONCLUIDO'

