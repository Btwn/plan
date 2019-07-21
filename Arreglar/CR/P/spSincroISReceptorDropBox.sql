SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spSincroISReceptorDropBox
@Ok								int				= NULL,
@OkRef							varchar(255)	= NULL

AS
BEGIN
DECLARE @Estacion							int,
@SincroISDropBox					bit,
@SincroISDropBoxRuta				varchar(255),
@Sucursal							int,
@SincroISDropBoxRutaSucursal		varchar(255),
@SincroISDropBoxRutaSucursalProc	varchar(255),
@ArchivoXML						varchar(255),
@ArchivoZIP						varchar(255),
@ArchivoProcesado					varchar(255),
@Nombre							varchar(128),
@NombreAnt						varchar(128),
@XML								varchar(max),
@ID								int,
@iDatos							int,
@Sistema							varchar(100),
@Contenido						varchar(100),
@Referencia						varchar(100),
@SubReferencia					varchar(100),
@Version							float,
@Usuario							varchar(10),
@Solicitud						varchar(max),
@Resultado						varchar(max),
@Estatus							varchar(15),
@FechaEstatus						datetime,
@ISOk								int,
@ISOkRef							varchar(255),
@SincroGUID						uniqueidentifier,
@Conversacion						uniqueidentifier,
@SucursalOrigen					int,
@SucursalDestino					int,
@SincroTabla						varchar(100),
@SincroSolicitud					uniqueidentifier
SELECT @SincroISDropBox		= ISNULL(SincroISDropBox, 0),
@SincroISDropBoxRuta	= dbo.fnDirectorioEliminarDiagonalFinal(SincroISDropBoxRuta),
@Sucursal				= Sucursal
FROM Version
IF @SincroISDropBox = 0 RETURN
SELECT @SincroISDropBoxRutaSucursal = @SincroISDropBoxRuta + '\' + CONVERT(varchar, @Sucursal)
SELECT @SincroISDropBoxRutaSucursalProc = @SincroISDropBoxRutaSucursal + '\Procesados'
EXEC spCrearDirectorio @SincroISDropBoxRutaSucursalProc, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @Estacion = @@SPID
EXEC speDocInListarDirectorio @SincroISDropBoxRutaSucursal, @Estacion
SELECT @NombreAnt = ''
WHILE(1=1)
BEGIN
SELECT @Nombre = MIN(Nombre)
FROM eDocInDirDetalle
WHERE Estacion = @Estacion
AND Nombre > @NombreAnt
AND Tipo	= '.zip'
IF @Nombre IS NULL BREAK
SELECT @NombreAnt = @Nombre
SELECT @ArchivoZIP		 = @SincroISDropBoxRutaSucursal + '\' + @Nombre,
@ArchivoXML		 = @SincroISDropBoxRutaSucursal + '\' + REPLACE(@Nombre, '.zip', '.xml'),
@ArchivoProcesado = @SincroISDropBoxRutaSucursalProc + '\' + @Nombre
IF @Ok IS NULL
EXEC spDescomprimirArchivo @ArchivoZIP, @ArchivoXML, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
EXEC spLeerArchivo @ArchivoXML, @Archivo = @XML OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @XML = '<?xml version="1.0" encoding="windows-1252"?>' + REPLACE(CONVERT(varchar(max), @XML), '<?xml version="1.0" encoding="UTF-8"?>', '')
END
IF @Ok IS NULL
BEGIN
EXEC sp_xml_preparedocument @iDatos OUTPUT, @XML
SELECT @ID				= ID,
@Sistema			= Sistema,
@Contenido			= Contenido,
@Referencia		= Referencia,
@SubReferencia		= SubReferencia,
@Version			= Version,
@Usuario			= Usuario,
@Solicitud			= Solicitud,
@Resultado			= Resultado,
@Estatus			= Estatus,
@FechaEstatus		= FechaEstatus,
@ISOk				= Ok,
@ISOkRef			= OkRef,
@SincroGUID		= SincroGUID,
@Conversacion		= Conversacion,
@SucursalOrigen	= SucursalOrigen,
@SucursalDestino	= SucursalDestino,
@SincroTabla		= SincroTabla,
@SincroSolicitud	= SincroSolicitud
FROM OPENXML (@iDatos, '/IntelisisService/IntelisisService', 3)
WITH (ID				int,
Sistema			varchar(100),
Contenido			varchar(100),
Referencia		varchar(100),
SubReferencia		varchar(100),
Version			float,
Usuario			varchar(10),
Solicitud			varchar(max),
Resultado			varchar(max),
Estatus			varchar(15),
FechaEstatus		datetime,
Ok				int,
OkRef				varchar(255),
Conversacion		uniqueidentifier,
SincroGUID		uniqueidentifier,
SucursalOrigen	int,
SucursalDestino	int,
SincroTabla		varchar(100),
SincroSolicitud	uniqueidentifier)
EXEC sp_xml_removedocument @iDatos
END
IF dbo.fnSincroISReceptorPuedeInsertarDropBox(@ID, @Conversacion) = 1
BEGIN
EXEC spSincroISTransmisorInsertarIS @Sistema, @Contenido, @Referencia, @SubReferencia, @Version, @Usuario, @Solicitud, NULL, @Resultado,
'RECIBIDO', @FechaEstatus, @ISOk, @ISOkRef, @SincroGUID, @Conversacion, @SucursalOrigen, @SucursalDestino,
@SincroGUID, @SincroTabla, @SincroSolicitud, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spEliminarArchivo @ArchivoProcesado, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spMoverArchivo @ArchivoZIP, @ArchivoProcesado, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spSincroISActualizaEstatusPaqueteDropBox @Conversacion, @ID
END
IF @Ok IS NULL
EXEC spEliminarArchivo @ArchivoXML, @Ok OUTPUT, @OkRef OUTPUT
END
RETURN
END

