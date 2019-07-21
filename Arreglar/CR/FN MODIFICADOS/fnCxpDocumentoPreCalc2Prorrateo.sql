SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCxpDocumentoPreCalc2Prorrateo(@ImporteO float, @ImpuestosO float, @RetencionO float, @ImporteD float)
RETURNS float
AS
BEGIN
DECLARE @Valor		float,
@ImporteTotal	float
SELECT @ImporteTotal = ISNULL(@ImporteO, 0) + ISNULL(@ImpuestosO, 0) - ISNULL(@RetencionO, 0)
SELECT @Valor = ((@ImporteD*100.0)/@ImporteTotal)/100.0
RETURN @Valor
END

