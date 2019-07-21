SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgProyectoDB ON ProyectoD

FOR DELETE
AS BEGIN
DECLARE
@ID		int,
@Actividad	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ID = ID, @Actividad = Actividad FROM Deleted
DELETE ProyectoDRecurso
WHERE ID = @ID AND Actividad = @Actividad
END

