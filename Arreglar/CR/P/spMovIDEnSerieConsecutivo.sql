SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovIDEnSerieConsecutivo
@MovID  	varchar(20),
@Serie		varchar(50)	OUTPUT,
@Consecutivo	bigint		OUTPUT

AS BEGIN
DECLARE
@p		int
SELECT @p = LEN(@MovID)
WHILE @p >= 1 AND dbo.fnEsNumerico(SUBSTRING(@MovID, @p, 1)) = 1
SELECT @p = @p - 1
SELECT @Serie = NULLIF(RTRIM(SUBSTRING(@MovID, 1, @p)), ''), @Consecutivo = CONVERT(bigint, RTRIM(SUBSTRING(@MovID, @p+1, LEN(@MovID))))
RETURN
END

