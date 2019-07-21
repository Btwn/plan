SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnWebDateToUnix
( @DAY datetime )
RETURNS  int
AS
BEGIN
DECLARE @wkdt datetime
IF (@DAY > convert(datetime, '2038-01-19 03:14:07.497', 101)) or (@DAY < convert(datetime, '1901-12-13 20:45:51.500', 101)) return null
SELECT @wkdt = dateadd(ms,round(datepart(ms,@DAY),-3)-datepart(ms,@DAY),@DAY)
IF @wkdt >= 712	RETURN datediff(ss,25567,@wkdt)
RETURN -2147472000-datediff(ss,@wkdt,712)
END

