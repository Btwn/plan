SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRegHistTrigger
@Tabla		varchar(100),
@Estatus	varchar(15)

AS BEGIN
DECLARE
@SELECT			varchar(max),
@SQL			varchar(max),
@SQL1			varchar(max),
@SQL2			varchar(max),
@TABLE			varchar(max),
@SQLINSERTED	varchar(max),
@SQLDELETED		varchar(max)
IF NOT EXISTS(SELECT * FROM sysobjects WHERE id = object_id(@Tabla) and type = 'U')
RETURN
SELECT @SQL = 'if exists (select * from sysobjects where id = object_id(''dbo.tgRegHist'+@Tabla+''') and sysstat & 0xf = 8) drop trigger dbo.tgRegHist'+@Tabla
EXEC (@SQL)
IF UPPER(@Estatus) <> 'ACTIVO' RETURN
SELECT @SQL = '
CREATE TRIGGER tgRegHist'+@Tabla+' ON '+@Tabla+'
FOR INSERT, UPDATE
AS BEGIN
DECLARE
@ID		int,
@Llave		varchar(1000),
@Empresa		varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@EstacionTrabajo	int,
@AccesoID		int
IF dbo.fnEstaSincronizando() = 1 RETURN
IF NOT EXISTS(SELECT * FROM Version WHERE RegHist = 1) RETURN
IF NOT EXISTS(SELECT * FROM CfgRegHist WHERE SysTabla = '''+@Tabla+''' AND UPPER(Estatus) = ''ACTIVO'') RETURN
IF (SELECT COUNT(*) FROM INSERTED) <> 1 RETURN
SELECT @AccesoID = MAX(ID) FROM Acceso WHERE SPID = @@SPID
SELECT @Empresa = Empresa, @Sucursal = Sucursal, @Usuario = Usuario, @EstacionTrabajo = EstacionTrabajo FROM Acceso WHERE ID = @AccesoID
CREATE TABLE #Anterior (Campo varchar(255) COLLATE Database_Default NOT NULL, Valor varchar(255) COLLATE Database_Default NULL)
CREATE TABLE #Nueva (Campo varchar(255) COLLATE Database_Default NOT NULL, Valor varchar(255) COLLATE Database_Default NULL)'
EXEC spTablaEstructura @Tabla, @SELECT = @SELECT OUTPUT, @TABLE = @TABLE OUTPUT, @ExcluirTimeStamp = 1, @ExcluirCalculados = 1, @ExcluirImage = 1, @ExcluirBLOBs = 1, @Prefijo = 'CONVERT(varchar(255), ', @Sufijo = ')', @ASCampo = 1, @ReemplazarTipo = 'varchar(255)'
SELECT @SQLINSERTED = ') SELECT ' + @SELECT + ' FROM INSERTED'
SELECT @SQLDELETED = ') SELECT ' + @SELECT + ' FROM DELETED'
SELECT @SQL = @SQL + '
CREATE TABLE #INSERTED(' + @TABLE + ')'
SELECT @SQL = @SQL + '
CREATE TABLE #DELETED(' + @TABLE + ')'
SELECT @SQL1 = '(Campo, Valor) SELECT Campo, Valor FROM (SELECT '+@SELECT
EXEC spTablaEstructura @Tabla,  @SELECT = @SELECT OUTPUT, @TABLE = @TABLE OUTPUT, @ExcluirTimeStamp = 1, @ExcluirCalculados = 1, @ExcluirImage = 1, @ExcluirBLOBs = 1, @ReemplazarTipo = 'varchar(255)'
SELECT @SQL = @SQL + '
INSERT INTO #INSERTED(' + @SELECT + @SQLINSERTED
SELECT @SQL = @SQL + '
INSERT INTO #DELETED(' + @SELECT + @SQLDELETED
SELECT @SQL1 = @SQL1 +' FROM '
SELECT @SQL2 = ') Origen UNPIVOT (Valor FOR Campo IN ('+@SELECT+')) AS Resultado'
SELECT @SQL = @SQL + '
INSERT #Anterior '+@SQL1 + '#DELETED'+@SQL2
SELECT @SQL = @SQL + '
INSERT #Nueva '+@SQL1 + '#INSERTED'+@SQL2
SELECT @SQL = @SQL + '
EXEC spRegHistTriggerPK '''+@Tabla+''', @Llave OUTPUT
IF @Llave IS NOT NULL
BEGIN
INSERT RegHist (SysTabla, Llave, Empresa, Sucursal, Usuario, EstacionTrabajo) VALUES ('''+@Tabla+''', @Llave, @Empresa, @Sucursal, @Usuario, @EstacionTrabajo)
SELECT @ID = SCOPE_IDENTITY()
IF EXISTS(SELECT * FROM CfgRegHistCampo WHERE SysTabla = '''+@Tabla+''')
INSERT RegHistD (SysTabla, Llave, ID, Campo,    Valor,   ValorAnterior)
SELECT '''+@Tabla+''', @Llave, @ID, n.Campo, n.Valor, a.Valor
FROM #Nueva n
LEFT OUTER JOIN #Anterior a ON a.Campo = n.Campo
WHERE ISNULL(a.Valor, '''') <> ISNULL(n.Valor, '''') AND n.Campo IN (SELECT Campo FROM CfgRegHistCampo WHERE SysTabla = '''+@Tabla+''')
ELSE
INSERT RegHistD (SysTabla, Llave, ID, Campo,    Valor,   ValorAnterior)
SELECT '''+@Tabla+''', @Llave, @ID, n.Campo, n.Valor, a.Valor
FROM #Nueva n
LEFT OUTER JOIN #Anterior a ON a.Campo = n.Campo
WHERE ISNULL(a.Valor, '''') <> ISNULL(n.Valor, '''')
IF @@ROWCOUNT = 0
DELETE RegHist WHERE SysTabla = '''+@Tabla+''' AND Llave = @Llave AND ID = @ID
END
DROP TABLE #Anterior
DROP TABLE #Nueva
END'
EXEC (@SQL)
RETURN
END

