SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPCPCatalogoExistenteEnCategoria
(
@CatalogoClave			varchar(20),
@Categoria				varchar(1),
@Proyecto				varchar(50)
)
RETURNS bit

AS BEGIN
DECLARE
@Resultado			bit
SELECT @Resultado = 0
IF EXISTS(SELECT * FROM ClavePresupuestalCatalogo WHERE Proyecto = @Proyecto AND Clave = @CatalogoClave AND Categoria = @Categoria) SELECT @Resultado = 1
RETURN (@Resultado)
END

