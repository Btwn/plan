SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRegenerarIndices

AS BEGIN
DECLARE
@tablename 			varchar(256), 
@tablename_header 	varchar(300)  
DECLARE tnames_cursor CURSOR FOR SELECT name FROM sysobjects WHERE type = 'U'
OPEN tnames_cursor
FETCH NEXT FROM tnames_cursor INTO @tablename
WHILE (@@fetch_status <> -1)
BEGIN
IF (@@fetch_status <> -2)
BEGIN
SELECT @tablename_header = "Regenerando: " +@tablename
PRINT @tablename_header
DBCC DBREINDEX (@tablename )
PRINT ''
END
FETCH NEXT FROM tnames_cursor INTO @tablename
END
CLOSE tnames_cursor
DEALLOCATE tnames_cursor
END

