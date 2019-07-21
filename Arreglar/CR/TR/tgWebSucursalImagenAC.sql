SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgWebSucursalImagenAC ON WebSucursalImagen

FOR INSERT,UPDATE
AS BEGIN
DECLARE
@Sucursal             int,
@DropBox              varchar(50),
@eCommerceSucursal    varchar(10),
@Ruta                 varchar(255),
@Archivo              varchar(255),
@Ok                   int,
@OkRef                varchar(255),
@Imagen               varchar(255),
@ArchivoDestino       varchar(255),
@eCommerceOffLine     bit
SELECT @Sucursal = Sucursal ,  @Archivo = ArchivoImagen FROM INSERTED
SELECT @Imagen = dbo.fnWebNombreImagen(@Archivo)
SELECT @DropBox = DirSFTP FROM WebVersion
SELECT @eCommerceSucursal = eCommerceSucursal, /*@CarpetaImagenes= eCommerceImagenes, */@eCommerceOffLine = ISNULL(eCommerceOffLine,0)
FROM Sucursal
WHERE Sucursal = @Sucursal
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
SELECT @Ruta =@Ruta+'\Sucursal\'
IF @OK IS NULL
EXEC spCrearFolder @Ruta, @Ok OUTPUT,@OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @ArchivoDestino = @Ruta+@Imagen
EXEC spCopiarArchivo @Archivo, @ArchivoDestino, @Ok OUTPUT,@OkRef OUTPUT
END
END

