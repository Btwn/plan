SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISSincroFinal
@iDatos				int,
@Solicitud			uniqueidentifier,
@Conversacion		uniqueidentifier,
@FechaEnvio			datetime,
@SucursalLocal		int,
@SucursalSincro		int,
@Ok					int		OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS BEGIN
DECLARE
@FechaRecibo	datetime,
@EsRespaldo		bit,
@EsTRCL		bit
SELECT @FechaRecibo = GETDATE()
SELECT @EsRespaldo = ISNULL(EsRespaldo, 0), @EsTRCL = ISNULL(EsTRCL, 0)
FROM OPENXML (@iDatos, '/Intelisis/Solicitud/IntelisisSincroIS')
WITH (EsRespaldo bit, EsTRCL bit)
IF @SucursalLocal <> @SucursalSincro
BEGIN
EXEC spSincroFinal
EXEC spSincroISSolicitud @Solicitud, @FechaRecibo = @FechaRecibo, @Estatus = 'CONCLUIDO'
IF @EsRespaldo = 0 AND @EsTRCL = 0
BEGIN
IF @SucursalLocal = 0
BEGIN
EXEC spSetInformacionContexto 'SINCROIS', 1
UPDATE Sucursal SET UltimaSincronizacion = @FechaRecibo WHERE Sucursal = @SucursalLocal
EXEC spSetInformacionContexto 'SINCROIS', 0
END
EXEC spSincroISEnviarTablasEnPartes @SucursalSincro, @EsSincroFinal = 1, @Solicitud = @Solicitud, @Conversacion = @Conversacion, @FechaEnvio = @FechaEnvio OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
EXEC spSincroISSolicitud @Solicitud, 'Sincronizacion', @SucursalLocal, @SucursalSincro, @FechaEnvio = @FechaEnvio, @Estatus = 'CONCLUIDO'
END
END
RETURN
END

