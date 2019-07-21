SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxAddTrigger
@table_name VARCHAR(50),
@from VARCHAR(10),
@to VARCHAR(10),
@table_group VARCHAR(20),
@relation CHAR(4) = 'both',
@additional_ignore_fields nvarchar(max) = NULL,
@sync_cascade SMALLINT = 1,
@load_order INT = 200,
@channel VARCHAR(20) = 'normal'
AS
BEGIN
DECLARE @trigger_id_from VARCHAR(50), @trigger_id_to VARCHAR(50), @router_id_from VARCHAR(50), @router_id_to VARCHAR(50), @ignore_fields nvarchar(max)
SELECT @router_id_from = 'rt_'+@table_group+'_'+@from+'_'+@to
SELECT @router_id_to = 'rt_'+@table_group+'_'+@to+'_'+@from
SELECT @trigger_id_from = 'tg_dn_'+@from+'_'+@table_name
SELECT @trigger_id_to = 'tg_up_'+@to+'_'+@table_name
EXEC sxGetTableIgnoredFields @table_name, @additional_ignore_fields,  @ignore_fields OUTPUT
SELECT @ignore_fields = CONVERT(text, @ignore_fields)
IF @relation IN ('both', 'push')
BEGIN
IF EXISTS (SELECT * FROM sx_trigger WHERE trigger_id LIKE 'tg_up_'+@from+'_'+@table_name)
UPDATE sx_trigger SET sync_on_incoming_batch = 1, excluded_column_names = @ignore_fields WHERE trigger_id LIKE 'tg_up_'+@from+'_'+@table_name
IF NOT EXISTS (SELECT * FROM sx_trigger WHERE trigger_id = @trigger_id_to )
INSERT INTO sx_trigger (trigger_id, source_table_name, channel_id, excluded_column_names, sync_on_incoming_batch, create_time, last_update_time)
VALUES (@trigger_id_to, @table_name, @channel, @ignore_fields, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ELSE
UPDATE sx_trigger SET sync_on_update = 1, sync_on_insert = 1, sync_on_delete = 1, channel_id = @channel, excluded_column_names = @ignore_fields WHERE trigger_id = @trigger_id_to
IF NOT EXISTS (SELECT * FROM sx_trigger_router WHERE trigger_id = @trigger_id_to AND router_id = @router_id_to)
INSERT INTO sx_trigger_router (trigger_id, router_id, initial_load_order, create_time, last_update_time)
VALUES (@trigger_id_to, @router_id_to, @load_order, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END
IF @relation IN ('both', 'pull')
BEGIN
IF EXISTS (SELECT trigger_id FROM sx_trigger_router WHERE trigger_id LIKE 'tg_dn_%_'+@table_name AND router_id LIKE 'rt_%_'+@from)
SELECT @sync_cascade = 1
IF NOT EXISTS (SELECT * FROM sx_trigger WHERE trigger_id = @trigger_id_from)
INSERT INTO sx_trigger (trigger_id, source_table_name, channel_id, excluded_column_names, sync_on_incoming_batch, create_time, last_update_time)
VALUES (@trigger_id_from, @table_name, @channel, @ignore_fields, @sync_cascade, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ELSE
UPDATE sx_trigger SET sync_on_update = 1, sync_on_insert = 1, sync_on_delete = 1, channel_id = @channel, excluded_column_names = @ignore_fields, sync_on_incoming_batch = @sync_cascade WHERE trigger_id = @trigger_id_from
IF NOT EXISTS (SELECT * FROM sx_trigger_router WHERE trigger_id = @trigger_id_from AND router_id = @router_id_from)
INSERT INTO sx_trigger_router (trigger_id, router_id, initial_load_order, create_time, last_update_time)
VALUES (@trigger_id_from, @router_id_from, @load_order, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END
END

