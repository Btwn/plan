SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxAddTriggerByID
@trigger_id VARCHAR(50),
@router_id VARCHAR(50),
@table_name VARCHAR(50),
@sync_cascade SMALLINT = 1,
@load_order INT = 200,
@channel VARCHAR(20) = 'normal',
@update_condition VARCHAR(max) = '',
@insert_condition VARCHAR(max) = '',
@delete_condition VARCHAR(max) = ''
AS
BEGIN
IF NOT EXISTS (SELECT * FROM sx_trigger WHERE trigger_id = @trigger_id)
INSERT INTO sx_trigger (trigger_id, source_table_name, channel_id, sync_on_incoming_batch, create_time, last_update_time, sync_on_update_condition, sync_on_insert_condition, sync_on_delete_condition)
VALUES (@trigger_id, @table_name, @channel, @sync_cascade, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, @update_condition, @insert_condition, @delete_condition)
ELSE
UPDATE sx_trigger SET sync_on_update = 1, sync_on_insert = 1, sync_on_delete = 1, sync_on_update_condition = @update_condition,
sync_on_insert_condition = @insert_condition, sync_on_delete_condition = @delete_condition
WHERE trigger_id = @trigger_id
IF NOT EXISTS (SELECT * FROM sx_trigger_router WHERE trigger_id = @trigger_id AND router_id = @router_id)
INSERT INTO sx_trigger_router (trigger_id, router_id, initial_load_order, create_time, last_update_time)
VALUES (@trigger_id, @router_id, @load_order, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

