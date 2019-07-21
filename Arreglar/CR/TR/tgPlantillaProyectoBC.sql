SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgPlantillaProyectoBC ON PlantillaProyecto

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@PlantillaN varchar(50),
@PlantillaA varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @PlantillaN = Plantilla FROM Inserted
SELECT @PlantillaA = Plantilla FROM Deleted
IF @PlantillaN = @PlantillaA  RETURN
IF @PlantillaN IS NULL
BEGIN
DELETE PlantillaProyectoD WHERE Plantilla = @PlantillaA
DELETE PlantillaProyectoDRecurso WHERE Plantilla = @PlantillaA
END ELSE BEGIN
UPDATE PlantillaProyectoD SET Plantilla = @PlantillaN WHERE Plantilla = @PlantillaA
UPDATE PlantillaProyectoDRecurso SET Plantilla = @PlantillaN WHERE Plantilla = @PlantillaA
END
END

