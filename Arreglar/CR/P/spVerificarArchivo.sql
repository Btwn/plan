SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerificarArchivo
(
@Archivo			varchar(255),
@Existe				int = 0 OUTPUT,
@Ok					int = NULL OUTPUT,
@OkRef				varchar(255) = NULL OUTPUT
)

AS
BEGIN
DECLARE
@ResultadoOLE		int,
@ManejadorObjeto	int
SET @Existe = 0
EXECUTE @ResultadoOLE = sp_OACreate 'Scripting.FileSystemObject', @ManejadorObjeto OUT
IF @ResultadoOLE <> 0 SELECT @Ok = 71510, @OkRef = @Archivo
EXECUTE @ResultadoOLE = sp_OAMethod @ManejadorObjeto, 'FileExists', @Existe OUT, @Archivo
IF @ResultadoOLE <> 0 SELECT @Ok = 71515, @OkRef = @Archivo
EXECUTE @ResultadoOLE = sp_OADestroy @ManejadorObjeto
IF @ResultadoOLE <> 0 SELECT @Ok = 71530, @OkRef = @Archivo
END

