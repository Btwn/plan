SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISEnviarTRCL
@iDatos			int,
@Solicitud		uniqueidentifier,
@Conversacion		uniqueidentifier,
@FechaEnvio		datetime,
@SucursalLocal		int,
@SucursalSincro		int,
@Ok			int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
IF @SucursalLocal <> @SucursalSincro AND @SucursalLocal = 0 AND @SucursalSincro > 0
BEGIN
EXEC spSincroISEnviarTablasEnPartes @SucursalSincro, @EsTRCL = 1, @Solicitud = @Solicitud, @Conversacion = @Conversacion, @FechaEnvio = @FechaEnvio OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
EXEC spSincroISSolicitud @Solicitud, 'TRCL', @SucursalLocal, @SucursalSincro, @FechaEnvio = @FechaEnvio, @Estatus = 'CONCLUIDO'
END
RETURN
END

