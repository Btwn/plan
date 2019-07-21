SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgProyectoDesarrolloClase2C ON ProyectoDesarrolloClase2

FOR UPDATE
AS BEGIN
DECLARE
@Clase2N            varchar(50),
@Clase2A            varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Clase2N = Clase2 FROM Inserted
SELECT @Clase2A = Clase2 FROM Deleted
IF @Clase2N <> @Clase2A
BEGIN
UPDATE ProyectoDesarrolloClase3 SET Clase2 = @Clase2N WHERE Clase2 = @Clase2A
UPDATE ProyectoDesarrolloClase4 SET Clase2 = @Clase2N WHERE Clase2 = @Clase2A
UPDATE ProyectoDesarrolloClase5 SET Clase2 = @Clase2N WHERE Clase2 = @Clase2A
END
RETURN
END

