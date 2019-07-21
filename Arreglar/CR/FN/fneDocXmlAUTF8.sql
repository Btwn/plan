SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fneDocXmlAUTF8
(
@XML				varchar(max),
@ConvertirCP437		bit = 0,
@ConvertirComillas  bit = 1
)
RETURNS varchar(max)

AS BEGIN
DECLARE
@LongitudTexto			bigint,
@Caracter				char(1),
@Contador				bigint,
@Estado					int,
@Consecutivo			varchar(50),
@EstadoAnterior			int,
@PosicionIni			bigint,
@PosicionFin			bigint,
@XMLResultado			varchar(max),
@Numero					int,
@CaracterUTF8			varchar(20),
@PosicionPuntoyComa		int
SET @XMLResultado = ''
SELECT @LongitudTexto = LEN(@XML), @Contador = 1, @Estado = 0, @Consecutivo = '', @PosicionIni = 0
WHILE @Contador <= @LongitudTexto
BEGIN
SELECT @Caracter = SUBSTRING(@XML,@Contador,1)
SET @EstadoAnterior = @Estado
SET @Estado = CASE
WHEN @Estado IN (0,1) AND @Caracter IN ('&')     THEN 1
WHEN @Estado IN (0,1) AND @Caracter NOT IN ('&') THEN 0
END
IF @Estado = 0
BEGIN
SET @XMLResultado = @XMLResultado + dbo.fnCaracterAUTF8(@Caracter,@ConvertirCP437,@ConvertirComillas)
END
IF @Estado = 1
BEGIN
SET @CaracterUTF8 = SUBSTRING(@XML,@Contador,20)
SET @PosicionPuntoyComa = ISNULL(PATINDEX('%;%',@CaracterUTF8),0)
IF @PosicionPuntoyComa <> 0
SET @CaracterUTF8 = SUBSTRING(@CaracterUTF8,1,@PosicionPuntoyComa)
ELSE
SET @CaracterUTF8 = NULL
IF @CaracterUTF8 IS NOT NULL AND dbo.fnEsCaracterUTF8(@CaracterUTF8) = 0
SET @XMLResultado = @XMLResultado + dbo.fnCaracterAUTF8(@Caracter,@ConvertirCP437,@ConvertirComillas)
ELSE IF @CaracterUTF8 IS NOT NULL
SET @XMLResultado = @XMLResultado + @Caracter
IF @CaracterUTF8 IS NULL
SET @XMLResultado = @XMLResultado + dbo.fnCaracterAUTF8(@Caracter,@ConvertirCP437,@ConvertirComillas)
END
SET @Contador = @Contador + 1
END
RETURN @XMLResultado
END

