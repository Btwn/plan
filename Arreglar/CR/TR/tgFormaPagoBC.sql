SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgFormaPagoBC ON FormaPago

FOR UPDATE
AS BEGIN
DECLARE
@FormaPagoN 	varchar(50),
@FormaPagoA		varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @FormaPagoN = FormaPago FROM Inserted
SELECT @FormaPagoA = FormaPago FROM Deleted
IF @FormaPagoN = @FormaPagoA RETURN
IF @FormaPagoN IS NULL
BEGIN
DELETE FormaPagoDesc  WHERE FormaPago = @FormaPagoA
DELETE FormaPagoD     WHERE FormaPago = @FormaPagoA
DELETE FormaPagoTipoD WHERE FormaPago = @FormaPagoA
END ELSE
BEGIN
UPDATE FormaPagoDesc  SET FormaPago = @FormaPagoN WHERE FormaPago = @FormaPagoA
UPDATE FormaPagoD     SET FormaPago = @FormaPagoN WHERE FormaPago = @FormaPagoA
UPDATE FormaPagoTipoD SET FormaPago = @FormaPagoN WHERE FormaPago = @FormaPagoA
END
END

