SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtApartadoTarimaSL

AS
SELECT t.Empresa,
d.Articulo,
t.Almacen,
slm.SerieLote,
CASE WHEN  CHARINDEX('-',d.Tarima,1) > 0 THEN SUBSTRING(d.Tarima,1,CHARINDEX('-',d.Tarima,1)-1) ELSE d.Tarima END Tarima,
SUM(CASE WHEN ISNULL(slm.Cantidad,0) <> 0 THEN slm.Cantidad ELSE ISNULL(d.CantidadPicking,0) END) Apartado
FROM TMA t
JOIN TMAD d ON t.ID = d.ID
JOIN MovTipo mt ON t.Mov = mt.Mov AND mt.Modulo = 'TMA'
LEFT JOIN SerieLoteMov slm ON mt.Modulo = slm.Modulo AND t.ID = slm.ID AND d.Articulo = slm.Articulo AND d.Renglon = slm.RenglonID
WHERE t.Estatus = 'PENDIENTE'
AND mt.Clave IN('TMA.OSUR','TMA.TSUR','TMA.SUR','TMA.OPCKTARIMA','TMA.PCKTARIMATRAN','TMA.PCKTARIMA')
GROUP BY t.Empresa, d.Articulo, t.Almacen, slm.SerieLote,
CASE WHEN  CHARINDEX('-',d.Tarima,1) > 0 THEN SUBSTRING(d.Tarima,1,CHARINDEX('-',d.Tarima,1)-1) ELSE d.Tarima END

