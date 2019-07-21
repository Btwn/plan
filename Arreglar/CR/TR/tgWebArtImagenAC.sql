SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgWebArtImagenAC ON WebArtImagen

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
@ArchivoDestino       varchar(255),
@eCommerceOffLine     bit
DECLARE crImagen CURSOR local FOR
SELECT ID , IDArt, ArchivoImagen FROM INSERTED
OPEN crImagen
FETCH NEXT FROM crImagen INTO @ID, @IDArt, @Archivo
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Imagen = dbo.fnWebNombreImagen(@Archivo)
SELECT @DropBox = DirSFTP FROM WebVersion
IF EXISTS(SELECT * FROM Sucursal WHERE eCommerce = 1 AND NULLIF(eCommerceSucursal,'') IS NOT NULL)
BEGIN
DECLARE crSucursal CURSOR local FOR
SELECT Sucursal, eCommerceSucursal, /*eCommerceImagenes, */ISNULL(eCommerceOffLine,0)
FROM Sucursal
WHERE eCommerce = 1 AND NULLIF(eCommerceSucursal,'') IS NOT NULL
OPEN crSucursal
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal,/*@CarpetaImagenes,*/ @eCommerceOffLine
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Ruta = @DropBox + '\' + @eCommerceSucursal+'\Imagenes'
IF @eCommerceOffLine = 1
BEGIN
SELECT @Ruta = @DropBox + '\' + @eCommerceSucursal+'\OffLine'
EXEC spCrearFolder @Ruta, @Ok OUTPUT,@OkRef OUTPUT
IF @Ok IS NULL
SELECT @Ruta =@Ruta+'\Imagenes'
EXEC spCrearFolder @Ruta, @Ok OUTPUT,@OkRef OUTPUT
END
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
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal,/*@CarpetaImagenes, */@eCommerceOffLine
END
CLOSE crSucursal
DEALLOCATE crSucursal
END
FETCH NEXT FROM crImagen INTO @ID, @IDArt, @Archivo
END
CLOSE crImagen
DEALLOCATE crImagen
END

