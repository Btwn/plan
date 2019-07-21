SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWMSOrdenSurtidoPendiente (@Tarima varchar(20), @Articulo varchar(20))
RETURNS TABLE
AS
RETURN (
SELECT ID, Mov, MovID, Articulo, SUM(Cantidad) Cantidad, Almacen, Tipo, Tarima, PCK, Renglon
FROM
(
SELECT v.ID, v.Mov, v.MovID, a.Articulo, ISNULL(d.CantidadPendiente, d.CantidadPicking) Cantidad, d.Almacen, 1 Tipo, d.Tarima, CASE WHEN m.SubClave = 'TMA.OSURP' THEN 1 ELSE 0 END PCK, d.Renglon
FROM TMAD d
JOIN TMA v ON v.ID = d.ID
JOIN MovTipo m ON m.Modulo = 'TMA' AND m.Mov = v.Mov
JOIN ArtDisponibleTarima a ON a.Tarima = d.Tarima
WHERE v.TarimaSurtido = @Tarima
AND a.Articulo = ISNULL(@Articulo, a.Articulo)
AND v.Estatus IN('PENDIENTE')
AND m.Clave = 'TMA.OSUR'
UNION ALL
SELECT o.ID, o.Mov, o.MovID, a.Articulo, -ISNULL(NULLIF(d.CantidadPendiente,0), a.Disponible) Cantidad, d.Almacen, 1 Tipo, od.Tarima, CASE WHEN m.SubClave = 'TMA.TSURP' THEN 1 ELSE 0 END PCK, d.Renglon
FROM TMAD d
JOIN TMA v ON v.ID = d.ID
JOIN TMA o ON o.Mov = v.Origen and o.MovID = v.OrigenID
JOIN TMAD od ON o.ID = od.ID
JOIN MovTipo m ON m.Modulo = 'TMA' AND m.Mov = v.Mov
JOIN ArtDisponibleTarima a ON a.Tarima = d.Tarima and od.Tarima = dbo.fnWMSTarimaPCK(d.Tarima)
WHERE v.TarimaSurtido = @Tarima
AND a.Articulo = ISNULL(@Articulo, a.Articulo)
AND v.Estatus IN('PROCESAR')
AND m.Clave = 'TMA.TSUR'
) x
GROUP BY ID, Mov, MovID, Articulo, Almacen, Tipo, Tarima, PCK, Renglon
HAVING SUM(Cantidad) > 0
)

