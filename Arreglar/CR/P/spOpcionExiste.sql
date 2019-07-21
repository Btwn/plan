SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOpcionExiste
@Texto		varchar(100),
@EnTexto	varchar(50),
@Existe		bit		OUTPUT

AS BEGIN
DECLARE
@i		int,
@r  	int,
@Letra 	char(1),
@RangoD	int,
@RangoA	int,
@Numero	int
SELECT @Existe = 0
SELECT @r = CHARINDEX(':', @Texto)
IF @r > 0
BEGIN
SELECT @Letra = SUBSTRING(@Texto, 1, 1),
@RangoD = CONVERT(int, SUBSTRING(@Texto, 2, @r-2)),
@RangoA = CONVERT(int, SUBSTRING(@Texto, @r+1, LEN(@Texto)))
EXEC spOpcionExtraerNumero @EnTexto, @Letra, @Numero OUTPUT
IF @Numero IS NOT NULL AND @Numero BETWEEN @RangoD AND @RangoA SELECT @Existe = 1
END ELSE
BEGIN
SELECT @i = CHARINDEX(@Texto, @EnTexto)
IF @i > 0 AND (LEN(@Texto) = 1 OR LEN(@EnTexto) = @i OR dbo.fnEsNumerico(SUBSTRING(@EnTexto, @i+LEN(@Texto), 1)) = 0) SELECT @Existe = 1
END
RETURN
END

