SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnFormatoMonedaDec
(
@Valor decimal(30,10),
@Decimales int
)
RETURNS varchar(50)
AS BEGIN
DECLARE @Resultado          varchar(20),
@Negativo           bit,
@Antes              varchar(20),
@Despues            varchar(20),
@Coma               int,
@RedondeoMonetarios int
SELECT @Negativo = CASE WHEN @Valor < 0 THEN 1 ELSE 0 END
SELECT @Valor    = ROUND(@Valor, @Decimales)
IF @Negativo = 1
SET @Valor = -1 * @Valor
SET @Resultado = CONVERT(varchar, ISNULL(@Valor, 0.0))
IF CHARINDEX ('.',@Resultado) > 0
BEGIN
SET @Despues = SUBSTRING(@Resultado, CHARINDEX ('.', @Resultado), LEN(@Resultado))
SET @Antes  = SUBSTRING(@Resultado,1, CHARINDEX ('.', @Resultado)-1)
END
ELSE
BEGIN
SET @Antes =   @Resultado
SET @Despues = ''
END
IF LEN(@Antes) > 3
BEGIN
SET @Coma = 3
WHILE @Coma > 1 and @Coma < LEN(  @Antes)
BEGIN
SET @Antes = SUBSTRING(@Antes,1,LEN(@Antes) - @Coma) + ',' + RIGHT(@Antes,@Coma)
SET @Coma = @Coma + 4
END
END
SET @Resultado = @Antes + SUBSTRING(@Despues,1,@Decimales + 1)
IF @Negativo = 1
SET @Resultado = '-' + @Resultado
SELECT @Resultado = '$' + @Resultado
RETURN  @Resultado
RETURN (@Resultado)
END

