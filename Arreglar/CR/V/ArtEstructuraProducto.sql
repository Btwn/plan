SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtEstructuraProducto

AS
SELECT
ArtMaterial.Articulo,
ArtMaterial.OrdenID,
ArtMaterial.SiOpcion,
ArtMaterial.Material,
ArtMaterial.SubCuenta,
ArtMaterial.Cantidad,
ArtMaterial.Unidad,
ArtMaterial.Merma,
ArtMaterial.Desperdicio,
ArtMaterial.CentroTipo,
ArtMaterial.Orden,
Art.Descripcion1,
Art.Categoria,
Art.Familia,
Art.Fabricante,
Art.ClaveFabricante,
Art.UnidadCompra,
Art.Tipo,
Art.Estatus,
Art.SeCompra,
Art.SeVende,
Art.SeProduce,
Art.EsFormula
FROM ArtMaterial
JOIN Art ON ArtMaterial.Material=Art.Articulo

