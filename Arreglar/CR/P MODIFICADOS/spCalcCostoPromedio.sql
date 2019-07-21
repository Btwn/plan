SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCalcCostoPromedio
@Existencia     float,
@EsEntrada	bit,
@Cantidad	float,
@Costo		float,
@CostoPromedio	float	OUTPUT

AS BEGIN
DECLARE
@ExistenciaNueva	float,
@CostoAnterior	float,
@CostoMov		float
SELECT @Existencia = ISNULL(@Existencia, 0.0)
IF @EsEntrada = 1
SELECT @ExistenciaNueva = @Existencia + @Cantidad
ELSE
SELECT @ExistenciaNueva = @Existencia - @Cantidad
SELECT @ExistenciaNueva = ROUND(@ExistenciaNueva, 10)
SELECT @CostoAnterior = ABS(@Existencia) * @CostoPromedio
SELECT @CostoMov = @Cantidad * @Costo
IF @ExistenciaNueva < 0.01
SELECT @CostoPromedio = @Costo
ELSE
IF @EsEntrada = 1
SELECT @CostoPromedio = (@CostoAnterior + @CostoMov) / @ExistenciaNueva
ELSE BEGIN
/*IF @CostoAnterior - @CostoMov <= 0.0
SELECT @CostoPromedio = 0.0
ELSE*/
SELECT @CostoPromedio = (@CostoAnterior - @CostoMov) / @ExistenciaNueva
END
RETURN
END

