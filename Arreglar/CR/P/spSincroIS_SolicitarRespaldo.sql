SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroIS_SolicitarRespaldo
@Usuario			varchar(10)

AS BEGIN
DECLARE
@SucursalOrigen		int,
@SucursalDestino	int,
@Solicitud			uniqueidentifier,
@Conversacion		uniqueidentifier,
@FechaEnvio			datetime,
@SQL				nvarchar(max),
@Datos				xml,
@SQL_ERROR_NUMBER	int,
@SQL_ERROR_MESSAGE	varchar(255),
@Ok					int,
@OkRef				varchar(255),
@SincroISDropBox		bit,
@SincroISDropBoxRuta	varchar(255)
EXEC spSincroISActualizarSesion @Usuario
SELECT @SQL_ERROR_NUMBER = 0, @SQL_ERROR_MESSAGE = NULL
SELECT @Ok = NULL, @OkRef = NULL
SELECT @SucursalOrigen = Sucursal, @SincroISDropBox = ISNULL(SincroISDropBox, 0), @SincroISDropBoxRuta = dbo.fnDirectorioEliminarDiagonalFinal(SincroISDropBoxRuta)
FROM Version
SELECT @SucursalDestino = 0, @FechaEnvio = GETDATE()
IF EXISTS (SELECT * FROM SincroISSolicitud WHERE Tipo = 'Respaldo' AND SucursalOrigen = @SucursalOrigen AND SucursalDestino = @SucursalDestino AND Estatus IN ('PENDIENTE', 'RECIBIENDO','ERROR'))
SELECT @Ok = 17010
IF @SucursalOrigen > 0 AND @Ok IS NULL
BEGIN
BEGIN TRY
BEGIN TRANSACTION
SELECT @Solicitud = NEWID()
SELECT @Conversacion = NEWID()
SELECT @Datos = '<?xml version="1.0" encoding="windows-1252"?><IntelisisSincroIS'+
dbo.fnXML('Tipo', 'SolicitarRespaldo')+
dbo.fnXMLGID('Solicitud', @Solicitud)+
dbo.fnXMLDateTime('FechaEnvio', @FechaEnvio)+
dbo.fnXMLInt('SucursalOrigen', @SucursalOrigen)+
dbo.fnXMLInt('SucursalDestino', @SucursalDestino)+
'/>'
EXEC spSincroISSend 'SolicitarRespaldo', @Datos, @Conversacion, @SucursalOrigen, @SucursalDestino, NULL, @Solicitud, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spSincroISSolicitud @Solicitud, 'Respaldo', @SucursalOrigen, @SucursalDestino, @FechaEnvio = @FechaEnvio, @Estatus = 'PENDIENTE'
COMMIT TRANSACTION
END TRY
BEGIN CATCH
SELECT @SQL_ERROR_NUMBER = ERROR_NUMBER(), @SQL_ERROR_MESSAGE = ERROR_MESSAGE()
ROLLBACK TRANSACTION
END CATCH
END
EXEC spSincroISOk @Solicitud, 'SincroIS/SolicitarRespaldo', @Datos, NULL, @SQL_ERROR_NUMBER, @SQL_ERROR_MESSAGE, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
SELECT 'Solicitud Enviada con Exito'
ELSE
SELECT Descripcion+'. '+ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
IF @Ok IS NULL
EXEC spSincroISTransmisor @SincroISDropBox = @SincroISDropBox, @SincroISDropBoxRuta = @SincroISDropBoxRuta
RETURN
END

