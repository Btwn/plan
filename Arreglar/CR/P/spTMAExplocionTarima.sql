SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTMAExplocionTarima
@Almacen		 varchar(10),
@Articulo		 varchar(20),
@Cantidad		 float = NULL,
@ControlArticulo varchar(20) = NULL,
@Tipo			 varchar(20) = NULL,
@Estacion        int         = NULL,
@Tarima			 varchar(20) OUTPUT,
@Disponible		 float		 OUTPUT,
@Posicion		 varchar(10) OUTPUT

AS BEGIN
SELECT @Tarima = NULL, @Disponible = NULL
IF (OBJECT_ID('Tempdb..#TarimaAux')) IS NULL
CREATE TABLE #TarimaAux (Tarima varchar(20) COLLATE Database_Default NOT NULL,  SubTarima varchar(20) COLLATE Database_Default NOT NULL, Cantidad float  NULL, CantidadA float  NULL, )
IF @Tipo = 'Cross Docking'
BEGIN
SELECT TOP 1
@Tarima		= adt.Tarima,
@Disponible	= adt.Disponible - ISNULL(at.Apartado,0) - ISNULL(ta.CantidadA,0)
FROM ArtDisponibleTarima adt
LEFT JOIN ArtApartadoTarima at ON adt.Empresa = at.Empresa AND adt.Articulo = at.Articulo AND adt.Almacen = at.Almacen AND adt.Tarima = at.Tarima
JOIN Tarima t ON adt.Almacen =t.Almacen AND adt.Tarima = t.Tarima
JOIN AlmPos ap ON t.Almacen = ap.Almacen AND t.Posicion = ap.Posicion
LEFT JOIN #TarimaAux ta ON adt.Tarima = ta.Tarima
WHERE adt.Almacen = @Almacen
AND adt.Articulo = @Articulo
AND ap.Tipo = 'Cross Docking'
AND @Cantidad <= adt.Disponible	- ISNULL(at.Apartado,0)	- ISNULL(ta.CantidadA,0)
AND adt.Tarima NOT IN (SELECT Tarima FROM WMSSurtidoProcesarD WHERE Tipo <> 'Ubicacion' AND Estacion = @Estacion)
AND adt.Disponible - ISNULL(at.Apartado,0) - ISNULL(ta.CantidadA,0) > 0
AND t.Estatus = 'ALTA'
ORDER BY t.FechaCaducidad, CASE @ControlArticulo
WHEN 'Caducidad'		THEN CONVERT(varchar, t.FechaCaducidad)
WHEN 'Fecha Entrada'	THEN CONVERT(varchar, t.Alta)
ELSE t.Posicion
END, adt.Tarima ASC
END
IF @Tipo = 'Ubicacion'
BEGIN
SELECT TOP 1
@Tarima		= adt.Tarima,
@Disponible	= adt.Disponible - ISNULL(at.Apartado,0) - ISNULL(ta.CantidadA,0),
@Posicion     = t.Posicion
FROM ArtDisponibleTarima adt
LEFT JOIN ArtApartadoTarima at ON adt.Empresa = at.Empresa AND adt.Articulo = at.Articulo AND adt.Almacen = at.Almacen AND adt.Tarima = at.Tarima
JOIN Tarima t ON adt.Almacen =t.Almacen AND adt.Tarima = t.Tarima
JOIN AlmPos ap ON t.Almacen = ap.Almacen AND t.Posicion = ap.Posicion
LEFT JOIN #TarimaAux ta ON adt.Tarima = ta.Tarima
WHERE adt.Almacen = @Almacen
AND adt.Articulo = @Articulo
AND ap.Tipo = 'Ubicacion'
AND @Cantidad >= adt.Disponible - ISNULL(at.Apartado,0) - ISNULL(ta.CantidadA,0)
AND adt.Tarima NOT IN (SELECT Tarima FROM WMSSurtidoProcesarD WHERE Tipo <> 'Ubicacion' AND Estacion = @Estacion)
AND adt.Disponible - ISNULL(at.Apartado,0) - ISNULL(ta.CantidadA,0) > 0
AND t.Estatus = 'ALTA'
ORDER BY t.FechaCaducidad, CASE @ControlArticulo
WHEN 'Caducidad'		THEN CONVERT(varchar, t.FechaCaducidad)
WHEN 'Fecha Entrada'	THEN CONVERT(varchar, t.Alta)
ELSE t.Posicion
END, adt.Tarima ASC
END
ELSE
IF @Tipo = 'PCKUbicacion'
BEGIN
SELECT TOP 1
@Tarima		= adt.Tarima,
@Disponible	= adt.Disponible  - ISNULL(at.Apartado,0) - ISNULL(ta.CantidadA,0)
FROM ArtDisponibleTarima adt
LEFT JOIN ArtApartadoTarima at ON adt.Empresa = at.Empresa AND adt.Articulo = at.Articulo AND adt.Almacen = at.Almacen AND adt.Tarima = at.Tarima
JOIN Tarima t ON adt.Almacen =t.Almacen AND adt.Tarima = t.Tarima
JOIN AlmPos ap ON t.Almacen = ap.Almacen AND t.Posicion = ap.Posicion
LEFT JOIN #TarimaAux ta ON adt.Tarima = ta.Tarima
WHERE adt.Almacen = @Almacen
AND adt.Articulo = @Articulo
AND ap.Tipo = 'Ubicacion'
AND @Cantidad < (adt.Disponible - ISNULL(at.Apartado,0) - ISNULL(ta.CantidadA,0))
AND adt.Tarima NOT IN (SELECT Tarima FROM WMSSurtidoProcesarD WHERE Tipo <> 'Ubicacion' AND Estacion = @Estacion)
AND adt.Disponible - ISNULL(at.Apartado,0) - ISNULL(ta.Cantidad,0) > 0
AND t.Estatus = 'ALTA'
ORDER BY t.FechaCaducidad, CASE @ControlArticulo
WHEN 'Caducidad'		THEN CONVERT(varchar, t.FechaCaducidad)
WHEN 'Fecha Entrada'	THEN CONVERT(varchar, t.Alta)
ELSE t.Posicion
END, adt.Tarima ASC
END
ELSE
IF @Tipo = 'Domicilio'
BEGIN
SELECT TOP 1
@Tarima		= adt.Tarima,
@Disponible	= adt.Disponible - ISNULL(at.Apartado,0) - ISNULL(ta.CantidadA,0)
FROM ArtDisponibleTarima adt
LEFT JOIN ArtApartadoTarima at ON adt.Empresa = at.Empresa AND adt.Articulo = at.Articulo AND adt.Almacen = at.Almacen AND adt.Tarima = at.Tarima
JOIN Tarima t ON adt.Almacen = t.Almacen AND adt.Tarima = t.Tarima
JOIN AlmPos ap ON t.Almacen = ap.Almacen AND t.Posicion = ap.Posicion
LEFT JOIN #TarimaAux ta ON adt.Tarima = ta.Tarima
WHERE adt.Almacen = @Almacen AND adt.Articulo = @Articulo
AND ap.ArticuloEsp = @Articulo AND ap.Tipo = @Tipo
AND t.Tarima NOT LIKE '%-%'
AND adt.Disponible - ISNULL(at.Apartado,0) - ISNULL(ta.CantidadA,0) > 0
AND t.Estatus = 'ALTA'
END
RETURN
END

