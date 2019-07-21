SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSMontacargaTarea
@Estacion        int,
@Todos           bit

AS BEGIN
DELETE WMSMontacargaTarea WHERE Estacion = @Estacion
INSERT WMSMontacargaTarea (
Estacion, Empresa, ID, Renglon, Mov, MovID, FechaEmision, Tarima,
Sucursal,
NomSucursal,
Zona,
Pasillo,
PosicionOrigen, PosicionDestino, Articulo, Montacarga, Prioridad, Almacen, Modificar, Clave, Movimiento, NoCajas)
SELECT @Estacion, t.Empresa, t.ID, d.Renglon, t.Mov, t.MovID, t.FechaEmision, d.Tarima,
CASE WHEN IsNumeric(Replace(t.Referencia,'Sucursal Destino','')) = 1 THEN Replace(t.Referencia,'Sucursal Destino','') ELSE t.Sucursal END,
ISNULL(sc.Nombre,'') + CASE WHEN t.OrigenObservaciones IS NULL THEN '' ELSE ' (' + ISNULL(t.OrigenObservaciones,'') + ')' END,
ald.Zona,
CASE WHEN mt.Clave IN('TMA.SADO','TMA.SRADO') THEN ald.Pasillo ELSE al.Pasillo END,
d.Posicion, d.PosicionDestino, a.Articulo, d.Montacarga, d.Prioridad, d.Almacen, 0, mt.Clave, t.Mov + ' ' + ISNULL(t.MovID, ''), SUM(CantidadUnidad)
FROM TMA t WITH(NOLOCK)
JOIN TMAD d WITH(NOLOCK) ON (t.ID = d.ID)
JOIN ArtDisponibleTarima a WITH(NOLOCK) ON (d.Tarima = a.Tarima AND a.Empresa = t.Empresa AND a.Almacen = d.Almacen AND a.Articulo = d.Articulo)
JOIN MovTipo mt WITH(NOLOCK) ON (t.Mov = mt.Mov AND Modulo = 'TMA')
LEFT OUTER JOIN Sucursal sc WITH(NOLOCK) ON (ISNULL(t.SucursalFiltro,t.Sucursal) = sc.Sucursal)
LEFT OUTER JOIN AlmPos al WITH(NOLOCK) ON (al.Almacen = t.Almacen AND al.Posicion = d.Posicion)
LEFT OUTER JOIN AlmPos ald WITH(NOLOCK) ON (ald.Almacen = t.Almacen AND ald.Posicion = CASE WHEN mt.Clave = 'TMA.OSUR' THEN d.Posicion ELSE d.PosicionDestino END)
WHERE t.Estatus IN('PENDIENTE')
AND mt.Clave IN('TMA.SADO','TMA.SRADO','TMA.OADO','TMA.ORADO','TMA.OSUR','TMA.OPCKTARIMA')
AND mt.SubClave NOT IN('TMA.OSURP')
AND ISNULL(d.Montacarga,'') = CASE WHEN @Todos = 0 THEN '' ELSE ISNULL(d.Montacarga,'') END
AND d.Procesado = 0
GROUP BY t.Empresa, t.ID, d.Renglon, t.Mov, t.MovID, t.FechaEmision, d.Tarima,
t.Referencia, t.Sucursal, sc.Nombre, t.OrigenObservaciones, mt.Clave, ald.Pasillo, al.Pasillo, d.Posicion, d.PosicionDestino,
a.Articulo, d.Montacarga, d.Prioridad, d.Almacen, ald.Zona
INSERT WMSMontacargaTarea (Estacion, Empresa, ID, Renglon, Mov, MovID, FechaEmision, Tarima,Sucursal,NomSucursal,Zona, Pasillo,PosicionOrigen, PosicionDestino, Articulo, Montacarga, Prioridad, Almacen, Modificar, Clave, Movimiento, NoCajas) 
SELECT @Estacion, t.Empresa, t.ID, 0, t.Mov, t.MovID, t.FechaEmision, 'Picking',CASE WHEN IsNumeric(Replace(t.Referencia,'Sucursal Destino',''))=1 THEN Replace(t.Referencia,'Sucursal Destino','') ELSE t.Sucursal END,
ISNULL(sc.Nombre,'') +  CASE WHEN t.OrigenObservaciones IS NULL THEN '' ELSE ' (' + ISNULL(t.OrigenObservaciones,'') + ')' END, 
ald.Zona, 
CASE WHEN mt.Clave IN('TMA.SADO','TMA.SRADO') THEN ald.Pasillo ELSE al.Pasillo END,
d.Posicion, d.PosicionDestino, a.Articulo, d.Montacarga, d.Prioridad, d.Almacen, 0, mt.Clave, t.Mov + ' ' + ISNULL(t.MovID, ''), SUM(CantidadUnidad)
FROM TMA t WITH(NOLOCK)
JOIN TMAD d  WITH(NOLOCK) ON t.ID = d.ID
JOIN ArtDisponibleTarima a  WITH(NOLOCK) ON d.Tarima = a.Tarima AND a.Empresa = t.Empresa AND a.Almacen = d.Almacen AND a.Articulo=d.Articulo 
JOIN MovTipo mt  WITH(NOLOCK) ON t.Mov = mt.Mov AND Modulo = 'TMA'
LEFT OUTER JOIN Sucursal sc  WITH(NOLOCK) ON ISNULL(t.SucursalFiltro,t.Sucursal) = sc.Sucursal 
LEFT OUTER JOIN AlmPos al  WITH(NOLOCK) ON al.Almacen = t.Almacen AND al.Posicion = d.Posicion
LEFT OUTER JOIN AlmPos ald  WITH(NOLOCK) ON ald.Almacen = t.Almacen AND ald.Posicion =
CASE WHEN mt.Clave = 'TMA.OSUR' THEN d.Posicion ELSE d.PosicionDestino END
WHERE t.Estatus IN('PENDIENTE')
AND mt.Clave IN('TMA.SRADO', 'TMA.SADO', 'TMA.OSUR')
AND mt.SubClave IN('TMA.OSURP')
AND ISNULL(d.Montacarga,'') = CASE WHEN @Todos = 0 THEN '' ELSE ISNULL(d.Montacarga,'') END
AND d.Procesado = 0 
GROUP BY t.Empresa, t.ID, t.Mov, t.MovID, t.FechaEmision, t.Referencia, t.Sucursal, sc.Nombre, t.OrigenObservaciones,mt.Clave, ald.Pasillo, al.Pasillo, d.Posicion, d.PosicionDestino,
a.Articulo,d.Montacarga, d.Prioridad, d.Almacen, mt.Clave, t.Mov, t.MovID, ald.Zona 
END

