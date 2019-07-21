SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgWebEnvolturaRegaloABC ON WebEnvolturaRegalo

FOR INSERT,UPDATE
AS BEGIN
DECLARE
@ID int,
@SucursaleCommerce varchar(10),
@Imagen		varchar(255),
@DropBox              varchar(50),
@Ruta                 varchar(255),
@WebArtDirectorio		varchar(255),
@Archivo              varchar(255),
@ArchivoDestino       varchar(255),
@Ok                   int,
@OkRef                varchar(255)
DECLARE crActualizar CURSOR local FOR
SELECT ID, SucursaleCommerce, Imagen FROM INSERTED
SELECT @DropBox = DirSFTP, @WebArtDirectorio = WebArtDirectorio FROM WebVersion
OPEN crActualizar
FETCH NEXT FROM crActualizar INTO @ID, @SucursaleCommerce, @Imagen
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Archivo = @WebArtDirectorio+'\Envoltura\'+@Imagen
SELECT @Ruta = @DropBox + '\' + @SucursaleCommerce+'\Imagenes'
IF @Ruta IS NOT NULL
BEGIN
EXEC spCrearFolder @Ruta, @Ok OUTPUT,@OkRef OUTPUT
SELECT @Ruta =@Ruta+'\Envoltura\'
IF @OK IS NULL
EXEC spCrearFolder @Ruta, @Ok OUTPUT,@OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @ArchivoDestino = @Ruta+@Imagen
EXEC spCopiarArchivo @Archivo, @ArchivoDestino, @Ok OUTPUT,@OkRef OUTPUT
END
END
FETCH NEXT FROM crActualizar INTO @ID, @SucursaleCommerce, @Imagen
END
CLOSE crActualizar
DEALLOCATE crActualizar
END

