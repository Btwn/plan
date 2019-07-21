SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxDisableTrigger
@table_name VARCHAR(50),
@from VARCHAR(10),
@to VARCHAR(10)
AS
BEGIN
DECLARE @trigger_id_from VARCHAR(50), @trigger_id_to VARCHAR(50)
SELECT @trigger_id_from = 'tg_dn_'+@from+'_'+@table_name
SELECT @trigger_id_to = 'tg_up'+@to+'_'+@table_name
UPDATE sx_trigger SET sync_on_update = 0, sync_on_insert = 0, sync_on_delete = 0 WHERE trigger_id = @trigger_id_from OR trigger_id = @trigger_id_to
END

