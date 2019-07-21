SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER function [dbo].[sx_base64_encode](@data varbinary(max)) returns varchar(max)
with schemabinding, returns null on null input
begin
return ( select [text()] = @data for xml path('') )
end

