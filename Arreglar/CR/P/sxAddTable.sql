SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxAddTable
@table_name varchar(50),
@table_group VARCHAR(20),
@ignore_fields text = '',
@sync_cascade_override smallint = NULL,
@channel_override VARCHAR(20) = ''
AS
BEGIN
DECLARE @from VARCHAR(10), @to VARCHAR(10), @sync_cascade_group INT, @sync_cascade_relation INT, @relation CHAR(4), @channel VARCHAR(20), @load_order INT
IF EXISTS (SELECT table_group FROM sx_table_group WHERE table_group = @table_group)
SELECT @sync_cascade_group = sync_cascade, @channel = channel, @load_order = load_order FROM sx_table_group WHERE table_group = @table_group
ELSE
BEGIN
RAISERROR('El Grupo de Tablas no existe', 16, 1)
RETURN
END
IF @channel_override != '' SELECT @channel = @channel_override
DECLARE crMasterEntries CURSOR LOCAL FOR
SELECT group_id_from, group_id_to, sync_cascade_override, relation_type
FROM sx_relations
WHERE table_group = @table_group
OPEN crMasterEntries
FETCH NEXT FROM crMasterEntries INTO @from, @to, @sync_cascade_relation, @relation
WHILE @@FETCH_STATUS = 0
BEGIN
IF @sync_cascade_relation IS NOT NULL SELECT @sync_cascade_group = @sync_cascade_relation
IF @sync_cascade_override IS NOT NULL SELECT @sync_cascade_group = @sync_cascade_override
EXEC sxAddTrigger @table_name, @from, @to, @table_group, @relation, @ignore_fields, @sync_cascade_group, @load_order, @channel
FETCH NEXT FROM crMasterEntries INTO @from, @to, @sync_cascade_group, @relation
END 
CLOSE crMasterEntries
DEALLOCATE crMasterEntries
IF NOT EXISTS (SELECT table_name FROM sx_table WHERE table_group = @table_group AND table_name = @table_name)
INSERT INTO sx_table (table_group, table_name, ignore_fields, sync_cascade_override, channel_override)
VALUES (@table_group, @table_name, @ignore_fields, @sync_cascade_override, @channel)
ELSE UPDATE sx_table SET ignore_fields = @ignore_fields, sync_cascade_override = @sync_cascade_override, channel_override = @channel
WHERE table_group = @table_group AND table_name = @table_name
END

