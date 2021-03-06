SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRegenerarArchivo
@Archivo		varchar(255),
@XML			varchar(max),
@Ok			int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@ManejadorObjeto			int,
@IDArchivo					int,
@Shell						varchar(max)
DECLARE @Datos TABLE
(
Datos		varchar(255)
)
SELECT @ManejadorObjeto = NULL, @IDArchivo = NULL
IF @Ok IS NULL
EXEC spEliminarArchivo @Archivo, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spCrearArchivo @Archivo, @ManejadorObjeto OUTPUT, @IDArchivo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spInsertaEnArchivo2 @IDArchivo, @XML, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spCerrarArchivo @IDArchivo, @ManejadorObjeto, @Ok OUTPUT, @OkRef OUTPUT
END

