SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnImporteInflacion
(
@TipoTasa			varchar(20),
@TieneTasaEsp		bit = 0,
@TasaEsp			float = NULL,
@Inflacion			float,
@InteresImporte		float,
@IVAPorcentaje		float,
@Quita				float
)
RETURNS float

AS BEGIN
DECLARE
@ImporteInflacion			float,
@TasaDiaria				float
SET @Quita = ISNULL(@Quita,0.0)
SET @Inflacion = ISNULL(@Inflacion,0.0)
SET @InteresImporte = ISNULL(@InteresImporte,0.0) * (1-(@Quita/100.0))
SET @IVAPorcentaje = ISNULL(@IVAPorcentaje,0.0) / 100.0
SET @ImporteInflacion = 0.0
SELECT @TasaDiaria = dbo.fnTasaDiaria(@TipoTasa,@TieneTasaEsp,@TasaEsp)
IF @TasaDiaria > 0.0 AND @Inflacion >= 0.0
BEGIN
IF @Inflacion > @TasaDiaria
SET @ImporteInflacion = 1.0
ELSE
SET @ImporteInflacion = (@Inflacion / @TasaDiaria)
SET @ImporteInflacion = @ImporteInflacion * @InteresImporte * @IVAPorcentaje
END ELSE
BEGIN
SET @ImporteInflacion = -1.0
END
RETURN @ImporteInflacion
END

