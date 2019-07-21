SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSValidarCB (
@Codigo   varchar(30)
)
RETURNS bit

AS
BEGIN
DECLARE
@Resultado  bit
SELECT @Resultado = 0
IF EXISTS (SELECT * FROM CB WHERE Codigo = @Codigo)
SELECT @Resultado = 1
RETURN (@Resultado)
END

