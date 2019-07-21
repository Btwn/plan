SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNotificacionGuardarVigencia
@Estacion			int,
@Notificacion		varchar(50)

AS BEGIN
DELETE FROM NotificacionVigencia WHERE Notificacion = @Notificacion
INSERT NotificacionVigencia (Notificacion, FechaD, FechaA)
SELECT Notificacion, FechaD, FechaA
FROM NotificacionVigenciaTemp
WHERE Notificacion = @Notificacion
AND Estacion = @Estacion
END

