SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION sxGetFieldsList (@list varchar(20), @search_table varchar(50), @origin_table varchar(50), @target_table varchar(50), @separator varchar(10), @asign smallint/*, @replace smallint*/)
RETURNS varchar(max)
AS
BEGIN
DECLARE @campo nvarchar(128), @sql_fields nvarchar(max), @asignator varchar(150)
set @asignator = ''
IF (@list = 'NonIdentity')
DECLARE crFields CURSOR LOCAL FOR
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @search_table AND TABLE_CATALOG = DB_NAME()
AND COLUMNPROPERTY(OBJECT_ID(TABLE_NAME), COLUMN_NAME,'IsIdentity') = 0
ELSE IF (@list = 'PrimaryKey')
DECLARE crFields CURSOR LOCAL FOR
SELECT cu.COLUMN_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE cu ON (tc.CONSTRAINT_NAME = cu.CONSTRAINT_NAME)
WHERE tc.TABLE_CATALOG = DB_NAME()
AND tc.TABLE_NAME = @search_table AND tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
OPEN crFields
FETCH NEXT FROM crFields INTO @campo
IF @asign = 1 SELECT @asignator = ' = ' + @target_table + '.' + @campo
SELECT @sql_fields = @origin_table + '.' + @campo + @asignator
FETCH NEXT FROM crFields INTO @campo
WHILE @@FETCH_STATUS = 0
BEGIN
IF @asign = 1 SELECT @asignator = ' = ' + @target_table + '.' + @campo
SELECT @sql_fields = @sql_fields + @separator + @origin_table + '.' + @campo + @asignator
FETCH NEXT FROM crFields INTO @campo
END
CLOSE crFields
DEALLOCATE crFields
RETURN @sql_fields
END

