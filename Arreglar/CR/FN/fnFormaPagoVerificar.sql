SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnFormaPagoVerificar(
@Empresa		varchar(5),
@FormaPago		varchar(50),
@Modulo			varchar(5),
@Mov			varchar(20),
@Usuario		varchar(10),
@Campo			varchar(20),
@CobroIntegrado	bit)
RETURNS bit
AS
BEGIN
DECLARE @Valor	bit
IF NOT EXISTS(SELECT FormaPago FROM dbo.fnFormaPagoAyudaCaptura(@Empresa, @Modulo, @Mov, @Usuario, @Campo, @CobroIntegrado, '') WHERE FormaPago = @FormaPago)
SELECT @Valor = 0
ELSE
SELECT @Valor = 1
RETURN @Valor
END

