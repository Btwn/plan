SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speCommerceCopiarDirectorio
@Ruta                   varchar(255),
@Estacion               int,
@Nivel                  int,
@DropBox                varchar(255),
@ArchivoDestino         varchar(255),
@eCommerceSucursal      varchar(10)

AS BEGIN
DECLARE
@Ok                   int,
@OkRef                varchar(255),
@Nombre               varchar(255),
@Tipo                 varchar(50),
@Archivo              varchar(255)
DECLARE creDocInDir CURSOR LOCAL FOR
SELECT Nombre, Tipo
FROM eCommerceDirDetalle2
WHERE  Estacion = @Estacion  AND Nivel = @Nivel
ORDER BY RowNum
OPEN creDocInDir
FETCH NEXT FROM creDocInDir INTO @Nombre, @Tipo
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Ok = NULL
SELECT @Archivo = @Ruta+'\'+@Nombre
SELECT @ArchivoDestino = REPLACE(@Archivo,'OffLine\','')
IF @Tipo <>'Folder'
BEGIN
EXEC spCopiarArchivo @Archivo, @ArchivoDestino, @Ok OUTPUT,@OkRef OUTPUT
IF @Ok IS NULL
EXEC spEliminarArchivo @Archivo, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Tipo ='Folder'
BEGIN
EXEC spCrearFolder @ArchivoDestino, @Ok OUTPUT, @OkRef OUTPUT
SELECT @Nivel = ISNULL(@Nivel,1)+1
EXEC speCommerceListarDirectorio2 @Archivo, @Estacion, @Nivel
EXEC speCommerceCopiarDirectorio @Archivo, @Estacion, @Nivel, @DropBox,@ArchivoDestino, @eCommerceSucursal
END
IF @Ok IS NULL AND @Tipo <>'Folder'
EXEC spEliminarArchivo @Archivo, @Ok OUTPUT, @OkRef OUTPUT
SELECT @Ok = NULL , @OkRef = NULL, @Archivo = NULL, @ArchivoDestino = NULL
FETCH NEXT FROM creDocInDir INTO @Nombre, @Tipo
END
CLOSE creDocInDir
DEALLOCATE creDocInDir
END

