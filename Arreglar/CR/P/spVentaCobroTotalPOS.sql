SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVentaCobroTotalPOS
@Empresa            varchar(5),
@FormaCobro1		varchar(50),
@FormaCobro2 		varchar(50),
@FormaCobro3 		varchar(50),
@FormaCobro4 		varchar(50),
@FormaCobro5 		varchar(50),
@Importe1			money,
@Importe2			money,
@Importe3			money,
@Importe4			money,
@Importe5			money,
@Total				money	OUTPUT,
@VerResultado		bit	 = 0,
@Moneda				char(10) = NULL,
@TipoCambio1		float    = 1.0,
@TipoCambio2		float    = 1.0,
@TipoCambio3		float    = 1.0,
@TipoCambio4		float    = 1.0,
@TipoCambio5		float    = 1.0

AS
BEGIN
EXEC spFormaPagoTCPOS @FormaCobro1, @Empresa, @Importe1 OUTPUT, @Moneda, @TipoCambio1
EXEC spFormaPagoTCPOS @FormaCobro2, @Empresa, @Importe2 OUTPUT, @Moneda, @TipoCambio2
EXEC spFormaPagoTCPOS @FormaCobro3, @Empresa, @Importe3 OUTPUT, @Moneda, @TipoCambio3
EXEC spFormaPagoTCPOS @FormaCobro4, @Empresa, @Importe4 OUTPUT, @Moneda, @TipoCambio4
EXEC spFormaPagoTCPOS @FormaCobro5, @Empresa, @Importe5 OUTPUT, @Moneda, @TipoCambio5
SELECT @Total = ((@Importe1) + (@Importe2) + (@Importe3) + (@Importe4) + (@Importe5))
IF @VerResultado = 1
SELECT "Total" = @Total
RETURN
END

