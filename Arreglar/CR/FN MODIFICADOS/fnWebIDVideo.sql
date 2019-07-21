SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWebIDVideo
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
SET @Expresion = REPLACE(@Expresion, 'http://', '')
SET @Expresion = REPLACE(@Expresion, 'https://', '')
SET @Expresion = REPLACE(@Expresion, 'www.youtu.be/', 'youtube.com/?v=')
SET @Expresion = REPLACE(@Expresion, 'youtu.be/', 'youtube.com/?v=')
SET @Longitud = LEN(@Expresion)
SELECT @Posicion = CHARINDEX('v=',@Expresion)
SELECT @Expresion = SUBSTRING(@Expresion,@Posicion,@Longitud)
SET @Longitud = LEN(@Expresion)
SET @Contador = 1
SET @Estado = 0
SET @Variable = ''
WHILE @Contador <= @Longitud
BEGIN
SET @EstadoAnterior = @Estado
SET @Caracter = SUBSTRING(@Expresion,@Contador,1)
IF @Estado = 0 AND @Caracter = 'v'   SET @Estado = 1 ELSE
IF @Estado = 1 AND @Caracter = ('=') SET @Estado = 2 ELSE
IF @Estado = 2 AND @Caracter = '&' OR  @Contador = @Longitud+1      SET @Estado = 3
IF @Estado = 2
BEGIN
SET @Variable = @Variable + @Caracter
END
SET @Contador = @Contador + 1
END
SELECT @Variable=stuff(@Variable,1,1,'' )
RETURN (@Variable)
END

