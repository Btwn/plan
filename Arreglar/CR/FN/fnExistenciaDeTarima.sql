SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnExistenciaDeTarima (@Empresa varchar(5), @Almacen varchar(10), @Tarima varchar(20), @Articulo varchar(20))
RETURNS float

AS BEGIN
DECLARE
@Resultado	float
SELECT @Resultado = NULL
SELECT @Resultado = SUM(Existencia)
FROM ArtExistenciaTarima
WHERE Empresa = @Empresa AND Almacen = @Almacen AND Tarima = @Tarima AND Articulo = @Articulo
RETURN(@Resultado)
END

