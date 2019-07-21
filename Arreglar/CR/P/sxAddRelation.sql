SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxAddRelation
@from VARCHAR(50),
@to VARCHAR(50),
@table_group VARCHAR(50),
@relation_type char(4),
@sync_cascade_override smallint = NULL,
@type VARCHAR(50) = NULL,
@expression varchar(255) = NULL
AS
BEGIN
DECLARE @temp VARCHAR(10), @sync_cascade_final smallint
DECLARE	@table_name VARCHAR(50), @channel VARCHAR(20), @load_order INT, @sync_cascade_group smallint, @sync_cascade_table smallint,
@schema_router varchar(32), @schema_trigger varchar(21), @ignore_fields varchar(max), @channel_override VARCHAR(20)
SELECT @sync_cascade_group = sync_cascade, @channel = channel, @load_order = load_order FROM sx_table_group WHERE table_group = @table_group
EXEC sxAddGroupLink @from, @to
IF NOT EXISTS (SELECT table_group FROM sx_relations WHERE group_id_from = @from AND group_id_to = @to AND table_group = @table_group)
INSERT INTO sx_relations (group_id_from, group_id_to, table_group, relation_type, sync_cascade_override)
VALUES  (@from, @to, @table_group, @relation_type, @sync_cascade_override)
IF @relation_type IN ('both', 'pull') EXEC sxAddRouter @from, @to, @table_group, @type, @expression
IF @relation_type IN ('both', 'push') EXEC sxAddRouter @to, @from, @table_group, @type, @expression
IF (@sync_cascade_override IS NULL OR @sync_cascade_override = 0) SELECT @sync_cascade_override = @sync_cascade_group
IF @relation_type IN ('both', 'push') EXEC sxAddRouter @from, @to, @table_group, @type, @expression
DECLARE crTables CURSOR LOCAL FOR
SELECT table_name, ignore_fields, sync_cascade_override, channel_override FROM sx_table WHERE table_group = @table_group
OPEN crTABLES
FETCH NEXT FROM crTables INTO @table_name, @ignore_fields, @sync_cascade_table, @channel_override
WHILE @@FETCH_STATUS = 0
BEGIN
IF (@sync_cascade_table IS NOT NULL OR @sync_cascade_table = 1) SELECT @sync_cascade_override = @sync_cascade_table
IF (@channel_override IS NOT NULL OR @channel_override != '') SELECT @channel = @channel_override
IF @sync_cascade_group IS NOT NULL SELECT @sync_cascade_final = @sync_cascade_group
IF @sync_cascade_table IS NOT NULL SELECT @sync_cascade_final = @sync_cascade_table
IF @sync_cascade_override IS NOT NULL SELECT @sync_cascade_final = @sync_cascade_override
IF @sync_cascade_final IS NULL SELECT @sync_cascade_final = 0
EXEC sxAddTrigger @table_name, @from, @to, @table_group, @relation_type, @ignore_fields, @sync_cascade_final, @load_order, @channel
FETCH NEXT FROM crTables INTO @table_name, @ignore_fields, @sync_cascade_table, @channel_override
END 
CLOSE crTables
DEALLOCATE crTables
IF NOT EXISTS (SELECT table_group FROM sx_Relations WHERE group_id_from = @from AND group_id_to = @to AND table_group = @table_group)
INSERT INTO sx_relations (group_id_from, group_id_to, table_group, relation_type, sync_cascade_override)
VALUES  (@from, @to, @table_group, @relation_type, @sync_cascade_override)
END

