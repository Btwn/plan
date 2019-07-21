SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CompraConfirmarD

AS
SELECT
Compra.ID,
Compra.Empresa,
Compra.Mov,
Compra.MovID,
Compra.Moneda,
Compra.FechaEmision,
Compra.Referencia,
Compra.Estatus,
Compra.Proveedor,
Compra.DescuentoGlobal,
Compra.Proyecto,
Compra.UEN,
Compra.Prioridad,
Compra.Agente,
Compra.situacion,
CompraD.Renglon,
CompraD.RenglonSub,
CompraD.Articulo,
CompraD.SubCuenta,
"Cantidad" = CompraD.Cantidad-ISNULL(CompraD.CantidadCancelada, 0.0),
"CantidadPendiente" = ISNULL(CompraD.CantidadPendiente, 0.0),
CompraD.Costo,
CompraD.DescuentoTipo,
CompraD.DescuentoLinea,
CompraD.Impuesto1,
CompraD.Impuesto2,
CompraD.Impuesto3,
CompraD.Retencion1,
CompraD.Retencion2,
CompraD.Retencion3,
CompraD.FechaRequerida,
CompraD.FechaEntrega,
CompraD.DescripcionExtra,
CompraD.Almacen,
CompraD.DestinoTipo,
CompraD.Destino,
CompraD.DestinoID,
CompraD.Unidad,
CompraD.Factor,
"CantidadFactor"  = (CompraD.Cantidad-ISNULL(CompraD.CantidadCancelada, 0.0))*CompraD.Factor,
"PendienteFactor" = ISNULL(CompraD.CantidadPendiente, 0.0)*CompraD.Factor,
CompraD.CantidadInventario,
CompraD.Paquete,
CompraD.Cliente,
Prov.Nombre ProvNombre,
Prov.Categoria ProvCat,
Prov.Familia ProvFam,
Art.Descripcion1 ArtDescripcion,
"MovTipo" = mt.Clave,
"Semana" = DATEDIFF(week, GETDATE(), CompraD.FechaEntrega),
CompraD.ContUso,
CompraD.ContUso2,
CompraD.ContUso3,
"Modulo" = mt.Modulo
FROM
Compra
JOIN CompraD ON Compra.ID = CompraD.ID /*AND CompraD.CantidadPendiente > 0.0 */AND Compra.Estatus='CONFIRMAR'
LEFT OUTER JOIN Prov ON Compra.Proveedor = Prov.Proveedor
JOIN Art ON CompraD.Articulo = Art.Articulo
JOIN MovTipo mt ON Compra.Mov = mt.Mov AND mt.Modulo = 'COMS'

