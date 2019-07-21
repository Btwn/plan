SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGestionAgendaAgregarMov
@Empresa	varchar(5),
@Sucursal	int,
@Modulo		varchar(5),
@ID		int,
@Reunion	varchar(20),
@ReunionID	varchar(20),
@IDReunion	int	= NULL

AS BEGIN
DECLARE
@Mov	varchar(20),
@MovID	varchar(20),
@Orden	int
IF @IDReunion IS NULL
SELECT @IDReunion = MIN(g.ID)
FROM Gestion g
 WITH(NOLOCK) JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = 'GES' AND mt.Mov = g.Mov AND mt.Clave = 'GES.REU'
WHERE g.Empresa = @Empresa AND g.Mov = @Reunion AND g.MovID = @ReunionID AND g.Estatus IN ('PENDIENTE', 'ALTAPRIORIDAD', 'PRIORIDADBAJA')
IF @IDReunion IS NOT NULL AND @Modulo = 'GES'
BEGIN
EXEC spMovInfo @ID, @Modulo, @Mov = @Mov OUTPUT, @MovID = @MovID OUTPUT
IF @Mov IS NOT NULL AND @MovID IS NOT NULL
IF NOT EXISTS(SELECT * FROM GestionAgenda WITH(NOLOCK) WHERE ID = @IDReunion AND Mov = @Mov AND MovID = @MovID)
BEGIN
SELECT @Orden = NULL
SELECT @Orden = MAX(Orden) FROM GestionAgenda WHERE ID = @IDReunion
SELECT @Orden = ISNULL(@Orden, 0) + 1
INSERT GestionAgenda (ID, Modulo, Mov, MovID, Orden, Sucursal) VALUES (@IDReunion, @Modulo, @Mov, @MovID, @Orden, @Sucursal)
EXEC spGestionModificarAgenda @IDReunion
END
END
RETURN
END

