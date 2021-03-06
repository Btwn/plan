SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
CREATE FUNCTION [dbo].[fnSplitScalar]
(
@Expression VARCHAR(max)
, @Delimiter  VARCHAR(max)
, @INDEX      INT
)
RETURNS VARCHAR(max)
AS
BEGIN
DECLARE @RETURN  VARCHAR(max)
DECLARE @Pos     INT
DECLARE @PrevPos INT
DECLARE @I       INT
IF @Expression IS NULL OR @Delimiter IS NULL OR DATALENGTH(@Delimiter) = 0 OR @INDEX < 1
SET @RETURN = NULL
ELSE IF @INDEX = 1
BEGIN
SET @Pos = CHARINDEX(@Delimiter, @Expression, 1)
IF @Pos > 0 SET @RETURN = LEFT(@Expression, @Pos - 1)
END
ELSE
BEGIN
SET @Pos = 0
SET @I = 0
WHILE (@Pos > 0 AND @I < @INDEX) OR @I = 0
BEGIN
SET @PrevPos = @Pos
SET @Pos = CHARINDEX(@Delimiter, @Expression, @Pos + DATALENGTH(@Delimiter))
SET @I = @I + 1
END
IF @Pos = 0 AND @I = @INDEX
SET @RETURN = SUBSTRING(@Expression, @PrevPos + DATALENGTH(@Delimiter), DATALENGTH(@Expression))
ELSE IF @Pos = 0 AND @I <> @INDEX
SET @RETURN = NULL
ELSE
SET @RETURN = SUBSTRING(@Expression, @PrevPos + DATALENGTH(@Delimiter), @Pos - @PrevPos - DATALENGTH(@Delimiter))
END
RETURN @RETURN
END





