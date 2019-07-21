SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCopiaCtoABC_CRM ON Cte

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@PrimaryContactId	varchar(40),
@Cliente			varchar(10)
SELECT @Cliente = Cliente, @PrimaryContactId =  PrimaryContactId FROM Inserted
IF NOT EXISTS(SELECT Cliente FROM CteCto WHERE PrimaryContactId = @PrimaryContactId AND Cliente = @Cliente)
BEGIN
IF @PrimaryContactId <> '0' AND @Cliente IS NOT NULL
INSERT CteCto (Cliente, Nombre, Telefonos, eMail, Fax, PrimaryContactId)
SELECT        @Cliente, Nombre, Telefonos, eMail, Fax, @PrimaryContactId
FROM Prospecto
WHERE CRMID = @PrimaryContactId
END
RETURN
END

