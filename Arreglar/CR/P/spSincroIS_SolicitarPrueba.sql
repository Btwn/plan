SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroIS_SolicitarPrueba
@Usuario			varchar(10)

AS BEGIN
DECLARE
@SucursalOrigen			int,
@SucursalDestino		int,
@Solicitud				uniqueidentifier,
@Conversacion			uniqueidentifier,
@FechaEnvio				datetime,
@Datos					xml,
@SQL_ERROR_NUMBER		int,
@SQL_ERROR_MESSAGE		varchar(255),
@Ok						int,
@OkRef					varchar(255),
@SincroISDropBox		bit,
@SincroISDropBoxRuta	varchar(255)
EXEC spSincroISActualizarSesion @Usuario
SELECT @SQL_ERROR_NUMBER = 0, @SQL_ERROR_MESSAGE = NULL
SELECT @Ok = NULL, @OkRef = NULL
SELECT @SucursalOrigen = Sucursal, @SincroISDropBox = ISNULL(SincroISDropBox, 0), @SincroISDropBoxRuta = dbo.fnDirectorioEliminarDiagonalFinal(SincroISDropBoxRuta) FROM Version
SELECT @SucursalDestino = 0, @FechaEnvio = GETDATE()
IF @SucursalOrigen > 0 AND @Ok IS NULL
BEGIN
BEGIN TRY
BEGIN TRANSACTION
SELECT @Solicitud = NEWID()
SELECT @Conversacion = NEWID()
SELECT @Datos = '<IntelisisSincroIS'+
dbo.fnXML('Tipo', 'SolicitarPrueba')+
dbo.fnXMLGID('Solicitud', @Solicitud)+
dbo.fnXMLDateTime('FechaEnvio', @FechaEnvio)+
dbo.fnXMLInt('SucursalOrigen', @SucursalOrigen)+
dbo.fnXMLInt('SucursalDestino', @SucursalDestino)+
'/>'
EXEC spSincroISSend 'SolicitarPrueba', @Datos, @Conversacion, @SucursalOrigen, @SucursalDestino, NULL, @Solicitud, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spSincroISSolicitud @Solicitud, 'Prueba', @SucursalOrigen, @SucursalDestino, @FechaEnvio, @Estatus = 'PENDIENTE'
COMMIT TRANSACTION
END TRY
BEGIN CATCH
SELECT @SQL_ERROR_NUMBER = ERROR_NUMBER(), @SQL_ERROR_MESSAGE = ERROR_MESSAGE()
ROLLBACK TRANSACTION
END CATCH
END
EXEC spSincroISOk @Solicitud, 'Prueba', @Datos, NULL, @SQL_ERROR_NUMBER, @SQL_ERROR_MESSAGE, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
EXEC spSincroISTransmisor @SincroISDropBox = @SincroISDropBox, @SincroISDropBoxRuta = @SincroISDropBoxRuta
SET ANSI_NULLS OFF
SET ANSI_WARNINGS OFF
END
IF @Ok IS NULL
SELECT 'Solicitud Enviada con Exito'
ELSE
SELECT Descripcion+' '+ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
RETURN
END

