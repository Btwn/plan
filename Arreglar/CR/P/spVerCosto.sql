SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerCosto
@Sucursal	int,
@Empresa	char(5),
@Proveedor	char(10),
@Articulo	char(20),
@SubCuenta	varchar(50),
@MovUnidad	varchar(50),
@Cual		char(20),
@MovMoneda	char(10),
@MovTipoCambio	float,
@MovCosto 	money   = NULL OUTPUT,
@ConReturn      bit     = 1,
@Precio		money	= NULL,
@Modulo		char(5)	= NULL,
@ModuloID	int	= NULL

AS BEGIN
DECLARE
@CostoNivelOpcion		bit,
@CfgMultiUnidadesNivel	char(20),
@UltCostoProv		bit,
@ArtMoneda			char(10),
@ArtTipo			varchar(20),
@UltCosto			money,
@Costo			money,
@Ultimo			money,
@UltimoSinGastos		money,
@Estandar			money,
@Reposicion			money,
@Promedio			money,
@ArtFactor			float,
@ArtTipoCambio		float,
@UnidadFactor		float,
@Margen			float,
@Decimales			int,
@Ok				int,
@CostoOk			bit,
@Mensaje			varchar(255),
@UltimoCosto		money,
@FechaUltimaCompra		datetime,
@UltimaCotizacion		money,
@FechaCotizacion		datetime,
@SugerirCostoArtServicio	varchar(20),
@Impuesto1			float,
@Impuesto2			float,
@Impuesto3			float,
@JuntarImpuestos		float,
@CfgImpInc			bit,
@CfgPrecioMoneda		bit,
@RedondeoMonetarios		int,
@Impuesto2Info		bit,
@Impuesto3Info		bit
SELECT @RedondeoMonetarios = RedondeoMonetarios, @Impuesto2Info = ISNULL(Impuesto2Info, 0), @Impuesto3Info = ISNULL(Impuesto3Info, 0) FROM Version
SELECT @UltCosto = @MovCosto,
@SubCuenta = NULLIF(NULLIF(RTRIM(@SubCuenta), ''), '0'),
@UltCostoProv = 0,
@Proveedor = NULLIF(NULLIF(RTRIM(@Proveedor), ''), '0'),
@MovUnidad = NULLIF(NULLIF(RTRIM(@MovUnidad), ''), '0'),
@CostoOk = 0
EXEC xpVerCosto @Empresa, @Proveedor, @Articulo,  @MovUnidad, @Cual, @MovMoneda, @MovTipoCambio, @MovCosto OUTPUT
IF @MovCosto = @UltCosto
BEGIN
SELECT @ArtFactor = 1.0, @UnidadFactor = 1.0, @Costo = NULL, @MovCosto = NULL, @Cual = NULLIF(UPPER(RTRIM(@Cual)), '')
SELECT @CfgMultiUnidadesNivel = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD'),
@UltCostoProv = ISNULL(CompraSugerirUltimoCostoProv, 0)
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @CostoNivelOpcion        = CosteoNivelSubCuenta,
@SugerirCostoArtServicio = ISNULL(NULLIF(RTRIM(UPPER(SugerirCostoArtServicio)), ''), 'NO'),
@CfgImpInc		    = VentaPreciosImpuestoIncluido,
@CfgPrecioMoneda	    = VentaPrecioMoneda
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @SugerirCostoArtServicio <> 'NO'
BEGIN
SELECT @ArtTipo = UPPER(Tipo) FROM Art WHERE Articulo = @Articulo
IF @ArtTipo IN ('SERVICIO', 'JUEGO')
SELECT @Cual = @SugerirCostoArtServicio
END
IF @Proveedor IS NOT NULL AND @UltCostoProv = 1
BEGIN
SELECT @MovCosto = NULL
IF @MovUnidad IS NOT NULL
SELECT @MovCosto = NULLIF(UltimoCosto, 0)
FROM ArtProvUnidad
WHERE Articulo = @Articulo AND ISNULL(RTRIM(SubCuenta), '') = ISNULL(@SubCuenta, '') AND Proveedor = @Proveedor AND Unidad = @MovUnidad
ELSE
BEGIN
SELECT @UltimoCosto = UltimoCosto,
@FechaUltimaCompra = UltimaCompra,
@UltimaCotizacion = UltimaCotizacion,
@FechaCotizacion = FechaCotizacion
FROM ArtProv
WHERE Articulo = @Articulo AND ISNULL(RTRIM(SubCuenta), '') = ISNULL(@SubCuenta, '') AND Proveedor = @Proveedor
IF @FechaCotizacion > @FechaUltimaCompra
SELECT @MovCosto = @UltimaCotizacion
ELSE
SELECT @MovCosto = @UltimoCosto
END
IF @MovCosto IS NOT NULL
BEGIN
SELECT @ArtMoneda = MonedaCosto FROM Art WHERE Articulo = @Articulo
IF @MovMoneda<>@ArtMoneda
EXEC spMoneda NULL, @MovMoneda, @MovTipoCambio, @ArtMoneda, @ArtFactor OUTPUT, @ArtTipoCambio OUTPUT, @Ok OUTPUT, @Modulo, @ModuloID
SELECT @MovCosto = ISNULL(@MovCosto*@ArtFactor, 0.0)
SELECT @CostoOk = 1
END
END
IF @CostoOk = 0
BEGIN
IF @Cual NOT IN (NULL, 'NO')
BEGIN
IF @Cual IN ('ESTANDAR', 'REPOSICION') AND @SubCuenta IS NOT NULL
BEGIN
SELECT @Estandar   = CostoEstandar,
@Reposicion = CostoReposicion
FROM ArtSub
WHERE Articulo = @Articulo
AND SubCuenta = @SubCuenta
IF @@ROWCOUNT = 0 AND NOT EXISTS(SELECT * FROM ArtSub WHERE Articulo = @Articulo)
SELECT @Estandar   = CostoEstandar,
@Reposicion = CostoReposicion
FROM Art
WHERE Articulo = @Articulo
END ELSE
BEGIN
IF @CostoNivelOpcion  = 1 AND @SubCuenta IS NOT NULL
SELECT @ArtMoneda 	= MonedaCosto,
@Ultimo    	= UltimoCosto,
@UltimoSinGastos = UltimoCostoSinGastos,
@Estandar  	= Art.CostoEstandar,
@Reposicion	= Art.CostoReposicion,
@Promedio  	= CostoPromedio,
@Precio	= ISNULL(@Precio, PrecioLista),
@Margen	= Margen,
@Impuesto1   = Art.Impuesto1
FROM Art
LEFT OUTER JOIN ArtSubCosto ON Art.Articulo = ArtSubCosto.Articulo AND ArtSubCosto.Sucursal = @Sucursal AND ArtSubCosto.Empresa = @Empresa AND ArtSubCosto.SubCuenta = @SubCuenta
WHERE Art.Articulo = @Articulo
ELSE
SELECT @ArtMoneda 	= MonedaCosto,
@Ultimo    	= UltimoCosto,
@UltimoSinGastos = UltimoCostoSinGastos,
@Estandar  	= Art.CostoEstandar,
@Reposicion	= Art.CostoReposicion,
@Promedio  	= CostoPromedio,
@Precio	= ISNULL(@Precio, PrecioLista),
@Margen      = Margen,
@Impuesto1   = ISNULL(Art.Impuesto1, 0),
@Impuesto2   = ISNULL(Art.Impuesto2, 0),
@Impuesto3   = ISNULL(Art.Impuesto3, 0)
FROM Art
LEFT OUTER JOIN ArtCosto ON Art.Articulo = ArtCosto.Articulo AND ArtCosto.Sucursal = @Sucursal AND ArtCosto.Empresa = @Empresa
WHERE Art.Articulo = @Articulo
END
IF @Impuesto2Info = 1 SELECT @Impuesto2 = 0.0
IF @Impuesto3Info = 1 SELECT @Impuesto3 = 0.0
IF @CfgImpInc = 1
BEGIN
SELECT @JuntarImpuestos = ((100+@Impuesto2)*(1+((@Impuesto1)/100))-100)
SELECT @Precio = (@Precio-@Impuesto3)/(1+(@JuntarImpuestos/100))
END
IF @Cual = 'PROMEDIO'     SELECT @Costo = @Promedio   ELSE
IF @Cual = 'ESTANDAR'     SELECT @Costo = @Estandar   ELSE
IF @Cual = 'REPOSICION'   SELECT @Costo = @Reposicion ELSE
IF @Cual = 'PRECIO LISTA' SELECT @Costo = @Precio     ELSE
IF @Cual = 'MARGEN'       SELECT @Costo = (@Precio*(100-@Margen))/100 ELSE
IF @Cual = 'ULTIMO (AUTOTRANS)'       SELECT @Costo = @Ultimo/(1+(@Impuesto1/100)) ELSE
IF @Cual = 'ULTIMO COSTO S/GASTO'  SELECT @Costo = @UltimoSinGastos
ELSE SELECT @Costo = @Ultimo
IF @MovMoneda<>@ArtMoneda
EXEC spMoneda NULL, @MovMoneda, @MovTipoCambio, @ArtMoneda, @ArtFactor OUTPUT, @ArtTipoCambio OUTPUT, @Ok OUTPUT, @Modulo, @ModuloID
SELECT @MovCosto = ISNULL(@Costo*@ArtFactor, 0.0)
IF @CfgMultiUnidadesNivel = 'ARTICULO'
EXEC xpArtUnidadFactor @Articulo, NULL, @MovUnidad, @UnidadFactor OUTPUT, @Decimales OUTPUT, @Ok OUTPUT
ELSE
EXEC xpUnidadFactor @Articulo, NULL, @MovUnidad, @UnidadFactor OUTPUT, @Decimales OUTPUT
SELECT @MovCosto = @MovCosto*@UnidadFactor
END
END
END
SELECT @MovCosto = ROUND(@MovCosto, @RedondeoMonetarios)
IF @ConReturn = 1 SELECT "Costo" = @MovCosto
END

