SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSurtidoTarima (@Empresa varchar(5), @ID int, @Modulo varchar(5))
RETURNS @Primera TABLE (Posicion varchar(10), Tarima varchar(20), CantidadPicking float, ControlArticulo varchar(20) NULL, Orden int NULL, Peso float NULL, Volumen float NULL, Disponible smallint NULL, Almacen varchar(10) NULL)
AS
BEGIN
DECLARE
@Articulo			varchar(10),
@Cantidad			float,
@CantidadTarima		float,
@Completas			int,
@Almacen			varchar(10)
IF @Modulo = 'VTAS'
DECLARE crCuantos CURSOR FOR
SELECT d.Articulo, v.Almacen, SUM(d.Cantidad), MAX(a.CantidadTarima), SUM(d.Cantidad) / MAX(a.CantidadTarima)
FROM Venta v
JOIN VentaD d ON v.ID = d.ID
JOIN Art a ON d.Articulo = a.Articulo
WHERE v.ID = @ID
GROUP BY d.Articulo, v.Almacen
IF @Modulo = 'INV'
DECLARE crCuantos CURSOR FOR
SELECT d.Articulo, v.Almacen, SUM(d.Cantidad), MAX(a.CantidadTarima), SUM(d.Cantidad) / MAX(a.CantidadTarima)
FROM Inv v
JOIN InvD d ON v.ID = d.ID
JOIN Art a ON d.Articulo = a.Articulo
WHERE v.ID = @ID
GROUP BY d.Articulo, v.Almacen
IF @Modulo = 'WMS'
DECLARE crCuantos CURSOR FOR
SELECT ad.Articulo, td.Almacen, a.CantidadTarima, 1
FROM TMAD td
JOIN ArtDisponibleTarima ad ON td.Almacen = ad.Almacen  AND td.Tarima = ad.Tarima
JOIN Art a ON ad.Articulo = a.Articulo
WHERE td.ID = @ID 
OPEN crCuantos
FETCH NEXT FROM crCuantos INTO @Articulo, @Almacen, @Cantidad, @CantidadTarima, @Completas
WHILE @@FETCH_STATUS = 0
BEGIN
WHILE @Completas > 0
BEGIN
INSERT @Primera (Tarima, Posicion, CantidadPicking)
SELECT TOP 1 t.Tarima, t.Posicion, @Cantidad
FROM AlmPos ap
JOIN Tarima t ON ap.Almacen = t.Almacen AND ap.Posicion = t.Posicion
WHERE ap.Almacen = @Almacen AND ap.Tipo = 'Ubicacion' AND ap.ArticuloEsp = @Articulo
AND NOT EXISTS (SELECT 1 FROM @Primera WHERE Tarima = t.Tarima)
ORDER BY ap.Orden
SET @Completas = @Completas - 1
END
FETCH NEXT FROM crCuantos INTO @Articulo, @Almacen, @Cantidad, @CantidadTarima, @Completas
END
CLOSE crCuantos
DEALLOCATE crCuantos
RETURN
END

