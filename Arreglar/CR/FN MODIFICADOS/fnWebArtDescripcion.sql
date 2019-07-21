SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWebArtDescripcion
(
@Expresion				varchar(MAX)
)
RETURNS varchar(MAX)

AS BEGIN
DECLARE
@Resultado			varchar(MAX),
@Longitud			bigint,
@Contador			bigint,
@Caracter			char(1),
@Estado				int,
@EstadoAnterior		int,
@Variable			varchar(MAX),
@Valor				varchar(MAX),
@Tipo				varchar(50),
@Posicion                   int
SET @Resultado = ''
SELECT @Expresion = LOWER(@Expresion)
SET @Longitud = LEN(@Expresion)
SET @Contador = 1
SET @Estado = 3
SET @Variable = ''
WHILE @Contador <= @Longitud
BEGIN
SET @Caracter = SUBSTRING(@Expresion,@Contador,1)
IF @Estado IN(0,3) AND @Caracter IN('',' ')   SET @Estado = 1
IF @Estado = 0
BEGIN
SET @Variable = @Variable + @Caracter
END
IF @Estado = 3
BEGIN
SET @Variable = @Variable + UPPER(@Caracter)
SET @Estado = 0
END
IF @Estado = 1
BEGIN
SET @Variable = @Variable + @Caracter
SET @Estado = 3
END
SET @Contador = @Contador + 1
END
RETURN (@Variable)
END

