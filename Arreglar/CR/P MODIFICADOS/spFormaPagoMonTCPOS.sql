SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spFormaPagoMonTCPOS
@FormaPago			varchar(50),
@Referencia			varchar(50),
@Moneda				char(10),
@TipoCambio			float,
@Importe			money,
@SumaEfectivo		money		OUTPUT,
@FormaMoneda 		char(10)	OUTPUT,
@FormaTipoCambio	float		OUTPUT,
@Ok					int			OUTPUT,
@FormaCobroVales	varchar(50)	= NULL,
@Empresa			varchar(5) = NULL

AS
BEGIN
DECLARE
@MonedaEsp				char(10),
@RequiereReferencia		bit,
@PermiteCambio			bit,
@POSMonedaAct			bit,
@ContMoneda				varchar(10)
SELECT @POSMonedaAct = POSMonedaAct
FROM POSCfg  WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @ContMoneda = RTRIM(ContMoneda)
FROM EmpresaCfg  WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @FormaMoneda = @Moneda, @FormaTipoCambio = @TipoCambio
IF @POSMonedaAct = 1 AND @FormaMoneda <> @ContMoneda
SELECT @FormaMoneda = @ContMoneda
IF NULLIF(RTRIM(@FormaPago), '') IS NULL
RETURN
SELECT @MonedaEsp = NULL
SELECT	@MonedaEsp = CASE WHEN @POSMonedaAct = 0
THEN NULLIF(RTRIM(Moneda), '')
ELSE NULLIF(RTRIM(POSMoneda), '')
END,
@RequiereReferencia = ISNULL(RequiereReferencia, 0),
@PermiteCambio      = ISNULL(PermiteCambio, 0)
FROM FormaPago  WITH (NOLOCK)
WHERE FormaPago = @FormaPago
IF @RequiereReferencia = 1 AND NULLIF(RTRIM(@Referencia), '') IS NULL
SELECT @Ok = 20910
IF @MonedaEsp IS NOT NULL
BEGIN
SELECT @Importe = @Importe * @FormaTipoCambio
END
IF @PermiteCambio = 1
SELECT @SumaEfectivo = ISNULL(@SumaEfectivo, 0) + ISNULL(@Importe, 0)
IF @FormaCobroVales IS NOT NULL AND @FormaPago = @FormaCobroVales AND @Importe < 0.0
SELECT @Ok = 36100
EXEC xpValidarFormaPago @FormaPago, @Referencia, @Importe, @Ok OUTPUT
RETURN
END

