SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spSincroISReceptorPaqueteDropBox
@Ok								int				= NULL OUTPUT,
@OkRef							varchar(255)	= NULL OUTPUT

AS
BEGIN
DECLARE @Estacion							int,
@SincroISDropBox					bit,
@SincroISDropBoxRuta				varchar(255),
@Sucursal							int,
@SincroISDropBoxRutaSucursal		varchar(255),
@SincroISDropBoxRutaSucursalProc	varchar(255),
@ArchivoXML						varchar(255),
@ArchivoPAQ						varchar(255),
@ArchivoProcesado					varchar(255),
@Nombre							varchar(128),
@NombreAnt						varchar(128),
@XML								varchar(max),
@iDatos							int
CREATE TABLE #SincroISDropBoxPaquete(
RID						int identity(1,1) NOT NULL,
Conversacion			uniqueidentifier,
Paquete					varchar(255),
IntelisisServiceID		int
)
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
AND Tipo	= '.paq'
IF @Nombre IS NULL BREAK
SELECT @NombreAnt = @Nombre
SELECT @ArchivoPAQ		 = @SincroISDropBoxRutaSucursal + '\' + @Nombre,
@ArchivoXML		 = @SincroISDropBoxRutaSucursal + '\' + REPLACE(@Nombre, '.paq', '.xml'),
@ArchivoProcesado = @SincroISDropBoxRutaSucursalProc + '\' + @Nombre
IF @Ok IS NULL
EXEC spDescomprimirArchivo @ArchivoPAQ, @ArchivoXML, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
EXEC spLeerArchivo @ArchivoXML, @Archivo = @XML OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @XML = '<?xml version="1.0" encoding="windows-1252"?>' + REPLACE(@XML, '<?xml version="1.0" encoding="UTF-8"?>', '')
END
IF @Ok IS NULL
BEGIN
EXEC sp_xml_preparedocument @iDatos OUTPUT, @XML
INSERT INTO #SincroISDropBoxPaquete(
Conversacion,		Paquete,
IntelisisServiceID)
SELECT Conversacion,		@Nombre,
IntelisisServiceID
FROM OPENXML (@iDatos, '/SincroISDropBoxPaquete/IntelisisService')
WITH SincroISDropBoxPaquete
INSERT INTO SincroISDropBoxPaquete(
Conversacion,		Paquete,
IntelisisServiceID)
SELECT Conversacion,		@Nombre,
IntelisisServiceID
FROM #SincroISDropBoxPaquete I
WHERE IntelisisServiceID NOT IN(SELECT IntelisisServiceID FROM SincroISDropBoxPaquete WHERE Conversacion = I.Conversacion)
EXEC sp_xml_removedocument @iDatos
END
IF @Ok IS NULL
EXEC spEliminarArchivo @ArchivoXML, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spEliminarArchivo @ArchivoProcesado, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spMoverArchivo @ArchivoPAQ, @ArchivoProcesado, @Ok OUTPUT, @OkRef OUTPUT
END
RETURN
END

