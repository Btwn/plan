SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVentasProcesarNCredito
@Estacion		int,
@Empresa		char(5),
@Sucursal           int,
@FacturaMov		char(20),
@DevolucionMov      char(20),
@FechaEmision	datetime,
@Usuario		char(10),
@Moneda             varchar(10),
@TipoCambio         float,
@AlmacenEncabezado  varchar(10),
@Cliente            varchar(10),
@EnviarA            int,
@Condicion          varchar(50),
@Concepto           varchar(50),
@Agente             varchar(10),
@UEN                int,
@CfgCosteoSeries	bit,
@CfgCosteoLotes	bit,
@VentaMultiAlmacen	bit,
@VentaEstatus       varchar(15),
@CteCNO		char(10) 	= NULL,
@EnSilencio		bit	 	= 0,
@FacturaFechaEmision datetime,
@FacturaFechaEmisionInicio  datetime,
@Ok			int	 	= NULL	OUTPUT,
@OkRef		varchar(255)	= NULL	OUTPUT

AS BEGIN
DECLARE
@DevolucionID               int,
@Renglon                    float,
@TipoCosteo			varchar(20),
@FacturaID			int,
@FacturaMovID		varchar(20),
@NotaID			int,
@AjusteID			int,
@Cuantas			int,
@CuantasFacturas		int,
@Almacen			char(10),
@Posicion			char(10),
@ArtTipo			char(20),
@Articulo			char(20),
@SubCuenta			varchar(50),
@Unidad			varchar(50),
@Factor			float,
@Cantidad			float,
@CantidadInventario		float,
@Disponible			float,
@MonedaCosto		char(10),
@Costo			float,
@Precio        		float,
@PrecioNeto        		float,
@Proveedor			char(10),
@DescuentoTipo		char(1),
@DescuentoLinea		float,
@DescuentoGlobal		float,
@SobrePrecio		float,
@Impuesto1			float,
@Impuesto2			float,
@Impuesto3			money,
@RenglonID			int,
@FactorCosto		float,
@TipoCambioCosto		float,
@ImporteTotal		money,
@CfgCosteoNivelSubCuenta 	bit,
@FechaRegistro		datetime,
@LeyendaEstatus		varchar(50),
@CerrarSucursalAuto		bit,
@ArtCostoIdentificado	bit,
@Accion			char(20),
@LotesFijos			bit,
@Lote			varchar(50),
@RenglonTipo		char(1),
@PrecioMonedaD		varchar(10),
@PrecioTipoCambioD	        float,
@CantidadObsequio	        float,
@OfertaID	                int,
@PrecioSugerido	        float,
@DescuentoImporte	        money,
@Puntos	                float,
@Comision	                float,
@CantidadAjusteLote         float,
@OrigenID                   int,
@OrigenRenglon              float,
@OrigenRenglonSub           int,
@CfgAnticipoArticuloServicio varchar(20),
@ArtOfertaFP                varchar(20),
@ArtOfertaImporte           varchar(20)
SELECT @ArtOfertaFP = ArtOfertaFP, @ArtOfertaImporte = ArtOfertaImporte
FROM POSCfg WHERE Empresa = @Empresa
SELECT @TipoCosteo		  = ISNULL(NULLIF(RTRIM(UPPER(TipoCosteo)), ''), 'PROMEDIO'),
@CfgCosteoSeries	  = ISNULL(CosteoSeries, 0),
@CfgCosteoLotes	  = ISNULL(CosteoLotes, 0)
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @CfgAnticipoArticuloServicio = NULLIF(CxcAnticipoArticuloServicio,'')    FROM EmpresaCfg2
WHERE Empresa = @Empresa
INSERT Venta (Sucursal,  SucursalOrigen, Empresa,  Mov,            FechaEmision,         Moneda,  TipoCambio,  Almacen,            Cliente,  EnviarA,  Condicion,  Concepto,  Usuario,  Estatus,         OrigenTipo, Agente,  UEN,  FormaPagoTipo)
VALUES (@Sucursal, @Sucursal,      @Empresa, @DevolucionMov, @FacturaFechaEmision, @Moneda, @TipoCambio, @AlmacenEncabezado, @Cliente, @EnviarA, @Condicion, NULL, @Usuario, @VentaEstatus,  'VMOS',      @Agente, @UEN, 'Varios')
SELECT @DevolucionID = SCOPE_IDENTITY()
INSERT VentaProcesarNotas(IDOrigen, ID,            Renglon,   RenglonSub,   Almacen,   Posicion,   Articulo,   SubCuenta,   RenglonTipo,   Unidad,   Impuesto1,               Impuesto2,               Impuesto3,               Cantidad,   CantidadInventario,   DescuentoTipo,              DescuentoLinea,               Precio,               DescuentoGlobal,               SobrePrecio,               MonedaCosto,     Tipo,     CostoIdentificado,     PrecioMoneda,   PrecioTipoCambio,   CantidadObsequio,   OfertaID,   PrecioSugerido,   DescuentoImporte,  Puntos,    Comision)
SELECT                    v.ID,     @DevolucionID, d.Renglon, d.RenglonSub, d.Almacen, d.Posicion, d.Articulo, d.SubCuenta, d.RenglonTipo, d.Unidad, ISNULL(d.Impuesto1,0.0), ISNULL(d.Impuesto2,0.0), ISNULL(d.Impuesto3,0.0), d.Cantidad, d.CantidadInventario, ISNULL(d.DescuentoTipo,''), ISNULL(d.DescuentoLinea,0.0), ISNULL(d.Precio,0.0), ISNULL(v.DescuentoGlobal,0.0), ISNULL(v.SobrePrecio,0.0), Art.MonedaCosto, Art.Tipo, Art.CostoIdentificado, d.PrecioMoneda, d.PrecioTipoCambio, d.CantidadObsequio, d.OfertaID, d.PrecioSugerido, d.DescuentoImporte, d.Puntos, d.Comision
FROM Venta v, VentaD d, ListaID l, Art
WHERE v.ID = d.ID AND d.ID = l.ID
AND CONVERT(char(10), v.FechaEmision, 121)  BETWEEN CONVERT(char(10), @FacturaFechaEmisionInicio, 121) AND   CONVERT(char(10), @FacturaFechaEmision, 121)
AND l.Estacion = @Estacion
AND d.ProcesadoID IS NULL
AND Art.Articulo = d.Articulo
AND ((d.Cantidad < 0.0) AND d.Articulo NOT IN (@CfgAnticipoArticuloServicio,@ArtOfertaFP,@ArtOfertaImporte ))
GROUP BY v.ID, d.Renglon, d.RenglonSub, d.Almacen, d.Posicion, d.Articulo, Art.MonedaCosto, Art.Tipo, Art.CostoIdentificado, d.SubCuenta, d.RenglonTipo, d.Unidad, d.Impuesto1, d.Impuesto2, d.Impuesto3, d.DescuentoTipo, d.DescuentoLinea, d.Precio, v.DescuentoGlobal, v.SobrePrecio, d.PrecioMoneda, d.PrecioTipoCambio, d.CantidadObsequio, d.OfertaID, d.PrecioSugerido, d.DescuentoImporte, d.Puntos, d.Comision, d.Cantidad, d.CantidadInventario
ORDER BY v.ID, d.Renglon, d.RenglonSub, d.Almacen, d.Posicion, d.Articulo, Art.MonedaCosto, Art.Tipo, Art.CostoIdentificado, d.SubCuenta, d.RenglonTipo, d.Unidad, d.Impuesto1, d.Impuesto2, d.Impuesto3, d.DescuentoTipo, d.DescuentoLinea, d.Precio, v.DescuentoGlobal, v.SobrePrecio, d.PrecioMoneda, d.PrecioTipoCambio, d.CantidadObsequio, d.OfertaID, d.PrecioSugerido, d.DescuentoImporte, d.Puntos, d.Comision, d.Cantidad, d.CantidadInventario
SELECT @Renglon = 0, @RenglonID = 0
DECLARE crNotas CURSOR LOCAL FOR
SELECT d.Almacen, d.Posicion, d.Articulo, d.SubCuenta, d.RenglonTipo, d.Unidad, ISNULL(ROUND(d.Impuesto1, 4),0.0), ISNULL(ROUND(d.Impuesto2, 4),0.0), ISNULL(ROUND(d.Impuesto3, 4),0.0), SUM(d.Cantidad*-1), SUM(d.CantidadInventario), ISNULL(d.DescuentoTipo,''), ISNULL(d.DescuentoLinea,0.0), ISNULL(d.Precio,0.0), ISNULL(d.DescuentoGlobal,0.0), ISNULL(d.SobrePrecio,0.0), d.MonedaCosto, d.Tipo, d.CostoIdentificado, d.PrecioMoneda, d.PrecioTipoCambio, d.CantidadObsequio, d.OfertaID, d.PrecioSugerido, d.DescuentoImporte, d.Puntos, d.Comision
FROM VentaProcesarNotas d
WHERE d.ID  = @DevolucionID
AND d.IDOrigen IN(SELECT ID FROM ListaID WHERE Estacion = @Estacion)
AND ((d.Cantidad < 0.0) AND d.Articulo NOT IN (@CfgAnticipoArticuloServicio,@ArtOfertaFP,@ArtOfertaImporte ))
GROUP BY d.Almacen, d.Posicion, d.Articulo, d.MonedaCosto, d.Tipo, d.CostoIdentificado, d.SubCuenta, d.RenglonTipo, d.Unidad, ROUND(d.Impuesto1, 4), ROUND(d.Impuesto2, 4), ROUND(d.Impuesto3, 4), d.DescuentoTipo, d.DescuentoLinea, d.Precio, d.DescuentoGlobal, d.SobrePrecio, d.PrecioMoneda, d.PrecioTipoCambio, d.CantidadObsequio, d.OfertaID, d.PrecioSugerido, d.DescuentoImporte, d.Puntos, d.Comision
ORDER BY d.Almacen, d.Posicion, d.Articulo, d.MonedaCosto, d.Tipo, d.CostoIdentificado, d.SubCuenta, d.RenglonTipo, d.Unidad, ROUND(d.Impuesto1, 4), ROUND(d.Impuesto2, 4), ROUND(d.Impuesto3, 4), d.DescuentoTipo, d.DescuentoLinea, d.Precio, d.DescuentoGlobal, d.SobrePrecio, d.PrecioMoneda, d.PrecioTipoCambio, d.CantidadObsequio, d.OfertaID, d.PrecioSugerido, d.DescuentoImporte, d.Puntos, d.Comision
OPEN crNotas
FETCH NEXT FROM crNotas INTO @Almacen, @Posicion, @Articulo, @SubCuenta, @RenglonTipo, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Cantidad, @CantidadInventario, @DescuentoTipo, @DescuentoLinea, @Precio, @DescuentoGlobal, @SobrePrecio, @MonedaCosto, @ArtTipo, @ArtCostoIdentificado, @PrecioMonedaD, @PrecioTipoCambioD, @CantidadObsequio, @OfertaID, @PrecioSugerido, @DescuentoImporte, @Puntos, @Comision
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @PrecioNeto = dbo.fnSubTotal(@Precio, @DescuentoGlobal, @SobrePrecio)
IF @VentaMultiAlmacen = 0 AND @Almacen <> @AlmacenEncabezado SELECT @Ok = 20860, @OkRef = @Almacen
SELECT @Costo = NULL
EXEC spVerCosto @Sucursal, @Empresa, @Proveedor, @Articulo, @SubCuenta, @Unidad, @TipoCosteo, @Moneda, @TipoCambio, @Costo OUTPUT, 0, @Precio = @PrecioNeto
SELECT @Renglon = @Renglon + 2048, @RenglonID = @RenglonID + 1
INSERT VentaD (Sucursal,  SucursalOrigen, ID,    Renglon, RenglonSub, RenglonID,  RenglonTipo,  Almacen,  Posicion,  Articulo,  SubCuenta,  Unidad,  Impuesto1,  Impuesto2,  Impuesto3,  Cantidad,  CantidadInventario,  DescuentoTipo,  DescuentoLinea,  Precio,      Costo,  UEN,  Agente,  PrecioMoneda,   PrecioTipoCambio,   CantidadObsequio,  OfertaID,  PrecioSugerido,   DescuentoImporte, Puntos,  Comision)
VALUES (@Sucursal, @Sucursal,      @DevolucionID, @Renglon,         0, @RenglonID, @RenglonTipo, @Almacen, @Posicion, @Articulo, @SubCuenta, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Cantidad, @CantidadInventario, @DescuentoTipo, @DescuentoLinea, @PrecioNeto, @Costo, @UEN, @Agente, @PrecioMonedaD, @PrecioTipoCambioD, @CantidadObsequio, @OfertaID, @PrecioSugerido, @DescuentoImporte, @Puntos, @Comision)
IF (@ArtTipo IN ('SERIE', 'VIN') AND (@CfgCosteoSeries = 1 OR @ArtCostoIdentificado = 1)) OR (@ArtTipo IN ('LOTE', 'PARTIDA') AND (@CfgCosteoLotes = 1 OR @ArtCostoIdentificado = 1))
BEGIN
INSERT SerieLoteMov (Empresa,  Modulo, ID,    RenglonID,  Articulo,  SubCuenta,              SerieLote,   ArtCostoInv,   Cantidad,        CantidadAlterna,        Sucursal, Propiedades)
SELECT @Empresa, 'VTAS', @DevolucionID, @RenglonID, @Articulo, ISNULL(@SubCuenta, ''), s.SerieLote, s.ArtCostoInv, SUM(s.Cantidad), SUM(s.CantidadAlterna), @Sucursal,ISNULL(s.Propiedades, '')
FROM SerieLoteMov s, Venta v, VentaD d, ListaID l, Art
WHERE v.ID = d.ID AND d.ID = l.ID
AND CONVERT(char(10), v.FechaEmision, 121) BETWEEN CONVERT(char(10), @FacturaFechaEmisionInicio, 121) AND   CONVERT(char(10), @FacturaFechaEmision, 121)
AND l.Estacion = @Estacion
AND (d.Cantidad < 0.0 OR d.Articulo NOT IN (@CfgAnticipoArticuloServicio,@ArtOfertaFP,@ArtOfertaImporte ))
AND Art.Articulo = d.Articulo
AND s.Empresa = @Empresa AND s.Modulo = 'VTAS' AND s.ID = v.ID AND s.RenglonID = d.RenglonID AND s.Articulo = @Articulo AND ISNULL(s.SubCuenta, '') = ISNULL(@SubCuenta, '')
AND d.Almacen = @Almacen AND ISNULL(d.Posicion, '') = ISNULL(@Posicion, '') AND d.Articulo = @Articulo AND Art.MonedaCosto = @MonedaCosto AND ISNULL(d.SubCuenta, '') = ISNULL(@SubCuenta, '') AND d.Unidad = @Unidad AND ISNULL(ROUND(d.Impuesto1, 4),0.0) = @Impuesto1 AND ISNULL(ROUND(d.Impuesto2, 4),0.0) = @Impuesto2 AND ISNULL(ROUND(d.Impuesto3, 4),0.0) = @Impuesto3 AND ISNULL(d.DescuentoTipo,'') = @DescuentoTipo AND ISNULL(d.DescuentoLinea,0.0) = @DescuentoLinea AND ISNULL(d.Precio,0.0) = @Precio AND ISNULL(ROUND(v.DescuentoGlobal, 10),0.0) = ISNULL(ROUND(@DescuentoGlobal, 10),0.0) AND ISNULL(ROUND(v.SobrePrecio, 10),0.0) = ISNULL(ROUND(@SobrePrecio, 10),0.0)
GROUP BY s.SerieLote, s.ArtCostoInv, s.Propiedades
SELECT @Costo = ISNULL(SUM(m.Cantidad*ISNULL(s.CostoPromedio*Mon.TipoCambio, 0.0))/NULLIF(SUM(m.Cantidad), 0.0), 0.0)/@TipoCambio
FROM SerieLoteMov m, SerieLote s, Art a, Mon
WHERE m.Empresa = @Empresa AND m.Modulo = 'VTAS' AND m.ID = @DevolucionID AND m.RenglonID = @RenglonID AND m.Articulo = @Articulo AND m.SubCuenta = ISNULL(@SubCuenta, '')
AND s.Empresa = @Empresa AND s.Articulo = @Articulo AND s.SubCuenta = ISNULL(@SubCuenta, '') AND s.SerieLote = m.SerieLote AND s.Sucursal = @Sucursal AND s.Almacen = @Almacen
AND a.Articulo = @Articulo
AND Mon.Moneda = a.MonedaCosto
UPDATE SerieLoteMov
SET ArtCostoInv = s.CostoPromedio
FROM SerieLoteMov m, SerieLote s
WHERE m.Empresa = @Empresa AND m.Modulo = 'VTAS' AND m.ID = @DevolucionID AND m.RenglonID = @RenglonID AND m.Articulo = @Articulo AND m.SubCuenta = ISNULL(@SubCuenta, '')
AND s.Empresa = @Empresa AND s.Articulo = @Articulo AND s.SubCuenta = ISNULL(@SubCuenta, '') AND s.SerieLote = m.SerieLote AND s.Sucursal = @Sucursal AND s.Almacen = @Almacen
UPDATE VentaD SET Costo = @Costo WHERE ID = @FacturaID AND Renglon = @Renglon AND RenglonSub = 0
END
END
FETCH NEXT FROM crNotas INTO @Almacen, @Posicion, @Articulo, @SubCuenta, @RenglonTipo, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Cantidad, @CantidadInventario, @DescuentoTipo, @DescuentoLinea, @Precio, @DescuentoGlobal, @SobrePrecio, @MonedaCosto, @ArtTipo, @ArtCostoIdentificado, @PrecioMonedaD, @PrecioTipoCambioD, @CantidadObsequio, @OfertaID, @PrecioSugerido, @DescuentoImporte, @Puntos, @Comision
END 
CLOSE crNotas
DEALLOCATE crNotas
IF @DevolucionID IS NOT NULL
BEGIN
INSERT #Devoluciones (ID, FechaEmision)
VALUES (@DevolucionID, @FacturaFechaEmision)
INSERT VentaOrigen (ID, OrigenID, Sucursal, SucursalOrigen)
SELECT @DevolucionID, v.ID, @Sucursal, @Sucursal
FROM Venta v, VentaD d, ListaID l
WHERE l.Estacion = @Estacion
AND v.ID = d.ID
AND d.ID = l.ID
AND CONVERT(char(10), v.FechaEmision, 121)  BETWEEN CONVERT(char(10), @FacturaFechaEmisionInicio, 121) AND   CONVERT(char(10), @FacturaFechaEmision, 121)
AND d.Cantidad <0.0
END
END

