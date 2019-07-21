SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSVerLimiteCreditoMN
@Cliente			char(10),
@Empresa			char(5),
@LimiteCredito		float		OUTPUT

AS
BEGIN
DECLARE
@Credito			varchar(50),
@CreditoEspecial	bit,
@MonedaCredito		char(10)
SELECT
@Credito 	    = Credito,
@CreditoEspecial = CreditoEspecial,
@LimiteCredito   = ISNULL(CreditoLimite, 0.0),
@MonedaCredito   = CreditoMoneda
FROM Cte
WHERE Cliente = @Cliente
IF @CreditoEspecial = 0
BEGIN
SELECT @LimiteCredito = NULL
SELECT
@LimiteCredito = ISNULL(LimiteCredito, 0.0),
@MonedaCredito = MonedaCredito
FROM CteCredito
WHERE Empresa = @Empresa AND Credito = @Credito
END
SELECT @LimiteCredito = @LimiteCredito*TipoCambio FROM Mon WHERE Moneda = @MonedaCredito
END

