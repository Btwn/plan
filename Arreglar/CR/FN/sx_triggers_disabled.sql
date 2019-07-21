SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER function [dbo].[sx_triggers_disabled]() returns smallint
begin
declare @disabled varchar(1);
set @disabled = coalesce(replace(substring(cast(context_info() as varchar), 1, 1), 0x0, ''), '');
if @disabled is null or @disabled != '1'
return 0;
return 1;
end

