SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgProyectoDesarrolloClase1C ON ProyectoDesarrolloClase1

FOR UPDATE
AS BEGIN
DECLARE
@Clase1N            varchar(50),
@Clase1A            varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Clase1N = Clase1 FROM Inserted
SELECT @Clase1A = Clase1 FROM Deleted
IF @Clase1N <> @Clase1A
BEGIN
UPDATE ProyectoDesarrolloClase2 SET Clase1 = @Clase1N WHERE Clase1 = @Clase1A
UPDATE ProyectoDesarrolloClase3 SET Clase1 = @Clase1N WHERE Clase1 = @Clase1A
UPDATE ProyectoDesarrolloClase4 SET Clase1 = @Clase1N WHERE Clase1 = @Clase1A
UPDATE ProyectoDesarrolloClase5 SET Clase1 = @Clase1N WHERE Clase1 = @Clase1A
END
RETURN
END

