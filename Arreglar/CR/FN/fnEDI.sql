SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnEDI (@Valor varchar(4000))
RETURNS varchar(4000)

AS BEGIN
SELECT @Valor = dbo.fnQuitarDoblesEspacios(@Valor)
SELECT @Valor = REPLACE(REPLACE(REPLACE(REPLACE(@Valor, '&', 'y'),'<',''),'>',''), char(34),'')
SELECT @Valor = LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(@Valor, '''', '?'''), '+', '?+'), ':', '?:')))
RETURN (@Valor)
END

