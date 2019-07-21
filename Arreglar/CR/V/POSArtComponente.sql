SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW POSArtComponente

AS
SELECT j.Articulo ArticuloP, j.Descripcion Componente, j.Juego, d.Opcion Articulo, NULLIF(d.SubCuenta,'')SubCuenta,
CASE WHEN NULLIF(d.SubCuenta,'') IS NOT NULL THEN d.Opcion+' ('+d.SubCuenta+')' ELSE d.Opcion END  ArtSubCuenta, j.Descripcion
FROM ArtJuego j JOIN ArtJuegoD d ON j.Articulo = d.Articulo AND j.Juego = d.Juego

