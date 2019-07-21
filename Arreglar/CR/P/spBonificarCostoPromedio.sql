SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spBonificarCostoPromedio
@Existencia	float,
@Accion		char(20),
@MovTipo	char(20),
@Cantidad	float,
@Costo		float,
@CostoPromedio	float	OUTPUT

AS BEGIN
DECLARE
@CostoAnterior	float,
@CostoMov		float,
@EsCargo		bit
SELECT @Existencia = ISNULL(@Existencia, 0.0)
SELECT @CostoAnterior = ABS(@Existencia) * @CostoPromedio
SELECT @CostoMov = @Cantidad * @Costo
IF @MovTipo = 'COMS.B' SELECT @EsCargo = 0 ELSE SELECT @EsCargo = 1
IF @Accion = 'CANCELAR' IF @EsCargo = 0 SELECT @EsCargo = 1 ELSE SELECT @EsCargo = 0
IF @EsCargo = 1
SELECT @CostoPromedio = (@CostoAnterior + @CostoMov) / NULLIF(@Existencia, 0)
ELSE
SELECT @CostoPromedio = (@CostoAnterior - @CostoMov) / NULLIF(@Existencia, 0)
RETURN
END

