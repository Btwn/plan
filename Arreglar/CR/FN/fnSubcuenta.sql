SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSubcuenta (@SubCuenta varchar(20))
RETURNS varchar(1000)
AS
BEGIN
DECLARE
@ret        varchar(1000),    
@s          varchar(20),      
@Opcion     char(1),          
@Numero     varchar(20),      
@t          varchar(1000),    
@c          char(1),          
@n          varchar(20),      
@o          int,              
@i          int,              
@k          int               
SELECT @ret = ''
SELECT @s = LTRIM(RTRIM(ISNULL(@SubCuenta,''))) + '~'
SELECT @Opcion = ''
SELECT @Numero = ''
SELECT @t = ''
SELECT @c = ''
SELECT @n = ''
SELECT @o = 0
SELECT @i = 1
SELECT @k = LEN(@s)
WHILE @i <= @k
BEGIN
SELECT @c = SUBSTRING(@s,@i,1)
IF NOT ISNUMERIC(@c) = 1
BEGIN
IF LEN(@Numero) > 0
BEGIN
SELECT @t = ''
SELECT @t = ISNULL(Nombre,'') FROM OpcionD d WHERE d.Opcion = @Opcion AND d.Numero = @Numero
SELECT @t = LTRIM(RTRIM(@t))
IF LEN(@t) > 0
BEGIN
SELECT @ret = @ret + @t + CHAR(32)
SELECT @o = @o + 1
END
SELECT @Opcion = @c
SELECT @Numero = ''
END
ELSE
BEGIN
SELECT @Opcion = @c
END
END
ELSE
BEGIN
SELECT @Numero = @Numero + @c
END
SELECT @i = @i + 1
END
SET @ret = UPPER(LTRIM(RTRIM(@ret)))
RETURN @ret
END

