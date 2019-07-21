SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCerrarArchivo
(
@IDArchivo			int,
@ManejadorObjeto	int,
@Ok					int = NULL OUTPUT,
@OkRef				varchar(255) = NULL OUTPUT
)

AS
BEGIN
DECLARE  @ResultadoOLE  int
EXECUTE @ResultadoOLE = sp_OAMethod @IDArchivo, 'Close'
IF @ResultadoOLE <> 0 SELECT @Ok = 71540
EXECUTE @ResultadoOLE = sp_OADestroy @IDArchivo
IF @ResultadoOLE <> 0 SELECT @Ok = 71540, @OkRef = 'Close'
EXECUTE @ResultadoOLE = sp_OADestroy @ManejadorObjeto
IF @ResultadoOLE <> 0 SELECT @Ok = 71540, @OkRef = 'Close'
END

