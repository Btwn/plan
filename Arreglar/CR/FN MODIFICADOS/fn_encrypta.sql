SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION [dbo].[fn_encrypta]
(
@clave	varchar(50)	,
@key	varchar(50)
)
returns varbinary(500)
as
begin
declare @pass as varbinary(500)
set @pass=ENCRYPTBYPASSPHRASE(@key,@clave)
return @pass
end

