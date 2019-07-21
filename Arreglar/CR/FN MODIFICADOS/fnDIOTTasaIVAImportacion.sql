SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnDIOTTasaIVAImportacion(
@Mov							varchar(20),
@MovID							varchar(20),
@Empresa						varchar(5),
@CalcularBaseImportacion		bit,
@Impuesto1						float
)
RETURNS float
AS
BEGIN
DECLARE @Valor		float
SELECT @Valor = Tasa
FROM DIOTCxpDocumentoImportacion
WHERE Empresa  = @Empresa
AND Origen   = @Mov
AND OrigenID = @MovID
AND NULLIF(Tasa, 0) IS NOT NULL
IF @Valor IS NULL
SELECT @Valor = @Impuesto1
RETURN ISNULL(@Valor, 0)
END

