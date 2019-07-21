SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGestionChecarEstatus
@ID                		int,
@FechaEmision      		datetime,
@IDDestino			int,
@MovTipoDestino		varchar(20),
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT

AS BEGIN
DECLARE
@MovTipo		varchar(20),
@Estado		varchar(30),
@EstatusA		varchar(15),
@EstatusN		varchar(15),
@IDOrigen		int,
@RamaID		int
IF @ID IS NULL RETURN
SELECT @RamaID = g.RamaID, @IDOrigen = g.IDOrigen, @EstatusA = g.Estatus, @MovTipo = mt.Clave, @Estado = g.Estado
FROM Gestion g
 WITH(NOLOCK) JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = 'GES' AND mt.Mov = g.Mov
WHERE g.ID = @ID
IF @MovTipo = 'GES.REU' AND @MovTipoDestino IN ('GES.STAR', 'GES.OTAR', 'GES.SRES') RETURN
SELECT @EstatusN = 'CONCLUIDO'
IF @MovTipo IN ('GES.TAR', 'GES.REU') AND @EstatusN = 'CONCLUIDO'
SELECT @EstatusN = dbo.fnTareaEstadoEnEstatus(@Estado)
IF @MovTipoDestino <> 'GES.TE'
BEGIN
IF EXISTS(SELECT * FROM Gestion WITH(NOLOCK) WHERE RamaID = @ID AND Estatus IN ('PENDIENTE', 'ALTAPRIORIDAD', 'PRIORIDADBAJA'))
SELECT @EstatusN = 'PENDIENTE'
IF @EstatusN = 'CONCLUIDO' AND @RamaID IS NULL
IF NOT EXISTS(SELECT * FROM Gestion WITH(NOLOCK) WHERE RamaID = @ID AND Estatus = 'CONCLUIDO')
SELECT @EstatusN = 'PENDIENTE'
/*
SELECT @IDDestino
SELECT gp.* FROM GestionPara gp
LEFT OUTER JOIN Gestion r  WITH(NOLOCK) ON r.ID = gp.RespuestaID
WHERE gp.ID = @ID AND ((UPPER(gp.Participacion) = 'REQUERIDO' AND gp.RespuestaID IS NULL) OR (r.Estatus IN ('PENDIENTE', 'ALTAPRIORIDAD', 'PRIORIDADBAJA') /*AND gp.RespuestaID<>@IDDestino*/))
*/
/*
IF @EstatusN = 'CONCLUIDO' AND @MovTipo IN ('GES.SRES', 'GES.REU', 'GES.STAR', 'GES.OTAR')
IF EXISTS(SELECT gp.Usuario FROM GestionPara gp LEFT OUTER  WITH(NOLOCK) JOIN Gestion r  WITH(NOLOCK) ON r.ID = gp.RespuestaID WHERE gp.ID = @ID AND ((UPPER(gp.Participacion) = 'REQUERIDO' AND gp.RespuestaID IS NULL) OR (r.Estatus IN ('PENDIENTE', 'ALTAPRIORIDAD', 'PRIORIDADBAJA') AND gp.RespuestaID<>@IDDestino)))
SELECT @EstatusN = 'PENDIENTE'
*/
IF @EstatusN = 'CONCLUIDO' AND @MovTipo IN ('GES.SRES', 'GES.REU', 'GES.STAR', 'GES.OTAR')
IF EXISTS(SELECT gp.Usuario FROM GestionPara gp LEFT OUTER  WITH(NOLOCK) JOIN Gestion r  WITH(NOLOCK) ON r.ID = gp.RespuestaID WHERE gp.ID = @ID AND ((UPPER(gp.Participacion) = 'REQUERIDO' AND gp.RespuestaID IS NULL)))
SELECT @EstatusN = 'PENDIENTE'
IF @EstatusN = 'CONCLUIDO' AND @MovTipo IN ('GES.SRES', 'GES.STAR', 'GES.OTAR')
IF EXISTS(SELECT gp.Usuario FROM GestionPara gp LEFT OUTER  WITH(NOLOCK) JOIN Gestion r  WITH(NOLOCK) ON r.ID = gp.RespuestaID WHERE gp.ID = @ID AND r.Estatus IN ('PENDIENTE', 'ALTAPRIORIDAD', 'PRIORIDADBAJA'))
SELECT @EstatusN = 'PENDIENTE'
END
/*
SELECT @id, @IDDestino, @movtipo, @EstatusN
SELECT @ok = 1
*/
IF @MovTipoDestino = 'GES.MOD' SET @EstatusN = @EstatusA
IF @EstatusA <> @EstatusN
BEGIN
UPDATE Gestion
 WITH(ROWLOCK) SET Estatus = @EstatusN,
FechaConclusion = CASE WHEN @EstatusN = 'CONCLUIDO' THEN @FechaEmision ELSE NULL END
WHERE ID = @ID
END
IF @IDOrigen IS NOT NULL
EXEC spGestionChecarEstatus @IDOrigen, @FechaEmision, @IDDestino, @MovTipo, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

