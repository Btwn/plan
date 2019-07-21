SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPlanArtExplotar
@Empresa		char(5),
@Almacen		char(10),
@Vuelta			int,
@ProductoPeriodo	int,
@MaterialPeriodo	int,
@Articulo		char(20),
@SubCuenta		varchar(50),
@Cantidad		float,
@ArtCantidad		float,
@ArtUnidad		varchar(50),
@Acronimo		char(10),
@CfgMermaIncluida	bit,
@CfgDesperdicioIncluido	bit,
@CfgTipoMerma		char(1),
@CfgMultiUnidades	bit,
@CfgMultiUnidadesNivel	char(20),
@Ok             	int          OUTPUT,
@OkRef          	varchar(255) OUTPUT

AS BEGIN
DECLARE
@ArtFactor	 	  float,
@ArtDecimales	  int,
@Veces		  float,
@SiOpcion		  varchar(100),
@Material		  char(20),
@mSubCuenta		  varchar(50),
@mCantidad		  float,
@mCantidadVeces	  float,
@mUnidad		  varchar(50),
@mFactor		  float,
@mDecimales		  int,
@mMerma	  	  float,
@mDesperdicio 	  float,
@mArtEsFormula	  bit,
@mArtCantidad	  float,
@mAlmacen		  char(10),
@mArtTipo		  char(20),
@mArtTipoOpcion	  char(20),
@Continuar		  bit
EXEC xpUnidadFactorProd @CfgMultiUnidades, @CfgMultiUnidadesNivel,
@Articulo, @SubCuenta, @ArtUnidad,
@ArtFactor OUTPUT, @ArtDecimales OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @ArtCantidad = 0 OR @ArtFactor = 0.0 SELECT @Ok = 25030
IF @Ok IS NULL SELECT @Veces = @Cantidad / (@ArtCantidad*@ArtFactor)
IF ROUND(@Cantidad, 4) > 0.0 AND @Ok IS NULL
BEGIN
DECLARE crArtMaterial CURSOR LOCAL FOR
SELECT NULLIF(RTRIM(e.SiOpcion), ''), e.Material, NULLIF(RTRIM(e.SubCuenta), ''), ISNULL(e.Cantidad, 0.0), e.Unidad, ISNULL(e.Merma, 0.0), ISNULL(e.Desperdicio, 0.0), a.EsFormula, a.ProdCantidad, NULLIF(RTRIM(e.Almacen), ''), a.Tipo, a.TipoOpcion
FROM ArtMaterial e, Art a
WHERE e.Material = a.Articulo AND a.Estatus NOT IN ('BAJA', 'DESCONTINUADO')
AND e.Articulo = @Articulo
ORDER BY e.SiOpcion, e.Material, e.SubCuenta
OPEN crArtMaterial
FETCH NEXT FROM crArtMaterial INTO @SiOpcion, @Material, @mSubCuenta, @mCantidad, @mUnidad, @mMerma, @mDesperdicio, @mArtEsFormula, @mArtCantidad, @mAlmacen, @mArtTipo, @mArtTipoOpcion
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF UPPER(@mAlmacen) = '(DEMANDA)' SELECT @mAlmacen = @Almacen
IF NULLIF(RTRIM(@mAlmacen), '') IS NULL SELECT @Ok = 20855, @OkRef = RTRIM(@Material)
SELECT @Continuar = 1
IF @SubCuenta IS NOT NULL AND @SiOpcion IS NOT NULL
EXEC spOpcionContinuar @SiOpcion, @SubCuenta, @Continuar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Continuar = 1
BEGIN
EXEC xpUnidadFactorProd @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Material, @mSubCuenta, @mUnidad, @mFactor OUTPUT, @mDecimales OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
IF @mSubCuenta IS NULL AND UPPER(@mArtTipoOpcion) = 'SI'
EXEC spOpcionHeredar @SubCuenta, @Material, @mSubCuenta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
ELSE IF CHARINDEX(':', @mSubCuenta) > 0 AND CHARINDEX(':', @SiOpcion) > 0
EXEC spOpcionHeredarRango @SiOpcion, @SubCuenta, @mSubCuenta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF UPPER(@mArtTipo) IN ('MATRIZ', 'PARTIDA') AND NULLIF(RTRIM(@mSubCuenta), '') IS NULL
SELECT @Ok = 20730, @OkRef = @Material
IF @Ok IS NULL
BEGIN
SELECT @mCantidadVeces = (@mCantidad*@mFactor) * @Veces
IF @CfgMermaIncluida       = 0 AND @mMerma       <> 0.0
BEGIN
IF @CfgTipoMerma = '#'
SELECT @mCantidadVeces = @mCantidadVeces + @mMerma
ELSE
SELECT @mCantidadVeces = @mCantidadVeces * (1+(@mMerma/100))
END
IF @CfgDesperdicioIncluido = 0 AND @mDesperdicio <> 0.0
BEGIN
IF @CfgTipoMerma = '#'
SELECT @mCantidadVeces = @mCantidadVeces + @mDesperdicio
ELSE
SELECT @mCantidadVeces = @mCantidadVeces * (1+(@mDesperdicio/100))
END
IF @mCantidadVeces <> 0.0 AND @Ok IS NULL
BEGIN
IF @mArtEsFormula = 1
EXEC spPlanArtExplotar @Empresa, @mAlmacen, @Vuelta, @ProductoPeriodo, @MaterialPeriodo, @Material, @mSubCuenta, @mCantidadVeces, @mArtCantidad, @mUnidad, @Acronimo,
@CfgMermaIncluida, @CfgDesperdicioIncluido, @CfgTipoMerma, @CfgMultiUnidades, @CfgMultiUnidadesNivel,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
BEGIN
UPDATE PlanArt
SET Cantidad = ISNULL(Cantidad, 0) + @mCantidadVeces
WHERE Empresa = @Empresa AND Almacen = @mAlmacen AND Articulo = @Material AND SubCuenta = ISNULL(@mSubCuenta, '') AND Acronimo = 'RB' AND Periodo = @MaterialPeriodo
IF @@ROWCOUNT = 0
BEGIN
INSERT PlanArt (Empresa,  Almacen,   Articulo,  SubCuenta,                Acronimo, Cantidad,        Periodo)
VALUES (@Empresa, @mAlmacen, @Material, ISNULL(@mSubCuenta, ''), 'RB',      @mCantidadVeces, @MaterialPeriodo)
END
IF NOT EXISTS(SELECT * FROM #PlanCorrida WHERE Articulo = @Material AND SubCuenta = ISNULL(@mSubCuenta, '') AND Almacen = @mAlmacen AND DRP = 0 AND Vuelta = @Vuelta + 1)
INSERT #PlanCorrida (Articulo, SubCuenta, Almacen, DRP, Vuelta) VALUES (@Material, ISNULL(@mSubCuenta, ''), @mAlmacen, 0, @Vuelta + 1)
UPDATE PlanArtFlujo
SET MaterialCantidad = ISNULL(MaterialCantidad, 0) + @mCantidadVeces,
ProductoCantidad = ISNULL(ProductoCantidad, 0) + @Cantidad
WHERE Empresa = @Empresa AND Material = @Material AND MaterialPeriodo = @MaterialPeriodo AND MaterialSubCuenta = ISNULL(@mSubCuenta, '') AND MaterialAlmacen = @mAlmacen AND MaterialAcronimo = 'RB' AND Producto = @Articulo AND ProductoPeriodo = @ProductoPeriodo AND ProductoSubCuenta = ISNULL(@SubCuenta, '') AND ProductoAlmacen = @Almacen AND ProductoAcronimo = @Acronimo
IF @@ROWCOUNT = 0
INSERT PlanArtFlujo (Empresa,  Material,  MaterialPeriodo,  MaterialSubCuenta,       MaterialAlmacen, MaterialAcronimo, Producto,  ProductoPeriodo,  ProductoSubCuenta,      ProductoAlmacen, ProductoAcronimo, MaterialCantidad, ProductoCantidad)
VALUES (@Empresa, @Material, @MaterialPeriodo, ISNULL(@mSubCuenta, ''), @mAlmacen,      'RB',             @Articulo, @ProductoPeriodo, ISNULL(@SubCuenta, ''), @Almacen,        @Acronimo,        @mCantidadVeces,  @Cantidad)
END
END
END
END
END
END
FETCH NEXT FROM crArtMaterial INTO @SiOpcion, @Material, @mSubCuenta, @mCantidad, @mUnidad, @mMerma, @mDesperdicio, @mArtEsFormula, @mArtCantidad, @mAlmacen, @mArtTipo, @mArtTipoOpcion
END
CLOSE crArtMaterial
DEALLOCATE crArtMaterial
END
RETURN
END

