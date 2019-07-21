SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWebSepararContacto
(
@Expresion				varchar(255),
@Tipo                                   int
)
RETURNS varchar(255)
AS BEGIN
DECLARE
@Resultado			varchar(255),
@Posicion                   int,
@Len                        int
SELECT @Len = LEN(@Expresion)
SELECT @Posicion = CHARINDEX(' ',@Expresion)
IF(@Posicion = 0) RETURN @Expresion
IF @Tipo = 1
SELECT @Resultado = SUBSTRING(@Expresion,1,@Posicion-1)
IF @Tipo = 2
SELECT @Resultado = SUBSTRING(@Expresion,@Posicion,@Len)
SELECT @Resultado = LTRIM(RTRIM(@Resultado))
RETURN (@Resultado)
END

