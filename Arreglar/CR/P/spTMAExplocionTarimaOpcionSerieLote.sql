SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTMAExplocionTarimaOpcionSerieLote
@Modulo          varchar(5), 
@ID              int, 
@Almacen		 varchar(10),
@Articulo		 varchar(20),
@SubCuenta       varchar(50), 
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
SELECT @Tarima = NULL, @Disponible = NULL
IF @Tipo = 'Ubicacion'
BEGIN
SELECT TOP 1
@Tarima		= adt.Tarima,
@Disponible	= adt.Disponible - ISNULL(a.Apartado,0)
FROM ArtDisponibleTarima adt
LEFT JOIN ArtApartadoTarima at ON adt.Empresa = at.Empresa AND adt.Articulo = at.Articulo AND adt.Almacen = at.Almacen AND adt.Tarima = at.Tarima
JOIN Tarima t ON adt.Almacen =t.Almacen AND adt.Tarima = t.Tarima
JOIN AlmPos ap ON t.Almacen = ap.Almacen AND t.Posicion = ap.Posicion
JOIN SerieLoteMov slmv ON slmv.Modulo=@Modulo AND slmv.ID=@ID 
LEFT JOIN ArtApartadoSerieTarima a ON adt.Empresa = a.Empresa AND adt.Articulo = a.Articulo AND adt.Almacen = a.Almacen AND adt.Tarima = a.Tarima AND a.Serielote = @SerieLote
WHERE adt.Almacen = @Almacen
AND adt.Articulo = @Articulo
AND ap.Tipo = 'Ubicacion'
AND adt.Tarima NOT IN (SELECT ISNULL(Tarima,'') FROM #TarimaAux)
AND adt.Disponible - ISNULL(a.Apartado,0) > 0
AND @Cantidad >= adt.Disponible - ISNULL(at.Apartado,0)
AND t.SubCuenta=@SubCuenta 
AND t.Estatus = 'ALTA'
ORDER BY t.FechaCaducidad, CASE @ControlArticulo
WHEN 'Caducidad'		THEN CONVERT(varchar, t.FechaCaducidad)
WHEN 'Fecha Entrada'	THEN CONVERT(varchar, t.Alta)
ELSE t.Posicion
END
END
ELSE
IF @Tipo = 'Ubicacion'
BEGIN
SELECT TOP 1
@Tarima		= adt.Tarima,
@Disponible	= adt.Disponible - ISNULL(a.Apartado,0)
FROM ArtDisponibleTarima adt
LEFT JOIN ArtApartadoTarima at ON adt.Empresa = at.Empresa AND adt.Articulo = at.Articulo AND adt.Almacen = at.Almacen AND adt.Tarima = at.Tarima
JOIN Tarima t ON adt.Almacen =t.Almacen AND adt.Tarima = t.Tarima
JOIN AlmPos ap ON t.Almacen = ap.Almacen AND t.Posicion = ap.Posicion
JOIN SerieLoteMov slmv ON slmv.Modulo=@Modulo AND slmv.ID=@ID 
LEFT JOIN ArtApartadoSerieTarima a ON adt.Empresa = a.Empresa AND adt.Articulo = a.Articulo AND adt.Almacen = a.Almacen AND adt.Tarima = a.Tarima AND a.Serielote = @SerieLote
WHERE adt.Almacen = @Almacen
AND adt.Articulo = @Articulo
AND ap.Tipo = 'Ubicacion'
AND adt.Tarima NOT IN (SELECT ISNULL(Tarima,'') FROM #TarimaAux)
AND adt.Disponible - ISNULL(a.Apartado,0) > 0
AND @Cantidad < adt.Disponible
AND t.SubCuenta=@SubCuenta 
AND t.Estatus = 'ALTA'
ORDER BY t.FechaCaducidad, CASE @ControlArticulo
WHEN 'Caducidad'		THEN CONVERT(varchar, t.FechaCaducidad)
WHEN 'Fecha Entrada'	THEN CONVERT(varchar, t.Alta)
ELSE t.Posicion
END
END
ELSE
IF @Tipo = 'Domicilio'
BEGIN
SELECT TOP 1
@Tarima		= adt.Tarima,
@Disponible	= adt.Disponible - ISNULL(a.Apartado,0)
FROM ArtSubDisponibleTarima adt  
LEFT JOIN ArtApartadoTarima at ON adt.Empresa = at.Empresa AND adt.Articulo = at.Articulo AND adt.Almacen = at.Almacen AND adt.Tarima = at.Tarima
JOIN Tarima t ON adt.Almacen = t.Almacen AND adt.Tarima = t.Tarima
JOIN AlmPos ap ON t.Almacen = ap.Almacen AND t.Posicion = ap.Posicion
JOIN SerieLoteMov slmv ON slmv.Modulo=@Modulo AND slmv.ID=@ID 
LEFT JOIN ArtApartadoSerieTarima a ON adt.Empresa = a.Empresa AND adt.Articulo = a.Articulo AND adt.Almacen = a.Almacen AND adt.Tarima = a.Tarima AND a.Serielote = @SerieLote
WHERE adt.Almacen = @Almacen
AND adt.Articulo = @Articulo
AND ap.ArticuloEsp = @Articulo
AND ap.Tipo = @Tipo
AND adt.Disponible - ISNULL(a.Apartado,0) > 0
AND t.Tarima NOT LIKE '%-%'
AND adt.SubCuenta=@SubCuenta 
AND t.Estatus = 'ALTA'
IF @Tarima IS NULL
BEGIN
SELECT TOP 1
@Tarima		= adt.Tarima,
@Disponible	= adt.Disponible - ISNULL(a.Apartado,0)
FROM ArtSubDisponibleTarima adt  
LEFT JOIN ArtApartadoTarima at ON adt.Empresa = at.Empresa AND adt.Articulo = at.Articulo AND adt.Almacen = at.Almacen AND adt.Tarima = at.Tarima
JOIN Tarima t ON adt.Almacen = t.Almacen AND adt.Tarima = t.Tarima
JOIN AlmPos ap ON t.Almacen = ap.Almacen AND t.Posicion = ap.Posicion
JOIN SerieLoteMov slmv ON slmv.Modulo=@Modulo AND slmv.ID=@ID 
LEFT JOIN ArtApartadoSerieTarima a ON adt.Empresa = a.Empresa AND adt.Articulo = a.Articulo AND adt.Almacen = a.Almacen AND adt.Tarima = a.Tarima AND a.Serielote = @SerieLote
WHERE adt.Almacen = @Almacen
AND adt.Articulo = @Articulo
AND ap.ArticuloEsp = @Articulo
AND ap.Tipo = @Tipo
AND adt.Disponible - ISNULL(a.Apartado,0) > 0
AND t.Tarima NOT LIKE '%-%'
AND adt.SubCuenta=@SubCuenta 
AND t.Estatus = 'ALTA'
SELECT @Disponible = @Disponible - ISNULL(SUM(Cantidad),0) FROM #TarimaAux WHERE Tarima = @Tarima
IF ISNULL(@Disponible, 0) <= 0 SELECT @Tarima = NULL, @Disponible = 0
END
SELECT @Disponible = @Disponible - ISNULL(SUM(ISNULL(d.CantidadPendiente,0) /*+ ISNULL(d.CantidadPicking,0)*/),0)
FROM TMAD d
JOIN TMA a ON a.ID = d.ID
JOIN MovTipo m ON m.Mov = a.Mov AND m.Modulo = 'TMA'
WHERE a.Estatus IN ('PENDIENTE', 'PROCESAR')
AND m.Clave IN ('TMA.OSUR', 'TMA.TSUR', 'TMA.SRADO', 'TMA.SADO', 'TMA.ORADO', 'TMA.OADO')
AND Tarima = @Tarima
AND d.Procesado = CASE m.Clave
WHEN 'TMA.OSUR'  THEN d.Procesado
WHEN 'TMA.TSUR'  THEN d.Procesado
WHEN 'TMA.SRADO' THEN 0
WHEN 'TMA.SADO'  THEN 0
WHEN 'TMA.ORADO' THEN 0
WHEN 'TMA.OADO'  THEN 0
END
SELECT @Disponible = @Disponible + ISNULL(SUM(ISNULL(d.CantidadPendiente,0) + ISNULL(d.CantidadPicking,0)),0)
FROM TMAD d
JOIN TMA a ON a.ID = d.ID
JOIN MovTipo m ON m.Mov = a.Mov AND m.Modulo = 'TMA'
WHERE a.Estatus IN ('PENDIENTE')
AND m.Clave IN ('TMA.SRADO', 'TMA.ORADO')
AND PosicionDestino IN(SELECT Posicion FROM AlmPos WHERE Almacen = @Almacen AND ArticuloEsp = @Articulo AND Tipo = @Tipo)
IF ISNULL(@Disponible, 0) <= 0 SELECT @Tarima = NULL, @Disponible = 0
END
ELSE
SELECT TOP 1
@Tarima		= t.Tarima,
@Disponible	= d.Disponible - ISNULL(ast.Apartado,0),
@Posicion		= t.Posicion
FROM ArtDisponibleTarima d
LEFT JOIN ArtApartadoTarima at ON d.Empresa = at.Empresa AND d.Articulo = at.Articulo AND d.Almacen = at.Almacen AND d.Tarima = at.Tarima
JOIN Tarima t ON d.Tarima = t.Tarima
JOIN AlmPos p ON t.Almacen = p.Almacen AND p.Posicion = t.Posicion
JOIN Art a ON d.Articulo = a.Articulo
JOIN SerieLoteMov slmv ON slmv.Modulo=@Modulo AND slmv.ID=@ID 
LEFT JOIN ArtApartadoSerieTarima ast ON d.Empresa = ast.Empresa AND d.Articulo = ast.Articulo AND d.Almacen = ast.Almacen AND d.Tarima = ast.Tarima AND ast.Serielote = @SerieLote
WHERE d.Almacen = @Almacen
AND p.Tipo = 'Ubicacion'
AND d.Articulo = @Articulo
AND t.Estatus = 'ALTA'
AND p.Estatus = 'ALTA'
AND t.Tarima NOT LIKE '%-%'
AND d.Tarima NOT IN (SELECT Tarima FROM WMSSurtidoProcesarD WHERE Estacion = @Estacion AND Articulo = @Articulo AND Procesado = 0)
AND d.Tarima NOT IN (SELECT wP.Tarima FROM WMSSurtidoProcesarD wp WHERE wp.Estacion = @Estacion AND wp.Procesado = 1 AND wp.Tipo = 'Ubicacion' AND Articulo IN(SELECT DISTINCT Clave FROM ListaSt WHERE Estacion = @Estacion))
AND Disponible - ISNULL(ast.Apartado,0) > 0
AND ISNULL(t.SubCuenta,'') = ISNULL(@SubCuenta,'') 
AND t.Estatus = 'ALTA'
ORDER BY t.FechaCaducidad, CASE @ControlArticulo
WHEN 'Caducidad'		THEN CONVERT(varchar, t.FechaCaducidad)
WHEN 'Fecha Entrada'	THEN CONVERT(varchar, t.Alta)
ELSE t.Posicion
END
RETURN
END

