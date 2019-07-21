SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNotificacionCargarVigencia
@Estacion			int,
@Notificacion		varchar(50)

AS BEGIN
DELETE FROM NotificacionVigenciaTemp WHERE Estacion = @Estacion AND Notificacion = @Notificacion
INSERT NotificacionVigenciaTemp (Estacion,  Notificacion, FechaD, FechaA)
SELECT @Estacion, Notificacion, FechaD, FechaA
FROM NotificacionVigencia
WHERE Notificacion = @Notificacion
END

