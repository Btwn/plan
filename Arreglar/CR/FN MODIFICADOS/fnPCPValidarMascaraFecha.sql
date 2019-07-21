SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPCPValidarMascaraFecha
(
@Fecha							varchar(10),
@Mascara						varchar(10)
)
RETURNS bit

AS BEGIN
DECLARE
@Resultado			bit,
@LongitudMascara	int,
@Contador			int,
@Salir				bit,
@CaracterMascara	char(1),
@CaracterFecha		char(1)
SET @Salir = 0
SET @Resultado = 1
SET @LongitudMascara = LEN(@Mascara)
IF LEN(@Fecha) <> @LongitudMascara SELECT @Salir = 1, @Resultado = 0
SET @Contador = 1
WHILE @Contador <= @LongitudMascara AND @Salir = 0
BEGIN
SET @CaracterFecha = SUBSTRING(@Fecha,@Contador,1)
SET @CaracterMascara = SUBSTRING(@Mascara,@Contador,1)
IF (@CaracterFecha <> @CaracterMascara) AND @CaracterMascara <> '?' SELECT @Resultado = 0, @Salir = 1
SET @Contador = @Contador + 1
END
RETURN (@Resultado)
END

