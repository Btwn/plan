SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNotificacionVerificarVigenciaHora
@Notificacion				varchar(50),
@FechaRegistro				datetime,
@GenerarNotificacion		bit OUTPUT

AS BEGIN
DECLARE
@FechaActual			datetime,
@Hora					varchar(2),
@Minuto				varchar(2),
@HoraActual			varchar(5),
@HoraActualEntero		int
SET @FechaActual = @FechaRegistro
SET @Hora = RTRIM(LTRIM(CONVERT(varchar,DATEPART(hh,@FechaActual))))
SET @Hora = CASE WHEN LEN(@Hora) = 1 THEN '0' + @Hora ELSE @Hora END
SET @Minuto = RTRIM(LTRIM(CONVERT(varchar,DATEPART(mi,@FechaActual))))
SET @Minuto = CASE WHEN LEN(@Minuto) = 1 THEN '0' + @Minuto ELSE @Minuto END
SET @HoraActual = @Hora + CHAR(58) + @Minuto
SET @HoraActualEntero = dbo.fnHoraEnEntero(@HoraActual)
IF EXISTS(SELECT 1 FROM NotificacionVigenciaHora WHERE Notificacion = @Notificacion)
BEGIN
IF NOT EXISTS(SELECT 1 FROM NotificacionVigenciaHora WHERE Notificacion = @Notificacion AND @HoraActualEntero BETWEEN dbo.fnHoraEnEntero(HoraD) AND dbo.fnHoraEnEntero(HoraA)) SET @GenerarNotificacion = 0
END
RETURN
END

