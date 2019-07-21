SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgTablaRangoStBC ON TablaRangoSt

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ClaveNueva  	varchar(50),
@ClaveAnterior	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ClaveNueva    = TablaRangoSt FROM Inserted
SELECT @ClaveAnterior = TablaRangoSt FROM Deleted
IF @ClaveNueva IS NULL
DELETE TablaRangoStD WHERE TablaRangoSt = @ClaveAnterior
ELSE
UPDATE TablaRangoStD SET TablaRangoSt = @ClaveNueva WHERE TablaRangoSt = @ClaveAnterior
END

