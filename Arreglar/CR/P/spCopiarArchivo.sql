SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCopiarArchivo(
@Origen				varchar(255),
@Destino			varchar(255),
@Ok					int			 = NULL OUTPUT,
@OkRef				varchar(255) = NULL OUTPUT
)

AS
BEGIN
DECLARE @ResultadoOLE		int,
@ManejadorObjeto	int,
@IDArchivo		int
EXECUTE @ResultadoOLE = sp_OACreate 'Scripting.FileSystemObject', @ManejadorObjeto OUT
IF @ResultadoOLE <> 0 SELECT @Ok = 71510, @OkRef = @Origen
EXECUTE @ResultadoOLE = sp_OAMethod @ManejadorObjeto, 'CopyFile', null, @Origen, @Destino
IF @ResultadoOLE <> 0 SELECT @Ok = 71510, @OkRef = @Origen
END

