SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnDivideRenglon
(@Cadena		varchar(max),
@Cantidad	int)
RETURNS VARCHAR(MAX)
BEGIN
DECLARE
@len         int,
@cadenanueva varchar(max),
@cadenaaux   varchar(max),
@caracteres  int
SET @len = LEN(@cadena)
SET @cadenanueva =''
SET @cadenaaux = ''
SET @caracteres = @Cantidad
WHILE (LEN(@cadena) > 0)
BEGIN
SET @cadenaaux = SUBSTRING(@cadena,0,@caracteres) + CHAR(10)+CHAR(13)
SET @cadena= SUBSTRING(@cadena,@caracteres,LEN(@cadena))
SET @len = LEN(@cadena)
SET @cadenanueva = @cadenanueva + @cadenaaux
SET @cadenaaux = ''
END
RETURN @cadenanueva
END

