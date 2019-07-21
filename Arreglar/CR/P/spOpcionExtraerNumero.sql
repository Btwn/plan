SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOpcionExtraerNumero
@SubCuenta	varchar(50),
@Letra		char(1),
@Numero		int		OUTPUT

AS BEGIN
DECLARE
@p		int,
@NumeroSt 	varchar(50)
SELECT @Numero = NULL, @NumeroSt = ''
SELECT @p = CHARINDEX(@Letra, @SubCuenta)
IF @p>0
BEGIN
SELECT @p = @p + 1
WHILE @p <= LEN(@SubCuenta) AND dbo.fnEsNumerico(SUBSTRING(@SubCuenta, @p, 1)) = 1
BEGIN
SELECT @NumeroSt = ISNULL(@NumeroSt, '') + RTRIM(SUBSTRING(@SubCuenta, @p, 1))
SELECT @p = @p + 1
END
IF LEN(@NumeroSt) > 0 SELECT @Numero = CONVERT(int, @NumeroSt)
END
RETURN
END

