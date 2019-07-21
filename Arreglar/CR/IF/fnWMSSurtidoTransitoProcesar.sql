SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWMSSurtidoTransitoProcesar (@Tarima varchar(20), @Articulo varchar(20))
RETURNS TABLE
AS
RETURN (
SELECT v.ID, v.Mov, v.MovID, a.Articulo, ISNULL(NULLIF(d.CantidadPendiente,0), a.Disponible) Cantidad, d.Almacen, 3 Tipo, d.Tarima, CASE WHEN m.SubClave = 'TMA.TSURP' THEN 1 ELSE 0 END PCK, d.Renglon
FROM TMAD d
JOIN TMA v ON v.ID = d.ID
JOIN MovTipo m ON m.Modulo = 'TMA' AND m.Mov = v.Mov
JOIN ArtDisponibleTarima a ON a.Tarima = d.Tarima
WHERE v.TarimaSurtido = @Tarima
AND a.Articulo = ISNULL(@Articulo, a.Articulo)
AND v.Estatus IN('PROCESAR')
AND m.Clave = 'TMA.TSUR'
)

