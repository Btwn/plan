SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSLDIMuestraFormaPago
@FormaPago		varchar(50),
@Importe		money

AS
BEGIN
DECLARE
@AplicaMeses	varchar(50),
@Aplicar		varchar(50),
@ApartirDe		money
SELECT TOP 1 @AplicaMeses = POSLDIFormaPago.AplicaMeses, @ApartirDe = POSLDIFormaPago.ApartirDe
FROM POSLDIFormaPago WITH (NOLOCK)
JOIN POSLDIFormaPagoDMeses WITH (NOLOCK) ON POSLDIFormaPago.FormaPago=POSLDIFormaPagoDMeses.FormaPago
WHERE POSLDIFormaPago.FormaPago = @FormaPago
IF @AplicaMeses = 'Si' AND @Importe >= @ApartirDe
BEGIN
SELECT @Aplicar = 'Si'
END
ELSE
SELECT @Aplicar = 'NO'
SELECT @Aplicar
END

