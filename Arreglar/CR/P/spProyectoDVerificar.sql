SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProyectoDVerificar
@ID		int,
@EnSilencio	bit		= 0,
@Ok		int		= NULL OUTPUT,
@OkRef		varchar(255)	= NULL OUTPUT

AS BEGIN
DECLARE
@Mensaje	        varchar(255),
@Actividad          varchar(50),
@Predecesora        varchar(50),
@Rama               varchar(50),
@EsFase             bit,
@DuracionUnidad     varchar(10)
SELECT @Actividad = NULL
SELECT @Actividad = MIN(Actividad) FROM ProyectoD WHERE ID = @ID AND Actividad = Predecesora
IF @Actividad IS NOT NULL
SELECT @Ok = 26150, @OkRef = @Actividad
IF @Ok IS NULL
BEGIN
SELECT @Actividad = NULL
SELECT @Actividad = MIN(Actividad)
FROM ProyectoDRecurso
WHERE ID = @ID
AND Actividad NOT IN (SELECT Actividad FROM ProyectoD WHERE ID = @ID)
IF @Actividad IS NOT NULL
SELECT @Ok = 14071, @OkRef = @Actividad
END
DECLARE crActValidar CURSOR LOCAL STATIC FOR
SELECT Actividad, NULLIF(RTRIM(Predecesora), ''), dbo.fnActRama(Actividad), EsFase, DuracionUnidad
FROM ProyectoD
WHERE ID = @ID
OPEN crActValidar
FETCH NEXT FROM crActValidar INTO @Actividad, @Predecesora, @Rama, @EsFase, @DuracionUnidad
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF EXISTS (SELECT * FROM dbo.fnActRamaDesglosar(@Actividad) WHERE Rama = @Predecesora)
SELECT @Ok = 26150, @OkRef = @Actividad
IF NOT EXISTS (SELECT * FROM ProyectoD WHERE ID = @ID AND Actividad = @Predecesora) AND @Ok IS NULL AND @Predecesora IS NOT NULL
SELECT @Ok = 26150, @OkRef = @Actividad
IF NOT EXISTS (SELECT * FROM ProyectoD WHERE ID = @ID AND Actividad = @Rama) AND @Ok IS NULL AND @Rama IS NOT NULL
SELECT @Ok = 20996, @OkRef = @Actividad
IF @EsFase = 1 AND NOT EXISTS(SELECT * FROM ProyectoD WHERE ID = @ID AND dbo.fnActRama(Actividad) = @Actividad)
SELECT @Ok = 20997, @OkRef = @Actividad
IF ISNULL(@DuracionUnidad, '') <> '' AND EXISTS (SELECT * FROM ProyectoD WHERE ID = @ID AND Actividad <> @Actividad AND ISNULL(DuracionUnidad,'') <> @DuracionUnidad AND ISNULL(DuracionUnidad,'') <> '') AND @Ok IS NULL
SELECT @Ok = 20187 
END
FETCH NEXT FROM crActValidar INTO @Actividad, @Predecesora, @Rama, @EsFase, @DuracionUnidad
END
CLOSE crActValidar
DEALLOCATE crActValidar
IF @EnSilencio = 0
BEGIN
IF @Ok IS NOT NULL
SELECT @Mensaje = Descripcion+' '+RTRIM(ISNULL(@OkRef, '')) FROM MensajeLista WHERE Mensaje = @Ok
ELSE
SELECT @Mensaje = NULL
SELECT @Mensaje
END
RETURN
END

