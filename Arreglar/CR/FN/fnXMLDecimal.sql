SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnXMLDecimal (@Parametro varchar(255), @Valor float, @Decimales int)
RETURNS varchar(255)

AS BEGIN
DECLARE
@Resultado	varchar(255),
@Valor2 varchar(100)
IF @Valor IS NULL
SELECT @Resultado = ''
ELSE
BEGIN
IF @Decimales = 1 SELECT @Valor2 = CONVERT(Decimal(38,1),@Valor)
IF @Decimales = 2 SELECT @Valor2 = CONVERT(Decimal(38,2),@Valor)
IF @Decimales = 3 SELECT @Valor2 = CONVERT(Decimal(38,3),@Valor)
IF @Decimales = 4 SELECT @Valor2 = CONVERT(Decimal(38,4),@Valor)
IF @Decimales = 5 SELECT @Valor2 = CONVERT(Decimal(38,5),@Valor)
IF @Decimales >= 6 SELECT @Valor2 = CONVERT(Decimal(38,6),@Valor)
SELECT @Resultado = ' '+dbo.fnXMLParametro(@Parametro)+'="'+CONVERT(varchar,@Valor2)+'"'
END
RETURN(@Resultado)
END

