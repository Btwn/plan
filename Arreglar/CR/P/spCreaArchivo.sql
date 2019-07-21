SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCreaArchivo
(@Archivo			varchar(255),
@ManejadorObjeto	Int   OUTPUT,
@IDArchivo			Int   OUTPUT)

AS BEGIN
DECLARE	@ResultadoOLE                int
EXECUTE @ResultadoOLE = sp_OACreate 'Scripting.FileSystemObject', @ManejadorObjeto OUT
IF @ResultadoOLE <> 0 RAISERROR('No es posible abrir el objeto OLE: %s.',10,1,'Scripting.FileSystemObject')
EXECUTE @ResultadoOLE = sp_OAMethod @ManejadorObjeto, 'CreateTextFile', @IDArchivo OUT, @Archivo, 8, 0
IF @ResultadoOLE <> 0 IF @ResultadoOLE <> 0 RAISERROR('No es posible crear el archivo: %s.',10,1,@Archivo)
END

