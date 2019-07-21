SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnExtraerOpcionNumero (@SubCuenta varchar(50), @Opcion char(1))
RETURNS int

AS BEGIN
DECLARE
@p		int,
@s		varchar(50),
@c		varchar(1),
@Resultado	int
SELECT @Resultado = NULL
SELECT @p = CHARINDEX(@Opcion, @SubCuenta)
IF @p>0
BEGIN
SELECT @s = ''
WHILE @p<LEN(@SubCuenta)
BEGIN
SELECT @p = @p + 1
SELECT @c = SUBSTRING(@SubCuenta, @p, 1)
IF dbo.fnEsNumerico(@c) = 1
SELECT @s = @s + @c
ELSE BREAK
END
IF @s <> '' AND dbo.fnEsNumerico(@s) = 1
SELECT @Resultado = CONVERT(int, @s)
END
RETURN (@Resultado)
END

