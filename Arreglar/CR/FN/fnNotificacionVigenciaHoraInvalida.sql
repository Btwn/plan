SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnNotificacionVigenciaHoraInvalida
(
@Estacion					int,
@Notificacion				varchar(50)
)
RETURNS bit

AS BEGIN
DECLARE
@Resultado			bit,
@RID					int,
@HoraD				int,
@HoraA				int
SET @Resultado = 0
DECLARE crNotificacionVigenciaHora CURSOR FOR
SELECT RID, dbo.fnHoraEnEntero(HoraD), dbo.fnHoraEnEntero(HoraA)
FROM NotificacionVigenciaHoraTemp
WHERE Notificacion = @Notificacion
AND Estacion = @Estacion
OPEN crNotificacionVigenciaHora
FETCH NEXT FROM crNotificacionVigenciaHora INTO @RID, @HoraD, @HoraA
WHILE @@FETCH_STATUS = 0 AND @Resultado = 0
BEGIN
IF EXISTS(SELECT 1 FROM NotificacionVigenciaHoraTemp WHERE Notificacion = @Notificacion AND RID <> @RID AND @HoraD BETWEEN dbo.fnHoraEnEntero(HoraD) AND dbo.fnHoraEnEntero(HoraA) AND Estacion = @Estacion) SET @Resultado = 1
IF @Resultado = 0 AND EXISTS(SELECT 1 FROM NotificacionVigenciaHoraTemp WHERE Notificacion = @Notificacion AND RID <> @RID AND @HoraA BETWEEN dbo.fnHoraEnEntero(HoraD) AND dbo.fnHoraEnEntero(HoraA) AND Estacion = @Estacion) SET @Resultado = 1
IF @Resultado = 0 AND @HoraA < @HoraD SET @Resultado = 1
FETCH NEXT FROM crNotificacionVigenciaHora INTO @RID, @HoraD, @HoraA
END
CLOSE crNotificacionVigenciaHora
DEALLOCATE crNotificacionVigenciaHora
RETURN (@Resultado)
END

