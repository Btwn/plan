SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnArtUnidadCantidadTarima(@Empresa varchar(5), @Articulo varchar(20), @Unidad varchar(50))
RETURNS float
AS BEGIN
DECLARE
@Resultado				float,
@CfgMultiUnidadesNivel	varchar(20),
@MultiUnidades          int 
SELECT @CfgMultiUnidadesNivel = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD'),
@MultiUnidades         = ISNULL(MultiUnidades,0) 
FROM EmpresaCfg2 WHERE Empresa = @Empresa
SELECT @Resultado = NULL
IF @MultiUnidades = 1 
BEGIN
IF @CfgMultiUnidadesNivel = 'ARTICULO'
SELECT @Resultado = NULLIF(CantidadCamaTarima, 0.0) 
FROM ArtUnidad WHERE Articulo = @Articulo AND Unidad = @Unidad
ELSE
IF @CfgMultiUnidadesNivel = 'UNIDAD'
SELECT @Resultado = NULLIF(CantidadTarima, 0.0) FROM Art WHERE Articulo = @Articulo
END
ELSE
SELECT @Resultado = NULLIF(CantidadTarima, 0.0) FROM Art WHERE Articulo = @Articulo
RETURN(@Resultado)
END

