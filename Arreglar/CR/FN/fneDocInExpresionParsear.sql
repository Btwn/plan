SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fneDocInExpresionParsear
(
@Expresion				varchar(max)
)
RETURNS varchar(max)

AS BEGIN
DECLARE
@Resultado			varchar(max),
@Longitud			bigint,
@Contador			bigint,
@Caracter			char(1),
@Estado				int,
@EstadoAnterior		int,
@Variable			varchar(255),
@Valor				varchar(max),
@Tipo				varchar(50)
SET @Resultado = ''
IF NULLIF(@Expresion,'') IS NULL RETURN @Resultado
SET @Longitud = LEN(@Expresion)
SET @Contador = 1
SET @Estado = 0
SET @Variable = ''
WHILE @Contador <= @Longitud
BEGIN
SET @EstadoAnterior = @Estado
SET @Caracter = SUBSTRING(@Expresion,@Contador,1)
IF @Estado = 0 AND @Caracter = '{'            SET @Estado = 1 ELSE
IF @Estado = 1 AND @Caracter NOT IN ('{','}') SET @Estado = 2 ELSE
IF @Estado IN (1,2) AND @Caracter = '}'       SET @Estado = 3
IF @Estado = 0
BEGIN
SET @Resultado = @Resultado + @Caracter
END ELSE IF @Estado = 1
BEGIN
SET @Variable = ''
END ELSE IF @Estado = 2
BEGIN
SET @Variable = @Variable + @Caracter
END ELSE IF @Estado = 3
BEGIN
SELECT @Valor = RTRIM(ISNULL(Valor,'')), @Tipo = RTRIM(ISNULL(Tipo,'TEXTO')) FROM eDocInVariableTemp WHERE Estacion = @@SPID AND UPPER(LTRIM(RTRIM(Variable))) = UPPER(RTRIM(LTRIM(@Variable)))
IF @Tipo NOT IN ('TEXTO','NUMERICO','FECHA','LOGICO')
BEGIN
SET @Resultado = ''
RETURN @Resultado
END
IF @Tipo IN ('TEXTO','FECHA')
BEGIN
SET @Resultado = @Resultado + CHAR(39) + @Valor + CHAR(39)
END ELSE IF @Tipo IN ('NUMERICO')
BEGIN
SET @Resultado = @Resultado + @Valor
END
SET @Estado = 0
END
SET @Contador = @Contador + 1
END
RETURN (@Resultado)
END

