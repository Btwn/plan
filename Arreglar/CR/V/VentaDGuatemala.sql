SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW VentaDGuatemala
AS SELECT
'VTAS' AS Modulo,
vd.ID,
vd.Renglon,
vd.RenglonSub,
vd.Articulo,
vd.SubCuenta,
CASE a.Tipo WHEN 'Servicio' THEN vd.Cantidad ELSE 0.0 END As CantidadServicio,
CASE a.Tipo WHEN 'Servicio' THEN vd.Unidad ELSE NULL END As UnidadServicio,
CASE a.Tipo WHEN 'Servicio' THEN ((vd.cantidad * vd.Precio) * (1 - (ISNULL(vd.DescuentoLinea,0.0)/100))) / ( 1 + (ISNULL(vd.Impuesto1,0.0)/100)) * v.TipoCambio ELSE 0.0 END As ImporteServicio,
CASE a.Tipo WHEN 'Servicio' THEN ((vd.cantidad * vd.Precio) * (1 - (ISNULL(vd.DescuentoLinea,0.0)/100))) / ( 1 + (ISNULL(vd.Impuesto1,0.0)/100)) * (ISNULL(vd.Impuesto1,0.0)/100) * v.TipoCambio ELSE 0.0 END As ImpuestoServicio,
CASE WHEN a.Tipo <> 'Servicio' THEN vd.Cantidad ELSE 0.0 END As CantidadBienes,
CASE WHEN a.Tipo <> 'Servicio' THEN vd.Unidad ELSE NULL END As UnidadBienes,
CASE WHEN a.Tipo <> 'Servicio' THEN ((vd.cantidad * vd.Precio) * (1 - (ISNULL(vd.DescuentoLinea,0.0)/100))) / ( 1 + (ISNULL(vd.Impuesto1,0.0)/100)) * v.TipoCambio ELSE 0.0 END As ImporteBienes,
CASE WHEN a.Tipo <> 'Servicio' THEN ((vd.cantidad * vd.Precio) * (1 - (ISNULL(vd.DescuentoLinea,0.0)/100))) / ( 1 + (ISNULL(vd.Impuesto1,0.0)/100)) * (ISNULL(vd.Impuesto1,0.0)/100) * v.TipoCambio ELSE 0.0 END As ImpuestoBienes,
CONVERT(money,NULL) /*ISNULL(vd.Impuesto2,0.0) + ISNULL(vd.Impuesto3,0.0)*/ As Excento
FROM VentaD vd JOIN Art a
ON vd.Articulo = a.Articulo JOIN Venta v
ON vd.ID = v.ID
UNION ALL
SELECT     'CXC' As Modulo,
vd.ID,
0,
0,
'',
'',
0.0 As CantidadServicio,
0.0 As UnidadServicio,
(vd.Importe * vd.TipoCambio) As ImporteServicio,
(vd.Impuestos * vd.TipoCambio) As ImpuestoServicio,
0.0 As CantidadBienes,
0.0 As UnidadBienes,
0.0 As ImporteBienes,
0.0 As ImpuestoBienes,
CONVERT(money,NULL) As Excento
FROM cxc vd JOIN MovTipo mt
ON vd.Mov = mt.Mov AND mt.Modulo = 'CXC'
WHERE mt.Clave IN ('CXC.CA','CXC.NC')

