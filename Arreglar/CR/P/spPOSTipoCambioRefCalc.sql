SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSTipoCambioRefCalc
@Sucursal			int,
@CodigoFormaPago	varchar(50),
@Empresa           varchar(5)

AS
BEGIN
DECLARE
@TipoCambio				float,
@Importe				float,
@Moneda					varchar(10),
@FormaPago				varchar(50),
@MonedaPrincipal		varchar(20),
@RedondeoMonetarios		int,
@POSMonedaAct			bit
SELECT @POSMonedaAct = POSMonedaAct
FROM POSCFG
WHERE Empresa = @Empresa
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT TOP 1 @MonedaPrincipal = Moneda
FROM POSLTipoCambioRef m
WHERE TipoCambio = 1 AND Sucursal = @Sucursal AND EsPrincipal = 1
SELECT @FormaPago = FormaPago
FROM CB
WHERE Codigo = @CodigoFormaPago
SELECT @Moneda = CASE WHEN @POSMonedaAct = 0 THEN NULLIF(fp.Moneda,'') ELSE NULLIF(fp.POSMoneda,'') END
FROM FormaPago fp
WHERE fp.FormaPago = @FormaPago
IF ISNULL(@Moneda, @MonedaPrincipal) <> @MonedaPrincipal
SELECT @TipoCambio = ptcr.TipoCambio
FROM POSLTipoCambioRef ptcr
WHERE ptcr.Sucursal = @Sucursal AND ptcr.Moneda = @Moneda
SELECT ROUND(ISNULL(@TipoCambio,1), @RedondeoMonetarios)
END

