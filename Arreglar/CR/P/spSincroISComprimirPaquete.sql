SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISComprimirPaquete
@IDPaquete				int,
@Ok						int = NULL OUTPUT,
@OkRef					varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@ManejadorObjeto			int,
@IDArchivo					int,
@XML						varchar(max),
@SQL						nvarchar(max),
@RutaCompresor				varchar(1000),
@Archivo					varchar(1000),
@ArchivoComprimido			varchar(1000),
@SucursalOrigen				int,
@SucursalDestino			int,
@Transaccion				varchar(100)
SELECT @XML = Solicitud, @SucursalOrigen = SucursalOrigen, @SucursalDestino = SucursalDestino FROM IntelisisService WHERE ID = @IDPaquete
IF NULLIF(@XML,'') IS NULL RETURN
SELECT @Transaccion = 'spSincroISComprimirPaquete' + RTRIM(LTRIM(CONVERT(varchar,@@SPID)))
BEGIN TRANSACTION @Transaccion
SELECT @RutaCompresor = dbo.fnDirectorioEmpaquetadorArchivos()
SELECT @Archivo = @RutaCompresor + '\TempSincroISIn_' + RTRIM(LTRIM(CONVERT(varchar,ISNULL(@SucursalOrigen,0)))) + '_' + RTRIM(LTRIM(CONVERT(varchar,ISNULL(@SucursalDestino,0)))) + '_' + RTRIM(LTRIM(CONVERT(varchar,@IDPaquete))) + '.xml'
SELECT @ArchivoComprimido = @RutaCompresor + '\TempSincroISOut_' + RTRIM(LTRIM(CONVERT(varchar,ISNULL(@SucursalOrigen,0)))) + '_' + RTRIM(LTRIM(CONVERT(varchar,ISNULL(@SucursalDestino,0)))) + '_' + RTRIM(LTRIM(CONVERT(varchar,@IDPaquete))) + '.zip'
IF @Ok IS NULL
EXEC spEliminarArchivo @Archivo, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spEliminarArchivo @ArchivoComprimido, @Ok OUTPUT, @OkRef OUTPUT
EXEC spSincroISCrearArchivo @Archivo, @XML, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spComprimirArchivo @Archivo, @ArchivoComprimido, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SET @SQL = N' UPDATE IntelisisService' +
N' SET SolicitudBinario = (SELECT * FROM OPENROWSET(BULK ' + CHAR(39)+ @ArchivoComprimido + CHAR(39) + ',SINGLE_BLOB) AS A) ' +
N' WHERE ID = ' + LTRIM(RTRIM(CONVERT(varchar,@IDPaquete)))
EXEC sp_executesql @SQL
END
IF @Ok IS NULL
UPDATE IntelisisService SET Solicitud = NULL WHERE ID = @IDPaquete
IF @Ok IS NULL
EXEC spEliminarArchivo @Archivo, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spEliminarArchivo @ArchivoComprimido, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
COMMIT TRANSACTION @Transaccion
ELSE
ROLLBACK TRANSACTION @Transaccion
END

