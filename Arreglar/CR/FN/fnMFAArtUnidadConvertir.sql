SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMFAArtUnidadConvertir
(
@Cantidad				float,
@FactorOrigen			float,
@FactorDestino			float
)
RETURNS float

AS BEGIN
DECLARE
@Resultado			float
SET @Resultado = @Cantidad * @FactorOrigen
SET @Resultado = @Resultado / NULLIF(@FactorDestino,0.0)
RETURN (@Resultado)
END

