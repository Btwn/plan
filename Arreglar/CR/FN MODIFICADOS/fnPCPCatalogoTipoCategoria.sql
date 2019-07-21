SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPCPCatalogoTipoCategoria
(
@CatalogoTipo			varchar(50),
@Proyecto				varchar(50)
)
RETURNS varchar(1)

AS BEGIN
DECLARE
@Resultado			varchar(1)
SELECT @Resultado = ''
SELECT @Resultado = Categoria FROM ClavePresupuestalCatalogoTipo WITH(NOLOCK) WHERE Tipo = @CatalogoTipo AND Proyecto = @Proyecto
RETURN (@Resultado)
END

