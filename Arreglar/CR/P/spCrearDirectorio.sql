SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCrearDirectorio
(
@Directorio			varchar(255),
@Ok					int = NULL OUTPUT,
@OkRef				varchar(255) = NULL OUTPUT
)

AS
BEGIN
DECLARE
@ResultadoOLE					int,
@ManejadorObjeto				int,
@ManejadorDirectorio			int,
@Existe						int
SET @ManejadorDirectorio = NULL
SET @Existe = 0
EXECUTE @ResultadoOLE = sp_OACreate 'Scripting.FileSystemObject', @ManejadorObjeto OUT
IF @ResultadoOLE <> 0 SELECT @Ok = 71510, @OkRef = @Directorio
EXECUTE @ResultadoOLE = sp_OAMethod @ManejadorObjeto, 'FolderExists', @Existe OUT, @Directorio
IF @ResultadoOLE <> 0 SELECT @Ok = 71640, @OkRef = @Directorio
IF ISNULL(@Existe,0) = 0
BEGIN
EXECUTE @ResultadoOLE = sp_OAMethod @ManejadorObjeto, 'CreateFolder', @ManejadorDirectorio OUT, @Directorio
IF @ResultadoOLE <> 0 SELECT @Ok = 71640, @OkRef = @Directorio
END
IF @ManejadorDirectorio IS NOT NULL
BEGIN
EXECUTE @ResultadoOLE = sp_OADestroy @ManejadorDirectorio
IF @ResultadoOLE <> 0 SELECT @Ok = 71640, @OkRef = @Directorio
END
EXECUTE @ResultadoOLE = sp_OADestroy @ManejadorObjeto
IF @ResultadoOLE <> 0 SELECT @Ok = 71640, @OkRef = @Directorio
END

