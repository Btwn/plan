SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSMuestraFormasPago

AS
BEGIN
DECLARE
@String			varchar(MAX),
@FormasPago		varchar(MAX),
@Codigo			varchar(50),
@FormaPago		varchar(50),
@LargoLinea		int
SELECT @LargoLinea = 100
DECLARE crFormaPago CURSOR LOCAL FOR
SELECT Codigo, FormaPago
FROM CB
WHERE TipoCuenta = 'Forma Pago'
OPEN crFormaPago
FETCH NEXT FROM crFormaPago INTO @Codigo, @FormaPago
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @String = LEFT(@Codigo + SPACE(40),40) + RIGHT(@FormaPago,30) + '<BR>'
SELECT @FormasPago = ISNULL(@FormasPago,'') + ISNULL(@String,'')
END
FETCH NEXT FROM crFormaPago INTO @Codigo, @FormaPago
END
CLOSE crFormaPago
DEALLOCATE crFormaPago
SELECT @FormasPago
END

