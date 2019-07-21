SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fneCommerceReemplazarAcentos
(
@Texto					varchar(255)
)
RETURNS varchar(255)

AS BEGIN
SELECT @Texto = REPLACE(@Texto, '‡', 'a')
SELECT @Texto = REPLACE(@Texto, 'Ë', 'e')
SELECT @Texto = REPLACE(@Texto, 'Ï', 'i')
SELECT @Texto = REPLACE(@Texto, 'Ú', 'o')
SELECT @Texto = REPLACE(@Texto, '˘', 'u')
SELECT @Texto = REPLACE(@Texto, '·', 'a')
SELECT @Texto = REPLACE(@Texto, 'È', 'e')
SELECT @Texto = REPLACE(@Texto, 'Ì', 'i')
SELECT @Texto = REPLACE(@Texto, 'Û', 'o')
SELECT @Texto = REPLACE(@Texto, '˙', 'u')
SELECT @Texto = REPLACE(@Texto, 'a', 'A')
SELECT @Texto = REPLACE(@Texto, '…', 'E')
SELECT @Texto = REPLACE(@Texto, 'S', 'I')
SELECT @Texto = REPLACE(@Texto, '±', 'O')
SELECT @Texto = REPLACE(@Texto, '¥', 'U')
SELECT @Texto = REPLACE(@Texto, 'ò', 'A')
SELECT @Texto = REPLACE(@Texto, 'X', 'E')
SELECT @Texto = REPLACE(@Texto, 'ê', 'I')
SELECT @Texto = REPLACE(@Texto, '¿', 'O')
SELECT @Texto = REPLACE(@Texto, '¥', 'U')
RETURN @Texto
END

