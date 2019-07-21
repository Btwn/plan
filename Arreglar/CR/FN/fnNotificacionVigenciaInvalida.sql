SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnNotificacionVigenciaInvalida
(
@Estacion					int,
@Notificacion				varchar(50)
)
RETURNS bit

AS BEGIN
DECLARE
@Resultado			bit,
@RID					int,
@FechaD				datetime,
@FechaA				datetime
SET @Resultado = 0
DECLARE crNotificacionVigencia CURSOR FOR
SELECT RID, dbo.fnFechaSinHora(FechaD), dbo.fnFechaSinHora(FechaA)
FROM NotificacionVigenciaTemp
WHERE Notificacion = @Notificacion
AND Estacion = @Estacion
OPEN crNotificacionVigencia
FETCH NEXT FROM crNotificacionVigencia INTO @RID, @FechaD, @FechaA
WHILE @@FETCH_STATUS = 0 AND @Resultado = 0
BEGIN
IF EXISTS(SELECT 1 FROM NotificacionVigenciaTemp WHERE Notificacion = @Notificacion AND RID <> @RID AND @FechaD BETWEEN dbo.fnFechaSinHora(FechaD) AND dbo.fnFechaSinHora(FechaA) AND Estacion = @Estacion) SET @Resultado = 1
IF @Resultado = 0 AND EXISTS(SELECT 1 FROM NotificacionVigenciaTemp WHERE Notificacion = @Notificacion AND RID <> @RID AND @FechaA BETWEEN dbo.fnFechaSinHora(FechaD) AND dbo.fnFechaSinHora(FechaA) AND Estacion = @Estacion) SET @Resultado = 1
IF @Resultado = 0 AND @FechaA < @FechaD SET @Resultado = 1
FETCH NEXT FROM crNotificacionVigencia INTO @RID, @FechaD, @FechaA
END
CLOSE crNotificacionVigencia
DEALLOCATE crNotificacionVigencia
RETURN (@Resultado)
END

