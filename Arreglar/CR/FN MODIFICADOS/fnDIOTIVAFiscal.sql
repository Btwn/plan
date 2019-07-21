SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnDIOTIVAFiscal (@Importe float, @Impuestos float)
RETURNS float
AS BEGIN
RETURN
(ISNULL(@Impuestos,0.0)/NULLIF((ISNULL(@Importe,0.0)+ISNULL(@Impuestos,0.0)),0.0))
END

