SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgEspacioBC ON Espacio

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@EspacioN 	char(10),
@EspacioA	char(10)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @EspacioN = Espacio FROM Inserted
SELECT @EspacioA = Espacio FROM Deleted
IF @EspacioN = @EspacioA RETURN
IF @EspacioN IS NULL
BEGIN
DELETE EspacioFecha     WHERE Espacio = @EspacioA
DELETE ArtEspacio       WHERE Espacio = @EspacioA
DELETE EspacioResultado WHERE Espacio = @EspacioA
DELETE EspacioMant      WHERE Espacio = @EspacioA
END ELSE
BEGIN
UPDATE EspacioFecha     SET Espacio = @EspacioN WHERE Espacio = @EspacioA
UPDATE ArtEspacio       SET Espacio = @EspacioN WHERE Espacio = @EspacioA
UPDATE EspacioResultado SET Espacio = @EspacioN WHERE Espacio = @EspacioA
UPDATE EspacioMant      SET Espacio = @EspacioN WHERE Espacio = @EspacioA
END
END

