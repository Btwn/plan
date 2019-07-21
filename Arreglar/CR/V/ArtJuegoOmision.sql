SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtJuegoOmision

AS
SELECT j.Articulo, j.Cantidad, j.Juego, "PrecioIndependiente" = CONVERT(int, j.PrecioIndependiente), j.ListaPreciosEsp,
"Opcion" = (SELECT Opcion FROM ArtJuegoD o WHERE o.Articulo = j.Articulo AND o.Juego = j.Juego AND o.Renglon = MIN(d.Renglon)),
"SubCuenta" = (SELECT SubCuenta FROM ArtJuegoD o WHERE o.Articulo = j.Articulo AND o.Juego = j.Juego AND o.Renglon = MIN(d.Renglon))
FROM ArtJuego j, ArtJuegoD d
WHERE j.Articulo = d.Articulo AND j.Juego = d.Juego
GROUP BY j.Articulo, j.Cantidad, j.Juego, CONVERT(int, j.PrecioIndependiente), j.ListaPreciosEsp

