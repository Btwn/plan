SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPOSTipoCambio (
@Moneda		varchar(10),
@Sucursal	int
)
RETURNS float

AS
BEGIN
DECLARE
@TipoCambio	float
SELECT @TipoCambio = TipoCambio
FROM POSLTipoCambioRef WITH(NOLOCK)
WHERE Moneda = @Moneda AND Sucursal = @Sucursal
IF @TipoCambio IS NULL
SELECT @TipoCambio = TipoCambio
FROM Mon WITH(NOLOCK)
WHERE Moneda = @Moneda
RETURN (@TipoCambio)
END

