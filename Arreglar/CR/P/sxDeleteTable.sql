SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxDeleteTable
@table_name VARCHAR(50),
@table_group VARCHAR(20)
AS
BEGIN
DECLARE @from VARCHAR(10), @to VARCHAR(10), @relation CHAR(4), @channel VARCHAR(20), @load_order INT
SELECT @channel = channel, @load_order = load_order FROM sx_table_group WHERE table_group = @table_group
DECLARE crMasterEntries CURSOR LOCAL FOR
SELECT group_id_from, group_id_to, relation_type
FROM sx_relations WHERE table_group = @table_group
OPEN crMasterEntries
FETCH NEXT FROM crMasterEntries INTO @from, @to, @relation
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC sxDeleteTrigger @table_name, @from, @to
FETCH NEXT FROM crMasterEntries INTO @from, @to, @relation
END
CLOSE crMasterEntries
DEALLOCATE crMasterEntries
DELETE FROM sx_table WHERE table_group = @table_group AND table_name = @table_name
END

