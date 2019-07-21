SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnTextoaTabla (@Texto varchar(max), @Longitud int)
RETURNS @Resultado TABLE (CadenaOriginal varchar(255))

AS BEGIN
DECLARE
@CadenaOriginal 	varchar(max)
SELECT @Texto = ISNULL(RTRIM(@Texto), '')
WHILE LEN(@Texto) > 0
BEGIN
SELECT @CadenaOriginal = LTRIM(RTRIM(SUBSTRING(@Texto, 1, @Longitud-1)))
SELECT @Texto = SUBSTRING(@Texto, @Longitud, LEN(@Texto))
SELECT @CadenaOriginal = NULLIF(RTRIM(@CadenaOriginal), '')
IF @CadenaOriginal IS NOT NULL
INSERT @Resultado (CadenaOriginal)
SELECT            @CadenaOriginal
END
RETURN
END

