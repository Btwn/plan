SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgeDocInBC ON eDocIn

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ClaveNueva  	varchar(50),
@ClaveAnterior	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ClaveNueva    = eDocIn  FROM Inserted
SELECT @ClaveAnterior = eDocIn  FROM Deleted
IF @ClaveNueva=@ClaveAnterior  RETURN
IF @ClaveNueva IS NULL
BEGIN
DELETE eDocInRuta    WHERE eDocIn = @ClaveAnterior
DELETE eDocInRutaD    WHERE eDocIn = @ClaveAnterior
DELETE eDocInRutaDCondicion    WHERE eDocIn = @ClaveAnterior
DELETE eDocInRutaExpresion 	WHERE eDocIn = @ClaveAnterior
DELETE eDocInRutaTabla	WHERE eDocIn = @ClaveAnterior
DELETE eDocInRutaTablaD	WHERE eDocIn = @ClaveAnterior
END
IF @ClaveNueva <> @ClaveAnterior
BEGIN
UPDATE eDocInRuta     SET eDocIn = @ClaveNueva WHERE eDocIn = @ClaveAnterior
UPDATE eDocInRutaD     SET eDocIn = @ClaveNueva WHERE eDocIn = @ClaveAnterior
UPDATE eDocInRutaDCondicion     SET eDocIn = @ClaveNueva WHERE eDocIn = @ClaveAnterior
UPDATE eDocInRutaExpresion SET eDocIn = @ClaveNueva WHERE eDocIn = @ClaveAnterior
UPDATE eDocInRutaTabla	 SET eDocIn = @ClaveNueva WHERE eDocIn = @ClaveAnterior
UPDATE eDocInRutaTablaD SET eDocIn = @ClaveNueva WHERE eDocIn = @ClaveAnterior
END
END

