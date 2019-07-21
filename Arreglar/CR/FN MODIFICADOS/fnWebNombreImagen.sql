SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWebNombreImagen
(
@Expresion				varchar(255)
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
@Variable			varchar(255),
@Valor				varchar(MAX),
@Tipo				varchar(50),
@Posicion                   int
SET @Resultado = ''
IF NULLIF(@Expresion,'') IS NULL RETURN @Resultado
SELECT @Expresion = REVERSE(@Expresion)
SET @Longitud = LEN(@Expresion)
SET @Contador = 1
SET @Estado = 0
SET @Variable = ''
WHILE @Contador <= @Longitud
BEGIN
SET @EstadoAnterior = @Estado
SET @Caracter = SUBSTRING(@Expresion,@Contador,1)
IF @Estado = 0 AND @Caracter = '\'   SET @Estado = 1
IF @Estado = 0
BEGIN
SET @Variable = @Variable + @Caracter
END
SET @Contador = @Contador + 1
END
SELECT @Variable = REVERSE(@Variable)
RETURN (@Variable)
END

