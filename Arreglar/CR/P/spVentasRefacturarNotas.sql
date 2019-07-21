SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVentasRefacturarNotas
@Empresa                varchar(5),
@Sucursal               int,
@Estacion               int,
@Usuario                varchar(10),
@ClienteFact            varchar(10),
@FacturaMostrador       varchar(20),
@Ok                     int	=   NULL		OUTPUT,
@OkRef                  varchar(255)= NULL	OUTPUT

AS
BEGIN
DECLARE
@Moneda							varchar(10),
@Cliente						varchar(10),
@TipoCambio						float,
@Almacen						varchar(10),
@NotaMov						varchar(20),
@AlmacenD						varchar(10),
@Fecha							datetime,
@Condicion						varchar(50),
@Concepto						varchar(50),
@Agente							varchar(10),
@UEN							int,
@DevolucionID					int,
@NotaID							int,
@Renglon						float,
@RenglonID						int,
@RenglonTipo					varchar(1),
@Posicion						varchar(10),
@ArtTipo						varchar(20),
@Articulo						varchar(20),
@SubCuenta						varchar(50),
@Unidad							varchar(50),
@Factor							float,
@Cantidad						float,
@CantidadInventario				float,
@Disponible						float,
@MonedaCosto					varchar(10),
@Costo							float,
@Precio        					float,
@PrecioNeto        				float,
@Proveedor						varchar(10),
@DescuentoTipo					varchar(1),
@DescuentoLinea					float,
@DescuentoGlobal				float,
@SobrePrecio					float,
@Impuesto1						float,
@Impuesto2						float,
@Impuesto3						money,
@CfgCosteoSeries				bit,
@CfgCosteoLotes					bit,
@TipoCosteo						varchar(20),
@VentaMultiAlmacen				bit,
@PrecioMonedaD					varchar(10),
@PrecioTipoCambioD				float,
@CantidadObsequio				float,
@OfertaID						int,
@PrecioSugerido					float,
@DescuentoImporte				money,
@Puntos							float,
@Comision						float,
@CantidadAjusteLote				float ,
@ArtCostoIdentificado			bit,
@SeriesLotesAutoOrden			varchar(20),
@CfgCosteoNivelSubCuenta		bit,
@FacturaID						int,
@IDFactura						int,
@CuantasFacturas				int,
@FacturaMovID					varchar(20),
@Cuantas						int,
@ArtTarjetaServicio				varchar(20)
DECLARE @Devolucion table(
ID  int)
DECLARE @Nota table(
ID        int)
DECLARE @Factura table(
ID        int)
DECLARE @Tarjeta  table(
Renglon		float,
RenglonID	int,
Articulo	varchar(20))
BEGIN TRANSACTION
SELECT @VentaMultiAlmacen = VentaMultiAlmacen
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @ArtTarjetaServicio = NULLIF(ArtTarjetaServicio,'')
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @Fecha = dbo.fnFechaSinHora(GETDATE())
IF NULLIF(@ClienteFact,'') IS NULL
SELECT @Ok = 10040
IF NULLIF(@FacturaMostrador,'') IS NULL
SELECT @Ok = 10160
SELECT  @NotaMov = VentaNota
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
DELETE VentaRefacturarTemp WHERE Estacion = @Estacion AND NULLIF(MovID,'') IS NULL
SELECT
@CfgCosteoNivelSubCuenta = CosteoNivelSubCuenta,
@TipoCosteo		  = ISNULL(NULLIF(RTRIM(UPPER(TipoCosteo)), ''), 'PROMEDIO'),
@CfgCosteoSeries	  =1,
@CfgCosteoLotes	  = ISNULL(CosteoLotes, 0),
@SeriesLotesAutoOrden    = UPPER(SeriesLotesAutoOrden)
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF NOT EXISTS (SELECT * FROM VentaRefacturarTemp WHERE Estacion = @Estacion AND ID IS NOT NULL)
SELECT @Ok = 60010
IF @Ok IS NULL
BEGIN
DECLARE crEncabezadoDev CURSOR LOCAL FOR
SELECT  Moneda,  TipoCambio,  Almacen, Condicion, Concepto, Agente, UEN, Cliente
FROM  Venta
WHERE ID IN(SELECT ID FROM VentaRefacturarTemp WHERE Estacion = @Estacion)
GROUP BY  Moneda,  TipoCambio,  Almacen, Condicion, Concepto, Agente, UEN, Cliente
OPEN crEncabezadoDev
FETCH NEXT FROM crEncabezadoDev INTO @Moneda,  @TipoCambio,  @Almacen, @Condicion, @Concepto,@Agente, @UEN, @Cliente
WHILE @@FETCH_STATUS = 0  AND @Ok IS NULL
BEGIN
SET @DevolucionID = NULL
INSERT Venta (
Sucursal, SucursalOrigen, Empresa, Mov, FechaEmision, Moneda, TipoCambio, Almacen, Cliente, Condicion, Concepto, Usuario, Estatus,
OrigenTipo, Agente, UEN, FormaPagoTipo)
SELECT
@Sucursal, @Sucursal, @Empresa, @NotaMov, @Fecha, @Moneda, @TipoCambio, @Almacen, @Cliente, @Condicion, @Concepto, @Usuario, 'SINAFECTAR',
'VMOS', @Agente, @UEN, 'Varios'
SELECT @DevolucionID = SCOPE_IDENTITY()
SELECT @Renglon = 0, @RenglonID = 0
INSERT   @Devolucion
SELECT   @DevolucionID
DECLARE crDevDetalle CURSOR LOCAL  FOR
SELECT d.Almacen, d.Posicion, d.Articulo, d.SubCuenta, d.RenglonTipo, d.Unidad, ISNULL(ROUND(d.Impuesto1, 4),0.0), ISNULL(ROUND(d.Impuesto2, 4),0.0),
ISNULL(ROUND(d.Impuesto3, 4),0.0), SUM(d.Cantidad*-1), SUM(d.CantidadInventario*-1), ISNULL(d.DescuentoTipo,''), ISNULL(d.DescuentoLinea,0.0),
ISNULL(d.Precio,0.0), ISNULL(v.DescuentoGlobal,0.0), ISNULL(v.SobrePrecio,0.0), a.MonedaCosto, a.Tipo, a.CostoIdentificado, d.PrecioMoneda,
d.PrecioTipoCambio, d.CantidadObsequio, d.OfertaID, d.PrecioSugerido, d.DescuentoImporte, d.Puntos, d.Comision
FROM Venta v JOIN VentaD d ON v.ID = d.ID
JOIN Art a ON d.Articulo = a.Articulo
WHERE v.ID IN (SELECT ID FROM VentaRefacturarTemp WHERE Estacion = @Estacion)
AND v.Moneda = @Moneda
AND v.TipoCambio = @TipoCambio
AND v.Almacen = @Almacen
AND ISNULL(v.Condicion,'') = ISNULL(@Condicion,'')
AND ISNULL(v.Concepto,'') = ISNULL(@Concepto,'')
AND v.Agente = @Agente
AND v.UEN = @UEN
AND v.Cliente = @Cliente
GROUP BY d.Almacen, d.Posicion, d.Articulo, a.MonedaCosto, a.Tipo, a.CostoIdentificado, d.SubCuenta, d.RenglonTipo, d.Unidad, ROUND(d.Impuesto1, 4),
ROUND(d.Impuesto2, 4), ROUND(d.Impuesto3, 4), d.DescuentoTipo, d.DescuentoLinea, d.Precio, v.DescuentoGlobal, v.SobrePrecio, d.PrecioMoneda,
d.PrecioTipoCambio, d.CantidadObsequio, d.OfertaID, d.PrecioSugerido, d.DescuentoImporte, d.Puntos, d.Comision
ORDER BY d.Almacen, d.Posicion, d.Articulo, a.MonedaCosto, a.Tipo, a.CostoIdentificado, d.SubCuenta, d.RenglonTipo, d.Unidad, ROUND(d.Impuesto1, 4),
ROUND(d.Impuesto2, 4), ROUND(d.Impuesto3, 4), d.DescuentoTipo, d.DescuentoLinea, d.Precio, v.DescuentoGlobal, v.SobrePrecio, d.PrecioMoneda,
d.PrecioTipoCambio, d.CantidadObsequio, d.OfertaID, d.PrecioSugerido, d.DescuentoImporte, d.Puntos, d.Comision
OPEN crDevDetalle
FETCH NEXT FROM crDevDetalle INTO @AlmacenD, @Posicion, @Articulo, @SubCuenta, @RenglonTipo, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Cantidad,
@CantidadInventario, @DescuentoTipo, @DescuentoLinea, @Precio, @DescuentoGlobal, @SobrePrecio, @MonedaCosto, @ArtTipo, @ArtCostoIdentificado,
@PrecioMonedaD, @PrecioTipoCambioD, @CantidadObsequio, @OfertaID, @PrecioSugerido, @DescuentoImporte, @Puntos, @Comision
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @PrecioNeto = dbo.fnSubTotal(@Precio, @DescuentoGlobal, @SobrePrecio)
IF @VentaMultiAlmacen = 0 AND @AlmacenD <> @Almacen
SELECT @Ok = 20860, @OkRef = @AlmacenD
SELECT @Costo = NULL
EXEC spVerCosto @Sucursal, @Empresa, @Proveedor, @Articulo, @SubCuenta, @Unidad, @TipoCosteo, @Moneda, @TipoCambio,
@Costo OUTPUT, 0, @Precio = @PrecioNeto
SELECT @Renglon = @Renglon + 2048, @RenglonID = @RenglonID + 1
INSERT VentaD (
Sucursal, SucursalOrigen, ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Almacen, Posicion, Articulo, SubCuenta,
Unidad, Impuesto1, Impuesto2, Impuesto3, Cantidad, CantidadInventario, DescuentoTipo, DescuentoLinea, Precio,
Costo, UEN, Agente, PrecioMoneda, PrecioTipoCambio, CantidadObsequio, OfertaID, PrecioSugerido,
DescuentoImporte, Puntos, Comision)
SELECT
@Sucursal, @Sucursal, @DevolucionID, @Renglon, 0, @RenglonID, @RenglonTipo, @Almacen, @Posicion, @Articulo, @SubCuenta,
@Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Cantidad, @CantidadInventario, @DescuentoTipo, @DescuentoLinea, @PrecioNeto,
@Costo, @UEN, @Agente, @PrecioMonedaD, @PrecioTipoCambioD, @CantidadObsequio, @OfertaID, @PrecioSugerido,
@DescuentoImporte, @Puntos, @Comision
IF (@ArtTipo IN ('SERIE', 'VIN') AND (@CfgCosteoSeries = 1 OR @ArtCostoIdentificado = 1)) OR (@ArtTipo IN ('LOTE', 'PARTIDA')
AND (@CfgCosteoLotes = 1 OR @ArtCostoIdentificado = 1))
BEGIN
INSERT SerieLoteMov (
Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, ArtCostoInv,
Cantidad, CantidadAlterna, Sucursal, Propiedades)
SELECT
@Empresa, 'VTAS', @DevolucionID, @RenglonID, @Articulo, ISNULL(@SubCuenta, ''), s.SerieLote, s.ArtCostoInv,
SUM(s.Cantidad), SUM(s.CantidadAlterna), @Sucursal,ISNULL(s.Propiedades, '')
FROM Venta v JOIN VentaD d ON v.ID = d.ID
JOIN SerieLoteMov s  ON s.ID = v.ID AND  s.RenglonID = d.RenglonID AND s.Articulo = d.Articulo
AND ISNULL(s.SubCuenta, '') = ISNULL(d.SubCuenta, '') AND s.Empresa = v.Empresa AND s.Modulo = 'VTAS'
JOIN Art a ON d.Articulo = a.Articulo
WHERE v.ID IN (SELECT ID FROM VentaRefacturarTemp WHERE Estacion = @Estacion)
AND v.Moneda = @Moneda
AND v.TipoCambio = @TipoCambio
AND v.Almacen = @Almacen
AND v.Condicion = @Condicion
AND v.Concepto = @Concepto
AND v.Agente = @Agente
AND v.UEN = @UEN
AND v.Cliente = @Cliente
AND d.Almacen = @AlmacenD AND ISNULL(d.Posicion, '') = ISNULL(@Posicion, '') AND d.Articulo = @Articulo
AND a.MonedaCosto = @MonedaCosto AND ISNULL(d.SubCuenta, '') = ISNULL(@SubCuenta, '') AND d.Unidad = @Unidad
AND ISNULL(ROUND(d.Impuesto1, 4),0.0) = @Impuesto1 AND ISNULL(ROUND(d.Impuesto2, 4),0.0) = @Impuesto2
AND ISNULL(ROUND(d.Impuesto3, 4),0.0) = @Impuesto3 AND ISNULL(d.DescuentoTipo,'') = @DescuentoTipo
AND ISNULL(d.DescuentoLinea,0.0) = @DescuentoLinea AND ISNULL(d.Precio,0.0) = @Precio
AND ISNULL(ROUND(v.DescuentoGlobal, 10),0.0) = ISNULL(ROUND(@DescuentoGlobal, 10),0.0)
AND ISNULL(ROUND(v.SobrePrecio, 10),0.0) = ISNULL(ROUND(@SobrePrecio, 10),0.0)
GROUP BY s.SerieLote, s.ArtCostoInv, s.Propiedades
SELECT @Costo = ISNULL(SUM(m.Cantidad*ISNULL(s.CostoPromedio*Mon.TipoCambio, 0.0))/NULLIF(SUM(m.Cantidad), 0.0), 0.0)/@TipoCambio
FROM SerieLoteMov m, SerieLote s, Art a, Mon
WHERE m.Empresa = @Empresa AND m.Modulo = 'VTAS' AND m.ID = @DevolucionID AND m.RenglonID = @RenglonID
AND m.Articulo = @Articulo AND m.SubCuenta = ISNULL(@SubCuenta, '')
AND s.Empresa = @Empresa AND s.Articulo = @Articulo AND s.SubCuenta = ISNULL(@SubCuenta, '')
AND s.SerieLote = m.SerieLote AND s.Sucursal = @Sucursal AND s.Almacen = @Almacen
AND a.Articulo = @Articulo
AND Mon.Moneda = a.MonedaCosto
UPDATE SerieLoteMov
SET ArtCostoInv = s.CostoPromedio
FROM SerieLoteMov m, SerieLote s
WHERE m.Empresa = @Empresa AND m.Modulo = 'VTAS' AND m.ID = @DevolucionID AND m.RenglonID = @RenglonID
AND m.Articulo = @Articulo AND m.SubCuenta = ISNULL(@SubCuenta, '')
AND s.Empresa = @Empresa AND s.Articulo = @Articulo AND s.SubCuenta = ISNULL(@SubCuenta, '')
AND s.SerieLote = m.SerieLote AND s.Sucursal = @Sucursal AND s.Almacen = @Almacen
UPDATE VentaD SET Costo = @Costo WHERE ID = @DevolucionID AND Renglon = @Renglon AND RenglonSub = 0
END
END
FETCH NEXT FROM crDevDetalle INTO @AlmacenD, @Posicion, @Articulo, @SubCuenta, @RenglonTipo, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3,
@Cantidad, @CantidadInventario, @DescuentoTipo, @DescuentoLinea, @Precio, @DescuentoGlobal, @SobrePrecio, @MonedaCosto, @ArtTipo,
@ArtCostoIdentificado, @PrecioMonedaD, @PrecioTipoCambioD, @CantidadObsequio, @OfertaID, @PrecioSugerido, @DescuentoImporte, @Puntos, @Comision
END
CLOSE crDevDetalle
DEALLOCATE crDevDetalle
INSERT @Tarjeta(
Renglon, RenglonID, Articulo)
SELECT
d.Renglon, d.RenglonID, d.Articulo
FROM Venta v JOIN VentaD d ON v.ID = d.ID JOIN SerieLoteMov s  ON s.ID = v.ID AND  s.RenglonID = d.RenglonID AND s.Articulo = d.Articulo
AND ISNULL(s.SubCuenta, '') = ISNULL(d.SubCuenta, '') AND s.Empresa = v.Empresa AND s.Modulo = 'VTAS'
JOIN ValeSerie vs ON  vs.Serie =  s.SerieLote AND s.Articulo = vs.Articulo
WHERE v.ID = @DevolucionID
IF NULLIF(@ArtTarjetaServicio,'') IS NOT NULL
UPDATE VentaD SET Articulo = @ArtTarjetaServicio, RenglonTipo ='N'
FROM VentaD d JOIN @Tarjeta t ON t.Renglon = d.Renglon AND t.RenglonID = d.RenglonID AND t.Articulo = d.Articulo
WHERE d.ID = @DevolucionID
DELETE SerieLoteMov
FROM SerieLoteMov s JOIN @Tarjeta t ON  t.RenglonID = s.RenglonID AND t.Articulo = s.Articulo
WHERE s.ID = @DevolucionID    AND s.Modulo = 'VTAS' AND s.Empresa = @Empresa
IF @Ok IS NULL AND @DevolucionID IS NOT NULL
EXEC spAfectar 'VTAS', @DevolucionID, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @ok OUTPUT, @OkRef = @OkRef OUTPUT
FETCH NEXT FROM crEncabezadoDev INTO @Moneda,  @TipoCambio,  @Almacen, @Condicion, @Concepto,@Agente, @UEN, @Cliente
END
CLOSE crEncabezadoDev
DEALLOCATE crEncabezadoDev
IF @Ok IS NULL
BEGIN
UPDATE Venta SET Refacturado = 1
WHERE ID IN (SELECT ID FROM VentaRefacturarTemp WHERE Estacion = @Estacion)
END
IF  @Ok IS NULL AND EXISTS(SELECT * FROM @Nota)
BEGIN
DECLARE crNotaEncabezado CURSOR LOCAL FOR
SELECT ID
FROM  @Nota
OPEN crNotaEncabezado
FETCH NEXT FROM crNotaEncabezado INTO @IDFactura
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
SET @FacturaID = NULL
INSERT Venta (
Sucursal, SucursalOrigen, Empresa, Mov, FechaEmision, Moneda, TipoCambio, Almacen, Cliente, Condicion, Concepto,
Usuario, Estatus, OrigenTipo, Agente, UEN, FormaPagoTipo, SucursalDestino)
SELECT
Sucursal, SucursalOrigen, Empresa, @FacturaMostrador, FechaEmision, Moneda, TipoCambio, Almacen, @ClienteFact, Condicion, Concepto,
Usuario, 'SINAFECTAR', NULL, Agente, UEN, FormaPagoTipo, Sucursal
FROM Venta
WHERE ID = @IDFactura
SELECT @FacturaID = SCOPE_IDENTITY()
SELECT @Renglon = 0, @RenglonID = 0
DECLARE crNotaDetalle CURSOR LOCAL  FOR
SELECT
d.Almacen,
d.Posicion,
d.Articulo,
d.SubCuenta,
d.RenglonTipo,
d.Unidad,
ISNULL(ROUND(d.Impuesto1, 4),0.0),
ISNULL(ROUND(d.Impuesto2, 4),0.0),
ISNULL(ROUND(d.Impuesto3, 4),0.0),
SUM(d.Cantidad),
SUM(d.CantidadInventario),
ISNULL(d.DescuentoTipo,''),
ISNULL(d.DescuentoLinea,0.0),
ISNULL(d.Precio,0.0),
ISNULL(v.DescuentoGlobal,0.0),
ISNULL(v.SobrePrecio,0.0),
a.MonedaCosto,
a.Tipo,
a.CostoIdentificado,
d.PrecioMoneda,
d.PrecioTipoCambio,
d.CantidadObsequio,
d.OfertaID,
d.PrecioSugerido,
d.DescuentoImporte,
d.Puntos,
d.Comision
FROM Venta v JOIN VentaD d ON v.ID = d.ID
JOIN Art a ON d.Articulo = a.Articulo
WHERE v.ID = @IDFactura
GROUP BY d.Almacen, d.Posicion, d.Articulo, a.MonedaCosto, a.Tipo, a.CostoIdentificado, d.SubCuenta, d.RenglonTipo, d.Unidad,
ROUND(d.Impuesto1, 4), ROUND(d.Impuesto2, 4), ROUND(d.Impuesto3, 4), d.DescuentoTipo, d.DescuentoLinea, d.Precio, v.DescuentoGlobal,
v.SobrePrecio, d.PrecioMoneda, d.PrecioTipoCambio, d.CantidadObsequio, d.OfertaID, d.PrecioSugerido, d.DescuentoImporte, d.Puntos, d.Comision
ORDER BY d.Almacen, d.Posicion, d.Articulo, a.MonedaCosto, a.Tipo, a.CostoIdentificado, d.SubCuenta, d.RenglonTipo, d.Unidad,
ROUND(d.Impuesto1, 4), ROUND(d.Impuesto2, 4), ROUND(d.Impuesto3, 4), d.DescuentoTipo, d.DescuentoLinea, d.Precio, v.DescuentoGlobal,
v.SobrePrecio, d.PrecioMoneda, d.PrecioTipoCambio, d.CantidadObsequio, d.OfertaID, d.PrecioSugerido, d.DescuentoImporte, d.Puntos, d.Comision
OPEN crNotaDetalle
FETCH NEXT FROM crNotaDetalle INTO @AlmacenD, @Posicion, @Articulo, @SubCuenta, @RenglonTipo, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3,
@Cantidad, @CantidadInventario, @DescuentoTipo, @DescuentoLinea, @Precio, @DescuentoGlobal, @SobrePrecio, @MonedaCosto, @ArtTipo,
@ArtCostoIdentificado, @PrecioMonedaD, @PrecioTipoCambioD, @CantidadObsequio, @OfertaID, @PrecioSugerido, @DescuentoImporte, @Puntos, @Comision
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @PrecioNeto = dbo.fnSubTotal(@Precio, @DescuentoGlobal, @SobrePrecio)
IF @VentaMultiAlmacen = 0 AND @AlmacenD <> @Almacen
SELECT @Ok = 20860, @OkRef = @AlmacenD
SELECT @Costo = NULL
EXEC spVerCosto @Sucursal, @Empresa, @Proveedor, @Articulo, @SubCuenta, @Unidad, @TipoCosteo, @Moneda, @TipoCambio,
@Costo OUTPUT, 0, @Precio = @PrecioNeto
SELECT @Renglon = @Renglon + 2048, @RenglonID = @RenglonID + 1
INSERT VentaD (
Sucursal, SucursalOrigen, ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Almacen, Posicion, Articulo, SubCuenta,
Unidad, Impuesto1, Impuesto2, Impuesto3, Cantidad, CantidadInventario, DescuentoTipo, DescuentoLinea, Precio,
Costo, UEN, Agente, PrecioMoneda, PrecioTipoCambio, CantidadObsequio, OfertaID, PrecioSugerido,
DescuentoImporte, Puntos, Comision)
SELECT
@Sucursal, @Sucursal, @FacturaID, @Renglon, 0, @RenglonID, @RenglonTipo, @Almacen, @Posicion, @Articulo, @SubCuenta,
@Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Cantidad, @CantidadInventario, @DescuentoTipo, @DescuentoLinea, @PrecioNeto,
@Costo, @UEN, @Agente, @PrecioMonedaD, @PrecioTipoCambioD, @CantidadObsequio, @OfertaID, @PrecioSugerido,
@DescuentoImporte, @Puntos, @Comision
IF (@ArtTipo IN ('SERIE', 'VIN') AND (@CfgCosteoSeries = 1 OR @ArtCostoIdentificado = 1)) OR (@ArtTipo IN ('LOTE', 'PARTIDA')
AND (@CfgCosteoLotes = 1 OR @ArtCostoIdentificado = 1))
BEGIN
INSERT SerieLoteMov (
Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, ArtCostoInv,
Cantidad, CantidadAlterna, Sucursal, Propiedades)
SELECT
@Empresa, 'VTAS', @FacturaID, @RenglonID, @Articulo, ISNULL(@SubCuenta, ''), s.SerieLote, s.ArtCostoInv,
SUM(s.Cantidad), SUM(s.CantidadAlterna), @Sucursal,ISNULL(s.Propiedades, '')
FROM Venta v JOIN VentaD d ON v.ID = d.ID
JOIN SerieLoteMov s  ON s.ID = v.ID AND  s.RenglonID = d.RenglonID AND s.Articulo = d.Articulo
AND ISNULL(s.SubCuenta, '') = ISNULL(d.SubCuenta, '') AND s.Empresa = v.Empresa AND s.Modulo = 'VTAS'
JOIN Art a ON d.Articulo = a.Articulo
WHERE v.ID = @IDFactura
AND d.Almacen = @AlmacenD AND ISNULL(d.Posicion, '') = ISNULL(@Posicion, '') AND d.Articulo = @Articulo
AND a.MonedaCosto = @MonedaCosto AND ISNULL(d.SubCuenta, '') = ISNULL(@SubCuenta, '') AND d.Unidad = @Unidad
AND ISNULL(ROUND(d.Impuesto1, 4),0.0) = @Impuesto1 AND ISNULL(ROUND(d.Impuesto2, 4),0.0) = @Impuesto2
AND ISNULL(ROUND(d.Impuesto3, 4),0.0) = @Impuesto3 AND ISNULL(d.DescuentoTipo,'') = @DescuentoTipo
AND ISNULL(d.DescuentoLinea,0.0) = @DescuentoLinea AND ISNULL(d.Precio,0.0) = @Precio
AND ISNULL(ROUND(v.DescuentoGlobal, 10),0.0) = ISNULL(ROUND(@DescuentoGlobal, 10),0.0)
AND ISNULL(ROUND(v.SobrePrecio, 10),0.0) = ISNULL(ROUND(@SobrePrecio, 10),0.0)
GROUP BY s.SerieLote, s.ArtCostoInv, s.Propiedades
SELECT @Costo = ISNULL(SUM(m.Cantidad *
ISNULL(s.CostoPromedio * Mon.TipoCambio, 0.0))/NULLIF(SUM(m.Cantidad), 0.0), 0.0)/@TipoCambio
FROM SerieLoteMov m, SerieLote s, Art a, Mon
WHERE m.Empresa = @Empresa AND m.Modulo = 'VTAS' AND m.ID = @FacturaID AND m.RenglonID = @RenglonID
AND m.Articulo = @Articulo AND m.SubCuenta = ISNULL(@SubCuenta, '')
AND s.Empresa = @Empresa AND s.Articulo = @Articulo AND s.SubCuenta = ISNULL(@SubCuenta, '')
AND s.SerieLote = m.SerieLote AND s.Sucursal = @Sucursal AND s.Almacen = @Almacen
AND a.Articulo = @Articulo
AND Mon.Moneda = a.MonedaCosto
UPDATE SerieLoteMov
SET ArtCostoInv = s.CostoPromedio
FROM SerieLoteMov m, SerieLote s
WHERE m.Empresa = @Empresa AND m.Modulo = 'VTAS' AND m.ID = @FacturaID AND m.RenglonID = @RenglonID
AND m.Articulo = @Articulo AND m.SubCuenta = ISNULL(@SubCuenta, '')
AND s.Empresa = @Empresa AND s.Articulo = @Articulo AND s.SubCuenta = ISNULL(@SubCuenta, '')
AND s.SerieLote = m.SerieLote AND s.Sucursal = @Sucursal AND s.Almacen = @Almacen
UPDATE VentaD SET Costo = @Costo WHERE ID = @FacturaID AND Renglon = @Renglon AND RenglonSub = 0
END
END
FETCH NEXT FROM crNotaDetalle INTO @AlmacenD, @Posicion, @Articulo, @SubCuenta, @RenglonTipo, @Unidad, @Impuesto1, @Impuesto2,
@Impuesto3, @Cantidad, @CantidadInventario, @DescuentoTipo, @DescuentoLinea, @Precio, @DescuentoGlobal, @SobrePrecio, @MonedaCosto,
@ArtTipo, @ArtCostoIdentificado, @PrecioMonedaD, @PrecioTipoCambioD, @CantidadObsequio, @OfertaID, @PrecioSugerido,
@DescuentoImporte, @Puntos, @Comision
END
CLOSE crNotaDetalle
DEALLOCATE crNotaDetalle
DELETE SerieLoteMov
FROM Venta v JOIN VentaD d ON v.ID = d.ID JOIN SerieLoteMov s  ON s.ID = v.ID AND  s.RenglonID = d.RenglonID AND s.Articulo = d.Articulo
AND ISNULL(s.SubCuenta, '') = ISNULL(d.SubCuenta, '') AND s.Empresa = v.Empresa AND s.Modulo = 'VTAS'
JOIN ValeSerie vs ON  vs.Serie =  s.SerieLote AND s.Articulo = vs.Articulo
JOIN Art a ON d.Articulo = a.Articulo
WHERE v.ID = @FacturaID
IF NULLIF(@ArtTarjetaServicio,'') IS NOT NULL
UPDATE VentaD SET Articulo = @ArtTarjetaServicio, RenglonTipo ='N'
FROM Venta v JOIN VentaD d ON v.ID = d.ID JOIN SerieLoteMov s  ON s.ID = v.ID AND  s.RenglonID = d.RenglonID AND s.Articulo = d.Articulo
AND ISNULL(s.SubCuenta, '') = ISNULL(d.SubCuenta, '') AND s.Empresa = v.Empresa AND s.Modulo = 'VTAS'
JOIN ValeSerie vs ON  vs.Serie =  s.SerieLote AND s.Articulo = vs.Articulo
JOIN Art a ON d.Articulo = a.Articulo
WHERE v.ID = @FacturaID
IF @Ok IS NULL
INSERT VentaOrigen (
ID, OrigenID, Sucursal, SucursalOrigen)
SELECT
@FacturaID, @IDFactura, @Sucursal, @Sucursal
IF @Ok IS NULL
BEGIN
INSERT VentaProcesarNotas(
IDOrigen, ID, Renglon, RenglonSub, Almacen, Posicion, Articulo, SubCuenta, RenglonTipo, Unidad,
Impuesto1, Impuesto2, Impuesto3, Cantidad, CantidadInventario,
DescuentoTipo, DescuentoLinea, Precio, DescuentoGlobal,
SobrePrecio, MonedaCosto, Tipo, CostoIdentificado, PrecioMoneda, PrecioTipoCambio,
CantidadObsequio, OfertaID, PrecioSugerido, DescuentoImporte, Puntos, Comision)
SELECT
v.ID, @FacturaID, d.Renglon, d.RenglonSub, d.Almacen, d.Posicion, d.Articulo, d.SubCuenta, d.RenglonTipo, d.Unidad,
ISNULL(d.Impuesto1,0.0), ISNULL(d.Impuesto2,0.0), ISNULL(d.Impuesto3,0.0), d.Cantidad, d.CantidadInventario,
ISNULL(d.DescuentoTipo,''), ISNULL(d.DescuentoLinea,0.0), ISNULL(d.Precio,0.0), ISNULL(v.DescuentoGlobal,0.0),
ISNULL(v.SobrePrecio,0.0), Art.MonedaCosto, Art.Tipo, Art.CostoIdentificado, d.PrecioMoneda, d.PrecioTipoCambio,
d.CantidadObsequio, d.OfertaID, d.PrecioSugerido, d.DescuentoImporte, d.Puntos, d.Comision
FROM Venta v, VentaD d,  Art
WHERE v.ID = d.ID
AND v.ID = @IDFactura
AND d.Cantidad > 0.0
AND Art.Articulo = d.Articulo
AND d.ProcesadoID IS NULL
GROUP BY v.ID, d.Renglon, d.RenglonSub, d.Almacen, d.Posicion, d.Articulo, Art.MonedaCosto, Art.Tipo, Art.CostoIdentificado,
d.SubCuenta, d.RenglonTipo, d.Unidad, d.Impuesto1, d.Impuesto2, d.Impuesto3, d.DescuentoTipo, d.DescuentoLinea, d.Precio,
v.DescuentoGlobal, v.SobrePrecio, d.PrecioMoneda, d.PrecioTipoCambio, d.CantidadObsequio, d.OfertaID, d.PrecioSugerido,
d.DescuentoImporte, d.Puntos, d.Comision, d.Cantidad, d.CantidadInventario
ORDER BY v.ID, d.Renglon, d.RenglonSub, d.Almacen, d.Posicion, d.Articulo, Art.MonedaCosto, Art.Tipo, Art.CostoIdentificado,
d.SubCuenta, d.RenglonTipo, d.Unidad, d.Impuesto1, d.Impuesto2, d.Impuesto3, d.DescuentoTipo, d.DescuentoLinea, d.Precio,
v.DescuentoGlobal, v.SobrePrecio, d.PrecioMoneda, d.PrecioTipoCambio, d.CantidadObsequio, d.OfertaID, d.PrecioSugerido,
d.DescuentoImporte, d.Puntos, d.Comision, d.Cantidad, d.CantidadInventario
END
IF @Ok IS NULL AND @FacturaID IS NOT NULL
BEGIN
EXEC spAfectar 'VTAS', @FacturaID, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1,
@Ok = @ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
INSERT @Factura
SELECT @FacturaID
END
FETCH NEXT FROM crNotaEncabezado INTO @FacturaID
END
CLOSE crNotaEncabezado
DEALLOCATE crNotaEncabezado
END
IF @FacturaID IS NOT NULL
BEGIN
SELECT @CuantasFacturas = COUNT(*) FROM @Factura
SELECT TOP 1 @FacturaMovID = MovID
FROM Venta
WHERE ID IN(SELECT ID FROM @Factura)
SELECT @Cuantas = COUNT(ID)
FROM VentaRefacturarTemp
WHERE Estacion = @Estacion
END
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
BEGIN
SELECT @OkRef = RTRIM(Convert(char, @Cuantas))+' Nota(s) procesadas.'
IF @CuantasFacturas = 1
SELECT @OkRef = RTRIM(@OkRef) + '<BR>Se Genero: '+RTRIM(@FacturaMostrador)+' '+ISNULL(RTRIM(@FacturaMovID), '')
ELSE
SELECT @OkRef = RTRIM(@OkRef) + '<BR>Se Generaron: '+CONVERT(varchar, @CuantasFacturas)+' '+RTRIM(@FacturaMostrador)+'(s) '
END
SELECT @OkRef
END
ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT Descripcion+' '+RTRIM(ISNULL(@OkRef,''))
FROM MensajeLista
WHERE Mensaje = @Ok
END
RETURN
END

