SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnTMADomicilioDisponible50 (@Empresa varchar(5), @Almacen varchar(10), @Articulo varchar(20), @TMAID int, @Tarima varchar(20))
RETURNS varchar(20)
AS BEGIN
DECLARE
@Resultado		varchar(20)
SELECT @Resultado = NULL
SELECT @Resultado = MIN(p.Posicion)
FROM ArtDisponibleTarima a
JOIN Tarima t WITH(NOLOCK) ON t.Tarima = a.Tarima
JOIN AlmPos p WITH(NOLOCK) ON p.Posicion = t.Posicion  AND p.Almacen = @Almacen
WHERE a.Articulo = @Articulo
AND p.Tipo = 'Domicilio'
AND a.Disponible > 0
AND t.Estatus = 'ALTA' AND t.Tarima NOT LIKE '%-%'
AND p.ArticuloEsp = @Articulo
IF @Resultado IS NULL
SELECT @Resultado = MIN(t.Posicion)
FROM ArtDisponibleTarima a
JOIN Tarima t WITH(NOLOCK) ON t.Tarima = a.Tarima
JOIN AlmPos p WITH(NOLOCK) ON p.Posicion = t.Posicion  AND p.Almacen = @Almacen
WHERE a.Articulo = @Articulo
AND p.Tipo = 'Domicilio'
AND t.Estatus = 'ALTA' AND t.Tarima NOT LIKE '%-%'
AND p.ArticuloEsp = @Articulo
IF @Resultado IS NULL
SELECT @Resultado = MIN(t.Posicion)
FROM ArtDisponibleTarima a
JOIN Tarima t WITH(NOLOCK) ON t.Tarima = a.Tarima
JOIN AlmPos p WITH(NOLOCK) ON p.Posicion = t.Posicion  AND p.Almacen = @Almacen
WHERE a.Articulo = @Articulo
AND p.Tipo = 'Domicilio'
AND t.Estatus = 'BAJA' AND t.Tarima NOT LIKE '%-%'
AND p.ArticuloEsp = @Articulo
RETURN(@Resultado)
END

