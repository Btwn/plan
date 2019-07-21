SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE mis_spListaMat
@Articulo		char(20),
@Empresa		char(5)

AS BEGIN
CREATE TABLE #ListaM
(
Lugar			char(1)		COLLATE Database_Default NULL,
ArtMArticulo		char(20)	COLLATE Database_Default NULL,
OrdenID		int		NULL,
SiOpcion		varchar(100)	COLLATE Database_Default NULL,
Material		char(20)	COLLATE Database_Default NULL,
SubCuenta		varchar(50)	COLLATE Database_Default NULL,
Cantidad		float		NULL,
Unidad		varchar(50)	COLLATE Database_Default NULL,
Merma			float(8)	NULL,
Desperdicio		float(8)	NULL,
Almacen		char(10)	NULL,
CentroTipo		varchar(20)	COLLATE Database_Default NULL,
CostoAcumulado	money		NULL,
Orden			int		NULL,
Porcentaje		float(8)	NULL,
ArtArticulo		char(20)	COLLATE Database_Default NULL,
ArtDescripcion1	varchar(100)	COLLATE Database_Default NULL,
ArtCategoria		varchar(50)	COLLATE Database_Default NULL,
ArtFamilia		varchar(50)	COLLATE Database_Default NULL,
ArtFabricante		varchar(50)	COLLATE Database_Default NULL,
ArtLinea		varchar(50)	COLLATE Database_Default NULL,
ArtUnidad		varchar(50)	COLLATE Database_Default NULL,
ArtUnidadCompra	varchar(50)	COLLATE Database_Default NULL,
ArtTipo		varchar(20)	COLLATE Database_Default NULL,
ArtTipoOpcion		varchar(20)	COLLATE Database_Default NULL,
ArtEstatus		char(15)	NULL,
ArtMensaje		varchar(50)	COLLATE Database_Default NULL,
ArtCategoriaProd	varchar(50)	COLLATE Database_Default NULL,
ArtProdPasoTotal	int		NULL,
ArtMerma		float(8)	NULL,
ArtDesperdicio	float(8)	NULL,
ArtSeVende		bit		NULL,
ArtSeCompra		bit		NULL,
ArtSeProduce		bit		NULL,
ArtEsFormula		bit		NULL,
ArtCostoEstandar	money		NULL,
ArtCostoCostoPromedio	money		NULL,
ArtCostoUltimoCosto	money		NULL
)
INSERT #ListaM
SELECT '1', ArtMaterial.Articulo, ArtMaterial.OrdenID, ArtMaterial.SiOpcion,
ArtMaterial.Material, ArtMaterial.SubCuenta, ArtMaterial.Cantidad, ArtMaterial.Unidad,
ArtMaterial.Merma, ArtMaterial.Desperdicio, ArtMaterial.Almacen, ArtMaterial.CentroTipo,
ArtMaterial.CostoAcumulado, ArtMaterial.Orden, ArtMaterial.Porcentaje,
Art.Articulo, Art.Descripcion1, Art.Categoria, Art.Familia, Art.Fabricante, Art.Linea,
Art.Unidad, Art.UnidadCompra, Art.Tipo, Art.TipoOpcion, Art.Estatus, Art.Mensaje,
Art.CategoriaProd, Art.ProdPasoTotal, Art.Merma, Art.Desperdicio, Art.SeVende,
Art.SeCompra, Art.SeProduce, Art.EsFormula, Art.CostoEstandar, ArtCosto.CostoPromedio,
ArtCosto.UltimoCosto
FROM ArtMaterial
JOIN Art ON ArtMaterial.Material=Art.Articulo
LEFT OUTER JOIN ArtCosto ON ArtMaterial.Material = ArtCosto.Articulo AND ArtCosto.Empresa = @Empresa
WHERE ArtMaterial.Articulo = @Articulo
ORDER BY ArtMaterial.Articulo
INSERT #ListaM
SELECT '2', ArtMaterial.Articulo, ArtMaterial.OrdenID, ArtMaterial.SiOpcion, ArtMaterial.Material,
ArtMaterial.SubCuenta, ArtMaterial.Cantidad, ArtMaterial.Unidad, ArtMaterial.Merma, ArtMaterial.Desperdicio,
ArtMaterial.Almacen, ArtMaterial.CentroTipo, ArtMaterial.CostoAcumulado, ArtMaterial.Orden,
ArtMaterial.Porcentaje, Producto.Articulo, Producto.Descripcion1, Producto.Categoria, Producto.Familia,
Producto.Fabricante, Producto.Linea, Producto.Unidad, Producto.UnidadCompra, Producto.Tipo,
Producto.TipoOpcion, Producto.Estatus, Producto.Mensaje, Producto.CategoriaProd,
Producto.ProdPasoTotal, Producto.Merma, Producto.Desperdicio, Producto.SeVende, Producto.SeCompra,
Producto.SeProduce, Producto.EsFormula, Producto.CostoEstandar, ArtCosto.CostoPromedio,
ArtCosto.UltimoCosto
FROM ArtMaterial
JOIN Art Producto ON ArtMaterial.Articulo=Producto.Articulo
LEFT OUTER JOIN ArtCosto ON ArtMaterial.Articulo = ArtCosto.Articulo AND ArtCosto.Empresa = @Empresa
WHERE ArtMaterial.Material = @Articulo
ORDER BY ArtMaterial.Articulo
SELECT * FROM #ListaM
ORDER BY ArtMArticulo, Lugar, Material
END

