SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMFATasaIVAImportacion(
@Mov							varchar(20),
@MovID							varchar(20),
@Empresa						varchar(5),
@COMSCalcularBaseImportacion	bit,
@Impuesto1						float
)
RETURNS float
AS
BEGIN
DECLARE @Valor		float
SELECT @Valor = NULL
SELECT @Valor = iva_tasa
FROM MFACompraImportacionCxpDocumentoCalc
WHERE Empresa  = @Empresa
AND Origen   = @Mov
AND OrigenID = @MovID
AND NULLIF(iva_tasa, 0) IS NOT NULL
IF(RTRIM(LTRIM(@Mov)) = 'Entrada Importacion' AND (select COUNT(*) from MFAConceptoCOMSG where EsIVAImportacion = 1) = 0 )
SET @Valor = 0
IF @Valor IS NULL
SELECT @Valor = @Impuesto1
RETURN ISNULL(@Valor, 0)
RETURN @Valor
END

