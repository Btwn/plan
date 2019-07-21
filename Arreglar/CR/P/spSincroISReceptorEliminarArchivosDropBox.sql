SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spSincroISReceptorEliminarArchivosDropBox
@SincroISDropBox					bit,
@SincroISDropBoxRuta				varchar(255),
@Sucursal							int,
@ISDropBoxDiasResguardoArchivos	int

AS
BEGIN
DECLARE @Estacion							int,
@SincroISDropBoxRutaSucursalProc	varchar(255),
@Nombre							varchar(128),
@NombreAnt						varchar(128),
@NoDias							int,
@Hoy								datetime,
@Archivo							varchar(255),
@Ok								int,
@OkRef							varchar(255)
SELECT @Estacion = @@SPID, @Hoy = GETDATE()
SELECT @SincroISDropBoxRutaSucursalProc = @SincroISDropBoxRuta + '\' + CONVERT(varchar, @Sucursal) + '\Procesados'
EXEC speDocInListarDirectorio @SincroISDropBoxRutaSucursalProc, @Estacion
SELECT @NombreAnt = ''
WHILE(1=1)
BEGIN
SELECT @Nombre = MIN(Nombre)
FROM eDocInDirDetalle
WHERE Estacion = @Estacion
AND Nombre > @NombreAnt
AND Tipo	IN('.zip', '.paq')
IF @Nombre IS NULL BREAK
SELECT @NombreAnt = @Nombre, @Archivo = @SincroISDropBoxRutaSucursalProc + '\' + @Nombre
SELECT @NoDias = DATEDIFF(dd, FechaCreacion, @Hoy)
FROM eDocInDirDetalle
WHERE Estacion = @Estacion
AND Nombre	= @Nombre
IF @NoDias > @ISDropBoxDiasResguardoArchivos
EXEC spEliminarArchivo @Archivo, @Ok OUTPUT, @OkRef OUTPUT
END
RETURN
END

