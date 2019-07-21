SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtSubCostoSucursal

AS
SELECT
c.Empresa,
c.Sucursal,
c.Articulo,
c.SubCuenta,
c.CostoPromedio,
c.UltimoCosto,
c.UltimoCostoSinGastos,
a.CostoEstandar,
a.CostoReposicion
FROM Art a
JOIN ArtSubCosto c ON a.Articulo = c.Articulo

