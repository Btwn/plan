SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSLeerArchivo (
@Path   varchar(255)
)
RETURNS varchar(8000)

AS
BEGIN
DECLARE
@Resultado				varchar(max),
@ResultadoOLE			int,
@ManejadorObjeto		int,
@ManejadorTexto			int,
@Ok						int,
@OkRef					varchar(255),
@Ruta					varchar(255),
@Cadena					varchar(8000),
@SiONo					int,
@Origen					varchar(255),
@Descripcion			varchar(255),
@Archivo				varchar(255),
@ID						int
SELECT @Resultado=''
SELECT @OkRef='opening the File System Object'
EXEC @ResultadoOLE = sp_OACreate  'Scripting.FileSystemObject' , @ManejadorObjeto OUT
IF @ResultadoOLE=0
SELECT @Ok=@ManejadorObjeto, @OkRef='Opening file "'+@Path+'"',@Ruta=@Path
IF @ResultadoOLE=0
EXEC @ResultadoOLE = sp_OAMethod   @ManejadorObjeto  , 'OpenTextFile', @ManejadorTexto OUT, @Ruta,1,false,0
WHILE @ResultadoOLE=0
BEGIN
IF @ResultadoOLE=0
SELECT @Ok=@ManejadorTexto, @OkRef='finding out IF there is more to read in "'+@Path+'"'
IF @ResultadoOLE=0
EXEC @ResultadoOLE = sp_OAGetProperty @ManejadorTexto, 'AtENDOfStream', @SiONo OUTPUT
IF @SiONo<>0
BREAK
IF @ResultadoOLE=0
SELECT @Ok=@ManejadorTexto, @OkRef='reading from the OUTPUT file "'+@Path+'"'
IF @ResultadoOLE=0
EXEC @ResultadoOLE = sp_OAMethod  @ManejadorTexto, 'Read', @Cadena OUTPUT,4000
SELECT @Resultado=@Resultado+@Cadena
END
IF @ResultadoOLE=0 SELECT @Ok=@ManejadorTexto, @OkRef='closing the OUTPUT file "'+@Path+'"'
IF @ResultadoOLE=0 EXEC @ResultadoOLE = sp_OAMethod  @ManejadorTexto, 'Close'
IF @ResultadoOLE<>0
BEGIN
EXEC sp_OAGetErrorInfo  @Ok, @Origen OUTPUT,@Descripcion OUTPUT,@Archivo OUTPUT,@ID OUTPUT
SELECT @OkRef='Error while ' + COALESCE(@OkRef,'doing something')+ ', '+COALESCE(@Descripcion,'')
SELECT @Resultado=@OkRef
END
EXEC  sp_OADestroy @ManejadorTexto
RETURN @Resultado
END

