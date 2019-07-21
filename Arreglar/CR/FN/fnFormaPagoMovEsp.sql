SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnFormaPagoMovEsp(
@Empresa		varchar(5),
@FormaPago		varchar(50),
@Modulo			varchar(5),
@Mov			varchar(20),
@Usuario		varchar(10),
@Campo			varchar(20),
@CobroIntegrado	bit,
@NivelAcceso	bit,
@NivelAccesoEsp	bit)
RETURNS bit
AS
BEGIN
DECLARE @Valor				bit,
@CfgCobroIntegrado	bit
SELECT @CfgCobroIntegrado = CobroIntegrado FROM FormaPago WHERE FormaPago = @FormaPago
SELECT @Valor = 0
IF NOT EXISTS(SELECT FormaPago FROM FormaPagoMovEsp WHERE FormaPago = @FormaPago AND Modulo = @Modulo)
SELECT @Valor = 1
ELSE IF EXISTS(SELECT FormaPago FROM FormaPagoMovEsp WHERE FormaPago = @FormaPago AND Modulo = @Modulo)
BEGIN
IF @Campo <> '(Forma Pago)'
BEGIN
IF EXISTS(SELECT FormaPago FROM FormaPagoMovEsp WHERE FormaPago = @FormaPago AND Modulo = @Modulo AND Mov IN(@Mov, '(Todos)') AND ConDesglose IN(@Campo, '(Todos)'))
SELECT @Valor = 1
ELSE IF @Campo = '(Forma Pago 1)' AND ISNULL(@CobroIntegrado, 0) = 1
IF EXISTS(SELECT FormaPago FROM FormaPagoMovEsp WHERE FormaPago = @FormaPago AND Modulo = @Modulo AND Mov IN(@Mov, '(Todos)') AND ConDesglose IN(@Campo, '(Todos)', 'Si'))
SELECT @Valor = 1
END
ELSE IF @Campo = '(Forma Pago)'
IF EXISTS(SELECT FormaPago FROM FormaPagoMovEsp WHERE FormaPago = @FormaPago AND Modulo = @Modulo AND Mov IN(@Mov, '(Todos)'))
SELECT @Valor = 1
IF ISNULL(@CobroIntegrado, 0) = 1 AND ISNULL(@CfgCobroIntegrado, 0) = 0
SELECT @Valor = 0
END
RETURN @Valor
END

