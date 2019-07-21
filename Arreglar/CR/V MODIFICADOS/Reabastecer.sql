SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW Reabastecer

AS
SELECT
"Modulo" = CONVERT(char(5), 'VTAS'),
v.ID,
v.Empresa,
v.Sucursal,
v.Almacen,
v.Mov,
v.MovID,
v.Concepto,
v.Referencia,
v.Proyecto,
v.UEN,
v.Usuario,
v.FechaEmision,
v.FechaRegistro,
"MovTipo" = mt.Clave,
d.Articulo,
"SubCuenta" = NULLIF(RTRIM(d.SubCuenta), ''),
d.Unidad,
d.Cantidad,
d.CantidadInventario
FROM Venta v WITH(NOLOCK)
JOIN VentaD d WITH(NOLOCK) ON v.ID = d.ID
JOIN Art a WITH(NOLOCK) ON d.Articulo = a.Articulo
JOIN MovTipo mt WITH(NOLOCK) ON v.Mov = mt.Mov AND mt.Modulo = 'VTAS'
WHERE
a.Tipo NOT IN ('SERVICIO', 'JUEGO') AND v.Estatus IN ('CONCLUIDO', 'PROCESAR') AND v.Reabastecido = 0 AND mt.Clave IN ('VTAS.F','VTAS.FAR', 'VTAS.FB', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX', 'VTAS.FM', 'VTAS.N', 'VTAS.NO', 'VTAS.NR', 'VTAS.VC', 'VTAS.VCR', 'VTAS.EG', 'VTAS.SG') AND ISNULL(v.OrigenTipo, '') <> 'VMOS'
UNION
SELECT
"Modulo" = CONVERT(char(5), 'INV'),
i.ID,
i.Empresa,
i.Sucursal,
i.Almacen,
i.Mov,
i.MovID,
i.Concepto,
i.Referencia,
i.Proyecto,
i.UEN,
i.Usuario,
i.FechaEmision,
i.FechaRegistro,
"MovTipo" = mt.Clave,
d.Articulo,
"SubCuenta" = NULLIF(RTRIM(d.SubCuenta), ''),
d.Unidad,
d.Cantidad,
d.CantidadInventario
FROM Inv i WITH(NOLOCK)
JOIN InvD d WITH(NOLOCK) ON i.ID = d.ID
JOIN Art a WITH(NOLOCK) ON d.Articulo = a.Articulo
JOIN MovTipo mt WITH(NOLOCK) ON i.Mov = mt.Mov AND mt.Modulo = 'INV'
WHERE
a.Tipo NOT IN ('SERVICIO', 'JUEGO') AND i.Estatus = 'CONCLUIDO' AND i.Reabastecido = 0 AND mt.Clave IN ('INV.CM', 'INV.S')

