SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spShrink_Log
@Base		varchar(255)

AS BEGIN
DECLARE @SQL		nvarchar(2000),
@Size		float,
@SizeAnt	float
CREATE TABLE #dbccOpenTran(DatabaseName sysname, OpenTran varchar(30))
WHILE(1=1)
BEGIN
DELETE #dbccopentran
SELECT @SizeAnt = size/128.0
FROM master..sysaltfiles AS saf
JOIN master..sysdatabases AS sdb ON saf.dbid = sdb.dbid
WHERE saf.filename LIKE '%.ldf%'
AND sdb.name = @Base
INSERT INTO #dbccopentran EXEC ('DBCC OPENTRAN WITH TABLERESULTS, NO_INFOMSGS')
IF NOT EXISTS(SELECT * FROM #dbccopentran)
BEGIN
SELECT @SQL = 'USE '+sdb.name+';CHECKPOINT;DBCC SHRINKFILE ('+ CONVERT(varchar(max), saf.fileid)+', 1) WITH NO_INFOMSGS'
FROM master..sysaltfiles AS saf
JOIN master..sysdatabases AS sdb ON saf.dbid = sdb.dbid
WHERE saf.filename LIKE '%.ldf%'
AND sdb.name = @Base
EXEC sp_executesql @SQL
SELECT @Size = size/128.0
FROM master..sysaltfiles AS saf
JOIN master..sysdatabases AS sdb ON saf.dbid = sdb.dbid
WHERE saf.filename LIKE '%.ldf%'
AND sdb.name = @Base
IF ISNULL(@Size, 0) <= ISNULL(@SizeAnt, 0)
BREAK
END
END
END

