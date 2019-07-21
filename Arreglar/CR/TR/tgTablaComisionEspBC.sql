SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgTablaComisionEspBC ON TablaComisionEsp

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ClaveNueva  	varchar(50),
@ClaveAnterior	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ClaveNueva    = TablaComisionEsp FROM Inserted
SELECT @ClaveAnterior = TablaComisionEsp FROM Deleted
IF @ClaveNueva IS NULL
DELETE TablaComisionEspD WHERE TablaComisionEsp = @ClaveAnterior
ELSE
UPDATE TablaComisionEspD SET TablaComisionEsp = @ClaveNueva WHERE TablaComisionEsp = @ClaveAnterior
END

