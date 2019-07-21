SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCaracterAUTF8
(
@Caracter				CHAR(1),
@ConvertirCP437			bit,
@ConvertirComillas		bit = 1
)
RETURNS varCHAR(20)

AS BEGIN
DECLARE
@CaracterCP437	int,
@CaracterUTF8	varCHAR(20)
SET @CaracterCP437 = dbo.fnASCII_CP437(@Caracter,@ConvertirCP437)
IF @Caracter = CHAR(38) SET @CaracterUTF8  = '&#038;'    ELSE
IF @Caracter = CHAR(94) SET @CaracterUTF8  = '&#094;'    ELSE
IF @Caracter = CHAR(34) AND @ConvertirComillas = 1 SET @CaracterUTF8  = '&#034;'    ELSE
IF (@CaracterCP437 >= 128 OR @CaracterCP437 <= 31) AND @CaracterCP437 NOT IN (10,13) SET @CaracterUTF8 = '&#' + REPLICATE('0',3-LEN(CONVERT(varchar,dbo.fnASCII_CP437(@Caracter,@ConvertirCP437)))) + CONVERT(varchar,dbo.fnASCII_CP437(@Caracter,@ConvertirCP437)) + ';' ELSE
IF (@CaracterCP437 < 128 AND @CaracterCP437 >= 32) OR @CaracterCP437 IN (10,13) SET @CaracterUTF8 = @Caracter
RETURN (@CaracterUTF8)
END

