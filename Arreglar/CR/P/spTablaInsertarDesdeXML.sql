SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTablaInsertarDesdeXML
@Tabla			varchar(255),
@iDatos			int,
@Ruta			varchar(255),
@ReemplazarCampo	varchar(100)	= NULL,
@ReemplazarValor	varchar(100)	= NULL

AS BEGIN
DECLARE
@SQL		nvarchar(max),
@SELECT	varchar(max),
@WITH		varchar(max),
@VALUES	varchar(max)
EXEC spTablaEstructura @Tabla, @SELECT = @SELECT OUTPUT, @WITH = @WITH OUTPUT, @VALUES = @VALUES OUTPUT, @ExcluirTimeStamp = 1, @ExcluirCalculados = 1, @ExcluirIdentity = 1, @ReemplazarCampo = @ReemplazarCampo, @ReemplazarValor = @ReemplazarValor
SELECT @SQL = N'INSERT '+@Tabla+N' ('+@SELECT+N') '+
N'SELECT '+@VALUES+N' FROM OPENXML (@iDatos, '''+@Ruta+''', 1) WITH ('+@WITH+N')'
EXEC sp_executesql @SQL, N'@iDatos int', @iDatos = @iDatos
END

