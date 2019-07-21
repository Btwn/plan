SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CompraDGuatemala
AS
SELECT 'COMS' Modulo,
cd.ID,
cd.Renglon,
cd.RenglonSub,
cd.Articulo,
cd.SubCuenta,
CASE a.Tipo WHEN 'Servicio' THEN cd.Cantidad ELSE 0.0 END As CantidadServicio,
CASE a.Tipo WHEN 'Servicio' THEN cd.Unidad ELSE NULL END As UnidadServicio,
CASE a.Tipo WHEN 'Servicio' THEN ((((cd.cantidad * cd.Costo) * (1 - (ISNULL(cd.DescuentoLinea,0.0)/100))))) * c.TipoCambio ELSE 0.0 END As ImporteServicio,
CASE a.Tipo WHEN 'Servicio' THEN ((((cd.cantidad * cd.Costo) * (1 - (ISNULL(cd.DescuentoLinea,0.0)/100)))) * (ISNULL(cd.Impuesto1,0.0)/100)) * c.TipoCambio ELSE 0.0 END As ImpuestoServicio,
CASE WHEN a.Tipo <> 'Servicio' THEN cd.Cantidad ELSE 0.0 END As CantidadBienes,
CASE WHEN a.Tipo <> 'Servicio' THEN cd.Unidad ELSE NULL END As UnidadBienes,
CASE WHEN a.Tipo <> 'Servicio' THEN ((((cd.cantidad * cd.Costo) * (1 - (ISNULL(cd.DescuentoLinea,0.0)/100))) /*/ ( 1 + (ISNULL(cd.Impuesto1,0.0)/100))*/)) * c.TipoCambio ELSE 0.0 END As ImporteBienes,
CASE WHEN a.Tipo <> 'Servicio' THEN ((((cd.cantidad * cd.Costo) * (1 - (ISNULL(cd.DescuentoLinea,0.0)/100))) /*/ ( 1 + (ISNULL(cd.Impuesto1,0.0)/100))*/) * (ISNULL(cd.Impuesto1,0.0)/100)) * c.TipoCambio ELSE 0.0 END As ImpuestoBienes,
(((((cd.cantidad * cd.Costo) * (1 - (ISNULL(cd.DescuentoLinea,0.0)/100)))) * ((ISNULL(cd.Impuesto2,0.0)) / 100.0)) +
(ISNULL(cd.Impuesto3,0.0) * ISNULL(cd.Cantidad,0.0))) * c.TipoCambio As Excento
FROM CompraD cd WITH (NOLOCK) JOIN Art a WITH (NOLOCK)
ON cd.Articulo = a.Articulo JOIN Compra c WITH (NOLOCK)
ON c.ID = cd.ID
UNION ALL
SELECT 'GAS' Modulo,
gd.ID,
gd.Renglon,
gd.RenglonSub,
gd.Concepto Articulo,
CONVERT(varchar(50),NULL) SubCuenta,
gd.Cantidad As CantidadServicio,
CONVERT(varchar(50),NULL) Unidad,
(gd.cantidad * gd.Precio) * g.TipoCambio As ImporteServicio,
((gd.cantidad * gd.Precio) * (ISNULL(gd.Impuesto1,0.0)/100)) * g.TipoCambio As ImpuestoServicio,
ISNULL(CONVERT(float,NULL),0.0) As CantidadBienes,
ISNULL(CONVERT(varchar(50),NULL),0.0) As UnidadBienes,
ISNULL(CONVERT(money,NULL),0.0) * g.TipoCambio As ImporteBienes,
ISNULL(CONVERT(money,NULL),0.0) * g.TipoCambio As ImpuestoBienes,
(((gd.cantidad * gd.Precio) * ((ISNULL(gd.Impuesto2,0.0)) / 100.0))
+ (ISNULL(gd.Cantidad,0.0) * ISNULL(gd.Impuesto3,0.0))) * g.TipoCambio  As Excento
FROM GastoD gd WITH (NOLOCK) JOIN Gasto g WITH (NOLOCK)
ON g.ID = gd.ID

