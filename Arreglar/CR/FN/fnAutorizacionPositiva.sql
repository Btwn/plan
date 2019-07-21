SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnAutorizacionPositiva
(
@Mensaje				varchar(max)
)
RETURNS bit

AS BEGIN
DECLARE
@Resultado								bit,
@Largo									int,
@Contador								int,
@Caracter								char(1),
@Modo									int,
@Campo									varchar(255)
SET @Mensaje = REPLACE(@Mensaje,CHAR(10),CHAR(32))
SET @Mensaje = REPLACE(@Mensaje,CHAR(13),CHAR(32))
SET @Mensaje = LTRIM(@Mensaje)
SELECT @Largo = LEN(@Mensaje), @Contador = 1, @Modo = 0, @Resultado = 0
WHILE @Contador <= @Largo
BEGIN
SET @Caracter = UPPER(SUBSTRING(@Mensaje,@Contador,1))
IF @Contador = 1
BEGIN
IF @Caracter NOT IN ('S','Y','O')  AND @Modo = 0  SET @Modo = -1  ELSE
IF @Caracter = 'S'                 AND @Modo = 0  SET @Modo = 1   ELSE
IF @Caracter = 'O'                 AND @Modo = 0  SET @Modo = 2   ELSE
IF @Caracter = 'Y'                 AND @Modo = 0  SET @Modo = 3
END ELSE
IF @Contador = 2
BEGIN
IF @Caracter <> 'I'                AND @Modo = 1 SET @Modo = -1  ELSE
IF @Caracter <> 'K'                AND @Modo = 2 SET @Modo = -1  ELSE
IF @Caracter <> 'E'                AND @Modo = 3 SET @Modo = -1  ELSE
IF @Caracter = 'I'                 AND @Modo = 1 SET @Modo = 100 ELSE
IF @Caracter = 'S'                 AND @Modo = 1 SET @Modo = 100 ELSE
IF @Caracter = 'K'                 AND @Modo = 2 SET @Modo = 100 ELSE
IF @Caracter = 'E'                 AND @Modo = 3 SET @Modo = 4
END ELSE
IF @Contador = 3
BEGIN
IF @Caracter <> 'S' AND @Modo = 4  SET @Modo = -1  ELSE
IF @Caracter = 'S'  AND @Modo = 4  SET @Modo = 100
END
IF @Modo = 100
BEGIN
SET @Resultado = 1
RETURN @Resultado
END ELSE
IF @Modo = -1
BEGIN
SET @Resultado = 0
RETURN @Resultado
END
SET @Contador = @Contador + 1
END
RETURN (@Resultado)
END

