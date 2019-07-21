SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnXMLValor (@Valor varchar(8000))
RETURNS varchar(8000)

AS BEGIN
/*
SELECT @Valor = REPLACE(@Valor,'?', 'euros')
SELECT @Valor = REPLACE(@Valor,''',',')
SELECT @Valor = REPLACE(@Valor,'�','')
SELECT @Valor = REPLACE(@Valor,'"',',,')
SELECT @Valor = REPLACE(@Valor,'.','...')
SELECT @Valor = REPLACE(@Valor,'�','')
SELECT @Valor = REPLACE(@Valor,'�','')
SELECT @Valor = REPLACE(@Valor,'^','')
SELECT @Valor = REPLACE(@Valor,'%','0/00')
SELECT @Valor = REPLACE(@Valor,'S','')
SELECT @Valor = REPLACE(@Valor,'<','<')
SELECT @Valor = REPLACE(@Valor,'O','OE')
SELECT @Valor = REPLACE(@Valor,''',CHAR(39))
SELECT @Valor = REPLACE(@Valor,''',CHAR(39))
SELECT @Valor = REPLACE(@Valor,'"',CHAR(34))
SELECT @Valor = REPLACE(@Valor,'"',CHAR(34))
SELECT @Valor = REPLACE(@Valor,'','-')
SELECT @Valor = REPLACE(@Valor,'-','-')
SELECT @Valor = REPLACE(@Valor,'-','-')
SELECT @Valor = REPLACE(@Valor,'~','')
SELECT @Valor = REPLACE(@Valor,'T','Trade Mark')
SELECT @Valor = REPLACE(@Valor,'s','')
SELECT @Valor = REPLACE(@Valor,'>','>')
SELECT @Valor = REPLACE(@Valor,'o','OE')
SELECT @Valor = REPLACE(@Valor,'Y','')
SELECT @Valor = REPLACE(@Valor,'Z','')
SELECT @Valor = REPLACE(@Valor,'z','')
*/
SELECT @Valor = dbo.fnQuitarDoblesEspacios(@Valor)
SELECT @Valor = NULLIF(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@Valor, '&', '&amp;'), '<', '&lt;'), '>', '&gt;'), '"', '&quot;'), '''', '&#39;'))),'')
RETURN (@Valor)
END

