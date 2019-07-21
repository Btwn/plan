SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoConcepto
@Cfg		varchar(50),
@ConceptoGasto	varchar(50),
@Concepto	varchar(50)	OUTPUT

AS BEGIN
IF @Cfg = '(Concepto Gasto)'       SELECT @Concepto = @ConceptoGasto ELSE
IF @Cfg = 'ISR - (Concepto Gasto)' SELECT @Concepto = 'ISR ' + @ConceptoGasto ELSE
IF @Cfg = 'IVA - (Concepto Gasto)' SELECT @Concepto = 'IVA ' + @ConceptoGasto ELSE
IF @Cfg = 'R3 - (Concepto Gasto)'  SELECT @Concepto = 'R3 ' + @ConceptoGasto
RETURN
END

