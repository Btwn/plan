SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxDeleteTrigger
@table_name VARCHAR(50),
@from VARCHAR(10),
@to VARCHAR(10)
AS
BEGIN
DECLARE @trigger_id_from VARCHAR(50), @trigger_id_to VARCHAR(50)
SELECT @trigger_id_from = 'tg_dn_'+@from+'_'+@table_name
SELECT @trigger_id_to = 'tg_up_'+@to+'_'+@table_name
DELETE FROM sx_trigger WHERE trigger_id = @trigger_id_from
DELETE FROM sx_trigger_router WHERE trigger_id = @trigger_id_from
DELETE FROM sx_trigger WHERE trigger_id = @trigger_id_to
DELETE FROM sx_trigger_router WHERE trigger_id = @trigger_id_to
END

