SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpArtUnidadFactorRecalc
@Empresa		char(5),
@Accion			char(20),
@Modulo			char(5),
@ID			int,
@Renglon		float,
@RenglonSub		int,
@MovTipo		char(20),
@AlmacenTipo		char(15),
@Articulo		char(20),
@SubCuenta		varchar(50),
@MovUnidad		varchar(50),
@ArtTipo		varchar(20),
@Factor			float,
@Almacen		char(10),
@Cantidad		float,
@CantidadInventario	float,
@EsEntrada		bit,
@EsSalida		bit,
@Ok			int		OUTPUT,
@OkRef			varchar(255)	OUTPUT
AS BEGIN
IF NOT EXISTS(SELECT Empresa FROM EmpresaCfg2 WHERE Empresa = @Empresa AND AutoAjustarArtUnidadFactor = 1 AND UPPER(NivelFactorMultiUnidad) = 'ARTICULO') RETURN
DECLARE
@Aumentar		bit,
@ArtUnidadFactor	float,
@NuevoFactor	float,
@InvAnterior	float,
@ExistenciaAnterior	float
IF @EsEntrada = 1 SELECT @Aumentar = 1 ELSE
IF @EsSalida  = 1 SELECT @Aumentar = 0 ELSE RETURN
SELECT @InvAnterior = SUM(Inventario)
FROM ArtSubExistenciaInv
WHERE Empresa = @Empresa AND Almacen = @Almacen AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
IF @Aumentar = 1
SELECT @InvAnterior = ISNULL(@InvAnterior, 0) - ISNULL(@CantidadInventario, 0)
ELSE
SELECT @InvAnterior = ISNULL(@InvAnterior, 0) + ISNULL(@CantidadInventario, 0)
SELECT @ArtUnidadFactor = ISNULL(Factor, 1) FROM ArtUnidad WHERE Articulo = @Articulo AND Unidad = @MovUnidad
SELECT @ExistenciaAnterior = ISNULL(@InvAnterior / NULLIF(@ArtUnidadFactor, 0), 0)
IF @Aumentar = 1
SELECT @NuevoFactor = (@InvAnterior + ISNULL(@CantidadInventario, 0)) / NULLIF(@ExistenciaAnterior + @Cantidad, 0)
ELSE
SELECT @NuevoFactor = (@InvAnterior - ISNULL(@CantidadInventario, 0)) / NULLIF(@ExistenciaAnterior - @Cantidad, 0)
IF @@ROWCOUNT = 0
INSERT ArtUnidad (Articulo, Unidad, Factor) VALUES (@Articulo, @MovUnidad, @NuevoFactor)
RETURN
END

