SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgServicioTipoBC ON ServicioTipo

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@ClaveNueva  	varchar(50),
@ClaveAnterior	varchar(50),
@Mensaje 		varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ClaveNueva    = Tipo FROM Inserted
SELECT @ClaveAnterior = Tipo FROM Deleted
IF @ClaveNueva=@ClaveAnterior RETURN
IF @ClaveNueva IS NULL
BEGIN
DELETE ServicioTipoPlantilla WHERE Tipo = @ClaveAnterior
END ELSE
IF @ClaveNueva <> @ClaveAnterior AND @ClaveAnterior IS NOT NULL
BEGIN
UPDATE ServicioTipoPlantilla SET Tipo = @ClaveNueva WHERE Tipo = @ClaveAnterior
END
END

