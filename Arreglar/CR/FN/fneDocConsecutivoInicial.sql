SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fneDocConsecutivoInicial
(
@Consecutivo				varchar(255)
)
RETURNS int

AS BEGIN
DECLARE
@Longitud			bigint,
@Contador			bigint,
@Caracter			char(1),
@Inicial			varchar(100),
@Estado			int,
@EstadoAnterior	int,
@Resultado		int
SELECT @Longitud = LEN(@Consecutivo), @Contador = 1, @Caracter = NULL, @Inicial = '', @Estado = 0
WHILE @Contador <= @Longitud
BEGIN
SET @Caracter = SUBSTRING(@Consecutivo,@Contador,1)
SET @EstadoAnterior = @Estado
SET @Estado = CASE
WHEN @Estado = 0 AND @Caracter = '«'         THEN 1
WHEN @Estado = 1 AND @Caracter = '|'         THEN 2
WHEN @Estado = 2 AND @Caracter IN ('|','»')  THEN 3
ELSE @Estado
END
IF @Estado = 2 AND @Caracter IN ('0','1','2','3','4','5','6','7','8','9')
BEGIN
SET @Inicial = @Inicial + @Caracter
END
IF @Estado = 2
BEGIN
IF @EstadoAnterior <> 2 SET @Inicial = ''
END
IF @Estado = 3
BEGIN
IF @EstadoAnterior = 2 SELECT @Resultado = CONVERT(int,NULLIF(@Inicial,''))
BREAK
END
SET @Contador = @Contador + 1
END
SELECT @Resultado = ISNULL(@Resultado,1)
RETURN @Resultado
END

