SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgProyectoD ON ProyectoD

FOR UPDATE
AS
BEGIN
DECLARE @FechaCambio	datetime,
@ID			int,
@IDAnt		int,
@Actividad    varchar(50),
@ActividadAnt	varchar(50),
@RID			int,
@Usuario      varchar(10)
SELECT @FechaCambio = GETDATE()
EXEC spExtraerFecha @FechaCambio OUTPUT
SELECT @IDAnt = 0
WHILE(1=1)
BEGIN
SELECT @ID = MIN(ID) FROM Inserted WHERE ID > @IDAnt
IF @ID IS NULL BREAK
SELECT @IDAnt = @ID
SELECT @ActividadAnt = ''
WHILE(1=1)
BEGIN
SELECT @Actividad = MIN(Actividad) FROM Inserted WHERE ID = @ID AND Actividad > @ActividadAnt
IF @Actividad IS NULL BREAK
SELECT @ActividadAnt = @Actividad
SELECT @RID = MAX(RID) FROM ProyectoDBitacora WHERE ID = @ID AND Actividad = @Actividad
SELECT @Usuario = Usuario FROM Proyecto WHERE ID = @ID
IF @RID IS NOT NULL
INSERT INTO ProyectoDBitacora(
ID,   Actividad,  Asunto,   PorcentajeAvance,   IDGestion,    Comienzo,     Fin,  RecursosAsignados,   Usuario,    FechaCambio,   Estado,  MovGestion)
SELECT i.ID, i.Actividad,  i.Asunto, i.Avance,         i.IDGestion,  i.Comienzo, i.Fin,  i.RecursosAsignados,  @Usuario, @FechaCambio, i.Estado, i.MovGestion
FROM Inserted i
JOIN ProyectoDBitacora d ON i.ID = d.ID AND i.Actividad = d.Actividad
WHERE d.RID = @RID
AND i.ID = @ID
AND d.Actividad = @Actividad
AND ((ISNULL(i.Avance, 0) <> ISNULL(d.PorcentajeAvance, 0))
OR (ISNULL(i.Comienzo, '') <> ISNULL(d.Comienzo, ''))
OR (ISNULL(i.Fin, '') <> ISNULL(d.Fin, ''))
OR (ISNULL(i.RecursosAsignados, '') <> ISNULL(d.RecursosAsignados, ''))
OR (ISNULL(i.Estado, '')  <> ISNULL(d.Estado, ''))
OR (ISNULL(i.MovGestion, '')  <> ISNULL(d.MovGestion, '')))
ELSE
INSERT INTO ProyectoDBitacora(
ID,   Actividad,  Asunto,   PorcentajeAvance,   IDGestion,    Comienzo,     Fin,  RecursosAsignados,   Usuario,   FechaCambio,   Estado,  MovGestion)
SELECT i.ID, i.Actividad,  i.Asunto, i.Avance,         i.IDGestion,  i.Comienzo, i.Fin,  i.RecursosAsignados,   @Usuario, @FechaCambio, i.Estado, i.MovGestion
FROM Inserted i
WHERE i.ID = @ID
AND i.Actividad = @Actividad
END
END
RETURN
END

