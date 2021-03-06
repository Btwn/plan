SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxDeleteGroupLink
@from VARCHAR(10),
@to VARCHAR(10)
AS
BEGIN
DELETE FROM sx_node_group_link WHERE (source_node_group_id = @from AND target_node_group_id = @to) OR (source_node_group_id = @to AND target_node_group_id = @from)
END

