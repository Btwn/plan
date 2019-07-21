SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCentroBC ON Centro

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ClaveNueva  	varchar(20),
@ClaveAnterior	varchar(20)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ClaveNueva    = Centro FROM Inserted
SELECT @ClaveAnterior = Centro FROM Deleted
IF @ClaveNueva = @ClaveAnterior RETURN
IF @ClaveNueva IS NULL
BEGIN
UPDATE EstacionT        SET Centro = NULL WHERE Centro = @ClaveAnterior
DELETE CentroTarifa     WHERE Centro = @ClaveAnterior
DELETE CentroMovimiento WHERE Centro = @ClaveAnterior OR CentroDestino = @ClaveAnterior
END ELSE
BEGIN
UPDATE EstacionT SET Centro = @ClaveNueva WHERE Centro = @ClaveAnterior
UPDATE CentroTarifa     SET Centro = @ClaveNueva WHERE Centro = @ClaveAnterior
UPDATE CentroMovimiento SET Centro = @ClaveNueva WHERE Centro = @ClaveAnterior
UPDATE CentroMovimiento SET CentroDestino = @ClaveNueva WHERE CentroDestino = @ClaveAnterior
END
END

