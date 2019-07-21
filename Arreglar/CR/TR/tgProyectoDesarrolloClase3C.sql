SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgProyectoDesarrolloClase3C ON ProyectoDesarrolloClase3

FOR UPDATE
AS BEGIN
DECLARE
@Clase3N            varchar(50),
@Clase3A            varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Clase3N = Clase3 FROM Inserted
SELECT @Clase3A = Clase3 FROM Deleted
IF @Clase3N <> @Clase3A
BEGIN
UPDATE ProyectoDesarrolloClase4 SET Clase3 = @Clase3N WHERE Clase3 = @Clase3A
UPDATE ProyectoDesarrolloClase5 SET Clase3 = @Clase3N WHERE Clase3 = @Clase3A
END
RETURN
END

