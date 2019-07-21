SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVentaActualizarPrecios
@ID             int

AS BEGIN
DECLARE
@Articulo		char(20),
@SubCuenta		varchar(50),
@Precio	        float,
@ListaPrecios	varchar(50),
@Moneda		char(10),
@TipoCambio		float
SELECT @ListaPrecios = ListaPreciosEsp,
@Moneda       = Moneda,
@TipoCambio   = TipoCambio
FROM Venta
WHERE ID = @ID
DECLARE crVentaD CURSOR FOR
SELECT Articulo, SubCuenta
FROM VentaD
WHERE ID = @ID
OPEN crVentaD
FETCH NEXT FROM crVentaD INTO @Articulo, @SubCuenta
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spVerArtPrecioDescuento @Articulo, @SubCuenta, @ListaPrecios, @Moneda, @TipoCambio, 1, @Precio OUTPUT
UPDATE VentaD SET Precio = @Precio, PrecioSugerido = @Precio WHERE CURRENT OF crVentaD
END
FETCH NEXT FROM crVentaD INTO @Articulo, @SubCuenta
END 
CLOSE crVentaD
DEALLOCATE crVentaD
RETURN
END

