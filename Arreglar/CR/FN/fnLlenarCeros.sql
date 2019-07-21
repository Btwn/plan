SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnLlenarCeros (@Consecutivo bigint, @Digitos int)
RETURNS varchar(16)
WITH ENCRYPTION
AS BEGIN
DECLARE
@Negativo	bit,
@Clave	varchar(16)
SELECT @Negativo = 0
IF @Consecutivo < 0 SELECT @Digitos = @Digitos - 1, @Consecutivo = -@Consecutivo, @Negativo = 1
SELECT @Clave = LTRIM(Convert(char, @Consecutivo))
IF @Digitos > 1  AND @Consecutivo < 10               SELECT @Clave = '0' + @Clave
IF @Digitos > 2  AND @Consecutivo < 100              SELECT @Clave = '0' + @Clave
IF @Digitos > 3  AND @Consecutivo < 1000             SELECT @Clave = '0' + @Clave
IF @Digitos > 4  AND @Consecutivo < 10000            SELECT @Clave = '0' + @Clave
IF @Digitos > 5  AND @Consecutivo < 100000           SELECT @Clave = '0' + @Clave
IF @Digitos > 6  AND @Consecutivo < 1000000          SELECT @Clave = '0' + @Clave
IF @Digitos > 7  AND @Consecutivo < 10000000         SELECT @Clave = '0' + @Clave
IF @Digitos > 8  AND @Consecutivo < 100000000        SELECT @Clave = '0' + @Clave
IF @Digitos > 9  AND @Consecutivo < 1000000000       SELECT @Clave = '0' + @Clave
IF @Digitos > 10 AND @Consecutivo < 10000000000      SELECT @Clave = '0' + @Clave
IF @Digitos > 11 AND @Consecutivo < 100000000000     SELECT @Clave = '0' + @Clave
IF @Digitos > 12 AND @Consecutivo < 1000000000000    SELECT @Clave = '0' + @Clave
IF @Digitos > 13 AND @Consecutivo < 10000000000000   SELECT @Clave = '0' + @Clave
IF @Digitos > 14 AND @Consecutivo < 100000000000000  SELECT @Clave = '0' + @Clave
IF @Digitos > 16 AND @Consecutivo < 1000000000000000 SELECT @Clave = '0' + @Clave
IF @Negativo = 1 SELECT @Clave = '-' + @Clave
SELECT @Clave = RTRIM(@Clave)
RETURN (@Clave)
END
*/
CREATE FUNCTION fnLlenarCeros (@Consecutivo varchar(Max), @Digitos int)
RETURNS varchar(16)
AS BEGIN
DECLARE
@Negativo	bit,
@Clave	varchar(16),
@DigitosConsecutivo int
SELECT @Negativo = 0
IF ISNUMERIC(@Consecutivo) = 1
IF @Consecutivo < 0 SELECT /*@Digitos = @Digitos - 1, @Consecutivo = -@Consecutivo,*/ @Negativo = 1
IF @Negativo = 1
SELECT @DigitosConsecutivo = LEN(@Consecutivo), @Clave = Stuff(@Consecutivo, 1, 1,'')
ELSE
SELECT @DigitosConsecutivo = LEN(@Consecutivo), @Clave = LTRIM(Convert(char, @Consecutivo))
IF @Digitos > 1  AND @DigitosConsecutivo < 2  SELECT @Clave = '0' + @Clave
IF @Digitos > 2  AND @DigitosConsecutivo < 3  SELECT @Clave = '0' + @Clave
IF @Digitos > 3  AND @DigitosConsecutivo < 4  SELECT @Clave = '0' + @Clave
IF @Digitos > 4  AND @DigitosConsecutivo < 5  SELECT @Clave = '0' + @Clave
IF @Digitos > 5  AND @DigitosConsecutivo < 6  SELECT @Clave = '0' + @Clave
IF @Digitos > 6  AND @DigitosConsecutivo < 7  SELECT @Clave = '0' + @Clave
IF @Digitos > 7  AND @DigitosConsecutivo < 8  SELECT @Clave = '0' + @Clave
IF @Digitos > 8  AND @DigitosConsecutivo < 9  SELECT @Clave = '0' + @Clave
IF @Digitos > 9  AND @DigitosConsecutivo < 10 SELECT @Clave = '0' + @Clave
IF @Digitos > 10 AND @DigitosConsecutivo < 11 SELECT @Clave = '0' + @Clave
IF @Digitos > 11 AND @DigitosConsecutivo < 12 SELECT @Clave = '0' + @Clave
IF @Digitos > 12 AND @DigitosConsecutivo < 13 SELECT @Clave = '0' + @Clave
IF @Digitos > 13 AND @DigitosConsecutivo < 14 SELECT @Clave = '0' + @Clave
IF @Digitos > 14 AND @DigitosConsecutivo < 15 SELECT @Clave = '0' + @Clave
IF @Digitos > 16 AND @DigitosConsecutivo < 17 SELECT @Clave = '0' + @Clave
IF @Negativo = 1 SELECT @Clave = '-' + @Clave
SELECT @Clave = RTRIM(@Clave)
RETURN (@Clave)
END

