SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWebOrdenarCombinacion
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
@Variable2			varchar(255),
@Valor				varchar(MAX),
@Tipo				varchar(50),
@Posicion                   int
DECLARE @Tabla table(ID int)
SET @Resultado = ''
IF NULLIF(@Expresion,'') IS NULL RETURN @Resultado
SET @Longitud = LEN(@Expresion)
SET @Contador = 1
SET @Estado = 0
SET @Variable = ''
WHILE @Contador <= @Longitud
BEGIN
SET @EstadoAnterior = @Estado
SET @Caracter = SUBSTRING(@Expresion,@Contador,1)
IF @Estado = 0 AND @Caracter =','   SET @Estado =1
IF @Estado = 0 AND @Contador = @Longitud SET @Estado =3
IF @Estado IN( 0,3)
SELECT @Variable = @Variable + @Caracter
IF  @Estado IN( 1,3)
BEGIN
IF ISNUMERIC(@Variable)=1
INSERT @Tabla(ID)
SELECT @Variable
SET @Estado = 0
SELECT @Variable = ''
END
SET @Contador = @Contador + 1
END
SELECT @Variable2 = ISNULL(@Variable2,'') + ',' + Convert(varchar,ID)
FROM  @Tabla
ORDER by ID
SELECT @Variable2 = STUFF(@Variable2,1,1,'' )
RETURN (@Variable2)
END

