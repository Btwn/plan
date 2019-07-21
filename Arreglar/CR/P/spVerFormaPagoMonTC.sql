SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerFormaPagoMonTC
@Empresa			varchar(5),
@FormaPago		varchar(50),
@Referencia		varchar(50),
@Moneda			char(10),
@TipoCambio		float,
@Importe			money

AS BEGIN
DECLARE
@SumaEfectivo				money,
@FormaMoneda				char(10),
@FormaTipoCambio			float,
@Ok						int,
@FormaCobroVales			varchar(50)
SELECT @SumaEfectivo = null, @FormaMoneda = NULL, @FormaTipoCambio = NULL, @Ok = NULL, @FormaCobroVales = NULL
SELECT @FormaPago = ISNULL(NULLIF(@FormaPago,''),FormaPagoCambio) FROM EmpresaCfg WHERE Empresa = @Empresa
EXEC spFormaPagoMonTC @FormaPago, @Referencia, @Moneda, @TipoCambio, @Importe, @SumaEfectivo OUTPUT, @FormaMoneda OUTPUT, @FormaTipoCambio OUTPUT, @Ok OUTPUT, @FormaCobroVales
SELECT @FormaTipoCambio
RETURN
END

