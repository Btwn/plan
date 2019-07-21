SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSInvInventarioFisico
@ID				int,
@Base			char(20),
@Modulo			char(5),
@Almacen			char(10),
@IDGenerar		int

AS BEGIN
DECLARE
@WMS			bit
SELECT @WMS = ISNULL(WMS,0) FROM Alm WHERE Almacen = @Almacen
IF @Modulo = 'INV' AND @WMS = 1
BEGIN
CREATE TABLE #ExistenciaFisicaWMS (Articulo varchar(20) COLLATE Database_Default NOT NULL,  SubCuenta varchar(50) COLLATE Database_Default NULL,  Cantidad float NULL, Tarima varchar(20)  COLLATE Database_Default NULL, PosicionActual varchar(10)  COLLATE Database_Default NULL, PosicionReal varchar(10)  COLLATE Database_Default NULL)
INSERT #ExistenciaFisicaWMS
(Articulo, SubCuenta, Cantidad, Tarima)
SELECT Articulo, SubCuenta, Cantidad, Tarima
FROM #ExistenciaFisica
DELETE #ExistenciaFisica
INSERT #ExistenciaFisica
(Articulo,  SubCuenta,   Cantidad,                            CantidadA,                           Costo, ArtTipo,  Almacen,  Tarima, PosicionActual, PosicionReal)
SELECT d.Articulo, d.SubCuenta, -t.Disponible * 1, -t.Disponible * 1, NULL,  a.Tipo,   @Almacen, d.Tarima, d.PosicionActual, d.PosicionReal
FROM InvD d
JOIN Art a
ON d.Articulo = a.Articulo
JOIN ArtSubDisponibleTarima t 
ON d.Tarima = t.Tarima
AND d.Articulo = t.Articulo
LEFT OUTER JOIN ArtUnidad u
ON d.Articulo = u.Articulo
AND d.Unidad = u.Unidad
WHERE d.ID = @ID AND d.Articulo = a.Articulo
AND ISNULL(t.SubCuenta, '')=ISNULL(d.SubCuenta,'') 
INSERT #ExistenciaFisica
(Articulo,  SubCuenta,   Cantidad,                         CantidadA,                        Costo, ArtTipo,  Almacen,  Tarima, PosicionActual, PosicionReal)
SELECT  d.Articulo, d.SubCuenta, d.CantidadA * ISNULL(u.Factor, 1), d.CantidadA * ISNULL(u.Factor, 1), NULL,  a.Tipo,   @Almacen, d.Tarima, d.PosicionActual, d.PosicionReal 
FROM InvD d
JOIN Art a
ON d.Articulo = a.Articulo
JOIN ArtSubDisponibleTarima t 
ON d.Tarima = t.Tarima
AND d.Articulo = t.Articulo
LEFT OUTER JOIN ArtUnidad u
ON d.Articulo = u.Articulo
AND d.Unidad = u.Unidad
WHERE d.ID = @ID AND d.Articulo = a.Articulo
AND ISNULL(t.SubCuenta, '')=ISNULL(d.SubCuenta,'') 
END
RETURN
END

