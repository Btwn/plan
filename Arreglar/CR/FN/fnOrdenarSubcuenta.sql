SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnOrdenarSubcuenta(
@Articulo varchar(20),
@SubCuenta varchar(20)
)
RETURNS varchar(20)
AS
BEGIN
DECLARE
@ret        varchar(20),
@o          char(1),
@t          varchar(20),
@c          char(1),
@k          int
DECLARE @Orden TABLE(
id          int IDENTITY(1,1),
Opcion      char(1)
)
SET @SubCuenta = LTRIM(RTRIM(@SubCuenta)) + '~'
SET @ret = ''
SET @o   = ''
SET @t   = ''
SET @c   = ''
SET @k   = 0
INSERT INTO @Orden
SELECT a.Opcion
FROM ArtOpcion a
JOIN Opcion o ON(a.Opcion = o.Opcion)
WHERE a.Articulo = @Articulo
ORDER BY a.Orden, a.Opcion
DECLARE fnOrdenarSubcuenta_cursor CURSOR FOR SELECT Opcion FROM @Orden
OPEN fnOrdenarSubcuenta_cursor
FETCH NEXT FROM fnOrdenarSubcuenta_cursor INTO @o
WHILE @@FETCH_STATUS = 0
BEGIN
SET @t = ''
SET @k = CHARINDEX(@o,@SubCuenta,1)
If @k > 0
BEGIN
SET @t = @o
SET @k = @k + 1
SET @c = SUBSTRING(@SubCuenta,@k,1)
WHILE IsNumeric(@c) = 1
BEGIN
SET @t = @t + @c
SELECT @k = @k + 1
SELECT @c = SUBSTRING(@SubCuenta,@k,1)
END
SET @ret = @ret + @t
END
FETCH NEXT FROM fnOrdenarSubcuenta_cursor INTO @o
END
CLOSE fnOrdenarSubcuenta_cursor
DEALLOCATE fnOrdenarSubcuenta_cursor
SET @ret = LTRIM(RTRIM(@ret))
RETURN @ret
END

