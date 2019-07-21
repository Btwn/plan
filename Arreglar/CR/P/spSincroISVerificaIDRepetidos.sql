SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISVerificaIDRepetidos
@Afectar   	bit = 0

AS BEGIN
DECLARE
@SysTabla				varchar(50),
@Ok					int,
@Campo				varchar(50),
@SQL					nvarchar(MAX),
@Parametros			nvarchar(MAX),
@Resultado			bit,
@Tabla				varchar(50),
@SELECT				nvarchar(MAX)
DECLARE @TablaResultado	TABLE
(
Tabla				varchar(50),
Campo				varchar(50)
)
DECLARE crTabla CURSOR FOR
SELECT SysTabla
FROM SysTabla
WHERE SincroActivo = 1
OPEN crTabla
FETCH NEXT FROM crTabla INTO @SysTabla
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
DECLARE crCampoExt CURSOR FOR
SELECT Campo
FROM SysCampoExt
WHERE EsIdentity = 1
AND Tabla = @SysTabla
OPEN crCampoExt
FETCH NEXT FROM crCampoExt INTO @Campo
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SET @Resultado = 0
SET @SQL = 'IF EXISTS(SELECT ' + RTRIM(@Campo) + ', COUNT(*) FROM ' + RTRIM(@SysTabla) + ' GROUP BY ' + RTRIM(@Campo) + ' HAVING COUNT(*) >= 2) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0'
SET @Parametros = '@Resultado bit OUTPUT'
EXEC sp_executesql @SQL, @Parametros, @Resultado = @Resultado OUTPUT
IF @Resultado = 1
BEGIN
INSERT @TablaResultado (Tabla, Campo) VALUES (@SysTabla, @Campo)
EXEC spSincroISTablaEstructura @SysTabla, @SELECT = @SELECT OUTPUT, @ExcluirTimeStamp = 1, @ExcluirCalculados = 1, @ExcluirIdentity = 1
IF @Afectar = 1
BEGIN
SET @SQL = 'SELECT * INTO #' + RTRIM(@SysTabla) + ' FROM ' + RTRIM(@SysTabla) + ' ' + CHAR(13) +
'DELETE FROM ' + RTRIM(@SysTabla) + ' ' + CHAR(13) +
'INSERT ' + RTRIM(@SysTabla) + ' (' + @SELECT + ') ' + CHAR(13) +
'SELECT ' + @SELECT + ' ' + CHAR(13) +
'FROM #' + RTRIM(@SysTabla) + ' ' + CHAR(13) +
'DROP TABLE #' + RTRIM(@SysTabla)
EXEC sp_executesql @SQL
END
END
FETCH NEXT FROM crCampoExt INTO @Campo
END
CLOSE crCampoExt
DEALLOCATE crCampoExt
FETCH NEXT FROM crTabla INTO @SysTabla
END
CLOSE crTabla
DEALLOCATE crTabla
SELECT * FROM @TablaResultado
END

