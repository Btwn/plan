SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnIPOk (@IP varchar(20))
RETURNS bit
AS BEGIN
DECLARE
@Error	bit,
@p		int,
@puntos	int,
@Resultado	bit
SELECT @Resultado = 0, @Error = 0
IF dbo.fnEsNumerico(SUBSTRING(@IP, 1, 1)) = 1 AND dbo.fnEsNumerico(SUBSTRING(@IP, LEN(@IP), 1)) = 1
BEGIN
SELECT @p = 1, @puntos = 0
WHILE @p < LEN(@IP) AND @Error = 0
BEGIN
IF SUBSTRING(@IP, @p, 1) = '.' SELECT @puntos = @puntos + 1 ELSE
IF dbo.fnEsNumerico(SUBSTRING(@IP, @p, 1)) = 0 SELECT @Error = 1
SELECT @p = @p + 1
END
IF @puntos = 3 AND @Error = 0 SELECT @Resultado = 1
END
RETURN (@Resultado)
END

