SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSabanaTraspaso
@Estacion           INT,
@Articulo           VARCHAR(20),
@Sucursal           INT,
@Almacen            VARCHAR(10)

AS
BEGIN
IF NOT EXISTS(SELECT * FROM SabanaTraspaso WHERE Estacion = @Estacion AND Articulo = @Articulo AND Sucursal = @Sucursal AND Almacen = @Almacen)
INSERT SabanaTraspaso(Estacion, Articulo, Sucursal, Almacen, AlmacenDestino, SucursalDestino, PrimeraEntrada, UltimaEntrada, Venta, Existencia, Transito, Ordenado, SugeridoTraspaso, CantidadTraspasar)
SELECT @Estacion, @Articulo, @Sucursal, @Almacen, gsd.Almacen, gsd.Sucursal, gsd.PrimeraEntrada, gsd.UltimaEntrada, gsd.Venta, gsd.Existencia, gsd.Transito, gsd.Ordenado, 0, 0
FROM SabanaD gsd
WHERE gsd.Estacion = @Estacion
AND gsd.Articulo = @Articulo AND gsd.Almacen <> @Almacen
END

