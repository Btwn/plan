SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNotificacionGuardarVigenciaHora
@Estacion			int,
@Notificacion		varchar(50)

AS BEGIN
DELETE FROM NotificacionVigenciaHora WHERE Notificacion = @Notificacion
INSERT NotificacionVigenciaHora (Notificacion, HoraD, HoraA)
SELECT Notificacion,  HoraD, HoraA
FROM NotificacionVigenciaHoraTemp
WHERE Notificacion = @Notificacion
AND Estacion = @Estacion
END

