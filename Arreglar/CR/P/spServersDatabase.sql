SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spServersDatabase
@Servidor		varchar(100)

AS BEGIN
DECLARE @SQL		nvarchar(255)
DECLARE @Tabla TABLE (
Base			varchar(100),
Tamano			varchar(100),
Propietario		varchar(100),
BaseID			int,
Creada			datetime,
Estatus			varchar(255),
Compabilidad	int
)
SELECT @SQL = N' EXEC ' + @Servidor + '.Master.dbo.sp_helpdb'
INSERT INTO @Tabla
EXEC sp_executesql @SQL, N'@Servidor varchar(100)', @Servidor = @Servidor
SELECT Base FROM @Tabla
END

