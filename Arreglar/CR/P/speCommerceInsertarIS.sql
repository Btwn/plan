SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speCommerceInsertarIS
@MoverArchivos bit = 1,
@NumeroProcesar int = 0

AS BEGIN
DECLARE
@Solicitud   varchar(MAX),
@Resultado   varchar(MAX),
@Nombre      varchar(255),
@ID          int,
@Estacion    int,
@Origen2     varchar(255),
@Destino2    varchar(255),
@Contrasena  varchar(32),
@Existe      int,
@Contador    int,
@Archivo     varchar(255),
@ArchivoDestino varchar(255),
@Ruta        varchar(255),
@RutaProc    varchar(255),
@RutaError   varchar(255),
@DropBox     varchar(255),
@eCommerceSucursal  varchar(10),
@Sucursal    int,
@Usuario     varchar(10),
@Extencion   varchar(255),
@Ok	       int,
@Error       int,
@OkRef       varchar(255)
SELECT @Extencion = '.xml'
IF EXISTS(SELECT * FROM Sucursal WHERE eCommerceOffLine = 1)
EXEC speCommerceMoverArchivosOffline
SELECT @DropBox = DirSFTP, @Usuario = WebUsuario  FROM WebVersion
SELECT @Contrasena = Contrasena FROM Usuario WHERE Usuario = @Usuario
SELECT @Estacion = @@SPID
IF EXISTS(SELECT * FROM Sucursal WHERE eCommerce = 1 AND NULLIF(eCommerceSucursal,'') IS NOT NULL)
BEGIN
DECLARE crSucursal CURSOR local FOR
SELECT Sucursal, eCommerceSucursal
FROM Sucursal
WHERE eCommerce = 1 AND NULLIF(eCommerceSucursal,'') IS NOT NULL
OPEN crSucursal
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Ruta = @DropBox + '\' + @eCommerceSucursal
EXEC speCommerceListarDirectorio @Ruta, @Estacion
IF (ISNULL(@NumeroProcesar, 0) < 1)
SELECT @NumeroProcesar = COUNT(RowNum)
FROM eCommerceDirDetalle
WHERE  Estacion = @Estacion AND Tipo = @Extencion
DECLARE creDocInDir CURSOR FOR
SELECT Nombre
FROM eCommerceDirDetalle
WHERE  Estacion = @Estacion AND Tipo = @Extencion
ORDER BY RowNum
OPEN creDocInDir
FETCH NEXT FROM creDocInDir INTO @Nombre
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL AND @NumeroProcesar > 0
BEGIN
SELECT @Error = NULL, @Ok = NULL, @OkRef = NULL
SELECT @Solicitud =  dbo.fneDocInLeerArchivo(@Ruta,@Nombre)
EXEC spIntelisisService @Usuario, @Contrasena, @Solicitud, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, 1, 0, @ID OUTPUT
IF @Ok IS NOT NULL
SELECT @Error = @Ok, @Ok = NULL , @OkRef = NULL
IF @ID IS NOT NULL
BEGIN
SELECT @Archivo = @Ruta+'\IE_'+CONVERT(varchar,@ID)+'.xml'
EXEC spRegenerarArchivo @Archivo, @Resultado, @Ok OUTPUT,@OkRef OUTPUT
END
SELECT @Archivo = @Ruta+'\'+@Nombre
SELECT @RutaProc = @Ruta +'\Procesados'
IF @Error IS NULL
BEGIN
SELECT @ArchivoDestino = @RutaProc+'\'+@Nombre
IF @MoverArchivos = 1 EXEC spCopiarArchivo @Archivo, @ArchivoDestino, @Ok OUTPUT,@OkRef OUTPUT
END
ELSE
IF @Error IS NOT NULL
BEGIN
SELECT @Ok = null
SELECT @RutaError = @Ruta +'\Errores'
SELECT @ArchivoDestino = @RutaError+'\'+@Nombre
IF @MoverArchivos = 1 EXEC spCopiarArchivo @Archivo, @ArchivoDestino, @Ok OUTPUT,@OkRef OUTPUT
END
IF @MoverArchivos = 1 EXEC spEliminarArchivo @Archivo, @Ok OUTPUT, @OkRef OUTPUT
SELECT @Ok = NULL , @OkRef = NULL
SET @NumeroProcesar = @NumeroProcesar - 1
FETCH NEXT FROM creDocInDir INTO @Nombre
END
CLOSE creDocInDir
DEALLOCATE creDocInDir
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal
END
CLOSE crSucursal
DEALLOCATE crSucursal
END
END

