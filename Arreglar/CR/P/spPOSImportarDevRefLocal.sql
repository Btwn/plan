SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSImportarDevRefLocal
@ID                 varchar(50),
@IDOrigen           varchar(50),
@Estacion           int,
@Sucursal           int,
@Ok                 int OUTPUT,
@OkRef              varchar(255) OUTPUT

AS
BEGIN
DECLARE
@MovGenerar						varchar(20),
@Host							varchar(20),
@Cluster						varchar(20),
@Empresa						varchar(5),
@cfgImpuestoIncluido			bit,
@Articulo						varchar(20),
@SubCuenta						varchar(50),
@SerieLote						varchar(50),
@Cantidad						float,
@CantidadS						float,
@RenglonID						int,
@Mov							varchar(20),
@FechaEmision					datetime,
@Cajero							varchar(10),
@Caja							varchar(10),
@CtaDinero						varchar(10),
@ArtOfertaFP					varchar(20),
@CodigoRedondeo					varchar(30),
@ArticuloRedondeo				varchar(20),
@CfgAnticipoArticuloServicio	varchar(20)
SELECT @Mov = Mov, @FechaEmision = FechaEmision, @Cajero = Cajero, @Caja = Caja, @CtaDinero = CtaDinero, @Empresa = Empresa
FROM POSL
WHERE ID = @ID
SELECT @CodigoRedondeo = RedondeoVentaCodigo , @ArtOfertaFP = ArtOfertaFP
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @ArticuloRedondeo = Cuenta
FROM CB
WHERE Codigo = @CodigoRedondeo
AND TipoCuenta = 'Articulos'
SELECT @ArticuloRedondeo = cb.Cuenta
FROM CB
WHERE CB.Cuenta = @CodigoRedondeo AND CB.TipoCuenta = 'Articulos'
SELECT @CfgAnticipoArticuloServicio = NULLIF(CxcAnticipoArticuloServicio,'')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
DELETE POSVentaPedidoTemp  WHERE Estacion = @Estacion
DELETE POSVentaPedidoDTemp2  WHERE Estacion = @Estacion
DELETE POSVentaPedidoSerieloteTemp WHERE Estacion = @Estacion
IF EXISTS(SELECT *  FROM POSLVenta WHERE ID = @IDOrigen AND Articulo IN(@ArtOfertaFP))
SELECT @Ok = 30465
IF @Ok IS NULL
INSERT POSVentaPedidoTemp(
Estacion, ID, Empresa, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia, Observaciones, Estatus, Cliente,
EnviarA, Almacen, Agente, AgenteServicio, AgenteComision, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Importe, Impuestos,
Saldo, DescuentoLineal, FechaRegistro, Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, SucursalOrigen, Monedero)
SELECT
@Estacion, -1, Empresa, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, 1, Usuario, Referencia, Observaciones, Estatus, Cliente,
EnviarA, Almacen, Agente, NULL, NULL, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Importe, Impuestos,
NULL, NULL, FechaRegistro, Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, Sucursal, Monedero
FROM POSL
WHERE ID = @IDOrigen
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
INSERT POSVentaPedidoDTemp2(
Estacion, ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad, Almacen, EnviarA, Articulo, SubCuenta, Precio, PrecioSugerido, DescuentoLinea,
Impuesto1, Impuesto2, Impuesto3, Aplica, AplicaID, CantidadPendiente, CantidadReservada, CantidadCancelada, CantidadOrdenada, CantidadA, Unidad,
Factor, Puntos, CantidadObsequio, OfertaID, Sucursal,
CantidadAplicar, Codigo, Importe)
SELECT
@Estacion, -1, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad, Almacen, NULL, Articulo, SubCuenta, Precio, PrecioSugerido, DescuentoLinea,
Impuesto1, Impuesto2, Impuesto3, Aplica, AplicaID, 0, 0, 0, 0, 0, Unidad,
Factor, Puntos, CantidadObsequio, OfertaID, @Sucursal,
0.0, Codigo, (Cantidad - ISNULL(CantidadObsequio, 0.0)) * ISNULL((Precio - (Precio * (ISNULL(DescuentoLinea,0.0)/100))),0.0)
FROM POSLVenta
WHERE ID = @IDOrigen
AND Articulo NOT IN(@CfgAnticipoArticuloServicio,@ArticuloRedondeo,@ArtOfertaFP)
IF @@ERROR <> 0
SET @Ok = 1
IF @OK IS NULL AND EXISTS(SELECT * FROM POSLSerieLote WHERE ID = @IDOrigen)
BEGIN
INSERT POSVentaPedidoSerieloteTemp (
Estacion,  ID, RenglonID,  Articulo,  SubCuenta,  SerieLote, Cantidad)
SELECT
@Estacion, -1, RenglonID,  Articulo,  SubCuenta,  SerieLote, 1
FROM POSLSerieLote
WHERE ID = @IDOrigen
END
END

