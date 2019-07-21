SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDescomprimirArchivo
@RutaArchivoComprimido	varchar(255),
@RutaArchivo			varchar(255),
@Ok						int			  = NULL OUTPUT,
@OkRef					varchar(255)  = NULL OUTPUT

AS
BEGIN
DECLARE @Shell								varchar(8000),
@DirectorioEmpaquetadorArchivos		varchar(255)
SELECT @DirectorioEmpaquetadorArchivos = dbo.fnDirectorioEmpaquetadorArchivos()
SELECT @Shell = @DirectorioEmpaquetadorArchivos + '\SincroISCompresor.exe d "' + @RutaArchivoComprimido + '" "' + @RutaArchivo + '"'
EXEC xp_cmdshell @Shell, no_output
RETURN
END

