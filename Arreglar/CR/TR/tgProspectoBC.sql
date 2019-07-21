SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgProspectoBC ON Prospecto

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ProspectoN varchar(10),
@ProspectoA	varchar(10),
@Mensaje	varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ProspectoN = Prospecto FROM Inserted
SELECT @ProspectoA = Prospecto FROM Deleted
IF @ProspectoN = @ProspectoA RETURN
IF @ProspectoN IS NULL
BEGIN
DELETE ProspectoCto WHERE Prospecto = @ProspectoA
END ELSE
IF @ProspectoA IS NOT NULL
BEGIN
UPDATE ProspectoCto SET Prospecto = @ProspectoN WHERE Prospecto = @ProspectoA
END
END

