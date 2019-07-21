SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnEstructuraEnOrden (@Clave varchar(50), @Digitos int)
RETURNS varchar(255)

AS BEGIN
DECLARE
@a 		int,
@b		int,
@Resultado 	varchar(255),
@Separador	char(1)
SELECT @Clave = NULLIF(RTRIM(@Clave), '')
IF @Clave IS NULL
SELECT @Resultado = NULL
ELSE
BEGIN
IF CHARINDEX('.', @Clave) > 0 SELECT @Separador = '.' ELSE
IF CHARINDEX('-', @Clave) > 0 SELECT @Separador = '-' ELSE
IF CHARINDEX('/', @Clave) > 0 SELECT @Separador = '/' ELSE
IF CHARINDEX('\', @Clave) > 0 SELECT @Separador = '\'
ELSE SELECT @Separador = '.'
SELECT @Resultado = ''
SELECT @a = 1
SELECT @b = CHARINDEX(@Separador, @Clave, 1)
WHILE @b > 0
BEGIN
SELECT @Resultado = @Resultado + dbo.fnLlenarCeros(SUBSTRING(@Clave, 1, @b-1), @Digitos) + SUBSTRING(@Clave, @b, 1)
SELECT @a = @b+1
SELECT @Clave = SUBSTRING(@Clave, @a, LEN(@Clave))
SELECT @b = CHARINDEX(@Separador, @Clave, 1)
END
IF NULLIF(@Clave, '') IS NOT NULL
SELECT @Resultado = @Resultado + dbo.fnLlenarCeros(SUBSTRING(@Clave, 1, LEN(@Clave)), @Digitos)
END
RETURN (@Resultado)
END

