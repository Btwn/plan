SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgClaseBC ON Clase

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ModuloA    char(5),
@ClaseN 	varchar(50),
@ClaseA	varchar(50),
@Mensaje	varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ClaseN = Clase FROM Inserted
SELECT @ClaseA = Clase, @ModuloA = Modulo FROM Deleted
IF @ClaseN = @ClaseA RETURN
IF @ClaseN IS NULL
BEGIN
DELETE SubClase       WHERE Clase = @ClaseA AND Modulo = @ModuloA
DELETE ClaseTarea     WHERE Clase = @ClaseA AND Modulo = @ModuloA
DELETE ClaseProrrateo WHERE Clase = @ClaseA AND Modulo = @ModuloA
END ELSE
BEGIN
UPDATE SubClase       SET Clase = @ClaseN WHERE Clase = @ClaseA AND Modulo = @ModuloA
UPDATE ClaseTarea     SET Clase = @ClaseN WHERE Clase = @ClaseA AND Modulo = @ModuloA
UPDATE ClaseProrrateo SET Clase = @ClaseN WHERE Clase = @ClaseA AND Modulo = @ModuloA
END
END

