SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISProcesarMensaje
@Conversacion		uniqueidentifier,
@TipoMensaje		nvarchar(256),
@iDatos				int,
@Brincar			bit		OUTPUT,
@Ok					int		OUTPUT,
@OkRef				varchar(255)	OUTPUT,
@Debug				bit	= 0

AS BEGIN
DECLARE
@Solicitud			uniqueidentifier,
@FechaEnvio			datetime,
@SucursalSincro		int,
@SucursalLocal		int,
@FechaRecibo		datetime
SELECT @SucursalLocal = Sucursal FROM Version
SELECT @SucursalSincro = NULL
SELECT @Solicitud = Solicitud, @FechaEnvio = FechaEnvio, @SucursalSincro = SucursalOrigen
FROM OPENXML (@iDatos, '/Intelisis/Solicitud/IntelisisSincroIS')
WITH (Solicitud uniqueidentifier, FechaEnvio datetime, SucursalOrigen int, SucursalDestino int)
WHERE SucursalDestino = @SucursalLocal
IF @SucursalSincro IS NOT NULL
BEGIN
IF @TipoMensaje = 'SincroIS/Sincro'				EXEC spSincroISRecibirSincro  @iDatos, @Solicitud, @Conversacion, @FechaEnvio, @SucursalLocal, @SucursalSincro, @Brincar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @TipoMensaje = 'SincroIS/SincroFinal'		EXEC spSincroISSincroFinal    @iDatos, @Solicitud, @Conversacion, @FechaEnvio, @SucursalLocal, @SucursalSincro, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @TipoMensaje = 'SincroIS/SolicitarTRCL'		EXEC spSincroISEnviarTRCL     @iDatos, @Solicitud, @Conversacion, @FechaEnvio, @SucursalLocal, @SucursalSincro, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @TipoMensaje = 'SincroIS/SolicitarRespaldo'	EXEC spSincroISEnviarRespaldo @iDatos, @Solicitud, @Conversacion, @FechaEnvio, @SucursalLocal, @SucursalSincro, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @TipoMensaje = 'SincroIS/SolicitarPrueba'	EXEC spSincroISEnviarPrueba   @iDatos, @Solicitud, @Conversacion, @FechaEnvio, @SucursalLocal, @SucursalSincro, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @TipoMensaje = 'SincroIS/Prueba'				EXEC spSincroISRecibirPrueba  @iDatos, @Solicitud, @Conversacion, @FechaEnvio, @SucursalLocal, @SucursalSincro, @Ok OUTPUT, @OkRef OUTPUT
END ELSE
SELECT @Ok = 17040, @OkRef = CONVERT(varchar, @SucursalSincro)
RETURN
END

