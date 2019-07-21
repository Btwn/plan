SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPCPValidarClaveCatalogo
(
@Clave					varchar(20),
@CatalogoTipo			varchar(50),
@Proyecto				varchar(50)
)
RETURNS bit

AS BEGIN
DECLARE
@Resultado			bit,
@Digitos			int
SET @Resultado = 0
SELECT @Digitos = Digitos FROM ClavePresupuestalCatalogoTipo WHERE Tipo = @CatalogoTipo AND Proyecto = @Proyecto
IF LEN(@Clave) = @Digitos SET @Resultado = 1
RETURN (@Resultado)
END

