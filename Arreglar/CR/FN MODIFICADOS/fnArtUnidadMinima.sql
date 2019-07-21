SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnArtUnidadMinima (@Empresa varchar(5), @Articulo varchar(20))
RETURNS varchar(50)

AS BEGIN
DECLARE
@Resultado			varchar(50),
@CfgMultiUnidadesNivel	varchar(20)
SELECT @CfgMultiUnidadesNivel = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
FROM EmpresaCfg2 WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @Resultado = NULL
IF @CfgMultiUnidadesNivel = 'ARTICULO'
SELECT @Resultado = NULLIF(Unidad, '')
FROM ArtUnidad WITH (NOLOCK)
WHERE Articulo = @Articulo AND Factor = 1
IF @Resultado IS NULL
SELECT @Resultado = dbo.fnUnidadMinima(@Articulo)
RETURN(@Resultado)
END

