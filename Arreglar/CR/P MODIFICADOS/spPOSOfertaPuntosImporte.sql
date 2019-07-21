SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSOfertaPuntosImporte
@Empresa    varchar(5),
@Estacion   int,
@ID         varchar(36),
@Ok         int = NULL OUTPUT ,
@OkRef      varchar(255) = NULL OUTPUT

AS
BEGIN
DECLARE
@ArticuloOferta			varchar(20),
@ImporteTotal			float,
@ImporteTotalMN			float,
@ImporteOferta			float,
@CantidadOferta			float,
@PorcentajeOferta		float,
@Renglon				float,
@RenglonID				int,
@Unidad					varchar(50),
@CodigoRedondeo			varchar(50),
@ArticuloRedondeo		varchar(20),
@IDOferta				int,
@Usar					varchar(50),
@Forma					varchar(50),
@Puntos					float,
@Sucursal				int,
@CantidadMoneda			varchar(10),
@Moneda					varchar(10),
@MonedaMov				varchar(10),
@MonedaPrincipal		varchar(10),
@TipoCambio				float,
@TipoCambioMov			float,
@Monedero				varchar(20),
@MonedaTarjeta			varchar(10),
@TipoCambioTarjeta		float,
@TipoCambioCantidad		float,
@LDI					int,
@Usuario				varchar(10),
@Movimeinto				varchar(20),
@MovClave				varchar(20),
@MovSubClave			varchar(20)
SELECT @Sucursal = Sucursal,@MonedaMov = Moneda, @Monedero = Monedero, @Usuario = Usuario, @Movimeinto = Mov
FROM POSL WITH (NOLOCK)
WHERE ID = @ID
SELECT @MovClave = Clave, @MovSubClave = Subclave
FROM MovTipo WITH (NOLOCK)
WHERE Mov = @Movimeinto AND Modulo = 'POS'
SELECT @MonedaTarjeta = Moneda
FROM POSValeSerie WITH (NOLOCK)
WHERE Serie = @Monedero
SELECT @TipoCambioTarjeta = TipoCambio
FROM POSLTipoCambioRef WITH (NOLOCK)
WHERE Moneda = @MonedaTarjeta AND Sucursal = @Sucursal
SELECT @MonedaPrincipal = Moneda
FROM POSLTipoCambioRef m WITH (NOLOCK)
WHERE TipoCambio = 1 AND Sucursal = @Sucursal AND EsPrincipal = 1
IF @MonedaMov <> @MonedaPrincipal
SELECT @TipoCambioMov = TipoCambio FROM POSLTipoCambioRef WITH (NOLOCK) WHERE Moneda = @MonedaMov AND Sucursal = @Sucursal
ELSE
SELECT   @TipoCambioMov = 1.0
SELECT @ArticuloOferta = ArtOfertaImporte, @CodigoRedondeo = RedondeoVentaCodigo, @LDI = MonederoLDI
FROM POSCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @ArticuloRedondeo = Cuenta
FROM CB WITH (NOLOCK)
WHERE Codigo = @CodigoRedondeo AND TipoCuenta = 'Articulos'
IF NULLIF(@ArticuloOferta,'') IS NOT NULL
BEGIN
SELECT @ImporteTotal = SUM(dbo.fnPOSImporteMov(((plv.Cantidad  - ISNULL(plv.CantidadObsequio,0.0)) * ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) - ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) * (ISNULL(p.DescuentoGlobal,0.0)/100)))), plv.Impuesto1, plv.Impuesto2, plv.Impuesto3, plv.Cantidad))
FROM POSLVenta plv WITH (NOLOCK)
JOIN POSL p WITH (NOLOCK) ON p.ID = plv.ID
WHERE plv.ID = @ID
AND plv.Articulo <> @ArticuloRedondeo
SELECT @Unidad = Unidad
FROM Art WITH (NOLOCK)
WHERE Articulo = @ArticuloOferta
IF NOT EXISTS(SELECT * FROM POSLVenta WITH (NOLOCK) WHERE ID = @ID AND Articulo = @ArticuloOferta AND RenglonTipo = 'O')
BEGIN
SELECT @Renglon = ISNULL(MAX(Renglon),0.0) +2048.0,
@RenglonID = ISNULL(MAX(RenglonID),0) + 1
FROM POSLVenta WITH (NOLOCK)
WHERE ID = @ID
INSERT POSLVenta(ID, Renglon, RenglonID,	RenglonTipo,	Articulo,			PrecioSugerido, Cantidad,	DescuentoImporte, DescuentoLinea, Unidad,  Aplicado,AplicaDescGlobal)
SELECT			@ID, @Renglon, @RenglonID, 'O',				@ArticuloOferta,	@ImporteTotal,	1,			0.0,			  0.0,			  @Unidad, 0,		0
IF @@ERROR <> 0 SET @Ok = 1
END
ELSE
BEGIN
UPDATE POSLVenta WITH (ROWLOCK) SET Aplicado = 0, PrecioSugerido = @ImporteTotal WHERE ID = @ID AND Articulo = @ArticuloOferta AND RenglonTipo = 'O'
IF @@ERROR <> 0 SET @Ok = 1
END
EXEC spPOSOfertaImportePuntosAplicar   @ID, NULL, 1
END
IF EXISTS(SELECT * FROM POSLVenta WITH (NOLOCK) WHERE ID = @ID AND Articulo = @ArticuloOferta AND RenglonTipo = 'O' AND OfertaID IS NOT NULL)
BEGIN
SELECT @IDOferta = OfertaID
FROM POSLVenta WITH (NOLOCK)
WHERE ID = @ID AND Articulo = @ArticuloOferta AND RenglonTipo = 'O'
SELECT @Forma = UPPER(Forma), @Usar = UPPER(Usar), @Moneda = Moneda
FROM Oferta WITH (NOLOCK)
WHERE ID = @IDOferta
SELECT @ImporteOferta = Importe, @CantidadOferta = Cantidad, @PorcentajeOferta = Porcentaje, @CantidadMoneda=Moneda
FROM OfertaD WITH (NOLOCK)
WHERE ID = @IDOferta AND Articulo = @ArticuloOferta
SELECT @TipoCambio = TipoCambio
FROM POSLTipoCambioRef WITH (NOLOCK)
WHERE Moneda = @Moneda AND Sucursal = @Sucursal
SELECT @ImporteOferta =  ((@ImporteOferta/ISNULL(@TipoCambio,1.0))*(ISNULL(@TipoCambioMov,1.0)))
IF @Forma = 'IMPORTE/PUNTOS'
BEGIN
IF @Usar = 'IMPORTE/CANTIDAD'
BEGIN
SELECT @TipoCambioCantidad = TipoCambio FROM POSLTipoCambioRef WITH (NOLOCK) WHERE Moneda = @CantidadMoneda AND Sucursal = @Sucursal
SELECT @Puntos = (FLOOR(ISNULL(@ImporteTotal,0.0)/ISNULL(@ImporteOferta,0.0))*ISNULL(@CantidadOferta,0.0))
END
IF @Usar = 'IMPORTE/PORCENTAJE'
SELECT @Puntos = (FLOOR(ISNULL(@ImporteTotal,0.0)/ISNULL(@ImporteOferta,0.0))*(ISNULL(@ImporteOferta,0.0)*(ISNULL(@PorcentajeOferta,0.0)/100)))
END
SELECT @Puntos= dbo.fnImporteMonTarjeta(@Puntos,@CantidadMoneda,@TipoCambioCantidad,@MonedaTarjeta,@TipoCambioTarjeta,@Sucursal)
UPDATE POSLVenta WITH (ROWLOCK) SET Aplicado = 1, Precio = NULL, PrecioSugerido = NULL, PrecioImpuestoInc= NULL,Puntos = @Puntos
WHERE ID = @ID AND Articulo = @ArticuloOferta AND RenglonTipo = 'O'
IF @@ERROR <> 0 SET @Ok = 1
END
IF EXISTS(SELECT * FROM POSLVentaWITH (NOLOCK) WHERE ID = @ID AND Articulo = @ArticuloOferta AND RenglonTipo = 'O' AND (OfertaID IS NULL OR NULLIF(Puntos,0.0) IS NULL))
DELETE POSLVenta WHERE ID = @ID AND Articulo = @ArticuloOferta AND RenglonTipo = 'O'
IF @@ERROR <> 0 SET @Ok = 1
END

