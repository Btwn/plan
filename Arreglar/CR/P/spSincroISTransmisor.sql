SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spSincroISTransmisor
@Enviar					bit = 1,
@Ok						int			 = NULL OUTPUT,
@OkRef					varchar(255) = NULL OUTPUT,
@SincroISDropBox		bit = 0,
@SincroISDropBoxRuta	varchar(255) = NULL

AS BEGIN
DECLARE
@SQLIdentificador	nvarchar(MAX),
@Insert				nvarchar(MAX),
@InsertGuidRecibido	nvarchar(MAX),
@Comando			nvarchar(MAX),
@Update				nvarchar(MAX),
@Tipo				varchar(20),
@Sucursal			int,
@OServidor			varchar(50),
@DServidor			varchar(50),
@OBase				varchar(50),
@DBase				varchar(50),
@ID					int,
@DSucursal			int,
@GUID				uniqueidentifier,
@ISGUID				uniqueidentifier,
@Retraso			datetime,
@SucursalAnterior	int,
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
@SincroTabla		varchar(100),
@SincroSolicitud	uniqueidentifier,
@Parametros			nvarchar(MAX),
@SincroISDropBoxSuc		bit,
@HabilitarCompresion	bit			
SELECT @Sucursal = Sucursal FROM Version
SELECT @OServidor = Servidor, @OBase = BaseDatosNombre FROM SincroISTransmisorSucursal WHERE Sucursal = @Sucursal
SET @SucursalAnterior = -1
SET @Retraso = NULL
IF @Enviar = 1
BEGIN
DECLARE crIS CURSOR FOR
SELECT ID, SincroGUID, SucursalDestino
FROM IntelisisService
WHERE SucursalDestino <> @Sucursal
AND Estatus = 'SINPROCESAR'
OPEN crIS
FETCH NEXT FROM crIS INTO @ID, @ISGUID, @DSucursal
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF @Sucursal = 0
BEGIN
SELECT @DBase = BaseDatosNombre, @DServidor = Servidor FROM SincroISTransmisorSucursal s JOIN IntelisisService isr ON isr.SucursalDestino = s.Sucursal WHERE isr.ID = @ID
SELECT @SincroISDropBoxSuc = ISNULL(SincroISDropBox, 0), @HabilitarCompresion = ISNULL(HabilitarCompresion, 0) FROM SincroISTransmisorSucursal WHERE Sucursal = @DSucursal 
END
ELSE
BEGIN
SELECT @DBase = BaseDatosNombre, @DServidor = Servidor FROM SincroISTransmisorSucursal WHERE Sucursal = 0
SELECT @SincroISDropBoxSuc = ISNULL(SincroISDropBox, 0), @HabilitarCompresion = ISNULL(HabilitarCompresion, 0) FROM SincroISTransmisorSucursal WHERE Sucursal = @Sucursal 
END
IF @HabilitarCompresion = 1
EXEC spSincroISComprimirPaquete @ID, @Ok OUTPUT, @OkRef OUTPUT
IF @ISGUID IS NULL and @Ok IS NULL
BEGIN
SET @GUID = NEWID()
SET @SQLIdentificador = N' UPDATE  ' + /*RTRIM(@OServidor) + '.' + RTRIM(@OBase) + N'.*/  N'dbo.IntelisisService SET SincroGUID = ' + NCHAR(39) + CONVERT(varchar(100),@GUID) + NCHAR(39) + N' WHERE ID = ' + CONVERT(nchar,@ID)
EXEC sp_executesql @SQLIdentificador
IF @@ERROR <> 0 SET @Ok = 1
END ELSE
BEGIN
SET @GUID = @ISGUID
END
IF @Ok IS NULL
BEGIN
SELECT  @Sistema = Sistema, @Contenido = Contenido, @Referencia = Referencia, @SubReferencia = SubReferencia, @Version = [Version], @Usuario = Usuario, @Solicitud = Solicitud, @Resultado = Resultado, @Estatus = Estatus, @FechaEstatus = FechaEstatus, @ISOk = Ok, @ISOkRef = OkRef, @SincroGUID = SincroGUID, @Conversacion = Conversacion, @SucursalOrigen = SucursalOrigen, @SucursalDestino = SucursalDestino, @SincroTabla = SincroTabla, @SincroSolicitud = SincroSolicitud, @SolicitudBinario = SolicitudBinario  
FROM  dbo.IntelisisService
WHERE ID = CONVERT(varchar,@ID)
IF @SincroISDropBox = 0 OR(@SincroISDropBox = 1 AND @SincroISDropBoxSuc = 0)
BEGIN
SET @Parametros = '@Sistema varchar(100), @Contenido varchar(100), @Referencia varchar(100), @SubReferencia varchar(100), @Version	float, @Usuario varchar(10), @Solicitud varchar(max), @Resultado varchar(max), @Estatus varchar(15), @FechaEstatus datetime, @ISOk int, @ISOkRef varchar(255), @SincroGUID uniqueidentifier, @Conversacion uniqueidentifier, @SucursalOrigen int,  @SucursalDestino	int, @GUID uniqueidentifier, @SincroTabla varchar(100), @SincroSolicitud uniqueidentifier, @Ok int OUTPUT, @OkRef varchar(255) OUTPUT, @SolicitudBinario varbinary(max)' 
SELECT @Insert = 'EXEC [' + RTRIM(@DServidor) + '].' + RTRIM(@DBase) + N'.dbo.spSincroISTransmisorInsertarIS @Sistema, @Contenido, @Referencia, @SubReferencia, @Version, @Usuario, @Solicitud, @SolicitudBinario, @Resultado, @Estatus, @FechaEstatus, @ISOk, @ISOkRef, @SincroGUID,  @Conversacion, @SucursalOrigen, @SucursalDestino, @GUID, @SincroTabla, @SincroSolicitud, @Ok, @OkRef'       
EXEC sp_executesql @Insert, @Parametros,
@Sistema = @Sistema,
@Contenido = @Contenido,
@Referencia = @Referencia,
@SubReferencia = @SubReferencia,
@Version = @Version,
@Usuario = @Usuario,
@Solicitud = @Solicitud,
@SolicitudBinario = @SolicitudBinario, 
@Resultado = @Resultado,
@Estatus = @Estatus,
@FechaEstatus = @FechaEstatus,
@ISOk = @ISOk,
@ISOkRef = @ISOkRef,
@SincroGUID = @SincroGUID,
@Conversacion = @Conversacion,
@SucursalOrigen = @SucursalOrigen,
@SucursalDestino = @SucursalDestino,
@GUID = @GUID,
@SincroTabla = @SincroTabla,
@SincroSolicitud = @SincroSolicitud,
@Ok = @Ok OUTPUT,
@OkRef = @OkRef OUTPUT
IF @@ERROR <> 0 SET @Ok = 1
END
ELSE IF @SincroISDropBox = 1 AND @SincroISDropBoxSuc = 1
BEGIN
EXEC spSincroISTransmisorPaqueteDropBox @Conversacion, @Sucursal, @DSucursal, @SucursalOrigen, @SincroISDropBox, @SincroISDropBoxRuta, @Ok OUTPUT, @OkRef OUTPUT
IF  @Ok IS NULL
EXEC spSincroISTransmisorDropBox @ID, @ISGUID, @Sucursal, @DSucursal, @SucursalOrigen, @SincroTabla, @SubReferencia, @SincroISDropBox, @SincroISDropBoxRuta, @Ok OUTPUT, @OkRef OUTPUT
END
END
IF @Ok IS NULL
BEGIN
UPDATE intelisisservice SET estatus = 'ENVIADO' WHERE ID = CONVERT(varchar,@ID)
IF @@ERROR <> 0 SET @Ok = 1
END
IF @DSucursal <> @SucursalAnterior
BEGIN
SELECT @Retraso = dbo.fnSincroISRetraso(@DSucursal)
SELECT @SucursalAnterior = @DSucursal
END
IF @Retraso IS NOT NULL WAITFOR DELAY @Retraso
FETCH NEXT FROM crIS INTO @ID, @ISGUID, @DSucursal
END
CLOSE crIS
DEALLOCATE crIS
END
END

