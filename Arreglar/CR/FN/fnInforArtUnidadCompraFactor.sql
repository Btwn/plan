SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnInforArtUnidadCompraFactor (@Empresa varchar(5), @Articulo varchar(20))
RETURNS float

AS BEGIN
DECLARE
@Resultado                                     float,
@CfgMultiUnidadesNivel           varchar(20),
@Unidad                     varchar(50)
SELECT @Unidad = ISNULL(NULLIF(UnidadCompra,''),Unidad) FROM Art WHERE Articulo = @Articulo
SELECT @CfgMultiUnidadesNivel = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @Resultado = NULL
IF @CfgMultiUnidadesNivel = 'ARTICULO'
SELECT @Resultado = NULLIF(Factor, 0.0)
FROM ArtUnidad
WHERE Articulo = @Articulo AND Unidad = @Unidad
IF @Resultado IS NULL
SELECT @Resultado = dbo.fnUnidadFactor(@Unidad)
RETURN(@Resultado)
END

