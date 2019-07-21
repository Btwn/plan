SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxDeleteRelation
@from VARCHAR(50),
@to VARCHAR(50),
@table_group VARCHAR(50)
AS
BEGIN
DECLARE	@name VARCHAR(50)
DECLARE crTables CURSOR LOCAL FOR
SELECT table_name FROM sx_table WHERE table_group = @table_group
OPEN crTables
FETCH NEXT FROM crTables INTO @name
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC sxDeleteTrigger @name, @from, @to
FETCH NEXT FROM crTables INTO @name
END
EXEC sxDeleteRouter @from, @to
EXEC sxDeleteGroupLink @from, @to
DELETE FROM sx_relations WHERE group_id_from = @from AND group_id_to = @to AND table_group = @table_group
END

