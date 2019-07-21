SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW IVAFiscal

AS
SELECT
"Modulo" = CONVERT(char(5), 'VTAS'),
e.ID,
e.Sucursal,
e.Empresa,
e.Mov,
e.MovID,
e.Moneda,
e.Referencia,
"Contacto" = e.Cliente,
cte.Nombre,
cte.RFC,
cte.CURP,
"AplicaFecha" = e.FechaEmision,
"Aplica" = e.Mov,
"AplicaID" = e.MovID,
"AplicaImporte" = vc.TotalCobrado,
"FechaEmision" = e.FechaEmision,
"IVAFiscalFactor" = e.IVAFiscal,
"IVAFiscalImporte" = vc.TotalCobrado * e.IVAFiscal,
"Factor" = 1,
"Dinero" = CONVERT(char(20), NULL),
"DineroID" = CONVERT(varchar(20), NULL),
"DineroCtaDinero" = CONVERT(char(10), NULL),
"Conciliado" = CONVERT(bit, 1),
"FechaConciliacion" = e.FechaEmision
FROM Venta e
JOIN VentaCobro vc ON e.ID = vc.ID
JOIN Cte ON e.Cliente =cte.Cliente
JOIN MovTipo mt ON e.Mov = mt.Mov AND mt.Modulo = 'VTAS'
WHERE
mt.Clave IN ('VTAS.N', 'VTAS.FM', 'VTAS.NO', 'VTAS.NR', 'VTAS.F', 'VTAS.S', 'VTAS.P', 'VTAS.VP', 'VTAS.SD', 'VTAS.B') AND e.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND vc.TotalCobrado <> 0
UNION
SELECT
"Modulo" = CONVERT(char(5), 'CXC'),
e.ID,
e.Sucursal,
e.Empresa,
e.Mov,
e.MovID,
e.Moneda,
e.Referencia,
"Contacto" = e.Cliente,
cte.Nombre,
cte.RFC,
cte.CURP,
"AplicaFecha" = e.FechaEmision,
d.Aplica,
d.AplicaID,
"AplicaImporte" = d.Importe,
"FechaEmision" = a.FechaEmision,
"IVAFiscalFactor" = a.IVAFiscal,
"IVAFiscalImporte" = CONVERT(money, d.Importe * a.IVAFiscal),
"Factor" = CASE mt.Clave WHEN 'CXC.DC' THEN -1 ELSE 1 END,
e.Dinero,
e.DineroID,
e.DineroCtaDinero,
"Conciliado" = e.DineroConciliado,
"FechaConciliacion" = DineroFechaConciliacion
FROM Cxc e
JOIN Cte ON e.Cliente = cte.Cliente
JOIN CxcD d ON e.ID = d.ID
JOIN CxcAplica a ON d.Aplica=a.Mov AND d.AplicaID=a.MovID AND e.Empresa=a.Empresa
JOIN MovTipo mt ON e.Mov = mt.Mov AND mt.Modulo = 'CXC'
WHERE
mt.Clave IN ('CXC.C', 'CXC.DC', 'CXC.ANC') AND e.Estatus NOT IN ('SINAFECTAR', 'CANCELADO') 
UNION
SELECT
"Modulo" = CONVERT(char(5), 'CXC'),
e.ID,
e.Sucursal,
e.Empresa,
e.Mov,
e.MovID,
e.Moneda,
e.Referencia,
"Contacto" = e.Cliente,
cte.Nombre,
cte.RFC,
cte.CURP,
"AplicaFecha" = e.FechaEmision,
"Aplica" = e.Mov,
"AplicaID" = e.MovID,
"AplicaImporte" = ISNULL(e.Importe, 0)+ISNULL(e.Impuestos, 0),
"FechaEmision" = e.FechaEmision,
"IVAFiscalFactor" = e.IVAFiscal,
"IVAFiscalImporte" = CONVERT(money, (ISNULL(e.Importe, 0)+ISNULL(e.Impuestos, 0)) * e.IVAFiscal),
"Factor" = 1,
e.Dinero,
e.DineroID,
e.DineroCtaDinero,
"Conciliado" = e.DineroConciliado,
"FechaConciliacion" = DineroFechaConciliacion
FROM Cxc e
JOIN Cte ON e.Cliente = cte.Cliente
JOIN MovTipo mt ON e.Mov = mt.Mov AND mt.Modulo = 'CXC'
WHERE
mt.Clave IN ('CXC.A', 'CXC.AA') AND e.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
UNION
SELECT
"Modulo" = CONVERT(char(5), 'CXP'),
e.ID,
e.Sucursal,
e.Empresa,
e.Mov,
e.MovID,
e.Moneda,
e.Referencia,
"Contacto" = e.Proveedor,
prov.Nombre,
prov.RFC,
prov.CURP,
"AplicaFecha" = e.FechaEmision,
d.Aplica,
d.AplicaID,
"AplicaImporte" = d.Importe,
"FechaEmision" = a.FechaEmision,
"IVAFiscalFactor" = a.IVAFiscal,
"IVAFiscalImporte" = CONVERT(money, d.Importe * a.IVAFiscal),
"Factor" = CASE mt.Clave WHEN 'CXP.DC' THEN 1 ELSE -1 END,
e.Dinero,
e.DineroID,
e.DineroCtaDinero,
"Conciliado" = e.DineroConciliado,
"FechaConciliacion" = DineroFechaConciliacion
FROM Cxp e
JOIN Prov ON e.Proveedor = Prov.Proveedor
JOIN CxpD d ON e.ID = d.ID
JOIN CxpAplica a ON d.Aplica=a.Mov AND d.AplicaID=a.MovID AND e.Empresa=a.Empresa
JOIN MovTipo mt ON e.Mov = mt.Mov AND mt.Modulo = 'CXP'
WHERE
mt.Clave IN ('CXP.P', 'CXP.DC', 'CXP.ANC') AND e.Estatus NOT IN ('SINAFECTAR', 'CANCELADO') 
UNION
SELECT
"Modulo" = CONVERT(char(5), 'CXP'),
e.ID,
e.Sucursal,
e.Empresa,
e.Mov,
e.MovID,
e.Moneda,
e.Referencia,
"Contacto" = e.Proveedor,
prov.Nombre,
prov.RFC,
prov.CURP,
"AplicaFecha" = e.FechaEmision,
"Aplica" = e.Mov,
"AplicaID" = e.MovID,
"AplicaImporte" = ISNULL(e.Importe, 0)+ISNULL(e.Impuestos, 0),
"FechaEmision" = e.FechaEmision,
"IVAFiscalFactor" = e.IVAFiscal,
"IVAFiscalImporte" = CONVERT(money, (ISNULL(e.Importe, 0)+ISNULL(e.Impuestos, 0)) * e.IVAFiscal),
"Factor" = -1,
e.Dinero,
e.DineroID,
e.DineroCtaDinero,
"Conciliado" = e.DineroConciliado,
"FechaConciliacion" = DineroFechaConciliacion
FROM Cxp e
JOIN Prov ON e.Proveedor = prov.Proveedor
JOIN MovTipo mt ON e.Mov = mt.Mov AND mt.Modulo = 'CXP'
WHERE
mt.Clave IN ('CXP.A', 'CXP.AA') AND e.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
UNION
SELECT
"Modulo" = CONVERT(char(5), 'GAS'),
e.ID,
e.Sucursal,
e.Empresa,
e.Mov,
e.MovID,
e.Moneda,
'Referencia' = CONVERT(varchar(50), NULL),
"Contacto" = e.Acreedor,
prov.Nombre,
prov.RFC,
prov.CURP,
"AplicaFecha" = e.FechaEmision,
"Aplica" = e.Mov,
"AplicaID" = e.MovID,
"AplicaImporte" = ISNULL(e.Importe, 0)+ISNULL(e.Impuestos, 0),
"FechaEmision" = e.FechaEmision,
"IVAFiscalFactor" = CONVERT(float, NULLIF(Impuestos, 0)) / NULLIF(Importe + Impuestos, 0),
"IVAFiscalImporte" = e.Impuestos,
"Factor" = -1,
e.Dinero,
e.DineroID,
e.DineroCtaDinero,
"Conciliado" = e.DineroConciliado,
"FechaConciliacion" = DineroFechaConciliacion
FROM Gasto e
JOIN Prov ON e.Acreedor = prov.Proveedor
JOIN MovTipo mt ON e.Mov  = mt.Mov AND mt.Modulo = 'GAS'
WHERE
mt.Clave IN ('GAS.C', 'GAS.CCH') AND e.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')

