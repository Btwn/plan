SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnWebSKUArticuloSubCuenta
(
@SKU        varchar(255)
)
RETURNS varchar(255)

AS BEGIN
DECLARE
@Resultado   varchar(255),
@Tipo        varchar(50)
IF @SKU LIKE 'IDCO#%'
SELECT   @Tipo = 'Combinacion'
IF @SKU LIKE 'ID#%'
SELECT   @Tipo = 'WebArt'
IF @Tipo = 'Combinacion'
SELECT @Resultado =  ISNULL(SubCuenta,'')
FROM WebArtVariacionCombinacion WITH(NOLOCK) WHERE ID = dbo.fnWebArtSKU (@SKU)
IF @Tipo = 'WebArt'
SELECT @Resultado = ISNULL(SubCuenta,'')
FROM WebArt WITH(NOLOCK) WHERE ID = dbo.fnWebArtSKU (@SKU)
IF @Tipo IS NULL
SELECT @Resultado = ISNULL(SubCuenta,'')
FROM CB WITH(NOLOCK) WHERE Codigo= @SKU
IF ISNULL(@Resultado, '') = ''
SELECT @Resultado = SubCuenta
FROM WebArt WITH(NOLOCK) WHERE SKU = @SKU
IF ISNULL(@Resultado, '') = ''
SELECT @Resultado = SubCuenta
FROM WebArtVariacionCombinacion WITH(NOLOCK) WHERE SKU = @SKU
RETURN (@Resultado)
END

