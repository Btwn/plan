SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnFormaPagoAcceso(
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
DECLARE @Valor			bit
SELECT @Valor = 0
IF @NivelAcceso = 1 AND @NivelAccesoEsp = 1
BEGIN
IF NOT EXISTS(SELECT FormaPago FROM FormaPagoAcceso WHERE FormaPago = @FormaPago AND ISNULL(Nivel, '') <> '(Todos)')
SELECT  @Valor = 1
ELSE
IF EXISTS(SELECT FormaPago FROM FormaPagoAcceso WHERE FormaPago = @FormaPago AND Nivel IN(@Usuario, '(Todos)'))
SELECT @Valor = 1
END
ELSE IF @NivelAcceso = 1 AND @NivelAccesoEsp = 0
SELECT @Valor = 1
ELSE IF @NivelAcceso = 0
SELECT @Valor = 1
RETURN @Valor
END

