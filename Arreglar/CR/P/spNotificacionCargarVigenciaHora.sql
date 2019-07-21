SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNotificacionCargarVigenciaHora
@Estacion			int,
@Notificacion		varchar(50)

AS BEGIN
DELETE FROM NotificacionVigenciaHoraTemp WHERE Estacion = @Estacion AND Notificacion = @Notificacion
INSERT NotificacionVigenciaHoraTemp (Estacion,  Notificacion, HoraD, HoraA)
SELECT @Estacion, Notificacion,  HoraD, HoraA
FROM NotificacionVigenciaHora
WHERE Notificacion = @Notificacion
END

