SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProyectoDAsignarAct
@ID     	int,
@Actividad	varchar(50),
@Recurso	varchar(10),
@Accion		varchar(20) = NULL,
@RecursoA	varchar(10) = NULL,
@DesAsignar	bit	    = 0

AS BEGIN
DECLARE
@EsFase             int,
@Comienzo           datetime,
@Fin                datetime,
@Sucursal		int
SELECT @Accion = UPPER(@Accion), @Recurso = NULLIF(RTRIM(@Recurso), '')
SELECT @Sucursal = Sucursal FROM Proyecto WHERE ID = @ID
IF @DesAsignar = 1
DELETE ProyectoDRecurso
WHERE ID = @ID AND Actividad = @Actividad
IF ISNULL(@Accion,'') IN ('', 'ASIGNAR')
BEGIN
IF NOT EXISTS(SELECT * FROM ProyectoRecurso WHERE ID = @ID AND Recurso = @Recurso)
INSERT ProyectoRecurso (
ID,  Sucursal,  Recurso,  Estatus, Rol, HorasDia, PrecioHora, CostoHora)
SELECT @ID, @Sucursal, @Recurso, 'ALTA',  Rol, HorasDia, PrecioHora, CostoHora
FROM Recurso
WHERE Recurso = @Recurso
INSERT ProyectoDRecurso ( ID,  Actividad,  Recurso,   Comienzo,  Fin)
SELECT @ID, ProyectoD.Actividad, @Recurso, ProyectoD.Comienzo, ProyectoD.Fin
FROM ProyectoD
WHERE ProyectoD.ID = @ID AND ProyectoD.Actividad = @Actividad AND ProyectoD.EsFase = 0
AND NOT EXISTS (SELECT * FROM ProyectoDRecurso WHERE Actividad = @Actividad AND Recurso = @Recurso AND ID = @ID)
EXEC spProyectoRecursoActualizar @ID, @Recurso
END ELSE
IF ISNULL(@Accion,'') = 'DESASIGNAR'
BEGIN
IF @Recurso IS NULL
DELETE ProyectoDRecurso
WHERE ID = @ID
AND Actividad = @Actividad
ELSE
DELETE ProyectoDRecurso
WHERE ID = @ID
AND Recurso = @Recurso
AND Actividad = @Actividad
END
RETURN
END

