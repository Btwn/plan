SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroIS_Recibir
@Usuario	varchar(10),
@Debug		bit	= 0

AS BEGIN
DECLARE
@TipoMensaje			nvarchar(256),
@iDatos					int,
@Brincar				bit,
@Ok						int,
@OkRef					varchar(255),
@ID						int,
@Sistema				varchar(100),
@Contenido				varchar(100),
@Referencia				varchar(100),
@SubReferencia			varchar(100),
@Version				float,
@Solicitud				varchar(max),
@SolicitudBinario		varbinary(max),  
@HabilitarCompresion	bit,    
@Resultado				varchar(max),
@Estatus				varchar(15),
@FechaEstatus			datetime,
@ISOk					int,
@ISOkRef				varchar(255),
@Conversacion			uniqueidentifier,
@SincroGUID				uniqueidentifier,
@IntelisisServiceID		int,
@FechaRecibo			datetime,
@UsuarioIS				varchar(10),
@SucursalLocal			int,
@SucursalOrigen			int,
@SucursalDestino		int,
@Detener				int,
@GUIDSolicitud			uniqueidentifier,
@SincroTabla			varchar(100)
SELECT @SucursalLocal = Sucursal FROM Version
EXEC spSincroISActualizarSesion @Usuario
UPDATE IntelisisService
SET Estatus = 'SINPROCESAR'
FROM IntelisisService iss JOIN IntelisisServiceBorrador isb
ON isb.ID = iss.ID
IF NOT EXISTS(SELECT * FROM IntelisisService WHERE Referencia = 'SincroIS' AND Estatus IN ('SINPROCESAR','ERROR') AND SucursalDestino = @SucursalLocal) RETURN
DECLARE @ConversacionTemporal table
(
Conversacion				uniqueidentifier
)
DECLARE @IntelisisService table
(
ID						int NOT NULL identity(1,1),
IntelisisServiceID		int NULL,
Sistema					varchar(100) COLLATE DATABASE_DEFAULT NULL,
Contenido					varchar(100) COLLATE DATABASE_DEFAULT NULL,
Referencia				varchar(100) COLLATE DATABASE_DEFAULT NULL,
SubReferencia				varchar(100) COLLATE DATABASE_DEFAULT NULL,
[Version]					float NULL,
Usuario					varchar(10) COLLATE DATABASE_DEFAULT NULL,
Solicitud					varchar(max) COLLATE DATABASE_DEFAULT NULL,
SolicitudBinario			varbinary(max)   NULL, 
Resultado					varchar(max) COLLATE DATABASE_DEFAULT NULL,
Estatus					varchar(15) COLLATE DATABASE_DEFAULT NULL,
FechaEstatus				datetime NULL,
Ok						int NULL,
OkRef						varchar(255) COLLATE DATABASE_DEFAULT NULL,
Conversacion				uniqueidentifier NULL,
SincroGUID				uniqueidentifier NULL,
SucursalOrigen			int			NULL,
SucursalDestino			int			NULL,
Detener					int NULL DEFAULT 0,
SincroTabla				varchar(100) COLLATE DATABASE_DEFAULT NULL,
HabilitarCompresion		bit				 NULL 
)
INSERT @IntelisisService (IntelisisServiceID,  Sistema, Contenido, Referencia, SubReferencia, [Version], Usuario, Solicitud, SolicitudBinario, Resultado, Estatus, FechaEstatus, Ok, OkRef, Conversacion, SincroGUID, SucursalOrigen, SucursalDestino, Detener, SincroTabla) 
SELECT  ID,                  Sistema, Contenido, Referencia, SubReferencia, [Version], Usuario, Solicitud, SolicitudBinario, Resultado, Estatus, FechaEstatus, Ok, OkRef, Conversacion, SincroGUID, SucursalOrigen, SucursalDestino, 0,       SincroTabla 
FROM IntelisisService
WHERE Referencia = 'SincroIS' AND Estatus IN ('SINPROCESAR','ERROR')
AND SucursalDestino = @SucursalLocal
AND ISNULL(SincroTabla,'') = 'IDRemoto'
AND RTRIM(SubReferencia) NOT IN ('SincroFinal')
ORDER BY ID
INSERT @IntelisisService (IntelisisServiceID,  Sistema, Contenido, Referencia, SubReferencia, [Version], Usuario, Solicitud, SolicitudBinario, Resultado, Estatus, FechaEstatus, Ok, OkRef, Conversacion, SincroGUID, SucursalOrigen, SucursalDestino, Detener, SincroTabla) 
SELECT  ID,                  Sistema, Contenido, Referencia, SubReferencia, [Version], Usuario, Solicitud, SolicitudBinario, Resultado, Estatus, FechaEstatus, Ok, OkRef, Conversacion, SincroGUID, SucursalOrigen, SucursalDestino, 0,       SincroTabla 
FROM IntelisisService
WHERE Referencia = 'SincroIS' AND Estatus IN ('SINPROCESAR','ERROR')
AND SucursalDestino = @SucursalLocal
AND ISNULL(SincroTabla,'') NOT IN ('IDRemoto')
AND RTRIM(SubReferencia) NOT IN ('SincroFinal')
ORDER BY ID
INSERT @IntelisisService (IntelisisServiceID,  Sistema, Contenido, Referencia, SubReferencia, [Version], Usuario, Solicitud, SolicitudBinario, Resultado, Estatus, FechaEstatus, Ok, OkRef, Conversacion, SincroGUID, SucursalOrigen, SucursalDestino, Detener, SincroTabla) 
SELECT  ID,                  Sistema, Contenido, Referencia, SubReferencia, [Version], Usuario, Solicitud, SolicitudBinario, Resultado, Estatus, FechaEstatus, Ok, OkRef, Conversacion, SincroGUID, SucursalOrigen, SucursalDestino, 0,       SincroTabla 
FROM IntelisisService
WHERE Referencia = 'SincroIS' AND Estatus IN ('SINPROCESAR','ERROR')
AND SucursalDestino = @SucursalLocal
AND ISNULL(SincroTabla,'') NOT IN ('IDRemoto')
AND RTRIM(SubReferencia) IN ('SincroFinal')
ORDER BY ID
UPDATE @IntelisisService SET HabilitarCompresion = 1 WHERE SolicitudBinario IS NOT NULL  
DELETE @IntelisisService WHERE SolicitudBinario IS NULL AND Solicitud IS NULL
/*
INSERT @IntelisisService (IntelisisServiceID,  Sistema, Contenido, Referencia, SubReferencia, [Version], Usuario, Solicitud, Resultado, Estatus, FechaEstatus, Ok, OkRef, Conversacion, SincroGUID, SucursalOrigen, SucursalDestino, Detener, SincroTabla)
SELECT  ID,                  Sistema, Contenido, Referencia, SubReferencia, [Version], Usuario, Solicitud, Resultado, Estatus, FechaEstatus, Ok, OkRef, Conversacion, SincroGUID, SucursalOrigen, SucursalDestino, 0,       SincroTabla
FROM IntelisisService
WHERE Referencia = 'SincroIS' AND Estatus IN ('SINPROCESAR','ERROR')
AND SucursalDestino = @SucursalLocal
AND SincroTabla NOT IN ('IDRemoto')
AND dbo.fnSincroISTablaConCampoIdentity(SincroTabla) = 0
ORDER BY ID
*/
WHILE EXISTS(SELECT * FROM @IntelisisService WHERE Referencia = 'SincroIS' AND Estatus IN ('SINPROCESAR','ERROR') AND SucursalDestino = @SucursalLocal) AND @Ok IS NULL
BEGIN
SELECT @ID = ID, @IntelisisServiceID = IntelisisServiceID, @Sistema = Sistema, @Contenido = Contenido, @Referencia = Referencia, @SubReferencia = SubReferencia, @Version = [Version],  @UsuarioIS = Usuario, @Solicitud = Solicitud, @SolicitudBinario = SolicitudBinario, @HabilitarCompresion = ISNULL(HabilitarCompresion, 0), @Resultado = Resultado, @Estatus = Estatus, @FechaEstatus = FechaEstatus, @ISOk = Ok, @ISOkRef = OkRef, @Conversacion = Conversacion, @SincroGUID = SincroGUID, @SucursalOrigen = SucursalOrigen, @SucursalDestino = SucursalDestino, @Detener = Detener, @SincroTabla = SincroTabla FROM @IntelisisService WHERE Referencia = 'SincroIS' AND Estatus IN ('SINPROCESAR','ERROR') AND ID = (SELECT MIN(ID) FROM @IntelisisService WHERE Referencia = 'SincroIS' AND Estatus IN ('SINPROCESAR','ERROR') AND SucursalDestino = @SucursalLocal) AND SucursalDestino = @SucursalLocal 
IF @HabilitarCompresion = 1
BEGIN
EXEC spSincroISDescomprimirPaquete @IntelisisServiceID
UPDATE i SET i.Solicitud = IntelisisService.Solicitud FROM @IntelisisService i JOIN IntelisisService ON i.IntelisisServiceID = IntelisisService.ID WHERE i.IntelisisServiceID = @IntelisisServiceID
SELECT @Solicitud = Solicitud FROM @IntelisisService WHERE IntelisisServiceID = @IntelisisServiceID
END
SELECT @TipoMensaje = 'SincroIS/' + @SubReferencia
BEGIN TRANSACTION
IF @SubReferencia NOT IN ('SincroFinal')
BEGIN
EXEC sp_xml_preparedocument @iDatos OUTPUT, @Solicitud
BEGIN TRY
SET @Brincar = 0
EXEC spSincroISProcesarMensaje @Conversacion, @TipoMensaje, @iDatos, @Brincar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @Debug = @Debug
END TRY
BEGIN CATCH
SELECT @Ok = ERROR_NUMBER(), @OkRef = ERROR_MESSAGE()
BREAK
END CATCH
EXEC sp_xml_removedocument @iDatos
END ELSE
BEGIN
IF NOT EXISTS(SELECT * FROM @IntelisisService WHERE RTRIM(Referencia) = 'SincroIS' AND RTRIM(SubReferencia) = 'Sincro' AND RTRIM(Estatus) IN ('SINPROCESAR','ERROR') AND SucursalDestino = @SucursalLocal AND Conversacion = @Conversacion)
BEGIN
EXEC sp_xml_preparedocument @iDatos OUTPUT, @Solicitud
BEGIN TRY
SET @Brincar = 0
EXEC spSincroISProcesarMensaje @Conversacion, @TipoMensaje, @iDatos, @Brincar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @Debug = @Debug
END TRY
BEGIN CATCH
SELECT @Ok = ERROR_NUMBER(), @OkRef = ERROR_MESSAGE()
BREAK
END CATCH
EXEC sp_xml_removedocument @iDatos
END ELSE
SET @Brincar = 1
END
IF @Brincar = 0
BEGIN
UPDATE IntelisisService
SET Estatus = CASE WHEN @Ok IS NULL THEN 'PROCESADO' ELSE 'ERROR' END,
Ok = @Ok,
OkRef = @OkRef
WHERE ID = @IntelisisServiceID
IF @HabilitarCompresion = 1
UPDATE IntelisisService SET Solicitud = NULL, SolicitudBinario = @SolicitudBinario WHERE ID = @IntelisisServiceID
DELETE FROM @IntelisisService WHERE ID = @ID
IF @Ok IS NULL UPDATE @IntelisisService SET Detener = 0 WHERE Detener > 0
IF @Ok IS NOT NULL
BEGIN
EXEC sp_xml_preparedocument @iDatos OUTPUT, @Solicitud
BEGIN TRY
EXEC spSincroISObtenerSolicitud @iDatos, @GUIDSolicitud OUTPUT
END TRY
BEGIN CATCH
SELECT @Ok = ERROR_NUMBER(), @OkRef = ERROR_MESSAGE()
BREAK
END CATCH
EXEC sp_xml_removedocument @iDatos
EXEC spSincroISSolicitud @GUIDSolicitud, @Estatus = 'ERROR'
EXEC spSincroISEnviarCorreo @IntelisisServiceID
END
END ELSE
IF @Brincar = 1
BEGIN
IF ISNULL(@Detener,0) < 5
BEGIN
DELETE FROM @IntelisisService WHERE ID = @ID
INSERT @IntelisisService (IntelisisServiceID,  Sistema,  Contenido,  Referencia,  SubReferencia,  [Version], Usuario,    Solicitud,   SolicitudBinario,  Resultado,  Estatus,  FechaEstatus,  Ok,  OkRef,  Conversacion,  SincroGUID,  SucursalOrigen,  SucursalDestino,  Detener,                SincroTabla,  HabilitarCompresion) 
VALUES (@IntelisisServiceID, @Sistema, @Contenido, @Referencia, @SubReferencia, @Version,  @UsuarioIS, @Solicitud, @SolicitudBinario,  @Resultado, @Estatus, @FechaEstatus, @Ok, @OkRef, @Conversacion, @SincroGUID, @SucursalOrigen, @SucursalDestino, ISNULL(@Detener,0) + 1, @SincroTabla, @HabilitarCompresion) 
END
BEGIN
IF @Detener = 5
BEGIN
SELECT @Ok = 72080
EXEC sp_xml_preparedocument @iDatos OUTPUT, @Solicitud
BEGIN TRY
EXEC spSincroISObtenerSolicitud @iDatos, @GUIDSolicitud OUTPUT
END TRY
BEGIN CATCH
SELECT @Ok = ERROR_NUMBER(), @OkRef = ERROR_MESSAGE()
BREAK
END CATCH
EXEC sp_xml_removedocument @iDatos
EXEC spSincroISSolicitud @GUIDSolicitud, @Estatus = 'ERROR'
UPDATE IntelisisService SET Estatus = 'ERROR', Ok = @Ok, OkRef = @OkRef WHERE ID = @IntelisisServiceID
EXEC spSincroISEnviarCorreo @IntelisisServiceID
END
END
END
INSERT @ConversacionTemporal (Conversacion) VALUES (@Conversacion)
IF @Debug = 1
BEGIN
ROLLBACK TRANSACTION
BREAK
END ELSE
COMMIT TRANSACTION
END
UPDATE IntelisisService SET Estatus = 'SINPROCESAR'
FROM IntelisisService inser JOIN @ConversacionTemporal c
ON inser.Conversacion = c.Conversacion
WHERE inser.Estatus = 'BORRADOR'
RETURN
END

