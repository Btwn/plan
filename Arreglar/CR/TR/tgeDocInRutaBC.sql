SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgeDocInRutaBC ON eDocInRuta

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ClaveNueva  	varchar(50),
@ClaveAnterior	varchar(50),
@eDocInNueva  	varchar(50),
@eDocInAnterior	varchar(50),
@ModuloNuevo     	varchar(20),
@ModuloAnterior	varchar(20)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ClaveNueva    = Ruta, @eDocInNueva = eDocIn, @ModuloNuevo = Modulo FROM Inserted
SELECT @ClaveAnterior = Ruta , @eDocInAnterior = eDocIn, @ModuloAnterior = Modulo FROM Deleted
IF @ClaveNueva=@ClaveAnterior  RETURN
IF @ClaveNueva IS NULL
BEGIN
DELETE eDocInRutaD    WHERE Ruta = @ClaveAnterior AND eDocIn = @eDocInAnterior
DELETE eDocInRutaDCondicion    WHERE Ruta = @ClaveAnterior AND eDocIn = @eDocInAnterior
DELETE eDocInRutaExpresion 	WHERE Ruta = @ClaveAnterior AND eDocIn = @eDocInAnterior
DELETE eDocInRutaTabla	WHERE Ruta = @ClaveAnterior AND eDocIn = @eDocInAnterior
DELETE eDocInRutaTablaD	WHERE Ruta = @ClaveAnterior AND eDocIn = @eDocInAnterior
END
IF @ClaveNueva <> @ClaveAnterior
BEGIN
UPDATE eDocInRutaD     SET Ruta = @ClaveNueva WHERE Ruta = @ClaveAnterior AND eDocIn = @eDocInAnterior
UPDATE eDocInRutaDCondicion     SET Ruta = @ClaveNueva WHERE Ruta = @ClaveAnterior AND eDocIn = @eDocInAnterior
UPDATE eDocInRutaExpresion SET Ruta = @ClaveNueva WHERE Ruta = @ClaveAnterior AND  eDocIn = @eDocInAnterior
UPDATE eDocInRutaTabla	 SET Ruta = @ClaveNueva WHERE Ruta = @ClaveAnterior AND  eDocIn = @eDocInAnterior
UPDATE eDocInRutaTablaD SET Ruta = @ClaveNueva WHERE Ruta = @ClaveAnterior AND eDocIn = @eDocInAnterior
END
END

