SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnTagFloatXSD (@xsd varchar(255), @Parametro varchar(255), @Valor float)
RETURNS varchar(255)

AS BEGIN
DECLARE
@Resultado	varchar(255)
SELECT @Valor = RTRIM(@Valor)
IF @Valor IS NULL
SELECT @Resultado = ''
ELSE
SELECT @Resultado = '<'+@xsd+':'+dbo.fnXMLParametro(@Parametro)+'>'+CONVERT(varchar, @Valor)+'</'+@xsd+':'+dbo.fnXMLParametro(@Parametro)+'>'
RETURN(@Resultado)
END

