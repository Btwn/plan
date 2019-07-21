SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProyectoDAsignar
@ID     	int,
@Estacion	int,
@Recurso	varchar(10),
@Accion		varchar(20) = NULL,
@RecursoA	varchar(10) = NULL,
@DesAsignar	bit	    = 0

AS BEGIN
DECLARE
@Actividad		varchar(50),
@EsFase             int,
@Comienzo           datetime,
@Fin                datetime,
@Sucursal		int
SELECT @Accion = UPPER(@Accion), @Recurso = NULLIF(RTRIM(@Recurso), '')
SELECT @Sucursal = Sucursal FROM Proyecto WHERE ID = @ID
IF @DesAsignar = 1
DELETE ProyectoDRecurso
WHERE ID = @ID AND Actividad IN (SELECT Clave FROM ListaSt WHERE Estacion = @Estacion)
IF ISNULL(@Accion,'') IN ('', 'ASIGNAR')
BEGIN
IF NOT EXISTS(SELECT * FROM ProyectoRecurso WHERE ID = @ID AND Recurso = @Recurso)
INSERT ProyectoRecurso (
ID,  Sucursal,  Recurso,  Estatus, Rol, HorasDia, PrecioHora, CostoHora)
SELECT @ID, @Sucursal, @Recurso, 'ALTA',  Rol, HorasDia, PrecioHora, CostoHora
FROM Recurso
WHERE Recurso = @Recurso
INSERT ProyectoDRecurso ( ID,  Actividad,  Recurso,   Comienzo,  Fin)
SELECT @ID, ListaSt.Clave, @Recurso, ProyectoD.Comienzo, ProyectoD.Fin
FROM ListaSt
JOIN ProyectoD ON ProyectoD.ID = @ID AND ProyectoD.Actividad = ListaSt.Clave AND ProyectoD.EsFase = 0
WHERE ListaSt.Estacion = @Estacion
AND NOT EXISTS (SELECT * FROM ProyectoDRecurso WHERE Actividad = ListaSt.Clave AND Recurso = @Recurso AND ID = @ID)
EXEC spProyectoRecursoActualizar @ID, @Recurso
END ELSE
IF ISNULL(@Accion,'') = 'DESASIGNAR'
BEGIN
IF @Recurso IS NULL
DELETE ProyectoDRecurso
WHERE ID = @ID
AND Actividad IN (SELECT Clave FROM ListaSt WHERE Estacion = @Estacion)
ELSE
DELETE ProyectoDRecurso
WHERE ID = @ID
AND Recurso = @Recurso
AND Actividad IN (SELECT Clave FROM ListaSt WHERE Estacion = @Estacion)
END
DELETE ListaSt WHERE Estacion = @Estacion
RETURN
END

