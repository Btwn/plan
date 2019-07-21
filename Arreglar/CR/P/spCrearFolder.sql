SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCrearFolder
(
@NuevoFolder			varchar(255),
@Ok				int = NULL OUTPUT,
@OkRef				varchar(255) = NULL OUTPUT
)

AS BEGIN
DECLARE
@ResultadoOLE		int,
@ManejadorObjeto	int,
@Existe			int
SET @Existe = 0
EXECUTE @ResultadoOLE = sp_OACreate 'Scripting.FileSystemObject', @ManejadorObjeto OUT
IF @ResultadoOLE <> 0 SELECT @Ok = 71510, @OkRef = @NuevoFolder
EXECUTE @ResultadoOLE = sp_OAMethod @ManejadorObjeto, 'FolderExists', @Existe OUT, @NuevoFolder
IF @ResultadoOLE <> 0 SELECT @Ok = 71515, @OkRef = @NuevoFolder
IF @Existe = 0
BEGIN
EXECUTE @ResultadoOLE = sp_OAMethod @ManejadorObjeto, 'CreateFolder', @Existe OUT, @NuevoFolder
IF @ResultadoOLE <> 0 SELECT @Ok = 71515, @OkRef = @NuevoFolder
END
EXECUTE @ResultadoOLE = sp_OADestroy @ManejadorObjeto
IF @ResultadoOLE <> 0 SELECT @Ok = 71515, @OkRef = @NuevoFolder
END

