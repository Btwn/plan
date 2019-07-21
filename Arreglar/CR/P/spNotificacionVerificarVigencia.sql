SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNotificacionVerificarVigencia
@Notificacion				varchar(50),
@FechaEmision				datetime,
@GenerarNotificacion		bit OUTPUT

AS BEGIN
IF EXISTS(SELECT 1 FROM NotificacionVigencia WHERE Notificacion = @Notificacion)
BEGIN
IF NOT EXISTS(SELECT 1 FROM NotificacionVigencia WHERE Notificacion = @Notificacion AND @FechaEmision BETWEEN dbo.fnFechaSinHora(FechaD) AND dbo.fnFechaSinHora(FechaA)) SET @GenerarNotificacion = 0
END
RETURN
END

