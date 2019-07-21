SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW VentaUtil

AS
SELECT
f.Empresa,
f.Sucursal,
f.FechaEmision,
'VTAS' Modulo,
f.ID,
f.Mov,
f.MovID,
RTRIM(f.Mov)+' '+RTRIM(Convert(Char,f.MovID)) Movimiento,
m.Clave MovClave,
f.Ejercicio,
f.Periodo,
f.Cliente,
d.EnviarA,
f.Agente,
f.Proyecto,
f.UEN,
f.Moneda,
f.TipoCambio,
f.Almacen,
f.DescuentoGlobal,
f.SobrePrecio,
f.Impuestos,
"Cantidad" = sum(d.Cantidad),
"Precio" = Convert(money, sum(CONVERT(money, d.Precio*d.Cantidad))/sum(d.Cantidad)),
"DescuentoTipo" = '%',
"DescuentoLinea" = CONVERT(money, ROUND(avg(case d.DescuentoTipo when '$' then (d.DescuentoLinea/d.precio)*100 else d.DescuentoLinea end), v.RedondeoMonetarios)),
"Importe" = SUM(ROUND(Convert(money, d.Cantidad * d.Precio - ISNULL(case d.DescuentoTipo when '$' then d.DescuentoLinea else d.Cantidad*d.Precio*(d.DescuentoLinea/100) end, 0.0)  ), v.RedondeoMonetarios)),
"CostoTotal" = CASE WHEN m.Clave = 'VTAS.B' THEN NULL ELSE sum(ROUND(Convert(money, d.Cantidad*ISNULL(d.Costo, 0.0)), v.RedondeoMonetarios)) END,
"ComisionTotal" = Convert(money, sum(d.Comision))
FROM Venta f
JOIN VentaD d ON f.ID = d.ID
JOIN MovTipo m ON f.Mov = m.Mov AND m.Modulo = 'VTAS'
JOIN Version v ON 1 = 1
WHERE
f.Estatus = 'CONCLUIDO' AND
d.RenglonTipo not in ('E','P') AND
m.Clave IN ('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.DF', 'VTAS.B')
GROUP BY
f.Empresa,
f.Sucursal,
f.FechaEmision,
f.ID,
f.Mov,
f.MovID,
m.Clave,
f.Ejercicio,
f.Periodo,
f.Cliente,
d.EnviarA,
f.Agente,
f.Proyecto,
f.UEN,
f.Moneda,
f.TipoCambio,
f.Almacen,
f.DescuentoGlobal,
f.SobrePrecio,
f.Impuestos,
v.RedondeoMonetarios
/*
UNION
SELECT
f.Empresa,
f.Sucursal,
f.FechaEmision,
'CXC' Modulo,
f.ID,
f.Mov,
f.MovID,
RTRIM(f.Mov)+' '+RTRIM(Convert(Char,f.MovID)) Movimiento,
m.Clave,
f.Ejercicio,
f.Periodo,
f.Cliente,
f.ClienteEnviarA,
"Agente"= NULL,
f.Proyecto,
f.UEN,
f.Moneda,
f.TipoCambio,
"Almacen" = NULL,
"DescuentoGlobal" = NULL,
"SobrePrecio" = NULL,
"Impuestos" = NULL,
"Cantidad" = NULL,
"Precio" = NULL,
"DescuentoTipo" = NULL,
"DescuentoLinea" = NULL,
Importe,
"CostoTotal" = NULL,
"ComisionTotal" = NULL
FROM CXC f,
MovTipo m
WHERE
m.Mov = f.Mov AND f.Estatus NOT IN ('SINAFECTAR', 'CANCELADO') AND
m.Clave IN ('CXC.NC','CXC.DAC','CXC.NCD','CXC.NCF','CXC.DV') AND
(f.OrigenTipo = NULL OR f.OrigenTipo <> 'VTAS')
*/

