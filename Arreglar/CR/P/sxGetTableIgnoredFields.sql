SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxGetTableIgnoredFields
@table_name varchar(50),
@additional_fields nvarchar(max),
@ignored_fields nvarchar(max) OUTPUT
AS
BEGIN
DECLARE @field_name nvarchar(128)
SELECT @ignored_fields = ''
DECLARE crTimestampFields CURSOR LOCAL FOR
SELECT name FROM sys.columns
WHERE object_id = OBJECT_ID(@table_name)
AND system_type_id = 189
OPEN crTimestampFields
FETCH NEXT FROM crTimestampFields INTO @field_name
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @ignored_fields = @ignored_fields + @field_name + ','
FETCH NEXT FROM crTimestampFields INTO @field_name
END
CLOSE crTimestampFields
DEALLOCATE crTimestampFields
DECLARE crComputedFields CURSOR LOCAL FOR
SELECT name FROM sys.computed_columns
WHERE object_id = OBJECT_ID(@table_name)
OPEN crComputedFields
FETCH NEXT FROM crComputedFields INTO @field_name
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @ignored_fields = @ignored_fields + @field_name + ','
FETCH NEXT FROM crComputedFields INTO @field_name
END
CLOSE crComputedFields
DEALLOCATE crComputedFields
IF @additional_fields IS NOT NULL SELECT @ignored_fields = @ignored_fields + @additional_fields
IF CHARINDEX(',', REVERSE(@ignored_fields)) = 1 SELECT @ignored_fields = SUBSTRING(@ignored_fields, 0, LEN(@ignored_fields))
SELECT @ignored_fields = NULLIF(@ignored_fields, '')
END

