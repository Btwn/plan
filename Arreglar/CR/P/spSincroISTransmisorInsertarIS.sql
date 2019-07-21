SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISTransmisorInsertarIS
@Sistema			varchar(100),
@Contenido			varchar(100),
@Referencia			varchar(100),
@SubReferencia		varchar(100),
@Version			float,
@Usuario			varchar(10),
@Solicitud			varchar(max),
@SolicitudBinario	varbinary(max),  
@Resultado			varchar(max),
@Estatus			varchar(15),
@FechaEstatus		datetime,
@ISOk				int,
@ISOkRef			varchar(255),
@SincroGUID			uniqueidentifier,
@Conversacion		uniqueidentifier,
@SucursalOrigen		int,
@SucursalDestino	int,
@GUID				uniqueidentifier,
@SincroTabla		varchar(100),
@SincroSolicitud	uniqueidentifier,
@Ok		int = NULL OUTPUT,
@OkRef		varchar(255) = NULL OUTPUT

AS BEGIN
IF NOT EXISTS(SELECT * FROM IntelisisService WHERE SincroGUID = CONVERT(varchar(100),@GUID)) AND @GUID IS NOT NULL
BEGIN
INSERT IntelisisService (Sistema,  Contenido,  Referencia,  SubReferencia,  [Version], Usuario,  Solicitud,   SolicitudBinario, Resultado,  Estatus,  FechaEstatus,  Ok,  OkRef,  SincroGUID,  Conversacion,  SucursalOrigen,  SucursalDestino,  SincroTabla,  SincroSolicitud) 
VALUES (@Sistema, @Contenido, @Referencia, @SubReferencia, @Version,  @Usuario, @Solicitud, @SolicitudBinario, @Resultado, @Estatus, @FechaEstatus, @Ok, @OkRef, @SincroGUID, @Conversacion, @SucursalOrigen, @SucursalDestino, @SincroTabla, @SincroSolicitud) 
IF @@ERROR <> 0 SET @Ok = 1
END ELSE IF @GUID IS NULL SET @Ok = 1
IF @Ok IS NULL
IF NOT EXISTS(SELECT * FROM SincroISGUIDRecibido WHERE SincroGUIDRecibido = CONVERT(varchar(100),@GUID)) INSERT SincroISGUIDRecibido (SincroGUIDRecibido) VALUES (CONVERT(varchar(100),@GUID))
END

