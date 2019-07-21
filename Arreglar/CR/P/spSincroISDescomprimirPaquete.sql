SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISDescomprimirPaquete
@IDPaquete				int,
@Ok						int = NULL OUTPUT,
@OkRef					varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@ManejadorObjeto			int,
@IDArchivo					int,
@XML						varchar(max),
@XMLBinario					varbinary(max),
@SQL						nvarchar(max),
@RutaCompresor				varchar(1000),
@Archivo					varchar(1000),
@ArchivoComprimido			varchar(1000),
@SucursalOrigen				int,
@SucursalDestino			int,
@Transaccion				varchar(100),
@ObjectToken				int
SELECT @XMLBinario = SolicitudBinario, @SucursalOrigen = SucursalOrigen, @SucursalDestino = SucursalDestino FROM IntelisisService WHERE ID = @IDPaquete
IF @XMLBinario IS NULL RETURN
SELECT @Transaccion = 'spSincroISDescomprimirPaquete' + RTRIM(LTRIM(CONVERT(varchar,@@SPID)))
BEGIN TRANSACTION @Transaccion
SELECT @RutaCompresor = dbo.fnDirectorioEliminarDiagonalFinal(dbo.fnDirectorioEmpaquetadorArchivos())
SELECT @ArchivoComprimido = @RutaCompresor + '\TempSincroISIn_' + RTRIM(LTRIM(CONVERT(varchar,ISNULL(@SucursalOrigen,0)))) + '_' + RTRIM(LTRIM(CONVERT(varchar,ISNULL(@SucursalDestino,0)))) + '_' + RTRIM(LTRIM(CONVERT(varchar,@IDPaquete))) + '.zip'
SELECT @Archivo = @RutaCompresor + '\TempSincroISOut_' + RTRIM(LTRIM(CONVERT(varchar,ISNULL(@SucursalOrigen,0)))) + '_' + RTRIM(LTRIM(CONVERT(varchar,ISNULL(@SucursalDestino,0)))) + '_' + RTRIM(LTRIM(CONVERT(varchar,@IDPaquete))) + '.xml'
IF @Ok IS NULL
EXEC spEliminarArchivo @Archivo, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spEliminarArchivo @ArchivoComprimido, @Ok OUTPUT, @OkRef OUTPUT
EXEC sp_OACreate 'ADODB.Stream', @ObjectToken OUTPUT
EXEC sp_OASetProperty @ObjectToken, 'Type', 1
EXEC sp_OAMethod @ObjectToken, 'Open'
EXEC sp_OAMethod @ObjectToken, 'Write', NULL,@XMLBinario
EXEC sp_OAMethod @ObjectToken, 'SaveToFile', NULL, @ArchivoComprimido, 2
EXEC sp_OAMethod @ObjectToken, 'Close'
EXEC sp_OADestroy @ObjectToken
IF @Ok IS NULL
EXEC spDescomprimirArchivo @ArchivoComprimido, @Archivo, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spLeerArchivo @Archivo, @Archivo = @XML OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
UPDATE IntelisisService SET Solicitud = @XML, SolicitudBinario = NULL WHERE ID = @IDPaquete
IF @Ok IS NULL
EXEC spEliminarArchivo @Archivo, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spEliminarArchivo @ArchivoComprimido, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
COMMIT TRANSACTION @Transaccion
ELSE
ROLLBACK TRANSACTION @Transaccion
END

