SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGestionAgendaOtrosModulos
@Empresa	varchar(5),
@Sucursal	int,
@Estacion	int,
@ReunionID	int

AS BEGIN
BEGIN TRANSACTION
DECLARE
@Modulo	varchar(5),
@ID		int,
@Mov	varchar(20),
@MovID	varchar(20),
@Orden	int
SELECT @Orden = MAX(Orden) FROM GestionAgenda WHERE ID = @ReunionID
DECLARE crGestionAgendaOtrosModulos CURSOR FOR
SELECT l.Modulo, l.ID, m.Mov, m.MovID
FROM ListaModuloID l
 WITH(NOLOCK) JOIN Mov m  WITH(NOLOCK) ON m.Empresa = @Empresa AND m.Modulo = l.Modulo AND m.ID = l.ID
WHERE l.Estacion = @Estacion
OPEN crGestionAgendaOtrosModulos
FETCH NEXT FROM crGestionAgendaOtrosModulos  INTO @Modulo, @ID, @Mov, @MovID
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF NOT EXISTS(SELECT * FROM GestionAgenda WITH(NOLOCK) WHERE ID = @ReunionID AND Modulo = @Modulo AND Mov = @Mov AND MovID = @MovID)
BEGIN
SELECT @Orden = ISNULL(@Orden, 0) + 1
INSERT GestionAgenda (
ID,         Modulo,  Mov,  MovID,  Orden,  Sucursal)
VALUES (@ReunionID, @Modulo, @Mov, @MovID, @Orden, @Sucursal)
END
END
FETCH NEXT FROM crGestionAgendaOtrosModulos  INTO @Modulo, @ID, @Mov, @MovID
END
CLOSE crGestionAgendaOtrosModulos
DEALLOCATE crGestionAgendaOtrosModulos
COMMIT TRANSACTION
RETURN
END

