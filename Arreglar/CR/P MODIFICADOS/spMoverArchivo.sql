SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMoverArchivo
(
@Origen 			varchar(255),
@Destino			varchar(255),
@Ok				int = NULL OUTPUT,
@OkRef				varchar(255) = NULL OUTPUT
)

AS
BEGIN
DECLARE
@ResultadoOLE				int,
@ManejadorObjeto			int
EXECUTE @ResultadoOLE = sp_OACreate 'Scripting.FileSystemObject', @ManejadorObjeto OUT
IF @ResultadoOLE <> 0 SELECT @Ok = 71510, @OkRef = @Origen
EXECUTE @ResultadoOLE =sp_oamethod @ManejadorObjeto, 'moveFile',null,@Origen, @Destino
IF @ManejadorObjeto IS NOT NULL
BEGIN
EXECUTE @ResultadoOLE = sp_OADestroy @ManejadorObjeto
IF @ResultadoOLE <> 0 SELECT @Ok = 71640, @OkRef = @Origen
END
END

