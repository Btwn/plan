SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fgetINPCNUM_PRORROGA(@fechaInve as Datetime, @fechaObt as Datetime, @Prorroga as bit)
RETURNS Float
AS
BEGIN
DECLARE	@valINPC as Float,
@mesesDif as int,
@fechaINPC as Datetime,
@mesINPC as int,
@AnioINPC as smallInt,
@_pro as int;
SET @_pro = 0;
SELECT  @mesesDif = DATEDIFF(MONTH, @fechaObt, @fechaInve);
SET @_pro= CAST(@Prorroga AS INT);
IF(@mesesDif >=12 AND @_pro=0 )
BEGIN
SET @fechaINPC= DATEADD(MONTH,12,@fechaObt);
SET @mesINPC= DATEPART(MONTH,@fechaINPC);
SET @AnioINPC =DATEPART(YEAR,@fechaINPC);
SELECT @valINPC= Importe
FROM dbo.INPC WHERE Mes=@mesINPC AND Anio=@AnioINPC
END
IF(@mesesDif >=24 AND @_pro=1)
BEGIN
SET @fechaINPC= DATEADD(MONTH,24,@fechaObt);
SET @mesINPC= DATEPART(MONTH,@fechaINPC);
SET @AnioINPC =DATEPART(YEAR,@fechaINPC);
SELECT @valINPC= Importe
FROM dbo.INPC WHERE Mes=@mesINPC AND Anio=@AnioINPC
END
IF(@mesesDif <12)
BEGIN
SET @mesINPC= DATEPART(MONTH,@fechaInve);
SET @AnioINPC =DATEPART(YEAR,@fechaInve);
SELECT @valINPC= Importe
FROM dbo.INPC WHERE Mes=@mesINPC AND Anio=@AnioINPC
END
RETURN @valINPC
END

