SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnRedondeaMaxMin(@Valor float)
RETURNS float
AS BEGIN
DECLARE @Entero              int,
@Decimal             float,
@Redondeo            float
SET @Entero = 0
SET @Decimal = 0
SET @Redondeo = 0
SET @Entero = CONVERT(int, @Valor)
SET @Decimal = ROUND((@Valor - @Entero), 2)
IF @Decimal > 0.5
SET @Redondeo = @Entero + 1
IF @Decimal <= 0.5
SET @Redondeo = @Entero
RETURN @Redondeo
END

