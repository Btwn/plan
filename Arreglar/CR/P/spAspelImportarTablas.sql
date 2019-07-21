SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spAspelImportarTablas]
(@SrvOrigen	varchar(50),
@BDOrigen		varchar(30),
@Origen		varchar(100),
@Sistema		varchar(30),
@Ruta			varchar(200),
@BaseDatos	varchar(30) OUTPUT,
@Empresa		int)

AS
DECLARE @Tabla			varchar(50),
@TablaAnt		varchar(50),
@Ruta2			varchar(200),
@TablaCursor	nvarchar(50),
@TablaCursor2	nvarchar(50),
@Cs				varchar(200),
@Sql			nvarchar(max),
@Sql1			nvarchar(max),
@RutaCoi		varchar(200),
@RutaCoiCC		varchar(200),
@MaxPer			varchar(30),
@MinPer			varchar(30),
@TablaCat		varchar(30),
@TablaCatD		varchar(30),
@BDatos			varchar(30),
@ValidaEmp		varchar(2),
@Emp			varchar(3),
@TablaEmp		varchar(40),
@TablaEmp2		varchar(40),
@PrimerTabla	bit,
@SqlPolizas		nvarchar(max),
@ODBC			varchar(50),
@Cuenta			int,
@sqlmes			nvarchar(max)
BEGIN
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SELECT @ODBC = RTRIM(Valor) FROM AspelCfgOpcion WHERE Descripcion = 'ODBC'
IF @BaseDatos IS NULL
BEGIN
SET @BDatos = 'Paso' + CONVERT(varchar(30),@Empresa)			
SET @BaseDatos = @Bdatos
END
ELSE
SET @Bdatos = @BaseDatos
SET @Sql = 'IF NOT EXISTS(SELECT * FROM sys.databases WHERE NAME = ' + char(39) + @BDatos + char(39) + ') '
+ ' CREATE DATABASE '+@Bdatos
EXEC sp_ExecuteSQL @Sql
IF @Sistema = 'SAE'
BEGIN
SET @Sql = 'IF EXISTS(SELECT * FROM sys.databases WHERE NAME = ' + char(39) + @BDatos +Char(39) + ') DROP DATABASE ' + @BDatos
+ ' CREATE DATABASE ' + @BDatos
EXEC sp_executesql @Sql
DELETE FROM TblAspelCfg
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('CLIE' + right('00' + convert(varchar, @Empresa),2), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('OCLI' + right('00' + convert(varchar, @Empresa),2), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('FACT' + right('00' + convert(varchar, @Empresa),2), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('PROV' + right('00' + convert(varchar, @Empresa),2), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('OPRV' + right('00' + convert(varchar, @Empresa),2), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('COMP' + right('00' + convert(varchar, @Empresa),2), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('MINV' + right('00' + convert(varchar, @Empresa),2), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('CONM' + right('00' + convert(varchar, @Empresa),2), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('CUEN' + right('00' + convert(varchar, @Empresa),2), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('CONC' + right('00' + convert(varchar, @Empresa),2), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('PAGA' + right('00' + convert(varchar, @Empresa),2), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('CONP' + right('00' + convert(varchar, @Empresa),2), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('VEND' + right('00' + convert(varchar, @Empresa),2), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('MULT' + right('00' + convert(varchar, @Empresa),2), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('INVE' + right('00' + convert(varchar, @Empresa),2), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('OINV' + right('00' + convert(varchar, @Empresa),2), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('IMPU' + right('00' + convert(varchar, @Empresa),2), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('NUMSER' + right('00' + convert(varchar, @Empresa),2), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('MONED' + right('00' + convert(varchar, @Empresa),2), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('CTARUB' + right('00' + convert(varchar, @Empresa),2), 'COI')
IF @Empresa BETWEEN 1 AND 9
BEGIN
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('FA0TY' + ltrim(rtrim(convert(varchar, @Empresa))), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('COM0Y' + ltrim(rtrim(convert(varchar, @Empresa))), 'SAE')
END
ELSE
BEGIN
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('FAYT' +   ltrim(rtrim(convert(varchar, @Empresa))), 'SAE')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('COMY' +   ltrim(rtrim(convert(varchar, @Empresa))), 'SAE')
END
IF @Origen = 'Paradox'
BEGIN
SET @Ruta2 = 'dir /b "' + @Ruta + '\*.DB"'
SET @CS = CHAR(39)+@ODBC+CHAR(39)+', '+CHAR(39)+'paradox 5.x;database='+@Ruta+CHAR(39)
END
IF @Origen = 'Access'
BEGIN
SET @Ruta2 = @Ruta + '\AspelNew.mdb; UID=Admin; PWD='+CHAR(39)+', '+CHAR(39)+'SELECT * FROM '
SET @CS = CHAR(39)+@ODBC+CHAR(39)+', '+CHAR(39)+'MS Access;Database='+@Ruta2+char(39)
END
DECLARE SAE CURSOR FOR
SELECT Tabla
FROM TblAspelCfg
WHERE Sistema = 'SAE'
OPEN SAE
FETCH next FROM SAE INTO @TablaCursor
WHILE @@FETCH_STATUS <> -1
BEGIN
IF ISNUMERIC(RIGHT(@TablaCursor, 2)) = 1
SET @TablaEmp = left(@TablaCursor, len(@TablaCursor) - 2) + '01'
IF @Tablaemp = 'FAYT01'
BEGIN
SET @Tablaemp = 'FA0TY1'
END
IF @Tablaemp = 'COMY01'
BEGIN
SET @Tablaemp = 'COM0Y1'
END
ELSE
SET @TablaEmp = left(@TablaCursor, len(@TablaCursor) - 1) + '1'
IF (@Origen = 'Paradox' or @Origen = 'Access') AND (@TablaCursor IS NOT NULL)
BEGIN
SET @sql = 'SELECT * INTO '+@Bdatos+'..'+@TablaEmp+' FROM OPENROWSET('+@CS+','+@TablaCursor+') '
END
IF @Origen = 'Sql' AND @TablaCursor IS NOT NULL
BEGIN
SET @Sql = 'SELECT * INTO '+@Bdatos+'..'+upper(@TablaEmp)+' FROM '+@SrvOrigen+'.'+@BDOrigen+'.dbo.'+@TablaCursor
END
EXEC SP_EXECUTESQL @sql
INSERT INTO AspelLog VALUES ('SAE',@TablaCursor, GetDate())
FETCH next FROM SAE INTO @TablaCursor
END
CLOSE SAE
DEALLOCATE SAE
END
IF @sistema = 'COI'
BEGIN
DELETE FROM TblAspelCfg
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('CTARUB'  + right('00' + convert(varchar, @Empresa),2), 'COI')
INSERT INTO TblAspelCfg (Tabla, Sistema) VALUES ('RANC' + right('00' + convert(varchar, @Empresa),2), 'COI')
IF @Origen = 'Paradox'
BEGIN
SET @Ruta2 = 'dir /b "' + @Ruta + '\*.DB"'
SET @CS = CHAR(39)+@ODBC+CHAR(39)+', '+CHAR(39)+'paradox 5.x;database='+@Ruta+CHAR(39)
END
IF @Origen = 'Access'
BEGIN
SET @Ruta2 = @Ruta + '\AspelNew.mdb; UID=Admin; PWD='+CHAR(39)+', '+CHAR(39)+'SELECT * FROM '
SET @CS = CHAR(39)+@ODBC+CHAR(39)+', '+CHAR(39)+'MS Access;Database='+@Ruta2
END
DECLARE COI CURSOR FOR
SELECT Tabla
FROM TblAspelCfg
WHERE Sistema = 'COI'
OPEN COI
FETCH next FROM COI INTO @TablaCursor
WHILE @@FETCH_STATUS <> -1
BEGIN
IF ISNUMERIC(RIGHT(@TablaCursor, 2)) = 1
SET @TablaEmp = left(@TablaCursor, len(@TablaCursor) - 2) + '01'
ELSE
SET @TablaEmp = left(@TablaCursor, len(@TablaCursor) - 1) + '1'
IF (@Origen = 'Paradox' or @Origen = 'Access') AND (@TablaCursor IS NOT NULL)
BEGIN
SET @sql = 'SELECT * INTO '+@Bdatos+'..'+@TablaEmp+' FROM OPENROWSET('+@CS+','+@TablaCursor+') '
END
IF @Origen = 'Sql'
BEGIN
SET @Sql = 'SELECT * INTO '+@Bdatos+'..'+@TablaEmp+' FROM '+@SrvOrigen+'.'+@BDOrigen+'.dbo.'+@TablaCursor
END
EXEC SP_EXECUTESQL @sql
INSERT INTO AspelLog VALUES ('COI',@TablaCursor, GetDate())
FETCH next FROM COI INTO @TablaCursor
END
CLOSE COI
DEALLOCATE COI
SET @RutaCoi = 'dir /b "' + @Ruta + '\MO*.DB"'
DELETE FROM TblAspelCfg WHERE Sistema = 'COI'
set @Sql = 'INSERT Into TblAspelCfg (Tabla) '
+ 'select name from ' + @SrvOrigen + '.' + @BDOrigen + '.sys.objects '
+ 'WHERE type in (N' + char(39) + 'U' + char(39) + ') and name like ' + char(39) + 'MO%' + char(39)
EXEC SP_EXECUTESQL @sql
DELETE FROM TblAspelCfg WHERE Sistema = 'COI'
set @Sql = 'INSERT Into TblAspelCfg (Tabla) '
+ 'select name from ' + @SrvOrigen + '.' + @BDOrigen + '.sys.objects '
+ 'WHERE type in (N' + char(39) + 'U' + char(39) + ') and name like ' + char(39) + 'PO%' + char(39)
EXEC SP_EXECUTESQL @sql
UPDATE TblAspelCfg SET Sistema = @Sistema
DELETE FROM TblAspelCfg
WHERE (Sistema = 'COI' AND SUBSTRING(Tabla, 1, 2) <> 'MO')
OR (SUBSTRING(Tabla, 3, 1) = 'N')
IF @Origen = 'Paradox'
BEGIN
SET @RutaCoi = 'dir /b "' + @Ruta + '\*.DB"'
SET @CS = CHAR(39)+@ODBC+CHAR(39)+', '+CHAR(39)+'paradox 5.x;database='+@Ruta+CHAR(39)
END
IF @Origen = 'Access'
BEGIN
SET @RutaCoi = @Ruta + '\AspelNew.mdb; UID=Admin; PWD='+CHAR(39)+', '+CHAR(39)+'SELECT * FROM '
SET @CS = CHAR(39)+@ODBC+CHAR(39)+', '+CHAR(39)+'MS Access;Database='+@RutaCoi+''
END
DECLARE COI CURSOR FOR
SELECT Tabla
FROM TblAspelCfg
WHERE Sistema = 'COI' AND Tabla IS NOT NULL
SET @PrimerTabla = 1
OPEN COI
FETCH NEXT FROM COI INTO @TablaCursor
WHILE @@FETCH_STATUS <> -1
BEGIN
IF ISNUMERIC(RIGHT(@TablaCursor, 2)) = 1
SET @TablaEmp = left(@TablaCursor, len(@TablaCursor) - 2) + '01'
ELSE
SET @TablaEmp = left(@TablaCursor, len(@TablaCursor) - 1) + '1'
SET @TablaEmp2 = replace(@TablaEmp, 'MO', 'PO')
SET @TablaCursor2 = replace(@TablaEmp, 'MO', 'PO')
IF (@Origen = 'Paradox' or @Origen = 'Access') AND (@TablaCursor IS NOT NULL)
BEGIN
SET @sql = 'SELECT * INTO '+@Bdatos+'.dbo.'+@TablaEmp+' FROM OPENROWSET('+@CS+','+@TablaCursor+') '
END
IF @Origen = 'SQL' AND @TablaCursor IS NOT NULL
BEGIN
SET @Sql = 'SELECT * INTO '+@Bdatos+'..'+@TablaEmp+' FROM '+@SrvOrigen+'.'+@BDOrigen+'.dbo.'+ @TablaCursor
SET @Sql1 = 'SELECT * INTO '+@Bdatos+'..'+@TablaEmp2+' FROM '+@SrvOrigen+'.'+@BDOrigen+'.dbo.'+ @TablaCursor2
END
EXEC SP_EXECUTESQL @sql
EXEC SP_EXECUTESQL @sql1
set @sqlmes = 'Update ' + @BDatos + '.dbo.' + @TablaEmp + ' '
+ 'set REFERENCIA = ' + char(39) +  @TablaEmp + char(39)
EXEC SP_EXECUTESQL @Sqlmes
IF @PrimerTabla = 1
BEGIN
SET @SqlPolizas = 'SELECT MO.NUM_REG, MO.TIPO_POLI, MO.NUM_POLIZ, MO.FECHA_POL, MO.NUM_CTA, ' +
'MO.CONCEP_PO, MO.DEBE_HABER, MO.MONTOMOV, MO.NUMDEPTO, MO.TIPCAMBIO, MO.REFERENCIA, ' +
'MO.NUM_PART, MO.CONTRAPAR, PO.CONCEP_PO AS CONCEP_CA ' +
'INTO ' + @Bdatos +
'.dbo.POLIZAS FROM ' + @BDatos + '.dbo.' + @TablaEmp + ' MO, ' +
@BDatos + '.dbo.' + @TablaEmp2 + ' PO ' +
'WHERE MO.NUM_POLIZ = PO.NUM_POLIZ AND MO.TIPO_POLI = PO.TIPO_POLI '
SET @PrimerTabla = 0
END
ELSE
BEGIN
SET @SqlPolizas = @SqlPolizas + 'UNION SELECT MO.NUM_REG, MO.TIPO_POLI, MO.NUM_POLIZ, MO.FECHA_POL, MO.NUM_CTA, ' +
'MO.CONCEP_PO, MO.DEBE_HABER, MO.MONTOMOV, MO.NUMDEPTO, MO.TIPCAMBIO, MO.REFERENCIA, ' +
'MO.NUM_PART, MO.CONTRAPAR, PO.CONCEP_PO AS CONCEP_CA FROM ' + @BDatos + '.dbo.' + @TablaEmp + ' MO, ' +
@BDatos + '.dbo.' + @TablaEmp2 + ' PO ' +
'WHERE MO.NUM_POLIZ = PO.NUM_POLIZ AND MO.TIPO_POLI = PO.TIPO_POLI '
END
INSERT INTO AspelLog VALUES ('COI',@TablaCursor, GetDate())
FETCH next FROM COI INTO @TablaCursor
END
EXEC SP_EXECUTESQL @SqlPolizas
CLOSE COI
DEALLOCATE COI
delete from TblAspelCfg where Sistema = 'COI'
SET @RutaCoiCC = 'dir /b "' + @Ruta + '\CC*.DB"'
set @Sql = 'INSERT Into TblAspelCfg (Tabla) '
+ 'select name from ' + @SrvOrigen + '.' + @BDOrigen + '.sys.objects '
+ 'WHERE type in (N' + char(39) + 'U' + char(39) + ') and name like ' + char(39) + 'CC%' + char(39)
EXEC SP_EXECUTESQL @sql
UPDATE TblAspelCfg SET Sistema = 'COI'
DELETE
FROM TblAspelCfg
WHERE tabla IS NULL
OR tabla like '%.DB'
UPDATE TblAspelCfg
SET Sistema = 'COI'
WHERE Sistema IS NULL
SELECT Tabla, SUBSTRING(Tabla,5,2) + MAX(SUBSTRING(Tabla,3,2)) PeriodoEjercicio
INTO #MaxCat
FROM TblAspelCfg
WHERE SUBSTRING(Tabla,1,2) = 'CC'
AND SUBSTRING(Tabla,1,4) <> 'CC99'
GROUP BY Tabla
SELECT @MaxPer = MAX(PeriodoEjercicio)
FROM #MaxCat
SELECT @TablaCat = Tabla
FROM #MaxCat
WHERE PeriodoEjercicio = @MaxPer
DECLARE COI CURSOR FOR
SELECT Tabla
FROM TblAspelCfg
WHERE Sistema = 'COI' AND Tabla IS NOT NULL
OPEN COI
FETCH NEXT FROM COI INTO @TablaCursor
WHILE @@FETCH_STATUS <> -1
BEGIN
IF ISNUMERIC(RIGHT(@TablaCursor, 2)) = 1
SET @TablaEmp = left(@TablaCursor, len(@TablaCursor) - 2) + '01'
ELSE
SET @TablaEmp = left(@TablaCursor, len(@TablaCursor) - 1) + '1'
IF (@Origen = 'Paradox' or @Origen = 'Access') AND (@TablaCursor IS NOT NULL)
BEGIN
SET @sql = 'SELECT * INTO '+@Bdatos+'.dbo.'+@TablaEmp+' FROM OPENROWSET('+@CS+','+@TablaCursor+') '
END
IF @Origen = 'SQL' AND @TablaCursor IS NOT NULL
BEGIN
SET @Sql = 'SELECT * INTO '+@Bdatos+'..'+@TablaEmp+' FROM '+@SrvOrigen+'.'+@BDOrigen+'.dbo.'+@TablaCursor
END
EXEC SP_EXECUTESQL @sql
INSERT INTO AspelLog VALUES ('COI',@TablaCursor, GetDate())
FETCH next FROM COI INTO @TablaCursor
END
CLOSE COI
DEALLOCATE COI
SET @Sql = ' SELECT num_cta, Nombre, Status, Tipo, LTRIM(cta_Papa) Rama,'
+ 'CASE WHEN DEPTSINO =' + CHAR(39) + 'S' + CHAR(39) + 'THEN ' + CHAR(39) + '1' + char(39) + ' ELSE ' + CHAR(39) + '0' + CHAR(39)
+ ' END AS DEPTSINO,'
+ ' CASE WHEN ltrim(rtrim(NATURALEZA)) =' + CHAR(39) + '0' + CHAR(39) + 'THEN ' + CHAR(39) + '0' + char(39) + ' ELSE ' + CHAR(39) + '1' + CHAR(39)
+ ' END AS NATURALEZA '
+ ' INTO '+@BDatos+'.dbo.CUENTAS '
+ ' FROM ' + @BDatos + '.dbo.' + @TablaCat +' '
EXEC Sp_executeSql @Sql
INSERT INTO AspelLog VALUES ('COI',@TablaCat, GetDate())
SELECT @Cuenta = COUNT(*) FROM TblAspelCfg
WHERE Sistema = 'COI'
SET @Sql =  ''
IF @Cuenta = 1
BEGIN
SELECT @TablaCat = Tabla FROM TblAspelCfg
WHERE Sistema = 'COI'
SET @Sql = 'Select DISTINCT NUM_CTA, INICONTAB, ' + CHAR(39) + @TablaCat + CHAR(39) + ' Tabla '
+ 'FROM ' + @SrvOrigen + '.' + @BDOrigen + '.dbo.' + @TablaCat + ' '
END
IF @Cuenta > 1
BEGIN
DECLARE cur_Tablas CURSOR FOR
SELECT Tabla FROM TblAspelCfg
WHERE Sistema = 'COI'
OPEN cur_Tablas
FETCH NEXT FROM cur_Tablas INTO @TablaCat
WHILE @@FETCH_STATUS <> -1
BEGIN
SET @Sql = @Sql + 'Select DISTINCT NUM_CTA, INICONTAB, ' + CHAR(39) + @TablaCat + CHAR(39) + ' Tabla '
+ 'FROM ' + @SrvOrigen + '.' + @BDOrigen + '.dbo.' + @TablaCat + ' '
+ 'UNION ALL '
FETCH NEXT FROM cur_Tablas INTO @TablaCat
END
SET @Sql = SUBSTRING(@Sql, 1, LEN(@Sql) - 10)
SET @Sql = @Sql + ' Order By NUM_CTA, Tabla '
CLOSE cur_Tablas
DEALLOCATE cur_Tablas
END
SELECT Tabla, SUBSTRING(Tabla,5,2) + MIN(SUBSTRING(Tabla,3,2)) PeriodoEjercicio
INTO #MinCat
FROM TblAspelCfg
WHERE SUBSTRING(Tabla,1,2) = 'CC'
GROUP BY Tabla
SELECT @MinPer = MIN(PeriodoEjercicio)
FROM #MinCat
SELECT @TablaCat = Tabla
FROM #MinCat
WHERE PeriodoEjercicio = @MinPer
SET @Sql = 'INSERT INTO PASO_CTAS(Cuenta, Nombre, SaldoIni, Naturaleza, Periodo, DEPTSINO) '
+ 'SELECT NUM_CTA, NOMBRE, INICONTAB, NATURALEZA, ' + char(39) + @MinPer  + char(39) + ', DEPTSINO FROM ' + @SrvOrigen + '.' + @BDOrigen + '.dbo.' + @TablaCat + ' '
+ 'WHERE INICONTAB <> 0 AND STATUS = ' + CHAR(39) + 'A' + CHAR(39) + ' AND TIPO = ' + CHAR(39) + 'D' + CHAR(39)
EXEC Sp_executeSql @Sql
SET @TablaCatD = 'CD' + substring(@TablaCat, 3, 6)
SET @Sql = 'INSERT INTO PASO_CTASD(Cuenta, Nombre, SaldoIni, Naturaleza, DEPTO) '
+ 'SELECT O.NUM_CTA, O.NOMBRE, D.SLDINIMC, O.NATURALEZA, D.NUMDEPTO '
+ 'FROM ' + @SrvOrigen + '.' + @BDOrigen + '.dbo.' + @TablaCat + ' AS O INNER JOIN '
+ @SrvOrigen + '.' + @BDOrigen + '.dbo.' + @TablaCatD + ' AS D ON O.NUM_CTA = D.DEPCTA '
+ 'WHERE O.INICONTAB <> 0 AND O.STATUS = ' + CHAR(39) + 'A' + CHAR(39) + ' AND O.TIPO = ' + CHAR(39) + 'D' + CHAR(39)
+' AND O.DEPTSINO = ' + CHAR(39) + 'S' + CHAR(39)
EXEC Sp_executeSql @Sql
END
SET ANSI_NULLS OFF
SET ANSI_WARNINGS OFF
END

