SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnEsNumerico (@num VARCHAR(64))
RETURNS BIT

AS BEGIN
IF LEFT(@num, 1) = '-'
SET @num = SUBSTRING(@num, 2, LEN(@num))
DECLARE @pos TINYINT
SET @pos = 1 + LEN(@num) - CHARINDEX('.', REVERSE(@num))
RETURN CASE
WHEN PATINDEX('%[^0-9.-]%', @num) = 0
AND @num NOT IN ('.', '-', '+', '^')
AND LEN(@num)>0
AND @num NOT LIKE '%-%'
AND
(
((@pos = LEN(@num)+1)
OR @pos = CHARINDEX('.', @num))
)
THEN
1
ELSE
0
END
END

