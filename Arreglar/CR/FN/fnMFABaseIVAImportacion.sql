SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMFABaseIVAImportacion(
@Mov							varchar(20),
@MovID							varchar(20),
@ImporteMov						float,
@ImporteTotal					float,
@Empresa						varchar(5),
@COMSCalcularBaseImportacion	bit
)
RETURNS float
AS
BEGIN
DECLARE @Valor		float,
@Factor		float
SELECT @Factor = (@ImporteTotal)/NULLIF(@ImporteMov, 0)
SELECT @Valor = SUM(importe_total)
FROM MFACompraImportacionCxpDocumentoCalc
WHERE Empresa  = @Empresa
AND Origen   = @Mov
AND OrigenID = @MovID
AND ISNULL(concepto_es_importacion, 0) = 1
SELECT @Valor = ISNULL(@Valor * @Factor, 0)
RETURN ISNULL(@Valor, 0)
END

