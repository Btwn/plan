SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOfertaProcesar
@Empresa		varchar(5),
@Sucursal		int,
@Moneda			varchar(10),
@TipoCambio		float,
@ListaPrecios	varchar(50),
@ID				int	= NULL,
@PuntosPrecio           bit = NULL

AS BEGIN
DECLARE
@CfgCostoBase			varchar(50),
@CfgOfertaNivelopcion	bit,
@Articulo				varchar(20),
@SubCuenta				varchar(50),
@ArtCantidadTotal		float,
@ArtPrecioSugerido		float,
@ArtCostoBase			float,
@ArtPrecio				float,
@ArtDescuento			float,
@ArtDescuentoImporte	money,
@ArtPuntos				float,
@ArtPuntosPorcentaje	float,
@ArtComision			float,
@ArtComisionPorcentaje	float,
@ArtOfertaID			int,
@RID					int,
@Renglon				float,
@RenglonSub				int,
@Aplica					bit,
@OfertaID				int,
@Descuento				float,
@DescuentoP1			float,
@DescuentoP2			float,
@DescuentoP3			float,
@DescuentoG1			float,
@DescuentoG2			float,
@DescuentoG3			float,
@Bandera				bit,
@ArtUnidad				varchar(50),
@DescuentoAd			float
SELECT @CfgCostoBase = CostoBase
FROM EmpresaGral
WHERE Empresa = @Empresa
SELECT @CfgOfertaNivelopcion = ISNULL(OfertaNivelopcion, 0)
FROM EmpresaCfg2
WHERE Empresa = @Empresa
EXEC spOfertaObsequiosMultiples @Empresa, @Sucursal, @Moneda, @TipoCambio
EXEC spOfertaArmada @Empresa, @Sucursal, @Moneda, @TipoCambio
IF @CfgOfertaNivelopcion = 1
DECLARE crVentaD CURSOR LOCAL FOR
SELECT Articulo, ISNULL(RTRIM(SubCuenta), ''), MIN(PrecioSugerido), SUM(Cantidad)/*SUM(CantidadInventario)*/, Unidad
FROM #VentaD
GROUP BY Articulo, ISNULL(RTRIM(SubCuenta), ''), Unidad
ELSE
DECLARE crVentaD CURSOR LOCAL FOR
SELECT Articulo, CONVERT(char(50), ''), MIN(PrecioSugerido), SUM(Cantidad)/*SUM(CantidadInventario)*/, Unidad
FROM #VentaD
GROUP BY Articulo, Unidad
OPEN crVentaD
FETCH NEXT FROM crVentaD INTO @Articulo, @SubCuenta, @ArtPrecioSugerido, @ArtCantidadTotal, @ArtUnidad
WHILE @@FETCH_STATUS <> -1
BEGIN
SELECT @Aplica = 1
EXEC xpOfertaAplicarDetalle @ID, @Articulo, @Aplica OUTPUT
IF @@FETCH_STATUS <> -2 AND @Aplica = 1
BEGIN
SELECT @ArtCostoBase = dbo.fnPCGet(@Empresa, 0, @Moneda, @TipoCambio, @Articulo, @SubCuenta, NULL, @CfgCostoBase)
SELECT @ArtPrecio = NULL, @ArtDescuento = NULL, @ArtDescuentoImporte = NULL, @ArtPuntos = NULL, @ArtPuntosPorcentaje = NULL,
@ArtComision = NULL, @ArtComisionPorcentaje = NULL, @ArtOfertaID = NULL
/**************************************************************************  Prioridad 1 *************************************************/
EXEC spOfertaNormal @Empresa, @Sucursal, @Moneda, @TipoCambio, @Articulo, @SubCuenta, @ArtCantidadTotal, @ArtCostoBase, @ArtPrecioSugerido,
@ArtPrecio OUTPUT, @ArtDescuento OUTPUT, @ArtDescuentoImporte OUTPUT, @ArtPuntos OUTPUT, @ArtPuntosPorcentaje OUTPUT,
@ArtComision OUTPUT, @ArtComisionPorcentaje OUTPUT, @ArtOfertaID OUTPUT, @CfgOfertaNivelopcion, @PuntosPrecio, 1, @ArtUnidad
IF @CfgOfertaNivelopcion = 1
UPDATE #VentaD
SET Precio = ISNULL(@ArtPrecio, PrecioSugerido),
DescuentoP1 = @ArtDescuento,
OfertaIDP1 = @ArtOfertaID,
OfertaID = ISNULL(@ArtOfertaID,OfertaID) 
WHERE Articulo = @Articulo AND ISNULL(SubCuenta, '') = @SubCuenta AND Unidad = @ArtUnidad
ELSE
UPDATE #VentaD
SET Precio = ISNULL(@ArtPrecio, PrecioSugerido),
DescuentoP1 = @ArtDescuento,
OfertaIDP1 = @ArtOfertaID,
OfertaID = ISNULL(@ArtOfertaID,OfertaID) 
WHERE Articulo = @Articulo AND Unidad = @ArtUnidad
SELECT @ArtPrecio = NULL, @ArtDescuento  = NULL, @ArtDescuentoImporte = NULL,
@ArtPuntos = NULL, @ArtPuntosPorcentaje = NULL, @ArtComision = NULL, @ArtOfertaID = NULL
/*****************************************************************************************************************************************/
/**************************************************************************  Prioridad 2 *************************************************/
EXEC spOfertaNormal @Empresa, @Sucursal, @Moneda, @TipoCambio, @Articulo, @SubCuenta, @ArtCantidadTotal, @ArtCostoBase, @ArtPrecioSugerido,
@ArtPrecio OUTPUT, @ArtDescuento OUTPUT, @ArtDescuentoImporte OUTPUT, @ArtPuntos OUTPUT, @ArtPuntosPorcentaje OUTPUT,
@ArtComision OUTPUT, @ArtComisionPorcentaje OUTPUT, @ArtOfertaID OUTPUT, @CfgOfertaNivelopcion, @PuntosPrecio, 2, @ArtUnidad
IF @CfgOfertaNivelopcion = 1
UPDATE #VentaD
SET Precio = ISNULL(@ArtPrecio, PrecioSugerido),
DescuentoP2 = @ArtDescuento,
Puntos = @ArtPuntos,
PuntosPorcentaje = @ArtPuntosPorcentaje,
OfertaIDP2 = @ArtOfertaID,
DescuentoImporte = @ArtDescuentoImporte,
OfertaID = ISNULL(@ArtOfertaID,OfertaID) 
WHERE Articulo = @Articulo AND ISNULL(SubCuenta, '') = @SubCuenta AND Unidad = @ArtUnidad
ELSE
UPDATE #VentaD
SET Precio = ISNULL(@ArtPrecio, PrecioSugerido),
DescuentoP2 = @ArtDescuento,
Puntos = @ArtPuntos,
PuntosPorcentaje = @ArtPuntosPorcentaje,
OfertaIDP2 = @ArtOfertaID,
DescuentoImporte = @ArtDescuentoImporte,
OfertaID = ISNULL(@ArtOfertaID,OfertaID) 
WHERE Articulo = @Articulo AND Unidad = @ArtUnidad
SELECT @ArtPrecio = NULL, @ArtDescuento  = NULL, @ArtDescuentoImporte = NULL,
@ArtPuntos = NULL, @ArtPuntosPorcentaje = NULL, @ArtComision = NULL, @ArtOfertaID = NULL
/*****************************************************************************************************************************************/
EXEC spOfertaNormal @Empresa, @Sucursal, @Moneda, @TipoCambio, @Articulo, @SubCuenta, @ArtCantidadTotal, @ArtCostoBase, @ArtPrecioSugerido,
@ArtPrecio OUTPUT, @ArtDescuento OUTPUT, @ArtDescuentoImporte OUTPUT, @ArtPuntos OUTPUT, @ArtPuntosPorcentaje OUTPUT,
@ArtComision OUTPUT, @ArtComisionPorcentaje OUTPUT, @ArtOfertaID OUTPUT, @CfgOfertaNivelopcion, @PuntosPrecio, 3, @ArtUnidad
IF @CfgOfertaNivelopcion = 1
UPDATE #VentaD
SET Precio = CASE WHEN Precio <> 0 THEN Precio ELSE PrecioSugerido END,  
DescuentoP3 = CASE WHEN PrecioSugerido > 0 THEN @ArtDescuento ELSE NULL END,
Comision = CASE WHEN PrecioSugerido > 0 THEN @ArtComision ELSE NULL END,
ComisionPorcentaje = CASE WHEN PrecioSugerido > 0 THEN @ArtComisionPorcentaje ELSE NULL END,
OfertaIDP3 = CASE WHEN PrecioSugerido > 0 THEN @ArtOfertaID ELSE NULL END,
OfertaID = CASE WHEN PrecioSugerido > 0 THEN ISNULL(@ArtOfertaID,OfertaID) ELSE NULL END
WHERE Articulo = @Articulo AND ISNULL(SubCuenta, '') = @SubCuenta AND Unidad = @ArtUnidad
ELSE
UPDATE #VentaD
SET Precio = CASE WHEN Precio <> 0 THEN Precio ELSE PrecioSugerido END,  
DescuentoP3 = CASE WHEN PrecioSugerido > 0 THEN @ArtDescuento ELSE NULL END,
Comision = CASE WHEN PrecioSugerido > 0 THEN @ArtComision ELSE NULL END,
ComisionPorcentaje = CASE WHEN PrecioSugerido > 0 THEN @ArtComisionPorcentaje ELSE NULL END,
OfertaIDP3 = CASE WHEN PrecioSugerido > 0 THEN @ArtOfertaID ELSE NULL END,
OfertaID = CASE WHEN PrecioSugerido > 0 THEN ISNULL(@ArtOfertaID,OfertaID) ELSE NULL END
WHERE Articulo = @Articulo AND Unidad = @ArtUnidad
END
FETCH NEXT FROM crVentaD INTO @Articulo, @SubCuenta, @ArtPrecioSugerido, @ArtCantidadTotal, @ArtUnidad
END  
CLOSE crVentaD
DEALLOCATE crVentaD
EXEC spOfertaGrupal @Empresa, @Sucursal, @Moneda, @TipoCambio, 1
EXEC spOfertaGrupal @Empresa, @Sucursal, @Moneda, @TipoCambio, 2
EXEC spOfertaGrupal @Empresa, @Sucursal, @Moneda, @TipoCambio, 3
SET @Bandera = 0
DECLARE crDesc CURSOR LOCAL FOR
SELECT					  RID,	Articulo,	SubCuenta, Unidad, ISNULL(Descuento,0), ISNULL(DescuentoP1,0), ISNULL(DescuentoP2,0), ISNULL(DescuentoP3,0), ISNULL(DescuentoG1,0), ISNULL(DescuentoG2,0), ISNULL(DescuentoG3,0), ISNULL(DescuentoAd,0)
FROM #VentaD
OPEN crDesc
FETCH NEXT FROM crDesc INTO @RID, @Articulo, @SubCuenta, @ArtUnidad, @Descuento, @DescuentoP1, @DescuentoP2,	@DescuentoP3, @DescuentoG1, @DescuentoG2, @DescuentoG3, @DescuentoAd
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @ArtDescuento = NULL,  @ArtOfertaID = NULL
SELECT @DescuentoP1 = @DescuentoP1/100, @DescuentoP2 = @DescuentoP2/100, @DescuentoP3 = @DescuentoP3/100,
@DescuentoG1 = @DescuentoG1/100, @DescuentoG2 = @DescuentoG2/100, @DescuentoG3 = @DescuentoG3/100, @DescuentoAd = @DescuentoAd/100
IF @Bandera = 0 AND @DescuentoG1 <> 0 SET @Bandera = 1
IF @Bandera = 0 AND @DescuentoG2 <> 0 SET @Bandera = 1
IF @Bandera = 0 AND @DescuentoG3 <> 0 SET @Bandera = 1
IF @Bandera = 0 AND @DescuentoP1 <> 0 SET @Bandera = 1
IF @Bandera = 0 AND @DescuentoP2 <> 0 SET @Bandera = 1
IF @Bandera = 0 AND @DescuentoP3 <> 0 SET @Bandera = 1
IF @Bandera = 0
SELECT @Descuento = @Descuento/100
ELSE
SELECT @Descuento = 0
SELECT @ArtDescuento = 1 - ((1-@DescuentoG1) *(1-@DescuentoG2) *(1-@DescuentoG3) *(1-@DescuentoP1) *(1-@DescuentoP2) *(1-@DescuentoP3) * (1-@Descuento) * (1-@DescuentoAd))
SELECT @ArtDescuento = (ISNULL (@ArtDescuento,0)*100)
IF (SELECT TOP 1 NULLIF(OfertaIDP3, '') FROM #VentaD WHERE RID = @RID AND Articulo = @Articulo AND Subcuenta = ISNULL(@SubCuenta,SubCuenta) AND Unidad = @ArtUnidad) IS NOT NULL BEGIN  SELECT @ArtOfertaID = NULLIF(OfertaIDP3, '') FROM #VentaD WHERE RID = @RID AND Articulo = @Articulo AND Subcuenta = ISNULL(@SubCuenta,SubCuenta) AND Unidad = @ArtUnidad END ELSE
IF (SELECT TOP 1 NULLIF(OfertaIDP2, '') FROM #VentaD WHERE RID = @RID AND Articulo = @Articulo AND Subcuenta = ISNULL(@SubCuenta,SubCuenta) AND Unidad = @ArtUnidad) IS NOT NULL BEGIN  SELECT @ArtOfertaID = NULLIF(OfertaIDP2, '') FROM #VentaD WHERE RID = @RID AND Articulo = @Articulo AND Subcuenta = ISNULL(@SubCuenta,SubCuenta) AND Unidad = @ArtUnidad END ELSE
IF (SELECT TOP 1 NULLIF(OfertaIDP1, '') FROM #VentaD WHERE RID = @RID AND Articulo = @Articulo AND Subcuenta = ISNULL(@SubCuenta,SubCuenta) AND Unidad = @ArtUnidad) IS NOT NULL BEGIN  SELECT @ArtOfertaID = NULLIF(OfertaIDP1, '') FROM #VentaD WHERE RID = @RID AND Articulo = @Articulo AND Subcuenta = ISNULL(@SubCuenta,SubCuenta) AND Unidad = @ArtUnidad END ELSE
IF (SELECT TOP 1 NULLIF(OfertaIDG3, '') FROM #VentaD WHERE RID = @RID AND Articulo = @Articulo AND Subcuenta = ISNULL(@SubCuenta,SubCuenta) AND Unidad = @ArtUnidad) IS NOT NULL BEGIN  SELECT @ArtOfertaID = NULLIF(OfertaIDG3, '') FROM #VentaD WHERE RID = @RID AND Articulo = @Articulo AND Subcuenta = ISNULL(@SubCuenta,SubCuenta) AND Unidad = @ArtUnidad END ELSE
IF (SELECT TOP 1 NULLIF(OfertaIDG2, '') FROM #VentaD WHERE RID = @RID AND Articulo = @Articulo AND Subcuenta = ISNULL(@SubCuenta,SubCuenta) AND Unidad = @ArtUnidad) IS NOT NULL BEGIN  SELECT @ArtOfertaID = NULLIF(OfertaIDG2, '') FROM #VentaD WHERE RID = @RID AND Articulo = @Articulo AND Subcuenta = ISNULL(@SubCuenta,SubCuenta) AND Unidad = @ArtUnidad END ELSE
IF (SELECT TOP 1 NULLIF(OfertaIDG1, '') FROM #VentaD WHERE RID = @RID AND Articulo = @Articulo AND Subcuenta = ISNULL(@SubCuenta,SubCuenta) AND Unidad = @ArtUnidad) IS NOT NULL BEGIN  SELECT @ArtOfertaID = NULLIF(OfertaIDG1, '') FROM #VentaD WHERE RID = @RID AND Articulo = @Articulo AND Subcuenta = ISNULL(@SubCuenta,SubCuenta) AND Unidad = @ArtUnidad END
UPDATE #VentaD SET Descuento =  @ArtDescuento , OfertaID = @ArtOfertaID WHERE RID = @RID AND Articulo = @Articulo AND ISNULL(Subcuenta,'') = ISNULL(@SubCuenta,ISNULL(Subcuenta,'')) AND Unidad = @ArtUnidad
END
FETCH NEXT FROM crDesc INTO @RID, @Articulo, @SubCuenta, @ArtUnidad, @Descuento, @DescuentoP1, @DescuentoP2, @DescuentoP3, @DescuentoG1, @DescuentoG2, @DescuentoG3, @DescuentoAd
END  
CLOSE crDesc
DEALLOCATE crDesc
DECLARE crArtObsequio CURSOR LOCAL FOR
SELECT Articulo, ISNULL(SubCuenta,''),ISNULL(Unidad,''), OfertaID
FROM #ArtObsequio
ORDER BY Articulo
OPEN crArtObsequio
FETCH NEXT FROM crArtObsequio INTO @Articulo, @SubCuenta, @ArtUnidad, @OfertaID
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @RID = MIN(RID)
FROM #VentaD
WHERE Articulo = @Articulo AND ISNULL(Unidad,'') = ISNULL(@ArtUnidad, ISNULL(Unidad,'')) AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta, ISNULL(Subcuenta,'')) AND ISNULL(Cantidad, 0.0) - ISNULL(CantidadObsequio, 0.0) > 0.0 AND RenglonTipo <> 'C'
UPDATE #VentaD
SET CantidadObsequio = ISNULL(CantidadObsequio, 0.0) + 1.0, OfertaID = @OfertaID
WHERE RID = @RID AND RenglonTipo <> 'C'
END
FETCH NEXT FROM crArtObsequio INTO @Articulo, @SubCuenta, @ArtUnidad, @OfertaID
END  
CLOSE crArtObsequio
DEALLOCATE crArtObsequio
UPDATE #VentaD SET Descuento = 0.00 WHERE ISNULL(Cantidad,0) < = ISNULL(CantidadObsequio,0) AND ISNULL(CantidadObsequio,0) > 0
RETURN
END

