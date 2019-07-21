SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnAlinearCampoValor2 (
@Campo		varchar(max),
@Valor		varchar(max),
@Espacio	int
)
RETURNS varchar(max)

AS
BEGIN
DECLARE
@Contador   int,
@Longitud   int,
@Campo2		varchar(max),
@Campo3		varchar(max)
SET @Contador = (@Espacio-LEN(@VALOR))
SET @Longitud = 0
IF (LEN(@Campo)+LEN(@Valor))>@Espacio
BEGIN
WHILE @Longitud < @Contador
BEGIN
SET @Campo2 =''
SELECT @Campo2 = dbo.fnAlinearCampoValor(SUBSTRING(@Campo,ISNULL(@Longitud,1)+1,(@Espacio-(LEN(@Valor)+1))),@Valor,@Espacio)
SELECT @Campo3 = ISNULL(@Campo3,'')+ISNULL(@Campo2,'')
SELECT @Longitud = @Longitud+ LEN(SUBSTRING(@Campo,ISNULL(@Longitud,1)+1,(@Espacio-(LEN(@Valor)+1))))
END
END
ELSE
SELECT @Campo3 = dbo.fnAlinearCampoValor(@Campo,@Valor,@Espacio)
RETURN(@Campo3)
END

