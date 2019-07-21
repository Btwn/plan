SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnDiasSemanaEnPeriodo (@FechaD datetime, @FechaA datetime)
RETURNS INT

AS BEGIN
WHILE datepart(weekday, @FechaD) in (1,7) 
BEGIN
SET @FechaD = dateadd(d,1,@FechaD)
END
WHILE datepart(weekday, @FechaA) in (1,7) 
BEGIN
SET @FechaA = dateadd(d,-1,@FechaA)
END
RETURN (datediff(d,@FechaD,@FechaA) + 1) - (datediff(ww,@FechaD,@FechaA) * 2)
END

