SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMFAIVA (@Empresa varchar(5), @Importe float, @Impuestos float)
RETURNS float
AS BEGIN
DECLARE
@IVAFiscal float,
@IVA		 float,
@Tasa		 float
SELECT @Tasa = NULLIF(DefImpuesto/100.0, 0) FROM EmpresaGral WHERE Empresa = @Empresa
SET @Importe = ISNULL(@Importe,0.0)
SET @Impuestos = ISNULL(@Impuestos,0.0)
SET @IVAFiscal = dbo.fnMFAIVAFiscal(@Importe,@Impuestos)
IF @Importe = 0 AND @Impuestos <> 0
SELECT @IVA = @Impuestos/2
ELSE
SELECT @IVA = ((@Importe/NULLIF((1-@IVAFiscal),0.0))*@IVAFiscal)
RETURN @IVA
END

