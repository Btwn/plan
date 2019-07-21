SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnDIOTBaseIVAImportacion(
@Mov						varchar(20),
@MovID						varchar(20),
@Empresa					varchar(5),
@CalcularBaseImportacion	bit
)
RETURNS float
AS
BEGIN
DECLARE @Valor		float
SELECT @Valor = SUM(ISNULL(Importe,0.0) + ISNULL(IVA,0.0) + ISNULL(IEPS,0.0) + ISNULL(ISAN,0.0) - ISNULL(Retencion1,0.0) - ISNULL(Retencion2,0.0))
FROM DIOTCxpDocumentoImportacion WITH(NOLOCK)
JOIN DIOTConceptoImportacion WITH(NOLOCK) ON DIOTCxpDocumentoImportacion.Concepto = DIOTConceptoImportacion.Concepto
WHERE Empresa  = @Empresa
AND Origen   = @Mov
AND OrigenID = @MovID
RETURN ISNULL(@Valor, 0)
END

