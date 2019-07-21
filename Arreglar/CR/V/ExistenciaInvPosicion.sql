SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ExistenciaInvPosicion

AS
SELECT e.Empresa, e.Almacen, e.SerieLote, e.Articulo, e.Subcuenta, Existencia = e.ExistenciaAlterna, e.Posicion, TipoPosicion = p.Tipo
FROM ExistenciaInvPosicionSerieLote e
JOIN Alm ON alm.Almacen = e.Almacen
JOIN AlmPos p ON Alm.Almacen = p.Almacen AND e.Posicion = p.Posicion
WHERE Alm.Ubicaciones = 1 AND Existencia > 0
UNION
SELECT ad.Empresa, ad.Almacen, sl.SerieLote, ad.Articulo, ad.Subcuenta,  Existencia =CASE WHEN a.Tipo  IN ('Serie', 'Lote') THEN sl.Existencia ELSE ad.Disponible END, NULL, NULL
FROM ArtSubDisponible ad
LEFT OUTER JOIN SerieLote sl ON ad.Empresa = sl.Empresa AND ad.Articulo = sl.Articulo AND ad.Subcuenta = sl.Subcuenta AND ad.Almacen = sl.Almacen
JOIN Art a ON ad.Articulo = a.Articulo
JOIN Alm ON ad.Almacen = alm.Almacen
WHERE Alm.Ubicaciones = 0 AND CASE WHEN a.Tipo  IN ('Serie', 'Lote') THEN sl.Existencia ELSE ad.Disponible END > 0

