SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroSSBEnviarRespaldo
@iDatos                 int,
@Solicitud        uniqueidentifier,
@Conversacion           uniqueidentifier,
@FechaEnvio       datetime,
@SucursalLocal          int,
@SucursalSincro         int,
@Ok               int         OUTPUT,
@OkRef                  varchar(255)      OUTPUT

AS BEGIN
DECLARE
@EsTRCL bit
IF @SucursalLocal <> @SucursalSincro AND @SucursalLocal = 0 AND @SucursalSincro > 0
BEGIN
SELECT @EsTRCL = TRCL FROM Version
EXEC spSincroSSBEnviar @SucursalSincro, @EsRespaldo = 1, @EsTRCL = @EsTRCL, @Solicitud = @Solicitud, @FechaEnvio = @FechaEnvio OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
EXEC spSincroSSBSolicitud @Solicitud, 'Respaldo', @SucursalLocal, @SucursalSincro, @FechaEnvio = @FechaEnvio, @Estatus = 'CONCLUIDO'
END
RETURN
END

