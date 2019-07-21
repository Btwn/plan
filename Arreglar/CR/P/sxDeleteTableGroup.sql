SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxDeleteTableGroup
@table_group VARCHAR(20)
AS
BEGIN
DECLARE @table_name VARCHAR(50), @from VARCHAR(10), @to VARCHAR(10)
DECLARE crTables CURSOR LOCAL FOR
SELECT t.table_name, r.group_id_from, r.group_id_to
FROM sx_relations r
JOIN sx_table t ON (r.table_group = t.table_group)
WHERE r.table_group = @table_group
OPEN crTables
FETCH NEXT FROM crTables INTO @table_name, @from, @to
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC sxDeleteTrigger @table_name, @from, @to
FETCH NEXT FROM crTables INTO @table_name, @from, @to
END
CLOSE crTables
DEALLOCATE crTables
DELETE FROM sx_table WHERE table_group = @table_group
DELETE FROM sx_table_group WHERE table_group = @table_group
END

