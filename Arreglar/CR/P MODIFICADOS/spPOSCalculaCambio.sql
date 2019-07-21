SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSCalculaCambio
@Saldo				float,
@Empresa			varchar(5),
@Importe			float,
@FormaPagoCodigo	varchar(50),
@Sucursal			int	= NULL

AS
BEGIN
DECLARE
@Cambio					float,
@FormaPago				varchar(50),
@FormaPagoMoneda		varchar(20),
@TipoCambio				float,
@MonedaPrincipal		varchar(20),
@RedondeoMonetarios		int,
@POSMonedaAct			bit
SELECT @POSMonedaAct = POSMonedaAct
FROM POSCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT @Saldo = ROUND(@Saldo,@RedondeoMonetarios)
SELECT @Importe = ROUND(@Importe,@RedondeoMonetarios)
SELECT TOP 1 @MonedaPrincipal = Moneda
FROM POSLTipoCambioRef m WITH (NOLOCK)
WHERE TipoCambio = 1
AND Sucursal = @Sucursal AND EsPrincipal = 1
IF @FormaPagoCodigo IS NOT NULL
BEGIN
SELECT @FormaPago = FormaPago
FROM CB WITH (NOLOCK)
WHERE Codigo = @FormaPagoCodigo
AND TipoCuenta = 'Forma Pago'
SELECT @FormaPagoMoneda = CASE WHEN @POSMonedaAct = 0 THEN ISNULL(NULLIF(Moneda,''), @MonedaPrincipal) ELSE ISNULL(NULLIF(POSMoneda,''), @MonedaPrincipal) END
FROM FormaPago fp WITH (NOLOCK)
WHERE fp.FormaPago = @FormaPago
IF ISNULL(@FormaPagoMoneda, @MonedaPrincipal) <> @MonedaPrincipal
SELECT @TipoCambio = TipoCambio
FROM POSLTipoCambioRef WITH (NOLOCK)
WHERE Sucursal = @Sucursal AND Moneda = @FormaPagoMoneda
ELSE
SELECT @TipoCambio = 1
END
SELECT @TipoCambio =  ROUND(@TipoCambio,@RedondeoMonetarios)
EXEC spPOSCalculaCambioCalc @Saldo,@Empresa, @Importe, 0, @Cambio OUTPUT
SELECT dbo.fnFormatoMoneda(( @Cambio / ISNULL(@TipoCambio,1.0)),@Empresa) + ' ' +ISNULL(@FormaPagoMoneda, @MonedaPrincipal)
END

