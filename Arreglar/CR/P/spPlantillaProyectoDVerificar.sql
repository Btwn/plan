SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPlantillaProyectoDVerificar
@Plantilla	varchar(50)

AS BEGIN
DECLARE
@Mensaje	        varchar(255),
@Actividad          varchar(50),
@Predecesora        varchar(50),
@Rama               varchar(50),
@Ok                 int,
@OkRef              varchar(255),
@EsFase             bit,
@SubPlantilla       varchar(50),
@RecursoOmision	varchar(10),
@DuracionUnidad     varchar(10)
SELECT @Actividad = NULL
SELECT @Actividad = MIN(Actividad) FROM PlantillaProyectoD WHERE Plantilla = @Plantilla AND Actividad = Predecesora
DECLARE crActValidar CURSOR LOCAL STATIC FOR
SELECT Actividad, NULLIF(RTRIM(Predecesora), ''), dbo.fnActRama(Actividad), EsFase, NULLIF(RTRIM(SubPlantilla), ''), NULLIF(RTRIM(RecursoOmision), ''), DuracionUnidad
FROM PlantillaProyectoD
WHERE Plantilla = @Plantilla
OPEN crActValidar
FETCH NEXT FROM crActValidar INTO @Actividad, @Predecesora, @Rama, @EsFase, @SubPlantilla, @RecursoOmision, @DuracionUnidad
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
/*IF @RecursoOmision IS NOT NULL
IF NOT EXISTS(SELECT * FROM PlantillaProyectoDRecurso WHERE Plantilla = @Plantilla AND Actividad = @Actividad AND Recurso = @RecursoOmision)
INSERT PlantillaProyectoDRecurso (Plantilla, Actividad, Recurso) VALUES (@Plantilla, @Actividad, @RecursoOmision)*/
IF EXISTS (SELECT * FROM dbo.fnActRamaDesglosar(@Actividad) WHERE Rama = @Predecesora)
SELECT @Ok = 26150, @OkRef = @Actividad
IF NOT EXISTS (SELECT * FROM PlantillaProyectoD WHERE Plantilla = @Plantilla AND Actividad = @Predecesora) AND @Ok IS NULL AND @Predecesora IS NOT NULL
SELECT @Ok = 26150, @OkRef = @Actividad
IF NOT EXISTS (SELECT * FROM PlantillaProyectoD WHERE Plantilla = @Plantilla AND Actividad = @Rama) AND @Ok IS NULL AND @Rama IS NOT NULL
SELECT @Ok = 20996, @OkRef = @Actividad
IF @EsFase = 1 AND @SubPlantilla IS NULL AND NOT EXISTS (SELECT * FROM PlantillaProyectoD WHERE Plantilla = @Plantilla AND dbo.fnActRama(Actividad) = @Actividad) AND @Ok IS NULL
SELECT @Ok = 20997, @OkRef = @Actividad
IF @EsFase = 1 AND @SubPlantilla IS NOT NULL AND EXISTS (SELECT * FROM PlantillaProyectoD WHERE Plantilla = @Plantilla AND dbo.fnActRama(Actividad) = @Actividad) AND @Ok IS NULL
SELECT @Ok = 72090, @OkRef = @Actividad
IF ISNULL(@DuracionUnidad, '') <> '' AND EXISTS (SELECT * FROM PlantillaProyectoD WHERE Plantilla = @Plantilla AND Actividad <> @Actividad AND ISNULL(DuracionUnidad,'') <> @DuracionUnidad AND ISNULL(DuracionUnidad,'') <> '') AND @Ok IS NULL
SELECT @Ok = 20186 
END
FETCH NEXT FROM crActValidar INTO @Actividad, @Predecesora, @Rama, @EsFase, @SubPlantilla, @RecursoOmision, @DuracionUnidad
END
CLOSE crActValidar
DEALLOCATE crActValidar
IF @Ok IS NOT NULL
SELECT @Mensaje = Descripcion+' '+RTRIM(ISNULL(@OkRef, '')) FROM MensajeLista WHERE Mensaje = @Ok
ELSE
SELECT @Mensaje = NULL
SELECT @Mensaje
RETURN
END

