SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSImporteRefCalc
@Sucursal		        int,
@ImporteRef			float,
@CodigoFormaPago		varchar(50),
@Empresa               varchar(5)

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
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT @POSMonedaAct = POSMonedaAct
FROM POSCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT TOP 1 @MonedaPrincipal = Moneda
FROM POSLTipoCambioRef WITH (NOLOCK)
WHERE TipoCambio = 1	  AND Sucursal = @Sucursal AND EsPrincipal = 1
SELECT @FormaPago = FormaPago
FROM CB WITH (NOLOCK)
WHERE Codigo = @CodigoFormaPago
AND TipoCuenta = 'Forma Pago'
SELECT @Moneda = CASE WHEN @POSMonedaAct = 0 THEN NULLIF(fp.Moneda,'') ELSE NULLIF(fp.POSMoneda,'') END
FROM FormaPago fp WITH (NOLOCK)
WHERE fp.FormaPago = @FormaPago
IF ISNULL(@Moneda, @MonedaPrincipal) <> @MonedaPrincipal
SELECT @TipoCambio = ptcr.TipoCambio
FROM POSLTipoCambioRef ptcr WITH (NOLOCK)
WHERE ptcr.Sucursal = @Sucursal
AND ptcr.Moneda = @Moneda
SELECT @Importe = @ImporteRef * ISNULL(@TipoCambio,1)
SELECT ROUND(@Importe, @RedondeoMonetarios)
END

