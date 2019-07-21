SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxAddHost
@external_id VARCHAR(50),
@group_id VARCHAR(50),
@is_registration smallint = 0,
@this_node varchar(50) = NULL
AS
BEGIN
IF @is_registration = 1 AND @this_node IS NULL
BEGIN
RAISERROR('Debe de indicar @this_node cuando @is_registration = 1', 16, 1)
RETURN
END
IF NOT EXISTS(SELECT * FROM sx_node_group WHERE node_group_id = @group_id)
INSERT INTO sx_node_group (node_group_id, description) VALUES (@group_id, 'Grupo '+@group_id)
IF NOT EXISTS(SELECT * FROM sx_node WHERE node_id = @external_id)
INSERT INTO sx_node (node_id, node_group_id, external_id, sync_enabled) VALUES (@external_id, @group_id, @external_id, 1)
IF NOT EXISTS (SELECT * FROM sx_node_security WHERE node_id = @external_id) AND (@is_registration = 1)
INSERT INTO sx_node_security (node_id, node_password, registration_enabled, registration_time, initial_load_enabled, initial_load_time, created_at_node_id)
VALUES (@external_id, '4d186321c1a7f0f354b297e8914ab240', 1, current_timestamp, 0, current_timestamp, @this_node)
END

