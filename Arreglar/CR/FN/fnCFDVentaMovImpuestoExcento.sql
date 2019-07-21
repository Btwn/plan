SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCFDVentaMovImpuestoExcento (@ID int, @Impuestos float)
RETURNS float

AS BEGIN
DECLARE
@Resultado 	float
IF NOT EXISTS(SELECT * FROM CFDVentaMovImpuesto WHERE ID = @ID)
SELECT @Resultado = NULL
ELSE
SELECT @Resultado = ISNULL(@Impuestos,0)
RETURN (@Resultado)
END

