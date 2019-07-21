SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnMovOpcionListaSeleccion
(
@OpcionOriginal			varchar(50),
@Verificar				bit
)
RETURNS varchar(max)

AS BEGIN
DECLARE
@LongitudTexto			bigint,
@Caracter				char(1),
@Contador				bigint,
@Estado					int,
@EstadoAnterior			int,
@Resultado				varchar(max),
@OpcionNoValida			varchar(50),
@Opcion					varchar(1)
SELECT @LongitudTexto = LEN(@OpcionOriginal), @Contador = 1, @Estado = 0, @Resultado = ''
WHILE @Contador <= @LongitudTexto
BEGIN
SELECT @Caracter = SUBSTRING(@OpcionOriginal,@Contador,1)
SET @EstadoAnterior = @Estado
SET @Estado = CASE
WHEN @Estado = 0 AND @Caracter IN ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'W', 'X', 'Y', 'Z') THEN 1
WHEN @Estado = 1 AND @Caracter NOT IN ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'W', 'X', 'Y', 'Z') THEN 0
ELSE @Estado
END
IF @Estado = 1
BEGIN
SELECT @Opcion = @Caracter
IF SUBSTRING(@OpcionOriginal,@Contador+1,1) NOT IN ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'W', 'X', 'Y', 'Z')
BEGIN
IF @Verificar = 0
SELECT @Resultado = @Resultado + @Opcion + ', '
ELSE
SELECT @Resultado = @Resultado + CHAR(39) + @Opcion + CHAR(39) + ', '
END
END
SET @Contador = @Contador + 1
END
IF LEN(@Resultado) > 1
SELECT @Resultado = SUBSTRING(@Resultado, 1, LEN(@Resultado)-1)
RETURN @Resultado
END

