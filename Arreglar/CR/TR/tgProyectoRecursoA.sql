SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgProyectoRecursoA ON ProyectoRecurso

FOR UPDATE
AS BEGIN
DECLARE
@Estatus            varchar(15),
@ID                 int,
@Recurso            varchar(10),
@Mensaje            varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Mensaje = NULL
SELECT @ID = ID, @Estatus = Estatus, @Recurso = Recurso FROM Inserted
IF @Estatus = 'BAJA' AND @ID IS NOT NULL
IF EXISTS (SELECT * FROM ProyectoD d JOIN ProyectoDRecurso r ON d.ID = r.ID AND d.Actividad = r.Actividad WHERE d.ID = @ID AND r.Recurso = @Recurso AND UPPER(d.Estado) NOT IN ('ELIMINADA', 'COMPLETADA', 'CANCELADA'))
SELECT @Mensaje = 'El Recurso ' + RTRIM(@Recurso) + ' Tiene Actividades Pendientes Asignadas'
IF @Mensaje IS NOT NULL
RAISERROR(@Mensaje, 16, 1)
RETURN
END

