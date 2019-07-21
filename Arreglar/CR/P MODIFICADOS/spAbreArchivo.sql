SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAbreArchivo
(
@Archivo			varchar(255),
@ManejadorObjeto	int				OUTPUT,
@IDArchivo			int				OUTPUT,
@Ok					int				= NULL OUTPUT,
@OkRef				varchar(255)	= NULL OUTPUT
)

AS BEGIN
DECLARE	@ResultadoOLE                int
EXECUTE @ResultadoOLE = sp_OACreate 'Scripting.FileSystemObject', @ManejadorObjeto OUT
IF @ResultadoOLE <> 0 SELECT @Ok = 71510, @OkRef = @Archivo
EXECUTE @ResultadoOLE = sp_OAMethod @ManejadorObjeto, 'OpenTextFile', @IDArchivo OUT, @Archivo, 8
IF @ResultadoOLE <> 0 SELECT @Ok = 71510, @OkRef = @Archivo
END

