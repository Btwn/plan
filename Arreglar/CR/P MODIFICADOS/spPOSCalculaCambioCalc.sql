SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSCalculaCambioCalc
@Saldo		float,
@Empresa	varchar(5),
@Importe	float,
@Mostrar	bit = 0,
@Cambio		float = NULL OUTPUT

AS
BEGIN
DECLARE
@RedondeoMonetarios int
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT @Cambio = ROUND(ISNULL(@Importe,0.0), @RedondeoMonetarios) - ROUND(ISNULL(@Saldo,0), @RedondeoMonetarios)
SELECT @Cambio =  ROUND(@Cambio,@RedondeoMonetarios)
IF @Cambio < 0.01
SELECT @Cambio = 0
IF @Mostrar = 1
SELECT @Cambio
END

