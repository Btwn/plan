SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNominaISRSubsidioAlEmpleoProporcional
@DiasPeriodo		     float,
@DiasPeriodoSubsidio float,
@DiasMes             float,
@ImportePeriodo      money,
@ISRNeto		         money	OUTPUT,
@SubsidioAlEmpleo	   money	OUTPUT,
@ISRBruto		         money	OUTPUT,
@Esfinmes                        int = 0

AS BEGIN
DECLARE
@ImporteMensual	money,
@Subsidio		    money
IF @ImportePeriodo <= 0
BEGIN
SELECT @ISRNeto=0, @SubsidioAlEmpleo=0, @ISRBruto=0
RETURN
END
SELECT @DiasPeriodo = dbo.fnMayor(0,@DiasPeriodo)
SELECT @ISRBruto = NULL, @SubsidioAlEmpleo = NULL
IF @Esfinmes = 0
SELECT @ImporteMensual = @ImportePeriodo * @DiasMes /  @DiasPeriodo
ELSE
SELECT @ImporteMensual = @ImportePeriodo
EXEC   spTablaImpuesto 'ISR', NULL,'Mensual', @ImporteMensual,  	@ISRBruto	OUTPUT
SELECT @ImporteMensual = @ImportePeriodo * 30.4 / @DiasPeriodoSubsidio
EXEC   spTablaImpuesto 'Subsidio Al Empleo', NULL, 'Mensual', @ImporteMensual,     	@SubsidioAlEmpleo 	OUTPUT
IF @Esfinmes = 0
SELECT  @ISRBruto= ISNULL(@ISRBruto, 0.0) * @DiasPeriodo / @DiasMes
SELECT @SubsidioAlEmpleo = @SubsidioAlEmpleo * @DiasPeriodoSubsidio / 30.4
SELECT @ISRNeto = ISNULL(@ISRBruto, 0.0) - ISNULL(@SubsidioAlEmpleo, 0.0)
RETURN
END

