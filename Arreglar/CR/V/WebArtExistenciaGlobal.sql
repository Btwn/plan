SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW WebArtExistenciaGlobal

AS
SELECT a.Articulo,a.SubCuenta,a.Inventario ,ISNULL(w.SKU,'ID#'+CONVERT(varchar,w.ID)) SKU, aa.Situacion
FROM eCommerceArtSubExistenciaInv a  JOIN WebArt w ON a.Articulo = w.Articulo AND ISNULL(a.SubCuenta,'') = ISNULL(w.SubCuenta,'')
JOIN Art aa ON a.Articulo = aa.Articulo
UNION ALL
SELECT a.Articulo,a.SubCuenta,a.Inventario ,ISNULL(c.SKU,'IDCO#'+CONVERT(varchar,c.ID)), aa.Situacion
FROM eCommerceArtSubExistenciaInv a  JOIN WebArtVariacionCombinacion c ON a.Articulo = c.Articulo AND ISNULL(a.SubCuenta,'') = ISNULL(c.SubCuenta,'')
JOIN Art aa ON a.Articulo = aa.Articulo

