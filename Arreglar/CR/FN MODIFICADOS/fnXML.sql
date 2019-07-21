SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnXML (@Parametro varchar(255), @Valor varchar(max))
RETURNS varchar(max)

AS BEGIN
DECLARE
@Resultado	varchar(max)
SELECT @Valor = dbo.fnXMLValor(@Valor)
IF @Valor IS NULL
SELECT @Resultado = ''
ELSE
SELECT @Resultado = ' '+dbo.fnXMLParametro(@Parametro)+'="'+@Valor+'"'
RETURN(@Resultado)
END

