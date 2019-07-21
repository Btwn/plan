SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW VentaCteD

AS
SELECT
l.Estacion,
l.ID,
l.Renglon,
l.RenglonSub,
l.CantidadA,
v.Empresa,
v.Mov,
v.MovID,
v.FechaEmision,
v.Concepto,
v.Proyecto,
v.Moneda,
v.TipoCambio,
v.Usuario,
v.Referencia,
v.Observaciones,
v.Estatus,
v.Situacion,
v.SituacionFecha,
v.SituacionUsuario,
v.SituacionNota,
v.Cliente,
d.EnviarA,
d.Almacen,
v.Agente,
v.Descuento,
v.Condicion,
v.Vencimiento,
v.DescuentoGlobal,
v.SobrePrecio,
v.Saldo,
v.Importe,
v.Impuestos,
v.ComisionTotal,
v.DescuentoLineal,
d.RenglonTipo,
d.Cantidad - ISNULL(VD.CantidadA, 0.0) Cantidad,
d.CantidadInventario,
d.Codigo,
d.Articulo,
d.SubCuenta,
d.Precio,
d.DescuentoTipo,
d.DescuentoLinea,
d.Impuesto1,
d.Impuesto2,
d.Impuesto3,
d.DescripcionExtra,
d.Costo,
d.CantidadCancelada,
a.Descripcion1
FROM Venta v
JOIN VentaD d ON v.ID = d.ID
JOIN VentaCteDLista l ON d.ID = l.ID AND d.Renglon = l.Renglon AND d.RenglonSub = l.RenglonSub
JOIN Art a ON d.Articulo = a.Articulo
LEFT JOIN VentaCteDevolucion vd ON v.ID = vd.RID AND d.Renglon = vd.Renglon
WHERE d.Cantidad - ISNULL(VD.CantidadA, 0.0) <= d.Cantidad
AND d.Cantidad - ISNULL(VD.CantidadA, 0.0) > 0

