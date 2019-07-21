SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.xrmGetClientNextNum(@Prefix varchar(3))
RETURNS varchar(10)

AS
BEGIN
DECLARE @ret varchar(10);
Declare @nextNum int;
select
@nextNum=((max(cast(SUBSTRING(cliente, CHARINDEX('-', cliente) + 1, LEN(cliente)) as integer)   ) + 1))
from cte where cliente like @Prefix+'-%'
set @ret = @Prefix+"-"+ RIGHT('00000'+ cast(@nextNum as varchar(5)),5)
RETURN @ret
END

