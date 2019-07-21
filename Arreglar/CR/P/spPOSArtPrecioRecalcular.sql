SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSArtPrecioRecalcular
@ID			varchar(36),
@Estacion	int

AS
BEGIN
DECLARE @EnviarA				int,
@Politica						varchar(max),
@DescuentoMonto					float,
@DescuentoMontoPorcentaje		float,
@Articulo						varchar(20),
@Cantidad						float,
@Unidad							varchar(50),
@Precio							float,
@DescuentoLinea					float,
@VentaID						int,
@SubCuenta						varchar(50),
@FechaEmision					Datetime,
@Agente							varchar(10),
@Moneda							varchar(10),
@TipoCambio						float,
@Renglon						float,
@Condicion						varchar(50),
@Almacen						varchar(10),
@Proyecto						varchar(50),
@FormaEnvio						varchar(50),
@Mov							varchar(20),
@ServicioTipo					varchar(50),
@ContratoTipo					varchar(50),
@Empresa						varchar(50),
@Region							varchar(50),
@Sucursal						int,
@ListaPreciosEsp				varchar(20),
@Cliente						varchar(10),
@PrecioConDescuento				bit,
@GetListaPreciosCliente			bit,
@Juego							varchar(10),
@OFER							bit,
@RenglonTipo					varchar(10),
@RenglonID						int,
@ArticuloPrincipal				varchar(20),
@PrecioIndependiente			bit,
@PrecioImpuestoInc				float,
@Impuesto1						float,
@Impuesto2						float,
@Impuesto3						float,
@CodigoRedondeo					varchar(30),
@ArticuloRedondeo				varchar(20),
@ArtOfertaImporte				varchar(20),
@ArtOfertaFP					varchar(20),
@CfgAnticipoArticuloServicio	varchar(20),
@ZonaImpuesto					varchar(50),
@DescuentoGlobal				float,
@AplicaDescGlobal				bit
SELECT	@FechaEmision = FechaEmision,
@Agente = Agente,
@Moneda = Moneda,
@TipoCambio = TipoCambio,
@Condicion = Condicion,
@Almacen = Almacen,
@Proyecto = Proyecto,
@FormaEnvio = FormaEnvio,
@Mov = Mov,
@Empresa = Empresa,
@Sucursal = Sucursal,
@ListaPreciosEsp = ListaPreciosEsp,
@Cliente = Cliente  ,
@ZonaImpuesto = ZonaImpuesto,
@DescuentoGlobal = ISNULL(DescuentoGlobal,0)
FROM  POSL WITH (NOLOCK)
WHERE  ID = @ID
SET @AplicaDescGlobal = 0
IF @DescuentoGlobal > 0
SELECT @AplicaDescGlobal = 1
SELECT @OFER = ISNULL(OFER,1)
FROM EmpresaGral
WHERE Empresa = @Empresa
SELECT @CodigoRedondeo = pc.RedondeoVentaCodigo
FROM POSCfg pc
WHERE pc.Empresa = @Empresa
SELECT @CodigoRedondeo = RedondeoVentaCodigo , @ArtOfertaFP = ArtOfertaFP, @ArtOfertaImporte = ArtOfertaImporte
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
IF @OFER = 1
BEGIN
DECLARE crArticulo CURSOR FOR
SELECT v.Renglon, v.Articulo, v.Cantidad, v.Unidad, v.DescuentoLinea, v.SubCuenta, v.RenglonTipo, v.RenglonID, v.Juego,
a.Impuesto1, a.Impuesto2, a.Impuesto3
FROM POSLVenta v JOIN Art a ON a.Articulo = v.Articulo
WHERE v.ID = @ID
AND v.Articulo NOT IN(@ArticuloRedondeo,@CfgAnticipoArticuloServicio,@ArtOfertaFP)
OPEN crArticulo
FETCH NEXT FROM crArticulo INTO @Renglon, @Articulo, @Cantidad, @Unidad, @DescuentoLinea, @SubCuenta, @RenglonTipo, @RenglonID, @Juego,
@Impuesto1, @Impuesto2, @Impuesto3
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @RenglonTipo <> 'C'
EXEC spPOSArtPrecio @Articulo = @Articulo, @Cantidad = @Cantidad, @UnidadVenta = @Unidad, @Precio = @Precio OUTPUT,
@Descuento = @DescuentoLinea OUTPUT, @SubCuenta = @SubCuenta, @FechaEmision = @FechaEmision, @Agente = @Agente,
@Moneda = @Moneda, @TipoCambio = @TipoCambio, @Condicion = @Condicion, @Almacen = @Almacen, @Proyecto = @Proyecto,
@FormaEnvio = @FormaEnvio, @Mov = @Mov, @Empresa = @Empresa, @Sucursal = @Sucursal, @ListaPreciosEsp = @ListaPreciosEsp,
@Cliente = @Cliente, @VentaID = @ID
ELSE
SELECT @Precio = 0.0
SELECT @Precio = dbo.fnPOSPrecio(@Empresa,@Precio,@Impuesto1,@Impuesto2,@Impuesto3)
SELECT @PrecioImpuestoInc = dbo.fnPOSPrecioConImpuestos(@Precio,@Impuesto1,@Impuesto2,@Impuesto3, @Empresa)
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto 'POS', 0, @Mov, @FechaEmision, @Empresa, @Sucursal, NULL, NULL, @Articulo = @Articulo, @EnSilencio = 1,
@Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
UPDATE POSLVenta
SET  Impuesto1 = @Impuesto1, Impuesto2 = @Impuesto2, Impuesto3 = @Impuesto3,
Precio = @Precio, PrecioSugerido = NULL, PrecioImpuestoInc = @PrecioImpuestoInc
WHERE ID = @ID  AND Renglon = @Renglon AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
SELECT @Precio = NULL, @DescuentoLinea = NULL, @PrecioImpuestoInc = NULL
FETCH NEXT FROM crArticulo INTO @Renglon, @Articulo, @Cantidad, @Unidad, @DescuentoLinea, @SubCuenta, @RenglonTipo, @RenglonID, @Juego,
@Impuesto1, @Impuesto2, @Impuesto3
END
CLOSE crArticulo
DEALLOCATE crArticulo
UPDATE POSLVenta SET CantidadObsequio = NULL,
DescuentoLinea = NULL,
OfertaID = NULL,
Puntos = NULL,
OfertaIDG1 = NULL,
OfertaIDG2 = NULL,
OfertaIDG3 = NULL,
OfertaIDP1 = NULL,
OfertaIDP2 = NULL,
OfertaIDP3 = NULL,
DescuentoG1 = NULL,
DescuentoG2 = NULL,
DescuentoG3 = NULL,
DescuentoP1 = NULL,
DescuentoP2 = NULL,
DescuentoP3 = NULL,
AplicaDescGlobal = @AplicaDescGlobal
WHERE ID = @ID
EXEC spPOSOfertaAplicar	@ID
EXEC spPOSOfertaPuntosInsertarTemp @ID, NULL, 1, @Estacion
END
ELSE
BEGIN
DECLARE crArticulo CURSOR FOR
SELECT v.Renglon, v.Articulo, v.Cantidad, v.Unidad, v.DescuentoLinea, v.SubCuenta, v.RenglonTipo, v.RenglonID, v.Juego, a.Impuesto1, a.Impuesto2, a.Impuesto3
FROM POSLVenta v JOIN Art a ON a.Articulo = v.Articulo
WHERE v.ID = @ID
AND v.Articulo NOT IN(@ArticuloRedondeo,@CfgAnticipoArticuloServicio,@ArtOfertaFP)
OPEN crArticulo
FETCH NEXT FROM crArticulo INTO @Renglon, @Articulo, @Cantidad, @Unidad, @DescuentoLinea, @SubCuenta, @RenglonTipo, @RenglonID, @Juego,
@Impuesto1, @Impuesto2, @Impuesto3
WHILE @@FETCH_STATUS <> -1
BEGIN
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto 'POS', 0, @Mov, @FechaEmision, @Empresa, @Sucursal, NULL, NULL, @Articulo = @Articulo, @EnSilencio = 1,
@Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
SELECT @Precio = 0.0
IF @RenglonTipo = 'C'
BEGIN
SELECT @ArticuloPrincipal = MAX(Articulo)
FROM POSLVenta
WHERE ID = @ID AND RenglonID = @RenglonID AND RenglonTipo = 'J'
SELECT @PrecioIndependiente = ISNULL(PrecioIndependiente,0)
FROM ArtJuego
WHERE Articulo = @ArticuloPrincipal AND Juego = @Juego
END
IF ISNULL(@PrecioIndependiente,0) = 1 OR @RenglonTipo <> 'C'
EXEC spPOSArtPrecio @Articulo = @Articulo, @Cantidad = @Cantidad, @UnidadVenta = @Unidad, @Precio = @Precio OUTPUT,
@Descuento = @DescuentoLinea OUTPUT, @SubCuenta = @SubCuenta, @FechaEmision = @FechaEmision, @Agente = @Agente, @Moneda = @Moneda,
@TipoCambio = @TipoCambio, @Condicion = @Condicion, @Almacen = @Almacen, @Proyecto = @Proyecto, @FormaEnvio = @FormaEnvio, @Mov = @Mov,
@Empresa = @Empresa, @Sucursal = @Sucursal, @ListaPreciosEsp = @ListaPreciosEsp, @Cliente = @Cliente, @VentaID = @ID
ELSE
SELECT @Precio = 0.0
SELECT @Precio = dbo.fnPOSPrecio(@Empresa,@Precio,@Impuesto1,@Impuesto2,@Impuesto3)
SELECT @PrecioImpuestoInc = dbo.fnPOSPrecioConImpuestos(@Precio,@Impuesto1,@Impuesto2,@Impuesto3, @Empresa)
UPDATE POSLVenta
SET Precio = @Precio, DescuentoLinea = ISNULL(@DescuentoLinea,DescuentoLinea), PrecioImpuestoInc = @PrecioImpuestoInc,
Impuesto1 = @Impuesto1, Impuesto2 = @Impuesto2, Impuesto3 = @Impuesto3, AplicaDescGlobal = @AplicaDescGlobal
WHERE ID = @ID AND Renglon = @Renglon AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
FETCH NEXT FROM crArticulo INTO @Renglon, @Articulo, @Cantidad, @Unidad, @DescuentoLinea, @SubCuenta, @RenglonTipo, @RenglonID, @Juego,
@Impuesto1, @Impuesto2, @Impuesto3
END
CLOSE crArticulo
DEALLOCATE crArticulo
END
END

