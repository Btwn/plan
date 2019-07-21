SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSImportarVenta
@ID                 int,
@Estacion           int

AS
BEGIN
DECLARE
@IDNuevo              varchar(36),
@MovGenerar           varchar(20),
@Ok                   int,
@Host                 varchar(20),
@Cluster              varchar(20),
@Empresa              varchar(5),
@cfgImpuestoIncluido  bit,
@Articulo             varchar(20),
@SubCuenta            varchar(50),
@SerieLote            varchar(50),
@Cantidad             float,
@CantidadS            float,
@RenglonID            int
EXEC spPOSHost @Host OUTPUT, @Cluster OUTPUT
SELECT @IDNuevo = NEWID()
INSERT POSL (
ID, Empresa, Modulo, Mov, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia, Estatus, Observaciones,
Cliente, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Causa, Atencion, AtencionTelefono,
ListaPreciosEsp, ZonaImpuesto, Sucursal, OrigenTipo, Origen, OrigenID, Host, Cluster, Cajero, Importe, Impuestos, Caja)
SELECT
@IDNuevo, Empresa, 'VTAS', Origen, FechaEmision, GETDATE(), Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia, 'SINAFECTAR', Observaciones,
Cliente, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Causa, Atencion, AtencionTelefono,
ListaPreciosEsp, ZonaImpuesto, SucursalOrigen, 'VTAS', Mov, MovID, @Host, @Cluster, ServicioAseguradora, Importe, Impuestos, CtaDinero
FROM Venta WITH(NOLOCK)
WHERE ID = @ID
IF @@ERROR <> 0
SET @Ok = 1
SELECT @Empresa = Empresa
FROM POSL WITH(NOLOCK)
WHERE ID = @IDNuevo
SELECT @cfgImpuestoIncluido = ISNULL(VentaPreciosImpuestoIncluido,0)
FROM EmpresaCfg WITH(NOLOCK)
WHERE Empresa = @Empresa
IF @Ok IS NULL
INSERT POSLVenta(
ID, Renglon, RenglonID, Aplica, AplicaID, RenglonTipo, Cantidad, CantidadObsequio, Articulo, SubCuenta,
Precio, PrecioSugerido, DescuentoLinea, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, Puntos,
PrecioImpuestoInc, Codigo, Almacen)
SELECT
@IDNuevo, Renglon, RenglonID, Aplica, AplicaID, RenglonTipo, Cantidad, CantidadObsequio, Articulo, SubCuenta,
CASE WHEN @cfgImpuestoIncluido = 1
THEN  dbo.fnPOSPrecioSinImpuestos(Precio,Impuesto1, Impuesto2, Impuesto3)
ELSE Precio
END, PrecioSugerido, DescuentoLinea, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, Puntos,
CASE WHEN @cfgImpuestoIncluido = 0
THEN dbo.fnPOSPrecioConImpuestos(Precio,Impuesto1, Impuesto2, Impuesto3, @Empresa)
ELSE Precio
END, Codigo, Almacen
FROM VentaD WITH(NOLOCK)
WHERE ID = @ID
IF @@ERROR <> 0
SET @Ok = 1
IF @OK IS NULL
BEGIN
DECLARE crArticulo CURSOR FOR
SELECT  Articulo, SubCuenta, SerieLote, ISNULL(Cantidad,0.0), RenglonID
FROM SerieLoteMov WITH(NOLOCK)
WHERE ID = @ID AND Modulo = 'VTAS' AND Empresa = @Empresa
OPEN crArticulo
FETCH NEXT FROM crArticulo INTO @Articulo, @SubCuenta, @SerieLote, @Cantidad, @RenglonID
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @CantidadS = @Cantidad
WHILE @CantidadS >0
BEGIN
INSERT POSLSerieLote (
ID, RenglonID,  Articulo,  SubCuenta,  SerieLote)
SELECT
@IDNuevo, @RenglonID, @Articulo, @SubCuenta, @SerieLote
SET @CantidadS = @CantidadS -1
END
FETCH NEXT FROM crArticulo INTO @Articulo, @SubCuenta, @SerieLote, @Cantidad, @RenglonID
END
CLOSE crArticulo
DEALLOCATE crArticulo
END
SELECT @IDNuevo
END

