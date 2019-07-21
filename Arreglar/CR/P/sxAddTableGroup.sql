SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxAddTableGroup
@table_group varchar(20),
@sync_cascade smallint,
@load_order int = 200,
@channel varchar(50) = 'normal'
AS
BEGIN
IF NOT EXISTS (SELECT table_group FROM sx_table_group WHERE table_group = @table_group)
INSERT INTO sx_table_group (table_group, sync_cascade, load_order, channel) VALUES (@table_group, @sync_cascade, @load_order, @channel)
END

