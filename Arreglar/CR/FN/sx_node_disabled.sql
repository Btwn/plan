SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER function [dbo].[sx_node_disabled]() returns varchar(50)
begin
declare @node varchar(50);
set @node = coalesce(replace(substring(cast(context_info() as varchar), 2, 50), 0x0, ''), '');
return @node;
end

