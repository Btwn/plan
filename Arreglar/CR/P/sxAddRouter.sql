SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxAddRouter
@from VARCHAR(10),
@to VARCHAR(10),
@table_group VARCHAR(20),
@type varchar(50) = NULL,
@expression varchar(255) = NULL
AS
BEGIN
DECLARE @router_id VARCHAR(50)
SELECT @router_id = 'rt_'+@table_group+'_'+@from+'_'+@to
IF NOT EXISTS (SELECT * FROM sx_router WHERE router_id = @router_id)
INSERT INTO sx_router (router_id, source_node_group_id, target_node_group_id, router_type, router_expression, sync_on_update, sync_on_insert, sync_on_delete, create_time, last_update_time)
VALUES (@router_id, @from, @to, @type, @expression, 1, 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ELSE
UPDATE sx_router SET sync_on_update = 1, sync_on_insert = 1, sync_on_delete = 1 WHERE router_id = @router_id
/*
IF NOT EXISTS (SELECT * FROM sx_router WHERE router_id = @router_id_to)
INSERT INTO sx_router (router_id, source_node_group_id, target_node_group_id, router_type, router_expression, sync_on_update, sync_on_insert, sync_on_delete, create_time, last_update_time)
VALUES (@router_id_to, @to, @from, @type, @expression, 1, 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
*/
END

