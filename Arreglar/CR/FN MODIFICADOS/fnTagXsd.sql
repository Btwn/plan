SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnTagXsd (@xsd varchar(255), @Parametro varchar(255), @Valor varchar(8000))
RETURNS varchar(8000)

AS BEGIN
DECLARE
@Resultado	varchar(8000)
SELECT @Valor = dbo.fnXMLValor(@Valor)
IF @Valor IS NULL
SELECT @Resultado = ''
ELSE
SELECT @Resultado = '<'+@xsd+':'+dbo.fnXMLParametro(@Parametro)+'>'+@Valor+'</'+@xsd+':'+dbo.fnXMLParametro(@Parametro)+'>'
RETURN(@Resultado)
END

