SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnLDISeparaCadena
(
@Expresion				varchar(max)
)
RETURNS @Tabla TABLE (Parametro varchar(max), Valor varchar(max),Cadena varchar(max))

AS BEGIN
DECLARE
@Resultado			varchar(max),
@Longitud			bigint,
@Contador			bigint,
@Caracter			char(1),
@Estado			int,
@EstadoAnterior		int,
@Variable			varchar(max),
@Valor			varchar(max),
@Tipo			varchar(50),
@Posicion                   int,
@IDOpcion                   int,
@Cadena                     varchar(max),
@Lcadena                    int,
@PosicionCaracter           int
SET @Resultado = ''
SELECT @Expresion = REPLACE(REPLACE(@Expresion,'{',''),'}','')
IF NULLIF(@Expresion,'') IS NULL RETURN
SET @Longitud = LEN(@Expresion)
SET @Contador = 1
SET @Estado = 0
SET @Variable = ''
WHILE @Contador <= @Longitud
BEGIN
SET @EstadoAnterior = @Estado
SET @Caracter = SUBSTRING(@Expresion,@Contador,1)
IF @Estado = 0 AND @Caracter =';'   SET @Estado =1
IF @Estado = 0 AND @Contador = @Longitud SET @Estado =3
IF @Estado IN( 0,3)
SELECT @Variable = @Variable + @Caracter
IF  @Estado IN( 1,3)
BEGIN
INSERT @Tabla(Cadena )
SELECT       @Variable
SET @Estado = 0
SELECT @Variable = ''
END
SET @Contador = @Contador + 1
END
UPDATE @Tabla SET Parametro = SUBSTRING(Cadena,1,CHARINDEX(':',Cadena)-1)
UPDATE @Tabla SET Valor = REPLACE(Cadena,Parametro+':','')
RETURN
END

