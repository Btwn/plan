SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW WMSEstatusTarima
AS
SELECT
adt.Empresa AS Empresa,
adt.Almacen AS Almacen,
alm.Nombre AS AlmNombre,
adt.Tarima AS Tarima,
CASE WHEN sl.SerieLote IS NOT NULL THEN Existencia ELSE adt.Disponible END AS Disponible,
t.Estatus AS Estatus,
t.EstatusControlCalidad AS EstatusControlCalidad,
ap.Posicion AS Posicion,
ap.Tipo AS UbicacionTipo,
ap.Descripcion AS UbicacionDescripcion,
t.Alta AS TarimaAlta,
t.Baja AS TarimaBaja,
t.SubCuenta AS TarimaSubCuenta,
adt.Articulo AS Articulo,
a.Descripcion1 AS ArtDescripcion1,
a.Unidad AS ArtUnidad,
ap.SubCuenta AS UbicacionSubCuenta,
t.FechaCaducidad AS FechaCaducidad,
ap.Zona AS Zona,
ap.Alto AS Alto,
ap.Largo AS Largo,
ap.Ancho AS Ancho,
ap.Volumen AS Volumen,
ap.Pasillo AS Pasillo,
ap.Fila AS Fila,
ap.Nivel AS Nivel,
sl.SerieLote
FROM ArtDisponibleTarima adt
JOIN Alm alm ON adt.Almacen=alm.Almacen
JOIN Art a ON adt.Articulo=a.Articulo
JOIN Tarima t ON adt.Tarima=t.Tarima AND adt.Almacen=t.Almacen
JOIN AlmPos ap ON t.Posicion=ap.Posicion AND t.Almacen=ap.Almacen
LEFT JOIN SerieLote sl ON sl.Empresa=adt.Empresa AND sl.Articulo=adt.Articulo AND adt.Almacen=sl.Almacen AND adt.Tarima=sl.Tarima

