SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgNotificacionBC ON Notificacion

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@NotificacionNueva  	varchar(50),
@NotificacionAnterior	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @NotificacionNueva = Notificacion
FROM Inserted
SELECT @NotificacionAnterior = Notificacion
FROM Deleted
IF @NotificacionNueva = @NotificacionAnterior RETURN
IF @NotificacionNueva IS NULL
BEGIN
DELETE FROM NotificacionDestinatario WHERE Notificacion = @NotificacionAnterior
DELETE FROM NotificacionFiltro WHERE Notificacion = @NotificacionAnterior
DELETE FROM NotificacionVigencia WHERE Notificacion = @NotificacionAnterior
DELETE FROM NotificacionVigenciaHora WHERE Notificacion = @NotificacionAnterior
DELETE FROM NotificacionConsulta WHERE Notificacion = @NotificacionAnterior
DELETE FROM NotificacionParam WHERE Notificacion = @NotificacionAnterior
END ELSE
IF @NotificacionNueva <> @NotificacionAnterior
BEGIN
UPDATE NotificacionDestinatario SET Notificacion = @NotificacionNueva WHERE Notificacion = @NotificacionAnterior
UPDATE NotificacionFiltro SET Notificacion = @NotificacionNueva WHERE Notificacion = @NotificacionAnterior
UPDATE NotificacionVigencia SET Notificacion = @NotificacionNueva WHERE Notificacion = @NotificacionAnterior
UPDATE NotificacionVigenciaHora SET Notificacion = @NotificacionNueva WHERE Notificacion = @NotificacionAnterior
UPDATE NotificacionConsulta SET Notificacion = @NotificacionNueva WHERE Notificacion = @NotificacionAnterior
UPDATE NotificacionParam SET Notificacion = @NotificacionNueva WHERE Notificacion = @NotificacionAnterior
END
END

