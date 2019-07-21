SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.splitstring ( @stringToSplit VARCHAR(MAX) )
RETURNS
@returnList TABLE ([Name] [nvarchar] (500))
AS
BEGIN
DECLARE @name NVARCHAR(255)
DECLARE @pos INT
WHILE CHARINDEX(',', @stringToSplit) > 0
BEGIN
SELECT @pos  = CHARINDEX(',', @stringToSplit)
SELECT @name = SUBSTRING(@stringToSplit, 1, @pos-1)
INSERT INTO @returnList
SELECT @name
SELECT @stringToSplit = SUBSTRING(@stringToSplit, @pos+1, LEN(@stringToSplit)-@pos)
END
INSERT INTO @returnList
SELECT @stringToSplit
RETURN
END

