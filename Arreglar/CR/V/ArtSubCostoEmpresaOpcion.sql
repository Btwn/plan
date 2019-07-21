SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtSubCostoEmpresaOpcion

AS
SELECT
c.Sucursal,
c.Empresa,
s.Rama,
s.Moneda,
c.Articulo,
c.SubCuenta,
s.Grupo,
s.SubGrupo,
"CostoPromedio" = CONVERT(money, SUM(s.SaldoU*c.CostoPromedio)/NULLIF(SUM(s.SaldoU), 0)),
"UltimoCosto" = CONVERT(money, SUM(s.SaldoU*c.UltimoCosto)/NULLIF(SUM(s.SaldoU), 0)),
"UltimoCostoSinGastos" = CONVERT(money, SUM(s.SaldoU*c.UltimoCostoSinGastos)/NULLIF(SUM(s.SaldoU), 0)),
"CostoEstandar"= AVG(a.CostoEstandar),
"CostoReposicion"= AVG(a.CostoReposicion)
FROM Art a
JOIN ArtSubCosto c ON a.Articulo = c.Articulo
JOIN SaldoU s ON c.Articulo = s.Cuenta AND c.SubCuenta = s.Subcuenta AND s.Rama = 'INV' AND c.Sucursal = s.Sucursal
GROUP BY
c.Sucursal, c.Empresa, s.Rama, s.Moneda, c.Articulo, c.SubCuenta, s.Grupo, s.SubGrupo

