SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSEstatusCajaBloqueada(
@Caja		varchar(10)
)
RETURNS varchar(100)

AS
BEGIN
DECLARE
@Resultado  bit
SELECT @Resultado = pec.Bloqueado
FROM POSEstatusCaja pec WITH(NOLOCK)
WHERE pec.Caja = @Caja
SELECT @Resultado = ISNULL(@Resultado,0)
RETURN (@Resultado)
END

