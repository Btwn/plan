SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spArtMesImportar

AS
BEGIN
INSERT INTO ArtMES(Articulo, Descripcion1, Descripcion2, Categoria,
Inventariable, Almacen, Ubicacion, UnidadAlmacen, UnidadCompra,
UnidadVenta, CostoEstandar, Impuesto1, TipoCosteo, PrecioLista,
Estatus, Cuenta, EstatusIntelIMES, Proveedor, TiempoEntrega,
TiempoEntregaSeg, Familia, SubFamilia)
SELECT a.Articulo, a.Descripcion1, SUBSTRING(a.Descripcion2, 1, 100), a.TipoArticulo,
'S', a.AlmacenROP, '(none)', (SELECT um.UnidadMedida FROM UnidadMES um WITH(NOLOCK) WHERE um.Descripcion = a.UnidadTraspaso), (SELECT um.UnidadMedida FROM UnidadMES um WITH(NOLOCK) WHERE um.Descripcion = a.UnidadCompra),
(SELECT um.UnidadMedida FROM UnidadMES um WITH(NOLOCK) WHERE um.Descripcion = a.Unidad), a.CostoEstandar, a.Impuesto1, a.TipoCosteo, a.PrecioLista,
Estatus, Cuenta, 0, Proveedor, TiempoEntrega,
TiempoEntregaSeg,
(SELECT TOP 1 Clave FROM ArtFamMes afm WITH(NOLOCK) WHERE afm.Descripcion = a.Familia),
(SELECT TOP 1 Clave FROM ArtSubFamMes afm WITH(NOLOCK) WHERE afm.Descripcion = a.Grupo)
FROM Art a WITH(NOLOCK)
WHERE a.Articulo IN (SELECT  a2.Articulo
FROM Art a2 WITH(NOLOCK)
LEFT OUTER JOIN ArtMES am WITH(NOLOCK) ON a2.Articulo = am.Articulo
WHERE a2.TipoArticulo IS NOT NULL
GROUP BY a2.Articulo, am.Articulo
HAVING am.Articulo IS NULL)
SELECT 'Proceso Concluido'
RETURN
END

