SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMFAGASImporte(
@GASPorcentajeDeducible		bit,
@PorcentajeDeducible		float
)
RETURNS float
AS BEGIN
DECLARE @Valor	float
IF ISNULL(@GASPorcentajeDeducible, 0) = 0
SELECT @Valor = 100.0
ELSE
SELECT @Valor = @PorcentajeDeducible
RETURN @Valor
END

