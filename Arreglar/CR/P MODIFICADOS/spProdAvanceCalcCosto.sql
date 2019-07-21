SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProdAvanceCalcCosto
@Empresa	 char(5),
@ProdSerieLote	 varchar(50),
@Articulo	 char(20),
@SubCuenta	 varchar(50),
@Ruta		 char(20),
@Orden		 int,
@Centro		 char(10),
@TipoCosto	 char(10),	
@Cantidad	 float,
@Tiempo		 float,
@TiempoUnidad	 char(10),
@MovMoneda	 char(10),
@MovTipoCambio	 float,
@EnSilencio	 bit	= 0,
@CostoMO	 float 	= 0.0	OUTPUT,
@CostoIndirectos float 	= 0.0	OUTPUT,
@CostoMaquila	 float  = 0.0   OUTPUT

AS BEGIN
DECLARE
@Moneda			char(10),
@CostoManoObra		float,
@Factor			float,
@TipoCambio			float,
@Cxp			bit,
@Ok				int
SELECT @Ok = NULL, @CostoMO = 0.0, @CostoIndirectos = 0.0, @TipoCosto = UPPER(@TipoCosto), @SubCuenta = ISNULL(RTRIM(@SubCuenta), '')
IF @TipoCosto IN ('MO', 'AMBOS')
BEGIN
IF @Ruta IS NULL
SELECT @Ruta = MIN(Ruta) FROM ProdSerieLotePendiente WHERE Empresa = @Empresa AND ProdSerieLote = @ProdSerieLote AND Articulo = @Articulo AND SubCuenta = @SubCuenta
SELECT @CostoMO = ISNULL(Costo, 0.0), @Moneda = Moneda
FROM ProdRutaD WITH(NOLOCK)
WHERE Ruta = @Ruta AND Orden = @Orden AND Centro = @Centro
EXEC spMoneda NULL, @MovMoneda, @MovTipoCambio, @Moneda, @Factor OUTPUT, @TipoCambio OUTPUT, @Ok OUTPUT
SELECT @CostoMO = @CostoMO * @Factor * @Cantidad
END
SELECT @Cxp = Cxp,
@CostoManoObra       = ISNULL(CostoManoObra, 0.0),
@CostoIndirectos     = ISNULL(CostoIndirectos, 0.0),
@Moneda = CostoMoneda
FROM Centro WITH(NOLOCK)
WHERE Centro = @Centro
EXEC spMoneda NULL, @MovMoneda, @MovTipoCambio, @Moneda, @Factor OUTPUT, @TipoCambio OUTPUT, @Ok OUTPUT
IF @Cxp = 1
BEGIN
SELECT @CostoMaquila = NULL
SELECT @CostoMaquila = ISNULL(Costo, 0) * @Factor * @Cantidad
FROM CentroTarifa WITH(NOLOCK)
WHERE Centro = @Centro AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(RTRIM(@SubCuenta), '')
IF @CostoMaquila IS NULL
SELECT @CostoMaquila = ISNULL(Costo, 0) * @Factor * @Cantidad
FROM CentroTarifa WITH(NOLOCK)
WHERE Centro = @Centro AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ''
END
SELECT @CostoMO         = @CostoMO + (@CostoManoObra * @Factor * @Tiempo),
@CostoIndirectos = (@CostoIndirectos * @Factor * @Tiempo)
IF @EnSilencio = 0
IF @TipoCosto = 'MAQ'
SELECT "Costo" = @CostoMaquila
ELSE IF @TipoCosto = 'MO'
SELECT "Costo" = @CostoMO
ELSE
SELECT "Costo" = @CostoIndirectos
END

