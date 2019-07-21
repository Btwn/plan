SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnConvertirTextoaTabla (@Texto varchar(max), @Longitud int, @Caracter char(1))
RETURNS @Tabla TABLE (Resultado varchar(255))

AS BEGIN
DECLARE
@Resultado 	varchar(max)
SELECT @Texto = ISNULL(RTRIM(@Texto), ''),
@Caracter = NULLIF(@Caracter, '')
WHILE LEN(@Texto) > 0 AND @Longitud > 0 AND @Caracter IS NULL
BEGIN
SELECT @Resultado = LTRIM(RTRIM(SUBSTRING(@Texto, 1, @Longitud-1)))
SELECT @Texto = SUBSTRING(@Texto, @Longitud, LEN(@Texto))
SELECT @Resultado = NULLIF(RTRIM(@Resultado), '')
IF @Resultado IS NOT NULL
INSERT @Tabla (Resultado)
SELECT        @Resultado
END
WHILE CHARINDEX(@Caracter, @Texto) > 0 AND @Longitud = 0
BEGIN
INSERT @Tabla (Resultado)
SELECT LTRIM(RTRIM(SUBSTRING(@Texto, 1, CHARINDEX(',', @Texto)-1)))
SELECT @Texto = SUBSTRING(@Texto,CHARINDEX(',', @Texto)+1, LEN(@Texto))
END
RETURN
END

