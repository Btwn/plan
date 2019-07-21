SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgTablaRangoBC ON TablaRango

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ClaveNueva  	varchar(50),
@ClaveAnterior	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ClaveNueva    = TablaRango FROM Inserted
SELECT @ClaveAnterior = TablaRango FROM Deleted
IF @ClaveNueva IS NULL
DELETE TablaRangoD WHERE TablaRango = @ClaveAnterior
ELSE
UPDATE TablaRangoD SET TablaRango = @ClaveNueva WHERE TablaRango = @ClaveAnterior
END

