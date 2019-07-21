SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[sp_RestoreBackUp](
@pathBackUp	varchar(200)
)

as begin
declare @st varchar(200),
@name varchar(50),
@namelog varchar(50),
@pathmdf varchar(200),
@pathLdf varchar(200)
create table #fileListTable
(
LogicalName          nvarchar(128),
PhysicalName         nvarchar(260),
[Type]               char(1),
FileGroupName        nvarchar(128),
Size                 numeric(20,0),
MaxSize              numeric(20,0),
FileID               bigint,
CreateLSN            numeric(25,0),
DropLSN              numeric(25,0),
UniqueID             uniqueidentifier,
ReadOnlyLSN          numeric(25,0),
ReadWriteLSN         numeric(25,0),
BackupSizeInBytes    bigint,
SourceBlockSize      int,
FileGroupID          int,
LogGroupGUID         uniqueidentifier,
DifferentialBaseLSN  numeric(25,0),
DifferentialBaseGUID uniqueidentifier,
IsReadOnl            bit,
IsPresent            bit,
TDEThumbprint        varbinary(32)
)
begin try
set @st='RESTORE FILELISTONLY  FROM DISK = '''+ @pathBackUp +''''
insert into #fileListTable
exec(@st)
select @name=LogicalName,@pathmdf=PhysicalName from #fileListTable where FileID=1
select @namelog=LogicalName,@pathLdf=PhysicalName from #fileListTable where FileID=2
drop table #fileListTable
RESTORE DATABASE @name
FROM disk = @pathBackUp
WITH replace
,MOVE @name to @pathmdf
,MOVE @namelog to @pathLdf
return 1
end try
begin catch
return 0
end catch
end

