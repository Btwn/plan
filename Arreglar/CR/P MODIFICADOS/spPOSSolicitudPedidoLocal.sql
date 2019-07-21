SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spPOSSolicitudPedidoLocal
@ID      		varchar(50),
@Empresa        varchar(5),
@Estacion       int,
@Sucursal       int,
@Usuario        varchar(10),
@Ok             int				OUTPUT,
@OkRef          varchar(255)	OUTPUT

AS
BEGIN
DECLARE
@Cliente      varchar(10)
DECLARE @Venta table(
Estacion				int,
ID						int,
Empresa					varchar(5) ,
Mov						varchar(20),
MovID					varchar(20),
FechaEmision			datetime,
Concepto				varchar(50),
Proyecto				varchar(50),
UEN						int,
Moneda					varchar(10),
TipoCambio				float,
Usuario					varchar(10),
Referencia				varchar(50),
Observaciones			varchar(100),
Estatus					varchar(15),
Cliente					varchar(10),
EnviarA					int,
Almacen					varchar(10),
Agente					varchar(10),
AgenteServicio			varchar(10),
AgenteComision			float,
FormaEnvio				varchar(50),
Condicion				varchar(50),
Vencimiento				datetime   ,
CtaDinero				varchar(10),
Descuento				varchar(30),
DescuentoGlobal			float,
Importe					money,
Impuestos				money,
Saldo					money,
DescuentoLineal			money,
OrigenTipo				varchar(10),
Origen					varchar(20),
OrigenID				varchar(20),
FechaRegistro			datetime   ,
Causa					varchar(50),
Atencion				varchar(50),
AtencionTelefono		varchar(50),
ListaPreciosEsp			varchar(20),
ZonaImpuesto			varchar(30),
Sucursal				int,
SucursalOrigen			int
)
DECLARE @VentaD table(
Estacion				int,
ID						int,
Renglon					float,
RenglonSub				int,
RenglonID				int,
RenglonTipo				char(1),
Cantidad				float,
Almacen					varchar(10),
EnviarA					int,
Articulo				varchar(20),
SubCuenta				varchar(50),
Precio					float,
DescuentoLinea			money,
Impuesto1				float,
Impuesto2				float,
Impuesto3				float,
Aplica					varchar(20),
AplicaID				varchar(20),
CantidadPendiente		float,
CantidadReservada		float,
CantidadCancelada		float,
CantidadOrdenada		float,
CantidadA				float,
Unidad					varchar(50),
Factor					float,
Puntos					money,
CantidadObsequio		float,
OfertaID				int,
Sucursal				int,
Codigo					varchar(30)
)
SELECT @Cliente = Cliente FROM POSL WITH (NOLOCK) WHERE ID = @ID
IF @Ok IS NULL
BEGIN
DELETE POSVentaPedidoTemp  WHERE Estacion = @Estacion
DELETE POSVentaPedidoDTemp  WHERE Estacion = @Estacion
INSERT @Venta(
Estacion, ID, Empresa, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia,
Observaciones, Estatus, Cliente, EnviarA, Almacen, Agente, AgenteServicio, AgenteComision, FormaEnvio, Condicion, Vencimiento,
CtaDinero, Descuento, DescuentoGlobal, Importe, Impuestos, Saldo, DescuentoLineal, OrigenTipo, Origen, OrigenID, FechaRegistro,
Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, SucursalOrigen)
SELECT
@Estacion, v.ID, v.Empresa, v.Mov, v.MovID, v.FechaEmision, v.Concepto, v.Proyecto, v.UEN, v.Moneda, v.TipoCambio, v.Usuario, v.Referencia,
v.Observaciones, v.Estatus, v.Cliente, v.EnviarA, v.Almacen, v.Agente, v.AgenteServicio, v.AgenteComision, v.FormaEnvio, v.Condicion, v.Vencimiento,
v.CtaDinero, v.Descuento, v.DescuentoGlobal, v.Importe, v.Impuestos, v.Saldo, v.DescuentoLineal, v.OrigenTipo, v.Origen, v.OrigenID, v.FechaRegistro,
v.Causa, v.Atencion, v.AtencionTelefono, v.ListaPreciosEsp, v.ZonaImpuesto, v.Sucursal, v.SucursalOrigen
FROM Venta v WITH (NOLOCK) JOIN MovTipo mt WITH (NOLOCK) ON v.Mov = mt.Mov AND mt.Modulo = 'VTAS'
WHERE v.Empresa = @Empresa
AND v.Estatus IN ('PENDIENTE')
AND mt.Clave = 'VTAS.P'
AND v.Cliente = @Cliente
IF @@ERROR<>0
SET @Ok = 1
IF @Ok IS NULL
BEGIN
INSERT @VentaD(
Estacion,ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad, Almacen, EnviarA, Articulo, SubCuenta, Precio, DescuentoLinea,
Impuesto1, Impuesto2, Impuesto3, Aplica, AplicaID, CantidadPendiente, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadA,
Unidad, Factor, Puntos, CantidadObsequio, OfertaID, Sucursal, Codigo)
SELECT
@Estacion, ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad, Almacen, EnviarA, Articulo, SubCuenta, Precio, DescuentoLinea,
Impuesto1, Impuesto2, Impuesto3, Aplica, AplicaID, CantidadPendiente, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadA,
Unidad, Factor, Puntos, CantidadObsequio, OfertaID, Sucursal,Codigo
FROM VentaD WITH (NOLOCK)
WHERE ID IN (SELECT ID FROM @Venta)
IF @@ERROR<>0
SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
INSERT POSVentaPedidoTemp(
Estacion, ID, Empresa, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia, Observaciones,
Estatus, Cliente, EnviarA, Almacen, Agente, AgenteServicio, AgenteComision, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento,
DescuentoGlobal, Importe, Impuestos, Saldo, DescuentoLineal, OrigenTipo, Origen, OrigenID, FechaRegistro, Causa, Atencion,
AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, SucursalOrigen)
SELECT
Estacion, ID, Empresa, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia, Observaciones,
Estatus, Cliente, EnviarA, Almacen, Agente, AgenteServicio, AgenteComision, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento,
DescuentoGlobal, Importe, Impuestos, Saldo, DescuentoLineal, OrigenTipo, Origen, OrigenID, FechaRegistro, Causa, Atencion,
AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, SucursalOrigen
FROM @Venta
WHERE Estacion = @Estacion
IF @@ERROR<>0
SET @Ok = 1
IF @Ok  IS NULL
INSERT POSVentaPedidoDTemp(
Estacion, ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad, Almacen, EnviarA, Articulo, SubCuenta, Precio,
DescuentoLinea, Impuesto1, Impuesto2, Impuesto3, Aplica, AplicaID, CantidadPendiente, CantidadReservada, CantidadCancelada,
CantidadOrdenada, CantidadA, Unidad, Factor, Puntos, CantidadObsequio, OfertaID, Sucursal, Codigo)
SELECT
d.Estacion, d.ID, d.Renglon, d.RenglonSub, d.RenglonID, d.RenglonTipo, d.Cantidad, d.Almacen, d.EnviarA, d.Articulo, d.SubCuenta, d.Precio,
d.DescuentoLinea, d.Impuesto1, d.Impuesto2, d.Impuesto3, v.Mov,  v.MovID,  d.CantidadPendiente, d.CantidadReservada, d.CantidadCancelada,
d.CantidadOrdenada, d.CantidadA, d.Unidad, d.Factor, d.Puntos, d.CantidadObsequio, d.OfertaID, d.Sucursal, d.Codigo
FROM @VentaD d JOIN @Venta v ON d.Estacion = v.Estacion AND d.ID = v.ID
WHERE d.Estacion = @Estacion
END
END
END

