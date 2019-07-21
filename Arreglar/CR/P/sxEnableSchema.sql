SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxEnableSchema
@from VARCHAR(50),
@to VARCHAR(50)
AS
BEGIN
DECLARE @schema_router varchar(50), @schema_trigger varchar(50)
SELECT @schema_router = 'rt_schema_'+@from+'_'+@to, @schema_trigger = 'tg_schema_'+@from
EXEC sxAddGroupLink @from, @to
EXEC sxAddRouterByID @schema_router, @from, @to, NULL, NULL
EXEC sxAddTriggerByID @schema_trigger, @schema_router, 'sx_schema', 0, 1, 'schema_channel'
END

