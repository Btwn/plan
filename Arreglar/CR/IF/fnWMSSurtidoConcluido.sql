SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWMSSurtidoConcluido (@Tarima varchar(20), @Articulo varchar(20))
RETURNS TABLE
AS
RETURN (
SELECT v.ID, v.Mov, v.MovID, a.Articulo, d.CantidadPicking Cantidad, d.Almacen, 2 Tipo, dbo.fnWMSTarimaPCK(d.Tarima) Tarima, CASE WHEN mt.SubClave = 'TMA.TSURP' THEN 1 ELSE 0 END PCK, d.Renglon
FROM TMAD d
JOIN TMA v ON v.ID = d.ID
JOIN MovTipo m ON m.Modulo = 'TMA' AND m.Mov = v.Mov
JOIN ArtDisponibleTarima a ON a.Tarima = d.Tarima
JOIN TMA tm ON tm.Mov = v.Origen AND tm.MovID = v.OrigenID AND tm.OrigenTipo = 'TMA' and tm.Empresa = v.Empresa
JOIN TMAD td ON tm.ID = td.ID AND td.Renglon = d.Renglon
JOIN MovTipo mt ON mt.Modulo = 'TMA' AND mt.Mov = tm.Mov
JOIN ArtDisponibleTarima at ON at.Tarima = td.Tarima AND at.Articulo = a.Articulo
WHERE d.Tarima = @Tarima
AND a.Articulo = ISNULL(@Articulo, a.Articulo)
AND v.Estatus IN('CONCLUIDO')
AND m.Clave = 'TMA.SUR'
AND mt.Clave = 'TMA.TSUR'
AND at.Tarima = ISNULL(d.TarimaPCK, at.Tarima)
UNION ALL
SELECT v.ID, v.Mov, v.MovID, a.Articulo, d.CantidadPicking Cantidad, d.Almacen, 2 Tipo, dbo.fnWMSTarimaPCK(d.Tarima) Tarima, CASE WHEN mt.SubClave = 'TMA.TSURP' THEN 1 ELSE 0 END PCK, d.Renglon
FROM TMAD d
JOIN TMA v ON v.ID = d.ID
JOIN MovTipo m ON m.Modulo = 'TMA' AND m.Mov = v.Mov
JOIN ArtDisponibleTarima a ON a.Tarima = d.Tarima
JOIN TMA tm ON tm.Mov = d.Aplica AND tm.MovID = d.AplicaID AND tm.Empresa = v.Empresa
JOIN TMAD td ON td.ID = tm.ID AND d.AplicaRenglon = td.Renglon
JOIN MovTipo mt ON mt.Modulo = 'TMA' AND mt.Mov = tm.Mov
JOIN ArtDisponibleTarima at ON at.Tarima = dbo.fnWMSTarimaPCK(td.Tarima)
WHERE d.Tarima = @Tarima
AND a.Articulo = ISNULL(@Articulo, a.Articulo)
AND at.Articulo = ISNULL(@Articulo, at.Articulo)
AND v.Estatus IN('CONCLUIDO')
AND m.Clave = 'TMA.SUR'
AND mt.Clave = 'TMA.TSUR'
AND mt.SubClave = 'TMA.TSURP'
)

