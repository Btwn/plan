SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSImportarDevRef
@ID                 varchar(50),
@Estacion           int,
@Empresa            varchar(5),
@Sucursal           int

AS
BEGIN
DECLARE
@IDNuevo              varchar(36),
@MovGenerar           varchar(20),
@Ok                   int,
@Host                 varchar(20),
@Cluster              varchar(20),
@cfgImpuestoIncluido  bit,
@Articulo             varchar(20),
@SubCuenta            varchar(50),
@SerieLote            varchar(50),
@Cantidad             float,
@CantidadS            float,
@RenglonID            int,
@Mov                  varchar(20),
@FechaEmision         datetime,
@Cajero               varchar(10),
@Caja                 varchar(10),
@CtaDinero            varchar(10),
@ArtOfertaImporte     varchar(20),
@TotalImporte         float,
@TotalImpuesto2       float,
@TotalImpuesto1       float,
@RedondeoMonetarios   float,
@TipoCambioMov        float,
@IDOferta             int,
@CantidadOferta       float,
@CantidadMoneda       float,
@PorcentajeOferta     float,
@MonedaOferta         varchar(10),
@ImporteOferta        float,
@TipoCambio           float,
@TotalImporteO        float
SELECT  @ArtOfertaImporte = ArtOfertaImporte
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT @Mov = Mov, @FechaEmision = FechaEmision, @Cajero = Cajero, @Caja = Caja, @CtaDinero = CtaDinero
FROM POSL
WHERE ID = @ID
IF EXISTS(SELECT * FROM POSVentaPedidoDTemp2   WHERE Estacion = @Estacion  AND CantidadAplicar >0.0 )
BEGIN
DELETE POSL WHERE ID = @ID
DELETE POSLVenta  WHERE ID = @ID
DELETE POSLSerieLote  WHERE ID = @ID
INSERT POSL (
ID, Empresa, Modulo, Mov, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia, Estatus, Observaciones,
Cliente, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Causa, Atencion, AtencionTelefono,
ListaPreciosEsp,  ZonaImpuesto,  Sucursal,           OrigenTipo,  Origen,  OrigenID, Host,   Cluster, Cajero,   Importe, Impuestos, Caja, Monedero)
SELECT
@ID, Empresa, 'VTAS', @Mov, @FechaEmision, GETDATE(), Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia, 'SINAFECTAR', Observaciones,
Cliente, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento, @CtaDinero, Descuento, DescuentoGlobal, Causa, Atencion, AtencionTelefono,
ListaPreciosEsp, ZonaImpuesto, SucursalOrigen, NULL, NULL, NULL, @Host, @Cluster, @Cajero, Importe, Impuestos, @Caja, Monedero
FROM POSVentaPedidoTemp
WHERE Estacion = @Estacion
IF @@ERROR <> 0
SET @Ok = 1
SELECT @Empresa = Empresa
FROM POSL
WHERE ID = @IDNuevo
SELECT @cfgImpuestoIncluido = ISNULL(VentaPreciosImpuestoIncluido,0)
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @Ok IS NULL
INSERT POSLVenta(
ID, Renglon, RenglonID, RenglonTipo, Cantidad, CantidadObsequio, Articulo, SubCuenta,
Precio, PrecioSugerido, DescuentoLinea, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, Puntos,
PrecioImpuestoInc, Codigo, Almacen, Aplicado)
SELECT
@ID, Renglon, RenglonID, RenglonTipo, (Cantidad*-1), (CantidadObsequio*-1), Articulo, SubCuenta,
CASE WHEN @cfgImpuestoIncluido = 1
THEN  dbo.fnPOSPrecioSinImpuestos(Precio,Impuesto1, Impuesto2, Impuesto3)
ELSE Precio
END, PrecioSugerido, DescuentoLinea, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, (Puntos*-1),
CASE WHEN @cfgImpuestoIncluido = 0
THEN dbo.fnPOSPrecioConImpuestos(Precio,Impuesto1, Impuesto2, Impuesto3, @Empresa)
ELSE Precio
END, Codigo, Almacen, 1
FROM POSVentaPedidoDTemp2
WHERE Estacion = @Estacion
AND ((CantidadAplicar >0.0) OR Articulo = @ArtOfertaImporte)
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
BEGIN
SELECT @TotalImporte = SUM(dbo.fnPOSImporte(plv.Cantidad, plv.CantidadObsequio, plv.Precio, plv.DescuentoLinea, CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END, plv.Articulo, p.Empresa)),
@TotalImpuesto2 = SUM(dbo.fnPOSImporteMov(((plv.Cantidad  - ISNULL(plv.CantidadObsequio,0.0)) * ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) - ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) * (CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END)/100))),plv.Impuesto1,plv.Impuesto2,plv.Impuesto3,plv.Cantidad)),
@TotalImpuesto1 = CONVERT(money,CONVERT(varchar, CONVERT(money, ISNULL(@TotalImpuesto2,0.0)), 104))-@TotalImporte
FROM POSL p
INNER JOIN POSLVenta plv ON p.ID = plv.ID
WHERE plv.ID = @ID
UPDATE POSL Set Importe = ROUND(@TotalImporte,@RedondeoMonetarios), Impuestos = ROUND(@TotalImpuesto1,@RedondeoMonetarios)  WHERE ID = @ID
END
IF EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID AND Articulo = @ArtOfertaImporte AND RenglonTipo = 'O' AND OfertaID IS NOT NULL AND ISNULL(Puntos,0.0)<0.0)
BEGIN
SELECT @TotalImporteO = Importe
FROM POSVentaPedidoTemp
WHERE Estacion = @Estacion
SELECT @TipoCambioMov = TipoCambio
FROM POSL
WHERE ID = @ID
SELECT @IDOferta = OfertaID
FROM POSLVenta
WHERE ID = @ID AND Articulo = @ArtOfertaImporte AND RenglonTipo = 'O'
SELECT @ImporteOferta = Importe, @CantidadOferta = Cantidad, @PorcentajeOferta = Porcentaje, @CantidadMoneda=Moneda
FROM  OfertaD
WHERE ID = @IDOferta AND Articulo = @ArtOfertaImporte
SELECT @TipoCambio = TipoCambio
FROM POSLTipoCambioRef
WHERE Moneda = @MonedaOferta AND Sucursal = @Sucursal
SELECT @ImporteOferta =  ((@ImporteOferta/ISNULL(@TipoCambio,1.0))*(ISNULL(@TipoCambioMov,1.0)))
IF @ImporteOferta <= (ISNULL(@TotalImporteO,0.0)-ISNULL(@TotalImporte,0.0))
DELETE POSLVenta WHERE ID = @ID AND Articulo = @ArtOfertaImporte AND RenglonTipo = 'O' AND OfertaID IS NOT NULL AND ISNULL(Puntos,0.0)<0.0
END
IF @OK IS NULL AND EXISTS(SELECT * FROM POSVentaPedidoSerieloteTemp WHERE Estacion = @Estacion)
BEGIN
DECLARE crArticulo CURSOR FOR
SELECT Articulo, SubCuenta, SerieLote, ISNULL(Cantidad,0.0), RenglonID
FROM POSVentaPedidoSerieloteTemp
WHERE Estacion = @Estacion
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
@ID, @RenglonID, @Articulo, @SubCuenta, @SerieLote
SET @CantidadS = @CantidadS -1
END
FETCH NEXT FROM crArticulo INTO @Articulo, @SubCuenta, @SerieLote, @Cantidad, @RenglonID
END
CLOSE crArticulo
DEALLOCATE crArticulo
END
END
END

