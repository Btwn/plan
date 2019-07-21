SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAgregaCampoHist
@Modulo		varchar(5)

AS
BEGIN
DECLARE
@Tabla				varchar(100),
@hTabla				varchar(100),
@Campo				varchar(100),
@TipoDatos			varchar(100),
@Tamano				int,
@Nulos				bit,
@Calculado			bit,
@TipoDatosTamano	varchar(100),
@Estructura			varchar(255),
@ID					int,
@EsPK				bit,
@ChecarTieneDatos	bit,
@ConDatos			bit,
@SQL				nvarchar(4000)
SELECT @SQL = 'TRUNCATE TABLE HistResultado'
EXEC(@SQL)
SELECT @SQL = ''
DECLARE crTabla CURSOR FOR
SELECT RTRIM(LTRIM(SysTabla))
FROM SysTabla
WHERE Modulo = @Modulo
OPEN crTabla
FETCH NEXT FROM crTabla INTO @Tabla
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @hTabla = 'h'+@Tabla
DECLARE crSysTipoDatos CURSOR FOR
SELECT Campo, TipoDatos, Tamano, Nulos, Calculado
FROM SysTipoDatos
WHERE Tabla = @Tabla
AND Campo NOT IN (NULL, 'SincroID', 'SincroC')
OPEN crSysTipoDatos
FETCH NEXT FROM crSysTipoDatos INTO @Campo, @TipoDatos, @Tamano, @Nulos, @Calculado
WHILE @@FETCH_STATUS = 0
BEGIN
IF NOT EXISTS(SELECT * FROM SysTipoDatos WHERE Tabla = @hTabla AND Campo = @Campo) AND @Calculado = 0
BEGIN
SELECT @SQL = 'EXEC spAlter_Table '+CHAR(39)+@hTabla+CHAR(39)+','+CHAR(39)+@Campo+CHAR(39)+','
SELECT @SQL = @SQL+CHAR(39)+@TipoDatos
IF @TipoDatos IN('char', 'nchar', 'varchar', 'nvarchar')
SELECT @SQL = @SQL+' ('+CAST(@Tamano as varchar(10))+')'
IF @Nulos = 1
SELECT @SQL = @SQL+' NULL'
ELSE
BEGIN
IF @TipoDatos IN('char', 'nchar', 'varchar', 'nvarchar')
SELECT @SQL = @SQL+' NOT NULL DEFAULT '+CHAR(39)+CHAR(39)+' WITH VALUES'
IF @TipoDatos IN('int', 'float', 'money', 'numeric')
SELECT @SQL = @SQL+' NOT NULL DEFAULT '+'0'+' WITH VALUES'
END
SELECT @SQL= @SQL+CHAR(39)
BEGIN TRAN
BEGIN TRY
EXEC(@SQL)
COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK TRAN
END CATCH
END
FETCH NEXT FROM crSysTipoDatos INTO @Campo, @TipoDatos, @Tamano, @Nulos, @Calculado
END
CLOSE crSysTipoDatos
DEALLOCATE crSysTipoDatos
FETCH NEXT FROM crTabla INTO @Tabla
END
CLOSE crTabla
DEALLOCATE crTabla
SELECT @SQL = 'EXEC spHistAuto '+CHAR(39)+LTRIM(RTRIM(@Modulo))+CHAR(39)+', 0'
EXEC(@SQL)
END

