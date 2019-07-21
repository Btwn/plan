SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnUnidadMinima (@Articulo varchar(20))
RETURNS varchar(20)

AS BEGIN
DECLARE
@Unidad    varchar(20),
@UnidadCompra    varchar(20),
@UnidadTraspaso    varchar(20),
@Resultado varchar(20)
SELECT @Unidad = Unidad,
@UnidadCompra = UnidadCompra,
@UnidadTraspaso = UnidadTraspaso
FROM Art
WHERE Articulo = @Articulo
SELECT @Resultado = ''
IF @Resultado = '' AND EXISTS (SELECT * FROM Unidad WHERE Factor = 1 AND Unidad = @Unidad)
SET @Resultado = @Unidad
IF @Resultado = '' AND EXISTS (SELECT * FROM Unidad WHERE Factor = 1 AND Unidad = @UnidadCompra)
SET @Resultado = @UnidadCompra
IF @Resultado = '' AND EXISTS (SELECT * FROM Unidad WHERE Factor = 1 AND Unidad = @UnidadTraspaso)
SET @Resultado = @UnidadTraspaso
IF ISNULL(@Resultado,'') = ''
SELECT @Resultado = Unidad
FROM Unidad
WHERE Factor = 1
IF @Articulo IS NOT NULL
SELECT @Resultado = Unidad
FROM Art
WHERE Articulo = @Articulo
RETURN(@Resultado)
END

