SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCaracterEspecial (@Etiqueta varchar(50))
RETURNS varchar(50)

AS BEGIN
DECLARE
@Resultado varchar(50)
SELECT @Etiqueta = UPPER(@Etiqueta)
IF @Etiqueta IN ('<ESP>', '<ESPACIO>', '<SPC>') SELECT @Resultado = ' '
ELSE IF @Etiqueta = '<CR>'   SELECT @Resultado = CHAR(13)
ELSE IF @Etiqueta = '<TAB>'  SELECT @Resultado = CHAR(9)
ELSE IF @Etiqueta = '<PIPE>' SELECT @Resultado = '|'
ELSE IF @Etiqueta = '<AND>'  SELECT @Resultado = '&'
RETURN(@Resultado)
END

