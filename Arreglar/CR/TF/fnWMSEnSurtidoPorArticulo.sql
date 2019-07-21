SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWMSEnSurtidoPorArticulo (@Tarima varchar(20))
RETURNS @Tabla TABLE
(
Articulo			varchar(20),
Cantidad			float
)
AS BEGIN
DECLARE
@Articulo		varchar(20)
DECLARE crSurtidoPorArticulo CURSOR LOCAL FOR
SELECT Articulo
FROM dbo.fnWMSEnSurtido(@Tarima, NULL)
GROUP BY Articulo
OPEN crSurtidoPorArticulo
FETCH NEXT FROM crSurtidoPorArticulo INTO @Articulo
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT INTO @Tabla
SELECT x.Articulo, SUM(x.Cantidad) Cantidad
FROM(
SELECT Articulo, Cantidad
FROM dbo.fnWMSEnSurtido(@Tarima, @Articulo)
) x
GROUP BY x.Articulo
FETCH NEXT FROM crSurtidoPorArticulo INTO @Articulo
END
CLOSE crSurtidoPorArticulo
DEALLOCATE crSurtidoPorArticulo
RETURN
END

