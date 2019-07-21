SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProyectoNuevo
@Estacion 	int,
@ID		int,
@Plantilla	varchar(50),
@Sucursal	int,
@EsSubPlantilla	bit	     = 0,
@Actividad	varchar(50)  = NULL,
@Orden		varchar(255) = NULL,
@Predecesora    varchar(50)  = NULL,
@Reemplazar	varchar(20)  = 'SI'

AS BEGIN
DECLARE
@SubPlantilla	varchar(50)
IF @EsSubPlantilla = 0 AND UPPER(@Reemplazar) = 'SI'
BEGIN
DELETE ProyectoRecurso WHERE ID = @ID
DELETE ProyectoD WHERE ID = @ID
DELETE ProyectoDRecurso WHERE ID = @ID
END
INSERT ProyectoD (
ID,
Sucursal,
Actividad,
Orden,
Predecesora,
EsFase, Clave, Asunto, Tipo, Categoria, Grupo, Familia, Duracion, DuracionUnidad, Estado, Prioridad)
SELECT @ID, @Sucursal,
CASE WHEN @EsSubPlantilla = 1 THEN @Actividad + '.' + Actividad ELSE Actividad END,
CASE WHEN @EsSubPlantilla = 1 THEN @Orden + '.' + Orden ELSE Orden END,
CASE WHEN @EsSubPlantilla = 1 AND NULLIF(RTRIM(Predecesora), '') IS NULL     THEN @Predecesora
WHEN @EsSubPlantilla = 1 AND NULLIF(RTRIM(Predecesora), '') IS NOT NULL THEN @Actividad + '.' + Predecesora
ELSE Predecesora
END,
EsFase, Clave, Asunto, Tipo, Categoria, Grupo, Familia, Duracion, DuracionUnidad, 'No comenzada', 'Normal'
FROM PlantillaProyectoD
WHERE Plantilla = @Plantilla
INSERT ProyectoDRecurso (ID, Sucursal, Actividad, Recurso)
SELECT @ID, @Sucursal, CASE WHEN @EsSubPlantilla = 1 THEN @Actividad + '.' + Actividad ELSE Actividad END, Recurso
FROM PlantillaProyectoDRecurso
WHERE Plantilla = @Plantilla
INSERT ProyectoDRecurso (ID, Sucursal, Actividad, Recurso)
SELECT @ID, @Sucursal, CASE WHEN @EsSubPlantilla = 1 THEN @Actividad + '.' + Actividad ELSE Actividad END, RecursoOmision
FROM PlantillaProyectoD
WHERE Plantilla = @Plantilla AND NULLIF(RTRIM(RecursoOmision), '') IS NOT NULL AND EsFase = 0
AND RecursoOmision NOT IN (SELECT Recurso FROM ProyectoDRecurso WHERE ID = @ID)
INSERT ProyectoRecurso (
ID,  Sucursal,  Recurso,   Estatus, Rol,   HorasDia,   PrecioHora,   CostoHora)
SELECT @ID, @Sucursal, r.Recurso, 'ALTA',  r.Rol, r.HorasDia, r.PrecioHora, r.CostoHora
FROM PlantillaProyectoD p
JOIN Recurso r ON r.Recurso = p.RecursoOmision
WHERE p.Plantilla = @Plantilla
GROUP BY r.Recurso, r.Rol, r.HorasDia, r.PrecioHora, r.CostoHora
INSERT ProyectoRecurso (
ID,  Sucursal,  Recurso,   Estatus, Rol,   HorasDia,   PrecioHora,   CostoHora)
SELECT @ID, @Sucursal, r.Recurso, 'ALTA',  r.Rol, r.HorasDia, r.PrecioHora, r.CostoHora
FROM PlantillaProyectoDRecurso p
JOIN Recurso r ON r.Recurso = p.Recurso
WHERE p.Plantilla = @Plantilla AND p.Recurso NOT IN (SELECT Recurso FROM ProyectoRecurso WHERE ID = @ID)
GROUP BY r.Recurso, r.Rol, r.HorasDia, r.PrecioHora, r.CostoHora
DECLARE crPlantilla CURSOR LOCAL FOR
SELECT Actividad, Orden, NULLIF(RTRIM(SubPlantilla), ''), NULLIF(RTRIM(Predecesora), '')
FROM PlantillaProyectoD
WHERE Plantilla = @Plantilla AND NULLIF(RTRIM(SubPlantilla), '') IS NOT NULL AND EsFase = 1
OPEN crPlantilla
FETCH NEXT FROM crPlantilla INTO @Actividad, @Orden, @SubPlantilla, @Predecesora
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
EXEC spProyectoNuevo @Estacion, @ID, @SubPlantilla, @Sucursal, @EsSubPlantilla = 1, @Actividad = @Actividad, @Orden = @Orden, @Predecesora = @Predecesora
FETCH NEXT FROM crPlantilla INTO @Actividad, @Orden, @SubPlantilla, @Predecesora
END
CLOSE crPlantilla
DEALLOCATE crPlantilla
RETURN
END

