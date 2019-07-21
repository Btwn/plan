SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSISPedidosCliente
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok			int          = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Cliente     	        varchar(10),
@Datos		        varchar(max),
@Empresa                varchar(5),
@ReferenciaIS           varchar(50),
@SubReferenciaIS        varchar(50),
@LenDatos               int
SELECT @ReferenciaIS = Referencia , @SubReferenciaIS = SubReferencia
FROM IntelisisService WITH (NOLOCK)
WHERE ID = @ID
SELECT @Cliente = Cliente, @Empresa = Empresa
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Pedido')
WITH (Cliente varchar(255), Empresa varchar(5))
SELECT @Datos =(SELECT  Venta.ID,Venta.Empresa,Venta.Mov,Venta.MovID,Venta.FechaEmision ,Venta.Concepto,Venta.Proyecto,Venta.UEN,Venta.Moneda,CONVERT(varchar,Venta.TipoCambio) TipoCambio,Venta.Usuario,Venta.Referencia,Venta.Observaciones,Venta.Estatus,Venta.Cliente,Venta.EnviarA,Venta.Almacen,Venta.Agente,Venta.AgenteServicio,CONVERT(varchar,Venta.AgenteComision) AgenteComision,Venta.FormaEnvio,Venta.Condicion,Venta.Vencimiento ,Venta.CtaDinero,Venta.Descuento,CONVERT(varchar,Venta.DescuentoGlobal) DescuentoGlobal,CONVERT(varchar,Venta.Importe) Importe,CONVERT(varchar,Venta.Impuestos) Impuestos,CONVERT(varchar,Venta.Saldo) Saldo,CONVERT(varchar,Venta.DescuentoLineal) DescuentoLineal,Venta.OrigenTipo,Venta.Origen,Venta.OrigenID,Venta.FechaRegistro FechaRegistro,Venta.Causa,Venta.Atencion,Venta.AtencionTelefono,Venta.ListaPreciosEsp,Venta.ZonaImpuesto,Venta.Sucursal,Venta.SucursalOrigen,(SELECT ISNULL(SUM(AnticipoSaldo*TipoCambio),0.0) FROM Cxc WITH (NOLOCK) WHERE Empresa =Venta.Empresa AND Estatus IN ('PENDIENTE', 'CONCLUIDO') AND AnticipoSaldo>0 AND Cliente = Venta.Cliente AND PedidoReferenciaID = Venta.ID )Anticipos,
VentaD.ID,CONVERT(varchar,VentaD.Renglon) Renglon,VentaD.RenglonSub,VentaD.RenglonID,VentaD.RenglonTipo,ISNULL(VentaD.CantidadPendiente,ISNULL(VentaD.CantidadReservada,0.0)) Cantidad,VentaD.Almacen,VentaD.EnviarA,VentaD.Articulo,VentaD.SubCuenta,CONVERT(varchar,VentaD.Precio) Precio,CONVERT(varchar,VentaD.DescuentoLinea) DescuentoLinea,CONVERT(varchar,VentaD.Impuesto1) Impuesto1,CONVERT(varchar,VentaD.Impuesto2) Impuesto2,CONVERT(varchar,VentaD.Impuesto3) Impuesto3,VentaD.Aplica,VentaD.AplicaID,CONVERT(varchar,VentaD.CantidadPendiente) CantidadPendiente,CONVERT(varchar,VentaD.CantidadReservada) CantidadReservada,CONVERT(varchar,VentaD.CantidadCancelada) CantidadCancelada,CONVERT(varchar,VentaD.CantidadOrdenada) CantidadOrdenada,CONVERT(varchar,VentaD.CantidadA) CantidadA,VentaD.Unidad,CONVERT(varchar,VentaD.Factor) Factor,CONVERT(varchar,VentaD.Puntos) Puntos,CONVERT(varchar,VentaD.CantidadObsequio) CantidadObsequio,VentaD.OfertaID,VentaD.Sucursal, VentaD.Codigo
FROM Venta Venta WITH (NOLOCK) JOIN VentaD VentaD WITH (NOLOCK) ON Venta.ID = VentaD.ID
JOIN MovTipo mt WITH (NOLOCK) ON Venta.Mov = mt.Mov AND mt.Modulo = 'VTAS'
WHERE Venta.Estatus IN ('PENDIENTE')
AND mt.Clave = 'VTAS.P'
AND ISNULL(Venta.Condicion,'') NOT IN (SELECT Condicion FROM Condicion WITH (NOLOCK) WHERE ControlAnticipos = 'Cobrar Pedido')
AND Venta.Empresa = @Empresa
AND Venta.Cliente = @Cliente
AND ISNULL(VentaD.CantidadPendiente,ISNULL(VentaD.CantidadReservada,0.0)) >0.0
FOR XML AUTO)
IF NULLIF(@Datos    ,'') IS NULL
SELECT @OK = 1 ,@OkRef= 'El Cliente No Tiene Pedidos,  '+@Cliente
SELECT @Datos = ISNULL(@Datos,'')
SELECT @LenDatos = LEN(@Datos)
IF @LenDatos BETWEEN 0 AND 3999
SELECT @Datos = @Datos+ '<Relleno '+  +'A="'+REPLICATE('X',4000-@LenDatos)+'" />'
SELECT @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34)
+ ' SubReferencia='+ CHAR(34) + ISNULL(@SubReferenciaIS,'') + CHAR(34)
+' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)+' >' +ISNULL(@Datos,'')+'</Resultado></Intelisis>'
END

