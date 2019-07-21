SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgOportunidadD ON OportunidadD

FOR UPDATE
AS
BEGIN
DECLARE @FechaCambio	datetime,
@ID			int,
@IDAnt		int,
@Renglon		float,
@RenglonAnt	float,
@RID			int
SELECT @FechaCambio = GETDATE()
EXEC spExtraerFecha @FechaCambio OUTPUT
SELECT @IDAnt = 0
WHILE(1=1)
BEGIN
SELECT @ID = MIN(ID)
FROM Inserted
WHERE ID > @IDAnt
IF @ID IS NULL BREAK
SELECT @IDAnt = @ID
SELECT @RenglonAnt = 0
WHILE(1=1)
BEGIN
SELECT @Renglon = MIN(Renglon)
FROM Inserted
WHERE ID = @ID
AND Renglon > @RenglonAnt
IF @Renglon IS NULL BREAK
SELECT @RenglonAnt = @Renglon
SELECT @RID = MAX(RID) FROM OportunidadDBitacora WHERE ID = @ID AND Renglon = @Renglon
IF @RID IS NOT NULL
INSERT INTO OportunidadDBitacora(
ID,   Renglon,   RenglonSub,   RenglonID,   Tipo,   Clave,   PorcentajeAvance,   IDGestion,   Comentarios,   RenglonTipo,   Contacto,   CantidadPendiente,   CantidadA,   Fecha,   Recurso,   Usuario,  FechaCambio,   Estado,  FechaA,    MovGestion)
SELECT i.ID, i.Renglon, i.RenglonSub, i.RenglonID, i.Tipo, i.Clave, i.PorcentajeAvance, i.IDGestion, i.Comentarios, i.RenglonTipo, i.Contacto, i.CantidadPendiente, i.CantidadA, i.Fecha, i.Recurso, i.Usuario, @FechaCambio, i.Estado, i.FechaA, i.MovGestion
FROM Inserted i
JOIN OportunidadDBitacora d ON i.ID = d.ID AND i.Renglon = d.Renglon AND i.RenglonSub = d.RenglonSub
WHERE d.RID = @RID
AND i.ID = @ID
AND d.Renglon = @Renglon
AND ((ISNULL(i.PorcentajeAvance, 0) <> ISNULL(d.PorcentajeAvance, 0))
OR (ISNULL(i.Comentarios, '') <> ISNULL(d.Comentarios, ''))
OR (ISNULL(i.Fecha, '') <> ISNULL(d.Fecha, ''))
OR (ISNULL(i.FechaA, '') <> ISNULL(d.FechaA, ''))
OR (ISNULL(i.Recurso, '') <> ISNULL(d.Recurso, ''))
OR (ISNULL(i.Estado, '')  <> ISNULL(d.Estado, ''))
OR (ISNULL(i.MovGestion, '')  <> ISNULL(d.MovGestion, '')))
ELSE
INSERT INTO OportunidadDBitacora(
ID,   Renglon,   RenglonSub,   RenglonID,   Tipo,   Clave,   PorcentajeAvance,   IDGestion,   Comentarios,   RenglonTipo,   Contacto,   CantidadPendiente,   CantidadA,   Fecha,   Recurso,   Usuario,  FechaCambio,   Estado,  FechaA,    MovGestion)
SELECT i.ID, i.Renglon, i.RenglonSub, i.RenglonID, i.Tipo, i.Clave, i.PorcentajeAvance, i.IDGestion, i.Comentarios, i.RenglonTipo, i.Contacto, i.CantidadPendiente, i.CantidadA, i.Fecha, i.Recurso, i.Usuario, @FechaCambio, i.Estado, i.FechaA, i.MovGestion
FROM Inserted i
WHERE i.ID = @ID
AND i.Renglon = @Renglon
END
END
RETURN
END

