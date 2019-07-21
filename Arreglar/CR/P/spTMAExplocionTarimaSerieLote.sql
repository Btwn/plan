SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTMAExplocionTarimaSerieLote
@Modulo          varchar(5), 
@ID              int, 
@Almacen		 varchar(10),
@Articulo		 varchar(20),
@Cantidad		 float = NULL,
@ControlArticulo varchar(20) = NULL,
@Tipo			 varchar(20) = NULL,
@Estacion        int         = NULL,
@Tarima			 varchar(20) OUTPUT,
@Disponible		 float		 OUTPUT,
@Posicion		 varchar(10) OUTPUT,
@RenglonID       int,
@SerieLote       varchar(50)

AS BEGIN
IF @Tipo IN ('Cross Docking','Ubicacion','PCKUbicacion','Domicilio')
BEGIN
IF @Tipo = 'Cross Docking'
BEGIN
SELECT TOP 1
@Tarima		= adt.Tarima,
@Disponible	= slmv.Cantidad
FROM ArtDisponibleTarima adt
LEFT JOIN ArtApartadoTarima at ON adt.Empresa = at.Empresa AND adt.Articulo = at.Articulo AND adt.Almacen = at.Almacen AND adt.Tarima = at.Tarima
JOIN Tarima t ON adt.Almacen =t.Almacen AND adt.Tarima = t.Tarima
JOIN AlmPos ap ON t.Almacen = ap.Almacen AND t.Posicion = ap.Posicion
JOIN SerieLoteMov slmv ON slmv.Modulo=@Modulo AND slmv.ID=@ID AND slmv.RenglonID = @RenglonID AND slmv.SerieLote = @SerieLote AND adt.Tarima = slmv.Tarima
LEFT JOIN ArtApartadoSerieTarima a ON adt.Empresa = a.Empresa AND adt.Articulo = a.Articulo AND adt.Almacen = a.Almacen AND adt.Tarima = a.Tarima AND a.Serielote = @SerieLote
WHERE adt.Almacen = @Almacen
AND adt.Articulo = @Articulo
AND slmv.SerieLote = @SerieLote
AND adt.Tarima = @Tarima
AND ap.Tipo = 'Cross Docking'
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
@Disponible	= adt.Disponible - ISNULL(a.Apartado,0) - ISNULL(ta.CantidadA,0)
FROM ArtDisponibleTarima adt
LEFT JOIN ArtApartadoTarima at ON adt.Empresa = at.Empresa AND adt.Articulo = at.Articulo AND adt.Almacen = at.Almacen AND adt.Tarima = at.Tarima
JOIN Tarima t ON adt.Almacen = t.Almacen AND adt.Tarima = t.Tarima
JOIN AlmPos ap ON t.Almacen = ap.Almacen AND t.Posicion = ap.Posicion
JOIN SerieLoteMov slmv ON slmv.Modulo=@Modulo AND slmv.ID=@ID AND slmv.RenglonID = @RenglonID AND slmv.SerieLote = @SerieLote AND adt.Tarima = slmv.Tarima 
LEFT JOIN ArtApartadoSerieTarima a ON adt.Empresa = a.Empresa AND adt.Articulo = a.Articulo AND adt.Almacen = a.Almacen AND adt.Tarima = a.Tarima AND a.Serielote = @SerieLote
LEFT JOIN #TarimaAux ta ON adt.Tarima = ta.Tarima
WHERE adt.Almacen = @Almacen
AND adt.Articulo = @Articulo
AND ap.Tipo = 'Ubicacion'
AND adt.Disponible - ISNULL(a.Apartado,0) - ISNULL(ta.CantidadA,0) > 0
AND @Cantidad >= adt.Disponible - ISNULL(at.Apartado,0) - ISNULL(ta.CantidadA,0)
AND adt.Tarima NOT IN (SELECT Tarima FROM WMSSurtidoProcesarD WHERE Tipo <> 'Ubicacion' AND Estacion = @Estacion)
AND adt.Tarima = @Tarima
ORDER BY t.FechaCaducidad, CASE @ControlArticulo
WHEN 'Caducidad'		THEN CONVERT(varchar, t.FechaCaducidad)
WHEN 'Fecha Entrada'	THEN CONVERT(varchar, t.Alta)
ELSE t.Posicion
END, adt.Tarima ASC
END
IF @Tipo = 'Domicilio'
BEGIN
SELECT TOP 1
@Tarima		= adt.Tarima,
@Disponible	= slmv.Cantidad
FROM ArtDisponibleTarima adt
LEFT JOIN ArtApartadoTarima at ON adt.Empresa = at.Empresa AND adt.Articulo = at.Articulo AND adt.Almacen = at.Almacen AND adt.Tarima = at.Tarima
JOIN Tarima t ON adt.Almacen = t.Almacen AND adt.Tarima = t.Tarima
JOIN AlmPos ap ON t.Almacen = ap.Almacen AND t.Posicion = ap.Posicion
JOIN SerieLoteMov slmv ON slmv.Modulo=@Modulo AND slmv.ID=@ID AND slmv.SerieLote = @SerieLote AND adt.Tarima = slmv.Tarima
LEFT JOIN ArtApartadoSerieTarima a ON adt.Empresa = a.Empresa AND adt.Articulo = a.Articulo AND adt.Almacen = a.Almacen AND adt.Tarima = a.Tarima AND a.Serielote = @SerieLote
WHERE adt.Almacen = @Almacen
AND adt.Articulo = @Articulo
AND ap.ArticuloEsp = @Articulo
AND ap.Tipo = @Tipo
AND adt.Disponible - ISNULL(a.Apartado,0) > 0 AND t.Tarima NOT LIKE '%-%'
AND slmv.SerieLote = @SerieLote
AND adt.Tarima = @Tarima
AND t.Estatus = 'ALTA'
END
IF @Tipo = 'PCKUbicacion'
BEGIN
SELECT TOP 1
@Tarima		= adt.Tarima,
@Disponible	= slmv.Cantidad - ISNULL(ta.CantidadA,0)
FROM ArtDisponibleTarima adt
LEFT JOIN ArtApartadoTarima at ON adt.Empresa = at.Empresa AND adt.Articulo = at.Articulo AND adt.Almacen = at.Almacen AND adt.Tarima = at.Tarima
JOIN Tarima t ON adt.Almacen =t.Almacen AND adt.Tarima = t.Tarima
JOIN AlmPos ap ON t.Almacen = ap.Almacen AND t.Posicion = ap.Posicion
JOIN SerieLoteMov slmv ON slmv.Modulo=@Modulo AND slmv.ID=@ID AND slmv.RenglonID = @RenglonID AND slmv.SerieLote = @SerieLote AND adt.Tarima = slmv.Tarima 
LEFT JOIN ArtApartadoSerieTarima a ON adt.Empresa = a.Empresa AND adt.Articulo = a.Articulo AND adt.Almacen = a.Almacen AND adt.Tarima = a.Tarima AND a.Serielote = @SerieLote
LEFT JOIN #TarimaAux ta ON adt.Tarima = ta.Tarima
WHERE adt.Almacen = @Almacen
AND adt.Articulo = @Articulo
AND ap.Tipo = 'Ubicacion'
AND adt.Disponible - ISNULL(a.Apartado,0) - ISNULL(ta.CantidadA,0) > 0
AND @Cantidad < (adt.Disponible - ISNULL(a.Apartado,0)  - ISNULL(ta.CantidadA,0))
AND adt.Tarima NOT IN (SELECT Tarima FROM WMSSurtidoProcesarD WHERE Tipo <> 'Ubicacion' AND Estacion = @Estacion)
AND slmv.SerieLote = @SerieLote
AND adt.Tarima = @Tarima
AND t.Estatus = 'ALTA'
ORDER BY t.FechaCaducidad, CASE @ControlArticulo
WHEN 'Caducidad'		THEN CONVERT(varchar, t.FechaCaducidad)
WHEN 'Fecha Entrada'	THEN CONVERT(varchar, t.Alta)
ELSE t.Posicion
END, adt.Tarima ASC
END
END
RETURN
END

