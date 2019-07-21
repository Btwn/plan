SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW VerVentaD

AS
SELECT
Venta.ID,
VentaD.Renglon,
VentaD.RenglonSub,
Venta.Empresa,
Venta.Mov,
Venta.MovID,
Venta.Moneda,
Venta.FechaEmision,
"FechaRequerida" = ISNULL(VentaD.FechaRequerida, Venta.FechaRequerida),
"FechaSalida" = DATEADD(day, VentaD.Cantidad-ISNULL(VentaD.CantidadCancelada, 0.0), ISNULL(VentaD.FechaRequerida, Venta.FechaRequerida)),
HoraRequerida = VentaD.HoraRequerida,
Venta.Prioridad,
Venta.Referencia,
Venta.Proyecto,
Venta.Concepto,
Venta.Estatus,
Venta.Cliente,
VentaD.EnviarA,
Venta.DescuentoGlobal,
Venta.SobrePrecio,
Venta.ServicioArticulo,
Venta.ServicioSerie,
Venta.ServicioFecha,
Venta.ServicioNumeroEconomico,
Venta.Sucursal,
Venta.SucursalOrigen,
VentaD.Agente,
VentaD.Almacen,
VentaD.Articulo,
VentaD.SubCuenta,
VentaD.Espacio,
"Cantidad" = VentaD.Cantidad-ISNULL(VentaD.CantidadCancelada, 0.0),
VentaD.CantidadReservada,
VentaD.CantidadOrdenada,
VentaD.CantidadPendiente,
VentaD.Unidad,
VentaD.Factor,
"CantidadFactor"  = (VentaD.Cantidad-ISNULL(VentaD.CantidadCancelada, 0.0))/VentaD.Factor,
"ReservadaFactor" = VentaD.CantidadReservada*VentaD.Factor,
"OrdenadaFactor"  = VentaD.CantidadOrdenada*VentaD.Factor,
"PendienteFactor" = VentaD.CantidadPendiente*VentaD.Factor,
VentaD.CantidadInventario,
VentaD.Precio,
VentaD.DescuentoTipo,
VentaD.DescuentoLinea,
VentaD.Impuesto1,
VentaD.Impuesto2,
VentaD.Impuesto3,
VentaD.Retencion1,
VentaD.Retencion2,
VentaD.Retencion3,
VentaD.DescripcionExtra,
VentaD.Instruccion,
VentaD.PoliticaPrecios,
VentaD.PrecioMoneda,
VentaD.PrecioTipoCambio,
VentaD.Paquete,
VentaD.UEN,
Cte.Nombre CteNombre,
Art.Descripcion1 ArtDescripcion,
Art.SeProduce ArtSeProduce,
Art.SeCompra ArtSeCompra,
Art.Espacios,
Art.EspaciosNivel,
"MovTipo" = mt.Clave,
"Semana" = DATEDIFF(week, GETDATE(), ISNULL(VentaD.FechaRequerida, Venta.FechaRequerida))
FROM Venta
JOIN VentaD ON Venta.ID = VentaD.ID
JOIN Cte ON Venta.Cliente = Cte.Cliente
JOIN Art ON VentaD.Articulo = Art.Articulo
JOIN MovTipo mt ON Venta.Mov = mt.Mov AND mt.Modulo = 'VTAS'

