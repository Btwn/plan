SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnAlinearCampoValor (@Campo varchar(max), @Valor varchar(max), @Espacio int)
RETURNS varchar(max)

AS BEGIN
IF LEN(@Valor)>@Espacio SELECT @Valor = SUBSTRING(@Valor, 1, @Espacio)
IF LEN(@Campo)+LEN(@Valor)>@Espacio SELECT @Campo = SUBSTRING(@Campo, 1, @Espacio-LEN(@Campo))
RETURN(@Campo+SPACE(@Espacio-LEN(@Campo)-LEN(@Valor))+@Valor)
END

