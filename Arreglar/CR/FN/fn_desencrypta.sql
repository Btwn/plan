SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION [dbo].[fn_desencrypta]
(
@clave	varbinary(500),
@key 	varchar(50)
)
returns varchar(50)
as
begin
declare @pass as varchar(50)
set @pass=DECRYPTBYPASSPHRASE(@key,@clave)
return @pass
end

