SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgWebArtVariacionCombinacionAC ON WebArtVariacionCombinacion

FOR INSERT,UPDATE
AS BEGIN
DECLARE
@ID                   int,
@IDArt                int,
@DropBox              varchar(50),
@Sucursal             int,
@eCommerceSucursal    varchar(10),
@Ruta                 varchar(255),
@Archivo              varchar(255),
@Ok                   int,
@OkRef                varchar(255),
@Imagen               varchar(255),
@ImagenD              varchar(255),
@ArchivoDestino       varchar(255)
SELECT @ID = ID , @IDArt = IDArt, @Archivo = Imagen FROM INSERTED
SELECT  @ImagenD = Imagen FROM DELETED
SELECT @Imagen = dbo.fnWebNombreImagen(@Archivo)
SELECT @DropBox = DirSFTP FROM WebVersion
IF EXISTS(SELECT * FROM Sucursal WHERE eCommerce = 1 AND NULLIF(eCommerceSucursal,'') IS NOT NULL) AND @Archivo <> @ImagenD
BEGIN
DECLARE crSucursal CURSOR local FOR
SELECT Sucursal, eCommerceSucursal
FROM Sucursal
WHERE eCommerce = 1 AND NULLIF(eCommerceSucursal,'') IS NOT NULL
OPEN crSucursal
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Ruta = @DropBox + '\' + @eCommerceSucursal+'\Imagenes'
/*IF @CarpetaImagenes IS NOT NULL AND @OK IS NULL
BEGIN*/
EXEC spCrearFolder @Ruta, @Ok OUTPUT,@OkRef OUTPUT
SELECT @Ruta =@Ruta+'\'+CONVERT(varchar,@IDArt)+'\'
IF @OK IS NULL
EXEC spCrearFolder @Ruta, @Ok OUTPUT,@OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @ArchivoDestino = @Ruta+@Imagen
EXEC spCopiarArchivo @Archivo, @ArchivoDestino, @Ok OUTPUT,@OkRef OUTPUT
END
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal
END
CLOSE crSucursal
DEALLOCATE crSucursal
END
END

