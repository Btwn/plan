SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMFAIVATasa (@Empresa varchar(5), @Importe float, @Impuestos float)
RETURNS float
AS BEGIN
DECLARE
@IVAFiscal float,
@Tasa		 float
SET @Importe = ISNULL(@Importe,0.0)
SET @Impuestos = ISNULL(@Impuestos,0.0)
SET @IVAFiscal = dbo.fnMFAIVAFiscal(@Importe,@Impuestos)
IF @Importe = 0 AND @Impuestos <> 0
SELECT @Tasa = DefImpuesto FROM EmpresaGral WITH(NOLOCK) WHERE Empresa = @Empresa
ELSE
SELECT @Tasa = ROUND(((@Importe/NULLIF((1-@IVAFiscal),0.0))*@IVAFiscal)/NULLIF(@Importe,0.0),2)*100.0
RETURN @Tasa
END

