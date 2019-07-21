SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOfertaPrecioSugerido
@Empresa		varchar(5),
@Sucursal		int,
@Moneda			varchar(10),
@TipoCambio		float,
@ListaPrecios		varchar(50)

AS BEGIN
DECLARE
@Articulo		varchar(20),
@SubCuenta		varchar(50),
@Unidad		varchar(50),
@Proveedor		varchar(10),
@PrecioSugerido	float,
@PrecioIndependiente bit, 
@RenglonTipo     char     
DECLARE @VentaD TABLE(
Orden			int IDENTITY(1,1) PRIMARY KEY,
Articulo      varchar(20)NULL,
Proveedor		varchar(10)NULL,
SubCuenta     varchar(50)NULL,
Unidad        varchar(50)NULL,
RenglonTipo   varchar(1)NULL)
INSERT @VentaD(Articulo, Proveedor, SubCuenta, Unidad, RenglonTipo)
SELECT Articulo, Proveedor, SubCuenta, Unidad, RenglonTipo
FROM #VentaD
WHERE NULLIF(PrecioSugerido, 0.0) IS NULL
GROUP BY Articulo, Proveedor, SubCuenta, Unidad, RenglonTipo
ORDER BY Articulo, Proveedor, SubCuenta, Unidad, RenglonTipo
DECLARE crVentaD CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
SELECT Articulo, Proveedor, SubCuenta, Unidad, RenglonTipo
FROM @VentaD
OPEN crVentaD
FETCH NEXT FROM crVentaD INTO @Articulo, @Proveedor, @SubCuenta, @Unidad, @RenglonTipo
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @PrecioSugerido = NULL
SELECT @PrecioIndependiente = NULL
IF @RenglonTipo = 'C'
SELECT @PrecioIndependiente = PrecioIndependiente
FROM ArtJuego a
JOIN ArtJuegoD d ON a.Articulo = d.Articulo AND a.Juego = d.Juego
WHERE d.Opcion = @Articulo
EXEC spPCGet @Sucursal, @Empresa, @Articulo, @SubCuenta, @Unidad, @Moneda, @TipoCambio, @ListaPrecios, @PrecioSugerido OUTPUT, @Proveedor = @Proveedor
UPDATE #VentaD SET PrecioSugerido = (CASE WHEN @PrecioIndependiente = 0 THEN PrecioSugerido ELSE @PrecioSugerido END) WHERE Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND ISNULL(Unidad, '') = ISNULL(@Unidad, '') AND ISNULL(Proveedor, '') = ISNULL(@Proveedor, '')
END
FETCH NEXT FROM crVentaD INTO @Articulo, @Proveedor, @SubCuenta, @Unidad, @RenglonTipo
END  
CLOSE crVentaD
DEALLOCATE crVentaD
RETURN
END

