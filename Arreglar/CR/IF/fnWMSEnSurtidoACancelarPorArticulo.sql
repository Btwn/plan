SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWMSEnSurtidoACancelarPorArticulo (@Tarima varchar(20))
RETURNS TABLE
AS
RETURN (
SELECT x.Articulo, SUM(x.Cantidad) Cantidad
FROM(
SELECT Articulo, -CASE WHEN dbo.fnWMSPorSurtirEnSurtidoPerdido(@Tarima) = 1 THEN Cantidad - Cantidad ELSE Cantidad END Cantidad FROM dbo.fnWMSPorSurtir(@Tarima)
UNION ALL
SELECT Articulo,  Cantidad Cantidad FROM dbo.fnWMSEnSurtidoPorArticulo(@Tarima)
UNION ALL
SELECT a.Articulo, -d.CantidadPicking Cantidad
FROM TMA t JOIN TMAD d
ON t.ID = d.ID JOIN ArtDisponibleTarima a
ON d.Tarima = a.Tarima JOIN MovTipo m
ON m.Modulo = 'TMA' AND m.Mov = t.Mov
WHERE m.Clave = 'TMA.SURPER' AND TarimaSurtido = @Tarima
UNION ALL
SELECT d.Articulo, -d.Cantidad
FROM Inv i JOIN InvD d
ON i.ID = d.ID JOIN MovTipo m
ON i.Mov = m.Mov AND m.Modulo = 'INV'
WHERE d.Tarima = @Tarima AND m.Clave = 'INV.T' AND m.SubClave = 'INV.TMA'
) x
GROUP BY x.Articulo
HAVING(SUM(x.Cantidad)) > 0
)

