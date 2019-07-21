SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCopiarTabla
@TablaO			varchar(50),
@Origen   		varchar(50),
@Destino			varchar(50)

AS BEGIN
DECLARE
@Tabla				varchar(50),
@Ok					int,
@Campo				varchar(50),
@SQL					nvarchar(MAX),
@Insert				nvarchar(MAX),
@Values				nvarchar(MAX),
@Contador				int,
@Detalle				int,
@PK					nvarchar(MAX),
@Texto				nvarchar(MAX)
DECLARE crTabla CURSOR FOR
SELECT Tabla
FROM dbo.fnCopiarTabla(@TablaO)
WHERE Tabla IS NOT NULL
OPEN crTabla
FETCH NEXT FROM crTabla INTO @Tabla
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC spSincroISTablaEstructura @Tabla, @SELECT = @Texto OUTPUT, @ExcluirTimeStamp = 1, @ExcluirCalculados = 1, @ExcluirIdentity = 1
SELECT @SQL = '', @Insert = '', @Values = '', @Contador = 0, @Detalle = 0
DECLARE crCampo CURSOR FOR
SELECT Resultado
FROM dbo.fnConvertirTextoaTabla(@Texto+',', 0, ',')
WHERE Resultado NOT IN(@TablaO)
OPEN crCampo
FETCH NEXT FROM crCampo INTO @Campo
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @SQL = @SQL + 'd.' + @Campo + ' = o.' + @Campo + ','
SELECT @Insert = @Insert + @Campo + ' , ', @Values = @Values + @Campo + ','
FETCH NEXT FROM crCampo INTO @Campo
END
CLOSE crCampo
DEALLOCATE crCampo
EXEC spSincroISTablaEstructura @Tabla, @SELECT = @PK OUTPUT, @ExcluirTimeStamp = 1, @ExcluirCalculados = 1, @ExcluirIdentity = 1, @PK = 1
SELECT @Detalle = dbo.fnTablaCamposPK(@PK, ',')
IF @Detalle < 1
BEGIN
IF @TablaO = 'UsuarioAcceso'
BEGIN
SELECT @SQL = SUBSTRING(@SQL, 1, LEN(@SQL)-1)
SELECT @SQL = REPLACE(@SQL, 'd.Usuario = o.Usuario,', '')
SELECT @SQL = 'UPDATE d SET ' + @SQL
SELECT @SQL = @SQL + ' FROM ' + @Tabla + ' o, ' + @Tabla + ' d WHERE o.' + 'Usuario' + ' = ''' + @Origen + ''' AND d.' + 'Usuario' + ' = ''' + @Destino + ''''
END
ELSE
BEGIN
SELECT @SQL = 'UPDATE d SET ' + @SQL + @TablaO +' = ''' + @Destino + ''''
SELECT @SQL = @SQL + ' FROM ' + @Tabla + ' o, ' + @Tabla + ' d WHERE o.' + @TablaO + ' = ''' + @Origen + ''' AND d.' + @TablaO + ' = ''' + @Destino + ''''
END
EXEC sp_executesql @SQL
SELECT @Contador = @@ROWCOUNT
END
IF @Contador = 0 OR @Detalle > 1
BEGIN
IF @TablaO = 'UsuarioAcceso'
BEGIN
SELECT @Values = SUBSTRING(@Values, 1, LEN(@Values)-1)
SELECT @Insert = SUBSTRING(@Insert, 1, LEN(@Insert)-1)
SELECT @Values = REPLACE(@Values, 'Usuario', ''''+@Destino+'''')
SELECT @Insert = 'DELETE ' + @Tabla + ' WHERE ' + 'Usuario' + ' = ''' + @Destino + ''' INSERT ' + @Tabla + ' (' + @Insert + ') '
SELECT @Values = 'SELECT ' + @Values + ' FROM ' + @Tabla + ' WHERE ' + 'Usuario' +' = ''' + @Origen + ''''
END
ELSE
BEGIN
SELECT @Insert = 'DELETE ' + @Tabla + ' WHERE ' + @TablaO + ' = ''' + @Destino + ''' INSERT ' + @Tabla + ' (' + @Insert + @TablaO + ') '
SELECT @Values = 'SELECT ' + @Values + '''' + @Destino + '''' + ' FROM ' + @Tabla + ' WHERE ' + @TablaO +' = ''' + @Origen + ''''
END
SELECT @SQL = @Insert + @Values
EXEC sp_executesql @SQL
END
FETCH NEXT FROM crTabla INTO @Tabla
END
CLOSE crTabla
DEALLOCATE crTabla
RETURN
END

