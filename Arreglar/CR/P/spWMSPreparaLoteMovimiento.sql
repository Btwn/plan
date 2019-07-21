SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSPreparaLoteMovimiento
@Estacion	int,
@Empresa	char(5)

AS BEGIN
DECLARE
@Zona		varchar(50),
@Fila		int,
@Nivel		int,
@Pasillo	int,
@Articulo	varchar(20)
SELECT @Zona		= CASE WHEN InfoZona = '(Todas)' THEN NULL ELSE InfoZona END,
@Fila		= InfoFila,
@Nivel		= InfoNivelWMS,
@Pasillo	= InfoPasillo,
@Articulo	= CASE WHEN RTRIM(LTRIM(InfoArticuloEsp)) = '' THEN NULL ELSE InfoArticuloEsp END
FROM RepParam
WHERE Estacion = @Estacion
DELETE WMSLoteMovimiento WHERE Estacion = @Estacion
INSERT WMSLoteMovimiento (Estacion, ID, Empresa, Movimiento, FechaEmision,
Almacen, Tarima, Cantidad, PosicionOrigen, PosicionDestino,
Articulo, Descripcion, CantidadA, Zona, Pasillo,
Fila, Nivel, Mov, Clave, SubClave,
Renglon, SubCuenta, Montacarga, Acomodador)
SELECT DISTINCT			@Estacion as Estacion, t.ID, t.Empresa, t.Mov + ' ' + ISNULL(t.MovID,'') as Movimiento, t.FechaEmision,
t.Almacen, d.Tarima, CASE WHEN m.SubClave IN('TMA.OSURP', 'TMA.TSURP') THEN ISNULL(NULLIF(d.CantidadPendiente,0),d.CantidadPicking) ELSE CASE WHEN ISNULL(d.Subcuenta,'') <> '' THEN o.Disponible ELSE a.Disponible END END as Cantidad, d.Posicion, d.PosicionDestino,
a.Articulo, art.Descripcion1, CASE WHEN m.SubClave IN('TMA.OSURP', 'TMA.TSURP') THEN ISNULL(NULLIF(d.CantidadPendiente,0),d.CantidadPicking) ELSE 1 END as CantidadA, d.Zona, p.Pasillo,
p.Fila, p.Nivel, t.Mov, m.Clave, m.SubClave,
d.Renglon, d.SubCuenta, t.Montacarga, t.Agente
FROM TMA t
JOIN TMAD d ON t.ID = d.ID
JOIN ArtDisponibleTarima a ON d.Tarima = a.Tarima AND d.Articulo=a.Articulo
LEFT JOIN ArtSubDisponibleTarima o ON d.Tarima = o.Tarima AND d.Articulo = o.Articulo AND ISNULL(d.SubCuenta,'') = ISNULL(o.SubCuenta,'') 
JOIN Art art ON a.Articulo = art.Articulo
JOIN MovTipo m ON t.Mov = m.Mov AND m.Modulo = 'TMA'
JOIN AlmPos p ON d.Posicion = p.Posicion
WHERE t.Estatus IN('PENDIENTE')
AND d.EstaPendiente  = 1
AND ISNULL(p.Zona,'') = ISNULL(@Zona, ISNULL(p.Zona,''))
AND ISNULL(p.Fila,'') = ISNULL(@Fila, ISNULL(p.Fila,''))
AND ISNULL(p.Nivel,'') = ISNULL(@Nivel, ISNULL(p.Nivel,''))
AND ISNULL(p.Pasillo,'') = ISNULL(@Pasillo, ISNULL(p.Pasillo,''))
AND ISNULL(art.Articulo,'') = ISNULL(@Articulo, ISNULL(art.Articulo,''))
END

