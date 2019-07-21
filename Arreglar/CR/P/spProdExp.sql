SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProdExp
@ID			int,
@Ruta			varchar(20),
@ProdSerieLote		varchar(50),
@Producto		char(20),
@SubProducto		varchar(50),
@Articulo		char(20),
@SubCuenta		varchar(50),
@Cantidad		float,
@Unidad			varchar(50),
@Factor			float,
@Volumen		float,
@Almacen		char(10),
@CfgMultiUnidades	bit,
@CfgMultiUnidadesNivel	char(20),
@CfgMermaIncluida	bit,
@CfgDesperdicioIncluido bit,
@CfgTipoMerma		char(1),
@FechaRequerida		datetime,
@RenglonExp		float	     OUTPUT,
@Ok             	int          OUTPUT,
@OkRef          	varchar(255) OUTPUT,
@Modulo			char(5)	     = 'PROD',
@RenglonID		int	     = NULL OUTPUT

AS BEGIN
DECLARE
@Veces		float,
@ArtCantidad	float,
@ArtUnidad		varchar(50),
@ArtFactor	 	float,
@ArtDecimales	int,
@ArtTipo		char(20),
@ArtTE		int,
@ArtTEUnidad	char(10),
@ArtEsFormula	bit,
@SiOpcion		varchar(100),
@Material		char(20),
@mSubCuenta		varchar(50),
@mCantidad		float,
@mCantidadVeces	float,
@mCantidadVecesNeto	float,
@mUnidad		varchar(50),
@mFactor		float,
@mVolumen		float,
@mMerma		float,
@Merma		float,
@mAlmacenOrigen	char(10),
@mAlmacenDestino	char(10),
@mDesperdicio	float,
@mCentro		char(10),
@Desperdicio	float,
@mCentroTipo	varchar(20),
@mDecimales		int,
@mFechaRequerida	datetime,
@mTE		int,
@mTEUnidad		char(10),
@mArtTipo		char(20),
@mArtTipoOpcion	char(20),
@mArtEsFormula	bit,
@UnaVez		bit,
@Continuar		bit,
@RenglonTipo	char(1),
@RenglonSubNuevo	int
SELECT @ArtCantidad = 0.0, @ArtUnidad = NULL, @UnaVez = 1
SELECT @ArtCantidad = ISNULL(ProdCantidad, 0), @ArtUnidad = UnidadCompra,
@ArtTipo = Tipo, @ArtTE = ISNULL(TiempoEntrega, 0), @ArtTEUnidad = UPPER(ISNULL(TiempoEntregaUnidad, 'Dias')),
@ArtEsFormula = EsFormula
FROM Art
WHERE Articulo = @Articulo
IF @ArtEsFormula = 0
EXEC spDecTiempo @FechaRequerida, @ArtTE, @ArtTEUnidad, @mFechaRequerida OUTPUT
ELSE
SELECT @mFechaRequerida = @FechaRequerida
EXEC xpUnidadFactorProd @CfgMultiUnidades, @CfgMultiUnidadesNivel,
@Articulo, @SubCuenta, @ArtUnidad,
@ArtFactor OUTPUT, @ArtDecimales OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @ArtCantidad = 0 OR @ArtFactor = 0.0 SELECT @Ok = 25030
IF @Ok IS NULL SELECT @Veces = (@Cantidad*@Factor) / (@ArtCantidad*@ArtFactor)
IF ROUND(@Cantidad, 4) > 0.0 AND @Ok IS NULL
BEGIN
DECLARE crOrdenExp CURSOR LOCAL FOR
SELECT NULLIF(RTRIM(e.SiOpcion), ''), e.Material, NULLIF(RTRIM(e.SubCuenta), ''), ISNULL(e.Cantidad, 0.0), e.Unidad, NULLIF(e.Volumen, 0), ISNULL(e.Merma, 0.0), ISNULL(e.Desperdicio, 0.0), NULLIF(RTRIM(e.Almacen), ''), NULLIF(RTRIM(e.CentroTipo), ''), a.TiempoEntrega, a.TiempoEntregaUnidad, a.Tipo, a.TipoOpcion, a.EsFormula
FROM ArtMaterial e, Art a
WHERE e.Material = a.Articulo
AND e.Articulo = @Articulo
ORDER BY e.SiOpcion, e.Material, e.SubCuenta
OPEN crOrdenExp
FETCH NEXT FROM crOrdenExp INTO @SiOpcion, @Material, @mSubCuenta, @mCantidad, @mUnidad, @mVolumen, @mMerma, @mDesperdicio, @mAlmacenOrigen, @mCentroTipo, @mTE, @mTEUnidad, @mArtTipo, @mArtTipoOpcion, @mArtEsFormula
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
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
IF @Volumen IS NOT NULL AND @mVolumen IS NOT NULL
SELECT @mCantidadVeces = @Volumen * @mVolumen
ELSE
SELECT @mCantidadVeces = ROUND((@mCantidad/* *@mFactor*/) * @Veces, 10)
SELECT @mCantidadVecesNeto = @mCantidadVeces
IF @CfgTipoMerma = '#'
BEGIN
IF @CfgMermaIncluida       = 0 AND ISNULL(@mMerma, 0)       <> 0.0 SELECT @mCantidadVecesNeto = @mCantidadVecesNeto + @mMerma
IF @CfgDesperdicioIncluido = 0 AND ISNULL(@mDesperdicio, 0) <> 0.0 SELECT @mCantidadVecesNeto = @mCantidadVecesNeto + @mDesperdicio
END ELSE
BEGIN
IF @CfgMermaIncluida       = 0 AND ISNULL(@mMerma, 0)       <> 0.0 SELECT @mCantidadVecesNeto = @mCantidadVecesNeto * (1+(@mMerma/100))
IF @CfgDesperdicioIncluido = 0 AND ISNULL(@mDesperdicio, 0) <> 0.0 SELECT @mCantidadVecesNeto = @mCantidadVecesNeto * (1+(@mDesperdicio/100))
END
SELECT @mCantidadVecesNeto = ROUND(@mCantidadVecesNeto, 10)
IF @Modulo = 'PROD'
BEGIN
IF @ArtEsFormula = 1
SELECT @mAlmacenDestino = @Almacen
ELSE BEGIN
SELECT @mAlmacenDestino = NULL
SELECT @mAlmacenDestino = MIN(c.Almacen),
@mCentro = MIN(c.Centro)
FROM ProdRutaD r, Centro c
WHERE r.Ruta = @Ruta AND r.Centro = c.Centro AND c.Tipo = @mCentroTipo
IF @mCentroTipo IS NULL SELECT @Ok = 25310
IF @mAlmacenDestino IS NULL SELECT @Ok = 25320
END
END
IF @Ok IS NULL
IF @mArtEsFormula = 1
EXEC spProdExp @ID, @Ruta, @ProdSerieLote,
@Producto, @SubProducto, @Material, @mSubCuenta, @mCantidadVecesNeto, @mUnidad, @mFactor, @Volumen, @mAlmacenDestino,
@CfgMultiUnidades, @CfgMultiUnidadesNivel, @CfgMermaIncluida, @CfgDesperdicioIncluido, @CfgTipoMerma, @mFechaRequerida,
@RenglonExp OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
ELSE
BEGIN
IF @CfgTipoMerma = '#'
SELECT @Merma       = @mMerma,
@Desperdicio = @mDesperdicio
ELSE
SELECT @Merma       = CONVERT(float, @mCantidadVeces * (@mMerma/100)),
@Desperdicio = CONVERT(float, @mCantidadVeces * (@mDesperdicio/100))
UPDATE ProdProgramaMaterial
SET CantidadP   = ISNULL(CantidadP,0) 	   + @Cantidad,
Cantidad    = ISNULL(Cantidad, 0)    	   + @mCantidadVecesNeto,
Merma       = NULLIF(ISNULL(Merma, 0)       + @Merma, 0),
Desperdicio = NULLIF(ISNULL(Desperdicio, 0) + @Desperdicio, 0)
WHERE ID = @ID AND Producto = @Articulo AND SubProducto =  @SubCuenta AND Lote = @ProdSerieLote AND Articulo = @Material AND SubCuenta = @mSubCuenta AND Unidad = @mUnidad AND Factor = @mFactor AND AlmacenDestino = @mAlmacenDestino AND AlmacenOrigen = @mAlmacenOrigen AND FechaRequerida = @mFechaRequerida
IF @@ROWCOUNT = 0
BEGIN
SELECT @RenglonExp  = @RenglonExp + 2048, @RenglonID = @RenglonID + 1
IF @Modulo = 'PROD'
INSERT ProdProgramaMaterial (ID,  Renglon,     Producto,  SubProducto,  CantidadP, UnidadP, Lote,           Articulo,  SubCuenta,   Cantidad,            Unidad,   Factor,              AlmacenDestino,   AlmacenOrigen,   Merma,  Desperdicio,  FechaRequerida)
VALUES (@ID, @RenglonExp, @Producto, @SubProducto, @Cantidad, @Unidad, @ProdSerieLote, @Material, @mSubCuenta, @mCantidadVecesNeto, @mUnidad, ISNULL(@mFactor, 1), @mAlmacenDestino, @mAlmacenOrigen, NULLIF(@Merma, 0), NULLIF(@Desperdicio, 0), @mFechaRequerida)
ELSE
IF @Modulo = 'INV'
INSERT InvD (ID,  Renglon,     RenglonID,  ProdSerieLote,  Producto,  SubProducto,  Articulo,  SubCuenta,   Cantidad,            Unidad,   Tipo,     Factor,              Almacen,         CantidadInventario)
VALUES (@ID, @RenglonExp, @RenglonID, @ProdSerieLote, @Producto, @SubProducto, @Material, @mSubCuenta, @mCantidadVecesNeto, @mUnidad, 'Salida', ISNULL(@mFactor, 1), @mAlmacenOrigen, @mCantidadVecesNeto*ISNULL(@mFactor, 1))
END
END
END
END
IF @Ok IS NOT NULL SELECT @OkRef = @Material
END
FETCH NEXT FROM crOrdenExp INTO @SiOpcion, @Material, @mSubCuenta, @mCantidad, @mUnidad, @mVolumen, @mMerma, @mDesperdicio, @mAlmacenOrigen, @mCentroTipo, @mTE, @mTEUnidad, @mArtTipo, @mArtTipoOpcion, @mArtEsFormula
END
CLOSE crOrdenExp
DEALLOCATE crOrdenExp
END
IF @Ok IS NOT NULL
IF @OkRef IS NULL SELECT @OkRef = @Articulo ELSE SELECT @OkRef = RTRIM(@Articulo)+' / '+RTRIM(@OkRef)
RETURN
END

