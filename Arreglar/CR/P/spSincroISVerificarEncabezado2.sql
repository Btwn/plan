SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISVerificarEncabezado2
(
@MarcarRegistros			bit = 0,
@Sucursal					int = 0
)

AS BEGIN
DECLARE
@SysTabla				varchar(50),
@Tipo					varchar(20),
@Modulo					varchar(5),
@SQL					nvarchar(MAX),
@JOIN_Encabezado		nvarchar(MAX),
@WHERE_Encabezado		nvarchar(MAX),
@TablaRemota			varchar(50)
DECLARE crSysTabla CURSOR FOR
SELECT SysTabla, dbo.fnSincroISTablaTipo(SysTabla), Modulo
FROM SysTabla
WHERE dbo.fnSincroISTablaTipo(SysTabla) IN ('Movimiento','MovimientoInfo')
AND SincroActivo = 1
ORDER BY SysTabla
OPEN crSysTabla
FETCH NEXT FROM crSysTabla INTO @SysTabla, @Tipo, @Modulo
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC spSincroISTablaEstructura @SysTabla, @JOIN_Encabezado = @JOIN_Encabezado OUTPUT, @WHERE_Encabezado = @WHERE_Encabezado OUTPUT
IF NULLIF(@JOIN_Encabezado,'') IS NOT NULL
BEGIN
SET @TablaRemota = dbo.fnSincroISMovTabla(@Modulo)
IF @MarcarRegistros = 0
BEGIN
SELECT @SQL = N'IF EXISTS(SELECT TOP 1 * FROM ' + @SysTabla + ' ' + @JOIN_Encabezado + ' WHERE ' + @TablaRemota + '.ID IS NULL) SELECT ' + CHAR(39) + @SysTabla + CHAR(39) + ',' + CHAR(39) + @TablaRemota + CHAR(39) + ',* FROM ' + @SysTabla + ' ' + @JOIN_Encabezado + ' WHERE ' + @TablaRemota + '.ID IS NULL'
END ELSE
IF @MarcarRegistros = 1
BEGIN
SELECT @SQL = N'IF EXISTS(SELECT TOP 1 * FROM ' + @SysTabla + ' ' + @JOIN_Encabezado + ' WHERE ' + @TablaRemota + '.ID IS NULL) INSERT SincroISNoRebote (SincroID, Sucursal) SELECT ' + @SysTabla + '.SincroID, ' + RTRIM(LTRIM(CONVERT(varchar,@Sucursal))) + ' FROM ' + @SysTabla + ' ' + @JOIN_Encabezado + ' WHERE ' + @TablaRemota + '.ID IS NULL'
EXEC sp_ExecuteSql @SQL
SELECT @SQL = N'IF EXISTS(SELECT TOP 1 * FROM ' + @SysTabla + ' ' + @JOIN_Encabezado + ' WHERE ' + @TablaRemota + '.ID IS NULL) SELECT ' + CHAR(39) + @SysTabla + CHAR(39) + ',' + CHAR(39) + @TablaRemota + CHAR(39) + ',* FROM ' + @SysTabla + ' ' + @JOIN_Encabezado + ' WHERE ' + @TablaRemota + '.ID IS NULL'
END
EXEC sp_ExecuteSql @SQL
END ELSE
IF NULLIF(@JOIN_Encabezado,'') IS NULL
BEGIN
IF NULLIF(@WHERE_Encabezado,'') IS NOT NULL
BEGIN
IF @MarcarRegistros = 0
BEGIN
SELECT @SQL = N'IF EXISTS(SELECT TOP 1 * FROM ' + @SysTabla + ' WHERE ' + @WHERE_Encabezado + ') SELECT ' + CHAR(39) + @SysTabla + CHAR(39) + ',* FROM ' + @SysTabla + ' WHERE ' + @WHERE_Encabezado + ' '
END ELSE
IF @MarcarRegistros = 1
BEGIN
SELECT @SQL = N'IF EXISTS(SELECT TOP 1 * FROM ' + @SysTabla + ' WHERE ' + @WHERE_Encabezado + ') INSERT SincroISNoRebote (SincroID, Sucursal) SELECT '+ @SysTabla + '.SincroID, ' + RTRIM(LTRIM(CONVERT(varchar,@Sucursal))) + ' FROM ' + @SysTabla + ' WHERE ' + @WHERE_Encabezado + ' '
EXEC sp_ExecuteSql @SQL
SELECT @SQL = N'IF EXISTS(SELECT TOP 1 * FROM ' + @SysTabla + ' WHERE ' + @WHERE_Encabezado + ') SELECT ' + CHAR(39) + @SysTabla + CHAR(39) + ',* FROM ' + @SysTabla + ' WHERE ' + @WHERE_Encabezado + ' '
END
EXEC sp_ExecuteSql @SQL
END
END
FETCH NEXT FROM crSysTabla INTO @SysTabla, @Tipo, @Modulo
END
CLOSE crSysTabla
DEALLOCATE crSysTabla
END

