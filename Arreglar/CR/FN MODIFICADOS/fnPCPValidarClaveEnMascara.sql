SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPCPValidarClaveEnMascara
(
@Clave					varchar(20),
@Categoria				varchar(1),
@Mascara				varchar(50)
)
RETURNS bit

AS BEGIN
DECLARE
@Resultado			bit,
@Digitos			int,
@Contador			int,
@LongitudMascara	int,
@LongitudCategoria	int,
@Caracter			varchar(1)
SET @Contador = 1
SET @LongitudMascara = LEN(@Mascara)
SET @LongitudCategoria = 0
WHILE @Contador <= @LongitudMascara
BEGIN
SET @Caracter = SUBSTRING(@Mascara,@Contador,1)
IF @Caracter = @Categoria SET @LongitudCategoria = @LongitudCategoria + 1
SET @Contador = @Contador + 1
END
SET @Resultado = 0
IF LEN(@Clave) = @LongitudCategoria SET @Resultado = 1
RETURN (@Resultado)
END

