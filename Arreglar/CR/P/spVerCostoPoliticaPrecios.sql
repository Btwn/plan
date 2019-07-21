SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerCostoPoliticaPrecios
@Empresa	    char(5),
@Articulo	    char(20),
@SubCuenta	    varchar(50),
@Sucursal	    int	 	= 0,
@Descripcion	varchar(100) 	= NULL,
@MovUnidad		varchar(50) = NULL

AS BEGIN
DECLARE
@Costo	money,
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@UnidadFactor			float,
@Decimales				float
SELECT @CfgMultiUnidades         = MultiUnidades,
@CfgMultiUnidadesNivel    = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @SubCuenta = NULLIF(NULLIF(RTRIM(@SubCuenta), ''), '0'), @Costo = NULL
IF @SubCuenta IS NOT NULL
SELECT @Costo = c.UltimoCosto
FROM ArtSubCosto c
WHERE c.Empresa = @Empresa AND c.Articulo = @Articulo AND c.SubCuenta = @SubCuenta
AND c.Sucursal = @Sucursal
IF @Costo IS NULL
SELECT @Costo = c.UltimoCosto
FROM ArtCosto c
WHERE c.Empresa = @Empresa AND c.Articulo = @Articulo
AND c.Sucursal = @Sucursal
IF (SELECT VentaPreciosImpuestoIncluido FROM EmpresaCfg WHERE Empresa = @Empresa) = 1
BEGIN
SELECT @Costo = dbo.fnPrecioConImpuestos(@Empresa, @Articulo, @Costo)
END
IF @CfgMultiUnidades = 1
BEGIN
IF @CfgMultiUnidadesNivel = 'ARTICULO'
EXEC xpArtUnidadFactor @Articulo, @SubCuenta, @MovUnidad, @UnidadFactor OUTPUT, @Decimales OUTPUT, NULL
ELSE
EXEC xpUnidadFactor @Articulo, @SubCuenta, @MovUnidad, @UnidadFactor OUTPUT, @Decimales OUTPUT
END
IF NULLIF(@UnidadFactor,0) IS NULL SELECT @UnidadFactor = 1
SELECT @Costo = @Costo*@UnidadFactor
SELECT "Costo" = @Costo
END

