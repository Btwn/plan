SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spPOSSolicitudAfectarVentaLocal
@ID      	varchar(50),
@Empresa        varchar(5),
@Estacion       int,
@Sucursal       int,
@Usuario        varchar(10),
@Ok             int OUTPUT,
@OkRef          varchar(255) OUTPUT

AS
BEGIN
DECLARE
@Cliente						varchar(10),
@IDVenta						int,
@Monedero						varchar(20),
@CodigoRedondeo					varchar(50),
@ArticuloRedondeo				varchar(20),
@VentaPreciosImpuestoIncluido	bit
DECLARE @Anticipos table(
ID                   int,
AnticipoAplicar      float
)
SELECT @CodigoRedondeo = pc.RedondeoVentaCodigo
FROM POSCfg pc WITH (NOLOCK)
WHERE pc.Empresa = @Empresa
SELECT @VentaPreciosImpuestoIncluido = ISNULL(VentaPreciosImpuestoIncluido,0)
FROM EmpresaCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @ArticuloRedondeo = Cuenta
FROM CB WITH (NOLOCK)
WHERE Codigo = @CodigoRedondeo
AND TipoCuenta = 'Articulos'
SELECT @Monedero = Monedero
FROM POSL WITH (NOLOCK)
WHERE ID = @ID
IF @Ok IS NULL
BEGIN
INSERT Venta (
Empresa, Mov, MovID, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia, Estatus,
Observaciones, Cliente, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Causa,
Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, OrigenTipo, Origen, OrigenID, ReferenciaOrdenCompra, GenerarDinero,
SucursalOrigen, AnticipoFacturadoTipoServicio)
SELECT
Empresa, Mov, MovID, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia, 'SINAFECTAR', Observaciones,
Cliente, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Causa, Atencion, AtencionTelefono,
ListaPreciosEsp, ZonaImpuesto, Sucursal, 'POS', Origen, OrigenID, ID, 1, Sucursal, 1
FROM POSL WITH (NOLOCK)
WHERE ID = @ID
SELECT @IDVenta = SCOPE_IDENTITY()
END
IF @Ok IS NULL AND @IDVenta IS NOT NULL
BEGIN
INSERT VentaD (
ID, Renglon, RenglonID, Aplica, AplicaID, RenglonTipo, Cantidad, CantidadObsequio, Almacen, EnviarA, Articulo, SubCuenta, Precio,
DescuentoLinea, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, Sucursal, Puntos, AnticipoFacturado, AnticipoRetencion, AnticipoMoneda,
AnticipoTipoCambio)
SELECT
@IDVenta, d.Renglon, d.RenglonID, v.Origen, v.OrigenID, d.RenglonTipo, d.Cantidad, d.CantidadObsequio, d.Almacen, NULL, d.Articulo, d.SubCuenta,
CASE WHEN d.Articulo = @ArticuloRedondeo
THEN d.Precio / (1-(ISNULL(v.DescuentoGlobal,0)/100))
ELSE CASE WHEN @VentaPreciosImpuestoIncluido = 1
THEN d.PrecioImpuestoInc
ELSE d.Precio
END
END, d.DescuentoLinea, d.Impuesto1, d.Impuesto2, d.Impuesto3, d.Unidad, 1, v.Sucursal, d.Puntos, d.AnticipoFacturado, d.AnticipoRetencion, v.Moneda,
v.TipoCambio
FROM POSLVenta  d WITH (NOLOCK)
JOIN POSL  v WITH (NOLOCK) ON v.ID = d.ID
WHERE v.ID = @ID
END
IF EXISTS(SELECT * FROM POSValeSerie WITH (NOLOCK) WHERE Serie = @Monedero)AND @IDVenta IS NOT NULL
INSERT TarjetaSerieMov(
Empresa, ID, Modulo, Serie, Sucursal)
SELECT
@Empresa, @IDVenta, 'VTAS', @Monedero, @Sucursal
IF EXISTS(SELECT * FROM POSLSerieLote WITH (NOLOCK) WHERE ID = @ID )AND @IDVenta IS NOT NULL
INSERT SerieLoteMov (
Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Sucursal)
SELECT
@Empresa, 'VTAS', @IDVenta, RenglonID, Articulo, ISNULL(SubCuenta, ''), SerieLote, COUNT(*), @Sucursal
FROM POSLSerieLote WITH (NOLOCK)
WHERE ID = @ID
GROUP BY Articulo, ISNULL(SubCuenta,''), SerieLote, RenglonID
IF EXISTS(SELECT * FROM POSVentaCobro WITH (NOLOCK) WHERE ID = @ID)AND @IDVenta IS NOT NULL
INSERT VentaCobro(
ID, Importe1, Importe2, Importe3, Importe4, Importe5, FormaCobro1, FormaCobro2, FormaCobro3, FormaCobro4, FormaCobro5, Referencia1, Referencia2,
Referencia3, Referencia4, Referencia5, CtaDinero, Cajero,POSTipoCambio1, POSTipoCambio2, POSTipoCambio3, POSTipoCambio4, POSTipoCambio5)
SELECT
@IDVenta, Importe1, Importe2, Importe3, Importe4, Importe5, FormaCobro1, FormaCobro2, FormaCobro3, FormaCobro4, FormaCobro5, Referencia1, Referencia2,
Referencia3, Referencia4, Referencia5, CtaDinero, Cajero,POSTipoCambio1, POSTipoCambio2, POSTipoCambio3, POSTipoCambio4, POSTipoCambio5
FROM POSVentaCobro WITH (NOLOCK)
WHERE ID = @ID
IF EXISTS (SELECT * FROM POSTarjetaSerieMov WITH (NOLOCK) WHERE ID = @ID)AND @IDVenta IS NOT NULL
INSERT TarjetaSerieMov(
Empresa, ID, Importe, ImporteTarjeta, Modulo, Serie, Sucursal, TipoCambioTarjeta)
SELECT
Empresa, @IDVenta, Importe, ImporteTarjeta, 'VTAS', Serie, Sucursal, TipoCambioTarjeta
FROM POSTarjetaSerieMov WITH (NOLOCK)
WHERE ID = @ID
INSERT @Anticipos(
ID, AnticipoAplicar)
SELECT
RID, AnticipoAplicar
FROM POSCxcAnticipoTemp WITH (NOLOCK)
WHERE Estacion = @Estacion AND ISNULL(AnticipoAplicar,0.0)>0.0
IF EXISTS(SELECT * FROM @Anticipos)AND @IDVenta IS NOT NULL
BEGIN
INSERT POSCxcAnticipo(
ID, RID, Cliente, Mov, MovID, FechaEmision, Referencia, Concepto, AnticipoSaldo, Moneda, TipoCambio, Importe, Impuestos ,Retencion,
AnticipoAplicar, GUIDOrigen, PedidoReferencia, PedidoReferenciaID)
SELECT
@ID, RID, Cliente, Mov, MovID, FechaEmision, Referencia, Concepto, AnticipoSaldo, Moneda, TipoCambio, Importe, Impuestos ,Retencion,
AnticipoAplicar, GUIDOrigen, PedidoReferencia, PedidoReferenciaID
FROM POSCxcAnticipoTemp WITH (NOLOCK)
WHERE Estacion = @Estacion AND ISNULL(AnticipoAplicar,0.0)>0.0
UPDATE Cxc WITH (ROWLOCK) SET AnticipoAplicaID = @IDVenta ,AnticipoAplicaModulo = 'VTAS',AnticipoAplicar =a.AnticipoAplicar
FROM @Anticipos a JOIN Cxc c ON a.ID = c.ID
END
IF @Ok IS NULL AND @IDVenta IS NOT NULL AND @Usuario IS NOT NULL
EXEC spAfectar 'VTAS', @IDVenta, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END

