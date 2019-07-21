SET DATEFIRST 7    
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnSplitTable (@StringSplit varchar(max), @Delimiter char(1))
RETURNS @tResult Table(ID int identity, Valor varchar(max))
AS
BEGIN
DECLARE @StringResult varchar(max)
SET @StringResult = @StringSplit
WHILE (SELECT CHARINDEX(@Delimiter, @StringResult)) > 0
BEGIN
INSERT @tResult SELECT SUBSTRING(@StringResult, 1, CHARINDEX(@Delimiter, @StringResult) - 1)
SET @StringResult = SUBSTRING(@StringResult,  CHARINDEX(@Delimiter, @StringResult) + 1, LEN(@StringSplit))
END
INSERT @tResult SELECT @StringResult
RETURN
END

