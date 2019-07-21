SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sxReplicateTables
@origin_table varchar(50),
@target_table varchar(50),
@overwrite smallint = 0
AS
BEGIN
IF @overwrite = 1 OR NOT EXISTS (SELECT table_group FROM sx_relations WHERE relation_type = 'tabl' AND group_id_from = @origin_table AND group_id_to = @target_table)
BEGIN
IF NOT EXISTS (SELECT table_group FROM sx_relations WHERE relation_type = 'tabl' AND group_id_from = @origin_table AND group_id_to = @target_table)
INSERT INTO sx_relations (group_id_from, group_id_to, table_group, relation_type)
VALUES (@origin_table, @target_table, @origin_table, 'tabl')
DECLARE @trigger_id varchar(100), @drop_sql varchar(max), @trigger_sql varchar(max), @to varchar(50)
SELECT @trigger_id = 'tgi_rpl_'+@origin_table
SELECT @drop_sql = 'if exists (select * from sysobjects where id = object_id(''dbo.'+@trigger_id+''') and type = ''TR'') drop trigger dbo.'+@trigger_id
EXEC(@drop_sql)
SELECT @trigger_sql = 'CREATE TRIGGER '+@trigger_id+' ON '+@origin_table+' FOR INSERT AS
BEGIN
DECLARE @insert_sql varchar(max)
SELECT * INTO #tempTable FROM INSERTED '
DECLARE crRelations CURSOR LOCAL FOR
SELECT group_id_to FROM sx_relations WHERE relation_type = 'tabl' AND group_id_from = @origin_table
OPEN crRelations
FETCH NEXT FROM crRelations INTO @to
WHILE @@FETCH_STATUS = 0
BEGIN
select @trigger_sql = @trigger_sql + 'SELECT @insert_sql = ''
INSERT INTO '+@to+' (''+dbo.sxGetFieldsList(''NonIdentity'', '''+@origin_table+''', '''+@to+''', ''#tempTable'', '', '', 0)+'')
SELECT ''+dbo.sxGetFieldsList(''NonIdentity'', '''+@origin_table+''', ''#tempTable'', ''#tempTable'', '', '', 0)+'' FROM #tempTable''
EXEC(@insert_sql) '
FETCH NEXT FROM crRelations INTO @to
END
CLOSE crRelations
DEALLOCATE crRelations
SELECT @trigger_sql = @trigger_sql + 'DROP TABLE #tempTable
END'
EXEC(@trigger_sql)
SELECT @trigger_id = 'tgd_rpl_'+@origin_table
SELECT @drop_sql = 'if exists (select * from sysobjects where id = object_id(''dbo.'+@trigger_id+''') and type = ''TR'') drop trigger dbo.'+@trigger_id
EXEC(@drop_sql)
SELECT @trigger_sql = 'CREATE TRIGGER '+@trigger_id+' ON '+@origin_table+' FOR DELETE AS
BEGIN
DECLARE @sql_campos varchar(max), @delete_sql varchar(max), @campo nvarchar(128)
SELECT * INTO #tempTable FROM DELETED '
DECLARE crRelations CURSOR LOCAL FOR
SELECT group_id_to FROM sx_relations WHERE relation_type = 'tabl' AND group_id_from = @origin_table
OPEN crRelations
FETCH NEXT FROM crRelations INTO @to
WHILE @@FETCH_STATUS = 0
BEGIN
select @trigger_sql = @trigger_sql + 'SELECT @delete_sql = ''DELETE '+@to+'
FROM '+@to+'
INNER JOIN #tempTable
ON (''+dbo.sxGetFieldsList(''PrimaryKey'', '''+@origin_table+''', '''+@to+''', ''#tempTable'', '' AND '', 1)+'')''
EXEC(@delete_sql) '
FETCH NEXT FROM crRelations INTO @to
END
CLOSE crRelations
DEALLOCATE crRelations
SELECT @trigger_sql = @trigger_sql + 'DROP TABLE #tempTable
END'
EXEC(@trigger_sql)
SELECT @trigger_id = 'tgu_rpl_'+@origin_table
SELECT @drop_sql = 'if exists (select * from sysobjects where id = object_id(''dbo.'+@trigger_id+''') and type = ''TR'') drop trigger dbo.'+@trigger_id
EXEC(@drop_sql)
SELECT @trigger_sql = 'CREATE TRIGGER '+@trigger_id+' ON '+@origin_table+' FOR UPDATE AS
BEGIN
DECLARE @update_sql varchar(max)
SELECT * INTO #tempTable FROM INSERTED '
DECLARE crRelations CURSOR LOCAL FOR
SELECT group_id_to FROM sx_relations WHERE relation_type = 'tabl' AND group_id_from = @origin_table
OPEN crRelations
FETCH NEXT FROM crRelations INTO @to
WHILE @@FETCH_STATUS = 0
BEGIN
select @trigger_sql = @trigger_sql + 'SELECT @update_sql = ''UPDATE '+@to+'
SET ''+dbo.sxGetFieldsList(''NonIdentity'', '''+@origin_table+''', '''+@to+''', ''#tempTable'', '', '', 1)+''
FROM '+@to+'
JOIN #tempTable ON (''+dbo.sxGetFieldsList(''PrimaryKey'', '''+@origin_table+''', '''+@to+''', ''#tempTable'', '' AND '', 1)+'')''
EXEC(@update_sql) '
FETCH NEXT FROM crRelations INTO @to
END
CLOSE crRelations
DEALLOCATE crRelations
SELECT @trigger_sql = @trigger_sql + 'DROP TABLE #tempTable
END'
EXEC(@trigger_sql)
END
END

