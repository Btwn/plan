SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtConCostoAlm

AS
SELECT
a.Articulo,
a.Descripcion1,
a.Grupo,
a.Categoria,
a.Familia,
a.Fabricante,
a.ClaveFabricante,
a.MonedaCosto,
a.Estatus,
a.Codigo,
c.Empresa,
c.CostoPromedio,
c.UltimoCosto,
c.UltimoCostoSinGastos,
a.CostoEstandar,
a.CostoReposicion,
c.Almacen
FROM
Art a
LEFT OUTER JOIN ArtCostoEmpresaAlm c ON a.Articulo = c.Articulo

