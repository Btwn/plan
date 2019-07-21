SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroIS_SolicitarTRCL
@Usuario				varchar(10)

AS BEGIN
DECLARE
@SucursalOrigen		int,
@SucursalDestino		int,
@Solicitud			uniqueidentifier,
@Conversacion		uniqueidentifier,
@FechaEnvio			datetime,
@SQL			nvarchar(max),
@Datos			xml,
@SQL_ERROR_NUMBER		int,
@SQL_ERROR_MESSAGE		varchar(255),
@Ok				int,
@OkRef			varchar(255)
EXEC spSincroISActualizarSesion @Usuario
SELECT @Ok = NULL, @OkRef = NULL, @SQL_ERROR_NUMBER = 0, @SQL_ERROR_MESSAGE = NULL
SELECT @SucursalOrigen = Sucursal FROM Version
SELECT @SucursalDestino = 0, @FechaEnvio = GETDATE()
IF EXISTS (SELECT * FROM SincroISSolicitud WHERE Tipo = 'TRCL' AND SucursalOrigen = @SucursalOrigen AND SucursalDestino = @SucursalDestino AND Estatus = 'PENDIENTE')
SELECT @Ok = 17020
IF @SucursalOrigen > 0 AND @Ok IS NULL
BEGIN
BEGIN TRY
BEGIN TRANSACTION
SELECT @Solicitud = NEWID()
SELECT @Conversacion = NEWID()
SELECT @Datos = '<IntelisisSincroIS'+
dbo.fnXML('Tipo', 'SolicitarTRCL')+
dbo.fnXMLGID('Solicitud', @Solicitud)+
dbo.fnXMLDateTime('FechaEnvio', @FechaEnvio)+
dbo.fnXMLInt('SucursalOrigen', @SucursalOrigen)+
dbo.fnXMLInt('SucursalDestino', @SucursalDestino)+
'/>'
EXEC spSincroISSend 'SolicitarTRCL', @Datos, @Conversacion, @SucursalOrigen, @SucursalDestino, NULL, @Solicitud, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spSincroISSolicitud @Solicitud, 'TRCL', @SucursalOrigen, @SucursalDestino, @FechaEnvio = @FechaEnvio, @Estatus = 'PENDIENTE'
COMMIT TRANSACTION
END TRY
BEGIN CATCH
SELECT @SQL_ERROR_NUMBER = ERROR_NUMBER(), @SQL_ERROR_MESSAGE = ERROR_MESSAGE()
ROLLBACK TRANSACTION
END CATCH
END
EXEC spSincroISOk @Solicitud, 'SincroIS/SolicitarTRCL', @Datos, NULL, @SQL_ERROR_NUMBER, @SQL_ERROR_MESSAGE, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
SELECT 'Solicitud Enviada con Exito'
ELSE
SELECT Descripcion+' '+ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
RETURN
END

