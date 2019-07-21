SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnTasaRealDiaria
(
@TasaDiaria				float,
@MoratoriosFactor		float,
@Inflacion				float
)
RETURNS float

AS BEGIN
DECLARE
@Resultado				float,
@TasaRealDiaria			float
IF @TasaDiaria = -1
BEGIN
SET @Resultado = @TasaDiaria
END
ELSE
BEGIN
SET @TasaRealDiaria = (@TasaDiaria * ISNULL(NULLIF(@MoratoriosFactor,0.0),1.0)) - @Inflacion
IF @TasaRealDiaria < 0.0 SET @TasaRealDiaria = 0.0
SET @Resultado = @TasaRealDiaria
END
RETURN (@Resultado)
END

