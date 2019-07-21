SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnMovOpcionValores
(
@OpcionOriginal			varchar(50)
)
RETURNS varchar(max)

AS BEGIN
DECLARE
@LongitudTexto			bigint,
@Caracter				char(1),
@Contador				bigint,
@Estado					int,
@EstadoAnterior			int,
@NoOpcion				int,
@Resultado				varchar(max),
@Numero					varchar(50),
@Letra					varchar(1)
SELECT @LongitudTexto = LEN(@OpcionOriginal), @Contador = 1, @Estado = 0, @Resultado = '', @Resultado = '', @Numero = '', @Letra = ''
WHILE @Contador <= @LongitudTexto
BEGIN
SELECT @Caracter = SUBSTRING(@OpcionOriginal,@Contador,1)
SET @EstadoAnterior = @Estado
SET @Estado = CASE
WHEN @Estado = 0 AND @Caracter IN ('Ñ','A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'W', 'X', 'Y', 'Z') THEN 1
WHEN @Estado = 1 AND @Caracter NOT IN ('Ñ', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'W', 'X', 'Y', 'Z') THEN 0
ELSE @Estado
END
IF @Estado = 0
BEGIN
IF @NoOpcion <> 0
SELECT @Numero = @Numero + @Caracter
END
IF @Estado = 1
BEGIN
IF @Letra = 'Ñ' SET @Numero = ''
IF LEN(@Letra) > 0 AND LEN(@Numero) > 0
BEGIN
SELECT @Resultado = @Resultado + CHAR(39) + RTRIM(d.Nombre) + CHAR(39) + ','
FROM OpcionD d
WHERE d.Opcion = @Letra
AND d.Numero = CONVERT(int,@Numero)
SET @Letra = ''
SET @Numero = ''
END
SET @Letra = @Caracter
END
SET @Contador = @Contador + 1
END
IF @Letra = 'Ñ' SET @Numero = ''
IF LEN(@Letra) > 0 AND LEN(@Numero) > 0
BEGIN
SELECT @Resultado = @Resultado + CHAR(39) + RTRIM(d.Nombre) + CHAR(39) + ','
FROM OpcionD d
WHERE d.Opcion = @Letra
AND d.Numero = CONVERT(int,@Numero)
END
IF LEN(@Letra) > 0 AND LEN(@Numero) < 1 AND @EstadoAnterior = @Estado
BEGIN
SELECT @Resultado = @Resultado + CHAR(39) + RTRIM(Descripcion) + CHAR(39) + ','
FROM Opcion
WHERE Opcion = @Letra
END
IF LEN(@Resultado) > 1
SELECT @Resultado = SUBSTRING(@Resultado, 1, LEN(@Resultado)-1)
RETURN @Resultado
END

