SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW VentaUtilD

AS
SELECT
f.ID,
f.Empresa,
f.Sucursal,
f.Mov,
f.MovID,
RTRIM(f.Mov)+' '+RTRIM(Convert(Char,f.MovID)) Movimiento,
m.Clave MovClave,
f.Ejercicio,
f.Periodo,
f.FechaEmision,
f.Cliente,
d.EnviarA,
f.Agente,
f.Proyecto,
f.UEN,
f.Moneda,
f.TipoCambio,
f.DescuentoGlobal,
f.SobrePrecio,
d.Almacen,
d.RenglonID,
d.Renglon,
d.RenglonSub,
d.Articulo,
d.Impuesto1,
d.Impuesto2,
d.Impuesto3,
"Cantidad" = sum(d.Cantidad),
"Precio" = Convert(money, sum(CONVERT(money, d.Precio*d.Cantidad))/sum(d.Cantidad)),
"DescuentoTipo" = '%',
"DescuentoLinea" = CONVERT(money, ROUND(avg(case d.DescuentoTipo when '$' then (d.DescuentoLinea/d.precio)*100 else d.DescuentoLinea end), v.RedondeoMonetarios)),
"Importe2" = sum(CONVERT(money, d.Cantidad*d.Precio)),
"Importe" = CONVERT(money, sum(ROUND(CONVERT(money, d.Cantidad*d.Precio), v.RedondeoMonetarios)) * (1-avg(case d.DescuentoTipo when '$' then (ISNULL(d.DescuentoLinea, 0.0)/d.precio)*100 else ISNULL(d.DescuentoLinea,0.0) end)/100)),
"CostoTotal" =sum(ROUND(Convert(money, (CASE WHEN d.RenglonTipo = 'J' AND ISNULL(d.Costo, 0.0) = 0.00 THEN j.CostoJuego ELSE d.Cantidad*ISNULL(d.Costo, 0.0) END)), v.RedondeoMonetarios)),
"CantidadFactor" = CONVERT(float, sum(d.Cantidad*d.Factor)),
"Comision" = sum(d.Comision)
FROM Venta f
JOIN VentaD d ON f.ID = d.ID
JOIN MovTipo m ON f.Mov = m.Mov AND m.Modulo = 'VTAS'
JOIN Version v on 1 = 1
JOIN (SELECT ID,RenglonID,SUM(Cantidad*ISNULL(Costo,0.0)) As CostoJuego FROM VentaD WHERE RenglonTipo <> 'J' GROUP BY ID,RenglonID)j ON j.ID = d.ID AND j.RenglonID = d.RenglonID
WHERE
f.Estatus = 'CONCLUIDO' AND
d.RenglonTipo not in ('E','P') AND
m.Clave IN ('VTAS.F', 'VTAS.FM', 'VTAS.D', 'VTAS.DF', 'VTAS.B')
GROUP BY
f.ID,
f.Empresa,
f.Sucursal,
f.Mov,
f.MovID,
m.Clave,
f.Ejercicio,
f.Periodo,
f.FechaEmision,
f.Cliente,
d.EnviarA,
f.Agente,
f.Proyecto,
f.UEN,
f.Moneda,
f.TipoCambio,
f.DescuentoGlobal,
f.SobrePrecio,
d.Almacen,
d.RenglonID,
d.Renglon,
d.RenglonSub,
d.Articulo,
d.Impuesto1,
d.Impuesto2,
d.Impuesto3,
v.RedondeoMonetarios

