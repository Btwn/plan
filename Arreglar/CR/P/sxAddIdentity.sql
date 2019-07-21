SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxAddIdentity
@external_id VARCHAR(50),
@group_id VARCHAR(50)
AS
BEGIN
IF EXISTS (SELECT node_id FROM sx_node_identity)
DELETE FROM sx_node_identity
INSERT INTO sx_node_identity (node_id) VALUES (@external_id)
EXEC sxAddHost @external_id, @group_id
EXEC sxCreateChannels
END

