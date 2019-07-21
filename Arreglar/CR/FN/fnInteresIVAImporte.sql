SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnInteresIVAImporte
(
@TipoTasa			varchar(20),
@TieneTasaEsp		bit = 0,
@TasaEsp			float = NULL,
@Inflacion			float,
@InteresImporte		float,
@IVAPorcentaje		float,
@Quita				float,
@Moratorios			bit = 0
)
RETURNS float

AS BEGIN
DECLARE
@InteresIVAImporte		float,
@TasaDiaria				float,
@TasaRealDiaria			float,
@MoratoriosFactor			float
IF @Moratorios = 1
SELECT @MoratoriosFactor = ISNULL(NULLIF(MoratoriosFactor,0.0),1.0) FROM TipoTasa WHERE TipoTasa = @TipoTasa
ELSE
SELECT @MoratoriosFactor = 1.0
SET @Quita = ISNULL(@Quita,0.0)
SET @Inflacion = ISNULL(@Inflacion,0.0)
SET @InteresImporte = ISNULL(@InteresImporte,0.0) * (1-(@Quita/100.0))
SET @IVAPorcentaje = ISNULL(@IVAPorcentaje,0.0)
SET @InteresIVAImporte = -1
SELECT @TasaDiaria = dbo.fnTasaDiaria(@TipoTasa,@TieneTasaEsp,@TasaEsp) * @MoratoriosFactor
IF @TasaDiaria >= 0.0 AND @Inflacion >= 0.0
BEGIN
SET @TasaRealDiaria = dbo.fnTasaRealDiaria(@TasaDiaria, @MoratoriosFactor, @Inflacion)
IF @InteresImporte >= 0.0 AND @IVAPorcentaje >= 0.0
BEGIN
SET @InteresIVAImporte = (@TasaRealDiaria/@TasaDiaria)*@InteresImporte*(@IVAPorcentaje/100.0)
END
END
RETURN @InteresIVAImporte
END

