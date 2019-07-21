SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spFormaPagoTCPOS
@FormaPago		varchar(50),
@Empresa		varchar(5),
@Importe		money 	OUTPUT,
@Moneda			char(10) 	= NULL,
@TipoCambio		float 		= 1.0

AS
BEGIN
DECLARE
@FormaPagoMoneda		char(10),
@RedondeoMonetarios		int,
@POSMonedaAct			bit
SELECT @POSMonedaAct = POSMonedaAct
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @FormaPagoMoneda = CASE WHEN @POSMonedaAct = 0
THEN Moneda
ELSE POSMoneda
END
FROM FormaPago
WHERE FormaPago = @FormaPago
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT @TipoCambio = ROUND(@TipoCambio,@RedondeoMonetarios)
SELECT @Importe = ROUND(ISNULL(@Importe, 0.0),@RedondeoMonetarios), @FormaPago = NULLIF(RTRIM(@FormaPago), '')
IF @Importe = 0.0 OR @FormaPago IS NULL
RETURN
SELECT @Importe = @Importe * @TipoCambio
SELECT @Importe = ROUND(@Importe,@RedondeoMonetarios)
RETURN
END

