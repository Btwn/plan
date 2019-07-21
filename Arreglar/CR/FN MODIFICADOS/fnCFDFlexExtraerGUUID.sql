SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnCFDFlexExtraerGUUID
(
@XML				varchar(max)
)
RETURNS varchar(max)

AS BEGIN
DECLARE
@LongitudTexto			bigint,
@Caracter				char(1),
@Contador				bigint,
@Estado					int,
@XMLResultado			varchar(max)
SET @XMLResultado = ''
SELECT @LongitudTexto = LEN(@XML), @Contador = 1, @Estado = 0
WHILE @Contador <= @LongitudTexto
BEGIN
SELECT @Caracter = SUBSTRING(@XML,@Contador,1)
SET @Estado = CASE
WHEN @Estado IN (0)   AND @Caracter IN ('U')  THEN 1
WHEN @Estado IN (1)   AND @Caracter IN ('U')  THEN 2
WHEN @Estado IN (2)   AND @Caracter IN ('I')  THEN 3
WHEN @Estado IN (3)   AND @Caracter IN ('D')  THEN 4
WHEN @Estado IN (4)   AND @Caracter IN ('=')  THEN 5
WHEN @Estado IN (5)   AND @Caracter IN ('"')  THEN 6
WHEN @Estado IN (6,7) AND @Caracter <>  '"'   THEN 7
WHEN @Estado IN (7)   AND @Caracter IN ('"')  THEN 8
ELSE 0
END
IF @Estado = 7
BEGIN
SET @XMLResultado = @XMLResultado + @Caracter
END
IF @Estado = 8
BEGIN
RETURN ISNULL(@XMLResultado,'')
END
SET @Contador = @Contador + 1
END
RETURN ISNULL(@XMLResultado,'')
END

