SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW [dbo].[ArtCostoEmpresa]

AS
SELECT c.Empresa
	  ,c.Articulo
	  ,"CostoPromedio" = CONVERT(MONEY, SUM(s.SaldoU * c.CostoPromedio) / NULLIF(SUM(s.SaldoU), 0))
	  ,"UltimoCosto" = CONVERT(MONEY, SUM(s.SaldoU * c.UltimoCosto) / NULLIF(SUM(s.SaldoU), 0))
	  ,"UltimoCostoSinGastos" = CONVERT(MONEY, SUM(s.SaldoU * c.UltimoCostoSinGastos) / NULLIF(SUM(s.SaldoU), 0))
	  ,"CostoEstandar" = AVG(a.CostoEstandar)
	  ,"CostoReposicion" = AVG(a.CostoReposicion)
FROM Art a
	,ArtCosto c
	,SaldoU s
WHERE a.Articulo = c.Articulo
AND s.Rama = 'INV'
AND s.Cuenta = a.Articulo
AND c.Sucursal = s.Sucursal
GROUP BY c.Empresa
		,c.Articulo

