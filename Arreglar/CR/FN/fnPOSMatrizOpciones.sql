SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPOSMatrizOpciones (
@Expresion		varchar(max),
@Tipo			int
)
RETURNS varchar(50)

AS
BEGIN
DECLARE
@Resultado			varchar(max),
@Posicion                   int,
@Longitud                   int
SELECT @Expresion =LTRIM(RTRIM(@Expresion))
SELECT @Longitud = LEN(@Expresion)
IF @Longitud <=4 AND (CHARINDEX(CHAR(9),@Expresion)= 0 AND CHARINDEX(CHAR(32),@Expresion)=0)
SELECT @Expresion=@Expresion+CHAR(9)+'1'
SELECT @Posicion = CHARINDEX(CHAR(9),@Expresion)
IF @Posicion = 0
SELECT @Posicion = CHARINDEX(CHAR(32),@Expresion)
IF @Tipo = 1
SELECT @Resultado =  SUBSTRING(@Expresion,1,(@Posicion-1))
IF @Tipo = 2
SELECT @Resultado =  SUBSTRING(@Expresion,(@Posicion+1),@Longitud)
SELECT @Resultado = LTRIM(RTRIM(@Resultado))
RETURN (@Resultado )
END

