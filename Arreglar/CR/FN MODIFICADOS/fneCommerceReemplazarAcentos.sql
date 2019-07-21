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
SELECT @Texto = REPLACE(@Texto, '�', 'a')
SELECT @Texto = REPLACE(@Texto, '�', 'e')
SELECT @Texto = REPLACE(@Texto, '�', 'i')
SELECT @Texto = REPLACE(@Texto, '�', 'o')
SELECT @Texto = REPLACE(@Texto, '�', 'u')
SELECT @Texto = REPLACE(@Texto, '�', 'a')
SELECT @Texto = REPLACE(@Texto, '�', 'e')
SELECT @Texto = REPLACE(@Texto, '�', 'i')
SELECT @Texto = REPLACE(@Texto, '�', 'o')
SELECT @Texto = REPLACE(@Texto, '�', 'u')
SELECT @Texto = REPLACE(@Texto, '�', 'A')
SELECT @Texto = REPLACE(@Texto, '�', 'E')
SELECT @Texto = REPLACE(@Texto, '�', 'I')
SELECT @Texto = REPLACE(@Texto, '�', 'O')
SELECT @Texto = REPLACE(@Texto, '�', 'U')
SELECT @Texto = REPLACE(@Texto, '�', 'A')
SELECT @Texto = REPLACE(@Texto, '�', 'E')
SELECT @Texto = REPLACE(@Texto, '�', 'I')
SELECT @Texto = REPLACE(@Texto, '�', 'O')
SELECT @Texto = REPLACE(@Texto, '�', 'U')
RETURN @Texto
END

