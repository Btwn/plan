SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgSubClaseBC ON SubClase

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ModuloA    char(5),
@ClaseA	varchar(50),
@SubClaseN 	varchar(50),
@SubClaseA	varchar(50),
@Mensaje	varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @SubClaseN = SubClase FROM Inserted
SELECT @SubClaseA = SubClase, @ClaseA = Clase, @ModuloA = Modulo FROM Deleted
IF @SubClaseN = @SubClaseA RETURN
IF @SubClaseN IS NULL
BEGIN
DELETE ClaseTarea     WHERE Modulo = @ModuloA AND Clase = @ClaseA AND SubClase = @SubClaseA
DELETE ClaseProrrateo WHERE Modulo = @ModuloA AND Clase = @ClaseA AND SubClase = @SubClaseA
END ELSE
BEGIN
UPDATE ClaseTarea     SET SubClase = @SubClaseN WHERE Modulo = @ModuloA AND Clase = @ClaseA AND SubClase = @SubClaseA
UPDATE ClaseProrrateo SET SubClase = @SubClaseN WHERE Modulo = @ModuloA AND Clase = @ClaseA AND SubClase = @SubClaseA
END
END

