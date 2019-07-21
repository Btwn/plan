SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnCFDFlexSepararID
(@ID     varchar(50), @Tipo varchar(50))
RETURNS varchar(50)

AS BEGIN
DECLARE
@Resultado      varchar(50),
@Caracter       int,
@Longitud		  int
SELECT @Longitud = LEN(@ID)
SELECT @Caracter= CHARINDEX('#',@ID)
IF @Tipo = 'ID' AND @Caracter > 0
SELECT @Resultado =  SUBSTRING(@ID, @Caracter + 1, @Longitud)
IF @Tipo = 'Modulo' AND @Caracter > 0
SELECT @Resultado =  SUBSTRING(@ID, 1, @Caracter -1 )
SELECT @Resultado = ISNULL(@Resultado,'')
RETURN (@Resultado)
END

