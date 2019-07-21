SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInListarDirectorio
@PathDir            varchar(8000),
@Estacion           int

AS BEGIN
DECLARE
@Contador         int,
@NombreI          varchar(8000) ,
@DirectorioCount  int,
@IsFile           bit,
@ObjFile          int,
@ObjFileSystem    int,
@Nombre           varchar(8000),
@Path             varchar(8000),
@Tipo             varchar(8000),
@Date			   datetime
DECLARE @Directorio table
(RowNum int IDENTITY(1,1),
Nombre varchar(256) PRIMARY KEY CLUSTERED,
Depth  bit,
IsFile bit)
DELETE eDocInDirDetalle WHERE Estacion = @Estacion
SELECT @PathDir = @PathDir+'\'
WHERE RIGHT(@PathDir,1)<>'\'
INSERT INTO @Directorio (Nombre, Depth, IsFile)
EXEC Master.dbo.xp_DirTree @PathDir,1,1
SET @DirectorioCount = @@ROWCOUNT
UPDATE @Directorio
SET Nombre = @PathDir + Nombre
EXEC dbo.sp_OACreate 'Scripting.FileSystemObject', @ObjFileSystem OUT
SET @Contador = 1
WHILE @Contador <= @DirectorioCount
BEGIN
SELECT @NombreI= Nombre, @IsFile = IsFile
FROM @Directorio
WHERE RowNum = @Contador
IF @IsFile = 1 AND @NombreI LIKE '%%'
BEGIN
EXEC dbo.sp_OAMethod @ObjFileSystem,'GetFile',		@ObjFile	OUT, @NombreI
EXEC dbo.sp_OAGetProperty @ObjFile, 'Path',           @Path       OUT
EXEC dbo.sp_OAGetProperty @ObjFile, 'Name',           @Nombre     OUT
EXEC dbo.sp_OAGetProperty @ObjFile, 'DateCreated',	@Date       OUT
INSERT INTO eDocInDirDetalle(Path,  Nombre,  Tipo, Estacion, FechaCreacion)
SELECT @Path,@Nombre,dbo.fnExtencionArchivo(@Nombre), @Estacion, @Date
END
SELECT @Contador = @Contador + 1
END
EXEC sp_OADestroy @ObjFileSystem
EXEC sp_OADestroy @ObjFile
END

