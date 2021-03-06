SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroFinal
@Modulo	char(5) = NULL

AS BEGIN
DECLARE
@SincroSSB			bit,
@SincroIS			bit
SELECT @SincroSSB = ISNULL(SincroSSB,0), @SincroIS = ISNULL(SincroIS,0) FROM Version
IF @SincroSSB = 0 AND @SincroIS = 0 RETURN
DECLARE crModulo CURSOR LOCAL FOR
SELECT Modulo
FROM Modulo
WHERE Modulo = CASE WHEN @Modulo IS NULL THEN Modulo ELSE @Modulo END
OPEN crModulo
FETCH NEXT FROM crModulo INTO @Modulo
WHILE @@fetch_status <> -1
BEGIN
IF @@fetch_status <> -2
BEGIN
EXEC spSincroFinalModulo @Modulo
END
FETCH NEXT FROM crModulo INTO @Modulo
END
CLOSE crModulo
DEALLOCATE crModulo
EXEC xpSincroFinal
END

