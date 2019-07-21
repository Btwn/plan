SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNotificacionEliminar
@Estacion				int,
@Notificacion			varchar(50)

AS BEGIN
DECLARE
@Transaccion		varchar(50),
@Ok			int,
@OkRef			varchar(255)
IF NOT EXISTS(SELECT 1 FROM Notificacion WHERE Notificacion = @Notificacion) RETURN
SELECT @Ok = NULL, @OkRef = NULL
SET @Transaccion = 'spNotificacionEliminar' + RTRIM(LTRIM(CONVERT(varchar,@Estacion)))
BEGIN TRANSACTION @Transaccion
DELETE FROM Notificacion WHERE Notificacion = @Notificacion
IF NULLIF(@@ERROR,0) IS NOT NULL SELECT @Ok = 1, @OkRef = 'Notificacion'
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
DELETE FROM NotificacionParam WHERE Notificacion = @Notificacion
IF NULLIF(@@ERROR,0) IS NOT NULL SELECT @Ok = 1, @OkRef = 'NotificacionParam'
END
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
DELETE FROM NotificacionConsulta WHERE Notificacion = @Notificacion
IF NULLIF(@@ERROR,0) IS NOT NULL SELECT @Ok = 1, @OkRef = 'NotificacionConsulta'
END
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
DELETE FROM NotificacionDestinatario WHERE Notificacion = @Notificacion
IF NULLIF(@@ERROR,0) IS NOT NULL SELECT @Ok = 1, @OkRef = 'NotificacionDestinatario'
END
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
DELETE FROM NotificacionFiltro WHERE Notificacion = @Notificacion
IF NULLIF(@@ERROR,0) IS NOT NULL SELECT @Ok = 1, @OkRef = 'NotificacionFiltro'
END
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
DELETE FROM NotificacionVigencia WHERE Notificacion = @Notificacion
IF NULLIF(@@ERROR,0) IS NOT NULL SELECT @Ok = 1, @OkRef = 'NotificacionVigencia'
END
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
DELETE FROM NotificacionVigenciaHora WHERE Notificacion = @Notificacion
IF NULLIF(@@ERROR,0) IS NOT NULL SELECT @Ok = 1, @OkRef = 'NotificacionVigenciaHora'
END
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
COMMIT TRANSACTION @Transaccion
END ELSE
BEGIN
ROLLBACK TRANSACTION @Transaccion
SELECT 'ERROR: ' + CONVERT(varchar,@Ok) + ', ' + (SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok) +'. ' + ISNULL(@OkRef,'')
END
END

