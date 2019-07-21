SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxAddGroupLink
@from VARCHAR(10),
@to VARCHAR(10)
AS
BEGIN
IF NOT EXISTS(SELECT * FROM sx_node_group_link WHERE source_node_group_id = @from AND target_node_group_id = @to)
INSERT INTO sx_node_group_link (source_node_group_id, target_node_group_id, data_event_action)
VALUES (@from, @to, 'W')
IF NOT EXISTS(SELECT * FROM sx_node_group_link WHERE source_node_group_id = @to AND target_node_group_id = @from)
INSERT INTO sx_node_group_link (source_node_group_id, target_node_group_id, data_event_action)
VALUES (@to, @from, 'P')
END

