SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNominaSubsidioProporcional
@DiasPeriodo		float,
@DiasMes		float,
@ImportePeriodo        	money,
@SubsidioAcreditable	float,
@Credito		money	OUTPUT

AS BEGIN
DECLARE
@ImporteMensual	money,
@Subsidio		money,
@FactorDiasMes	float
SELECT  @Subsidio = NULL, @Credito = NULL, @FactorDiasMes =  NULLIF(@DiasMes, 0)
SELECT @ImporteMensual = @ImportePeriodo * NULLIF(@FactorDiasMes, 0)
EXEC   spTablaImpuesto 'Subsidio al Empleo', NULL, 'Mensual', @ImporteMensual,     	@Credito 	OUTPUT
SELECT @Credito = @Credito / @DiasMes
RETURN
END

