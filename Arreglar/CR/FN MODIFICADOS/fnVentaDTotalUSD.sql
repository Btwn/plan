SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnVentaDTotalUSD (@Moneda varchar(10), @Importe float)
RETURNS float

AS BEGIN
DECLARE
@Resultado     float,
@Clave         varchar(3),
@TipoCambioUSD float
SELECT @Clave = Clave FROM Mon WITH(NOLOCK) WHERE Moneda = @Moneda
SELECT @TipoCambioUSD = TipoCambio FROM Mon WITH(NOLOCK) WHERE Clave = 'USD'
IF ISNULL(@Clave,'') = 'USD' SELECT @Resultado = @Importe
ELSE IF ISNULL(@Clave,'') = 'MXN' SELECT @Resultado = @Importe / TipoCambio FROM Mon WITH(NOLOCK) WHERE Clave = 'USD'
ELSE IF ISNULL(@TipoCambioUSD,0) > 0 SELECT @Resultado = @Importe * (TipoCambio / @TipoCambioUSD) FROM Mon WITH(NOLOCK) WHERE Moneda = @Moneda
RETURN(@Resultado)
END

