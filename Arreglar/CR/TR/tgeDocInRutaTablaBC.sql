SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgeDocInRutaTablaBC ON eDocInRutaTabla

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ClaveNueva  	varchar(50),
@ClaveAnterior	varchar(50),
@RutaNueva  	varchar(50),
@RutaAnterior	varchar(50),
@eDocInNueva  	varchar(50),
@eDocInAnterior	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ClaveNueva    = Tablas, @eDocInNueva = eDocIn, @RutaNueva = Ruta  FROM Inserted
SELECT @ClaveAnterior = Tablas , @eDocInAnterior = eDocIn, @RutaAnterior = Ruta FROM Deleted
IF @ClaveNueva=@ClaveAnterior  RETURN
IF @ClaveNueva IS NULL
BEGIN
DELETE eDocInRutaTablaD	WHERE Tablas = @ClaveAnterior AND eDocIn = @eDocInAnterior AND Ruta = @RutaAnterior
END
IF @ClaveNueva <> @ClaveAnterior
BEGIN
UPDATE eDocInRutaTablaD SET Tablas = @ClaveNueva WHERE Tablas = @ClaveAnterior AND eDocIn = @eDocInAnterior AND Ruta = @RutaAnterior
END
END

