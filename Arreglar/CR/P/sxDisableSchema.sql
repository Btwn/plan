SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxDisableSchema
@from VARCHAR(50),
@to VARCHAR(50)
AS
BEGIN
DECLARE @schema_router varchar(32), @schema_trigger varchar(21)
SELECT @schema_router = 'rt_schema_'+@from+'_'+@to, @schema_trigger = 'tg_schema_'+@from
UPDATE sx_router SET sync_on_update = 0, sync_on_insert = 0, sync_on_delete = 0 WHERE router_id = @schema_router
UPDATE sx_trigger SET sync_on_update = 0, sync_on_insert = 0, sync_on_delete = 0 WHERE trigger_id = @schema_trigger
/*
IF NOT EXISTS (SELECT router_id FROM sx_trigger_router WHERE router_id = @schema_router)
DELETE FROM sx_router WHERE router_id = @schema_router
IF NOT EXISTS (SELECT trigger_id FROM sx_trigger_router WHERE trigger_id = @schema_trigger)
DELETE FROM sx_trigger WHERE trigger_id = @schema_trigger
*/
IF NOT EXISTS (SELECT router_id FROM sx_router WHERE source_node_group_id = @from AND target_node_group_id = @to)
EXEC sxDeleteGroupLink @from, @to
END

