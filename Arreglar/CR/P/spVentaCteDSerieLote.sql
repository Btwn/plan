SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVentaCteDSerieLote
@Empresa			char(5),
@Sucursal			int,
@CfgSeriesLotesAutoOrden 	char(20),
@ID				int,
@VentaDRenglonID 		int,
@RenglonID			int,
@VentaID			int,
@Articulo			char(20),
@SubCuenta			varchar(50),
@CantidadTotal			float

AS BEGIN
DECLARE
@SeriesLotesAutoOrden	char(20),
@SerieLote			varchar(50),
@Cantidad			float,
@CantidadAlterna		float,
@SumaCantidad		float,
@Propiedades		varchar(20),
@Ubicacion			int,
@ArtCostoInv		float
SELECT @SeriesLotesAutoOrden = ISNULL(NULLIF(NULLIF(RTRIM(UPPER(SeriesLotesAutoOrden)), ''), '(EMPRESA)'), @CfgSeriesLotesAutoOrden)
FROM Art
WHERE Articulo = @Articulo
IF @SeriesLotesAutoOrden = 'DESCENDENTE'
DECLARE crSerieLoteMov CURSOR FOR
SELECT SerieLote, Cantidad, CantidadAlterna, Propiedades, Ubicacion, ArtCostoInv
FROM SerieLoteMov
WHERE Modulo = 'VTAS' AND ID = @ID AND RenglonID = @VentaDRenglonID AND Articulo = @Articulo
ORDER BY SerieLote
ELSE
DECLARE crSerieLoteMov CURSOR FOR
SELECT SerieLote, Cantidad, CantidadAlterna, Propiedades, Ubicacion, ArtCostoInv
FROM SerieLoteMov
WHERE Modulo = 'VTAS' AND ID = @ID AND RenglonID = @VentaDRenglonID AND Articulo = @Articulo
ORDER BY SerieLote DESC 	
SELECT @SumaCantidad = 0.0
OPEN crSerieLoteMov
FETCH NEXT FROM crSerieLoteMov INTO @SerieLote, @Cantidad, @CantidadAlterna, @Propiedades, @Ubicacion, @ArtCostoInv
WHILE @@FETCH_STATUS <> -1 AND @SumaCantidad < @CantidadTotal
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @SumaCantidad + @Cantidad > @CantidadTotal
SELECT @CantidadAlterna = ((@CantidadTotal - @SumaCantidad)*@CantidadAlterna)/@Cantidad,
@Cantidad        = @CantidadTotal - @SumaCantidad
INSERT SerieLoteMov (Sucursal, Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, CantidadAlterna, Propiedades, Ubicacion, ArtCostoInv)
VALUES (@Sucursal, @Empresa, 'VTAS', @VentaID, @RenglonID, @Articulo, ISNULL(@SubCuenta, ''), @SerieLote, @Cantidad, @CantidadAlterna, @Propiedades, @Ubicacion, @ArtCostoInv)
SELECT @SumaCantidad = @SumaCantidad + @Cantidad
END
FETCH NEXT FROM crSerieLoteMov INTO @SerieLote, @Cantidad, @CantidadAlterna, @Propiedades, @Ubicacion, @ArtCostoInv
END  
CLOSE crSerieLoteMov
DEALLOCATE crSerieLoteMov
RETURN
END

