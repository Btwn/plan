USE [IntelisisTmp]
GO

/****** Object:  View [dbo].[ArtCostoEmpresa]    Script Date: 24/06/2019 07:37:25 p. m. ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
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
GO


