SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDVentaDExt AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.ID))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.ID))) +
REPLICATE('0',12-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.Renglon))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.Renglon))) +
REPLICATE('0',7-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.RenglonSub))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.RenglonSub))) +
REPLICATE(' ',50)
OrdenExportacion,
VentaD.ID,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE VentaD.Cantidad - ISNULL(VentaD.CantidadObsequio,0.0) END VentaDCantidad,
VentaD.CantidadInventario VentaDCantidadInventario,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE Unidad.Clave END VentaDUnidad,
Unidad.Clave UnidadClave,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE VentaD.Articulo END VentaDArticulo,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE CONVERT(DECIMAL(20,2), dbo.fnVentaDTotalUSD(Venta.Moneda, (vtc.Importe/( VentaD.Cantidad - ISNULL(VentaD.CantidadObsequio,0.0))))) END VentaDPrecio ,
VentaD.Renglon VentaDRenglon,
VentaD.RenglonSub VentaDRenglonSub,
VentaD.RenglonID VentaDRenglonID,
VentaD.RenglonTipo VentaDRenglonTipo,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE sart.FraccionArancelaria END sartFraccionArancelaria,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE sart.Marca END sartMarca,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE sart.Modelo END sartModelo,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE sart.SubModelo END sartSubModelo,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE SerieLoteMov.SerieLote END SerieLote,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE
CONVERT(DECIMAL(20,2), (VentaD.Cantidad - ISNULL(VentaD.CantidadObsequio,0.0)) *
CONVERT(DECIMAL(20,2), dbo.fnVentaDTotalUSD(Venta.Moneda, (vtc.Importe/( VentaD.Cantidad - ISNULL(VentaD.CantidadObsequio,0.0)))))) END VentaDTotalUSD
FROM VentaD JOIN Art
ON VentaD.Articulo = Art.Articulo JOIN VentaTCalc vtc
ON vtc.ID = VentaD.ID AND vtc.Renglon = VentaD.Renglon AND vtc.RenglonSub = VentaD.RenglonSub LEFT OUTER JOIN Unidad
ON Unidad.Unidad = VentaD.Unidad LEFT OUTER JOIN ArtProv
ON ArtProv.Proveedor = Art.Proveedor AND ArtProv.Articulo = Art.Articulo JOIN Venta
ON Venta.ID = VentaD.ID LEFT OUTER JOIN EmpresaCFD
ON EmpresaCFD.Empresa = Venta.Empresa LEFT OUTER JOIN TipoEmpaque
ON Art.tipoEmpaque=TipoEmpaque.TipoEmpaque JOIN MovTipo mt
ON mt.Modulo = 'VTAS' AND mt.Mov = Venta.Mov LEFT OUTER JOIN EmpresaCfg Ecfg
ON Ecfg.Empresa = Venta.Empresa LEFT OUTER JOIN SATArticuloInfo sart
ON VentaD.Articulo = sart.Articulo LEFT OUTER JOIN SerieLoteMov
ON SerieLoteMov.ID = VentaD.ID AND SerieLoteMov.RenglonID = VentaD.RenglonID LEFT JOIN VentaCFDIRelacionado vcfd
ON VentaD.ID = vcfd.ID LEFT OUTER JOIN Empresa
ON Venta.Empresa = Empresa.Empresa
UNION
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,Venta.ID))))) + RTRIM(LTRIM(CONVERT(varchar,Venta.ID))) +
REPLICATE('0',12-LEN(RTRIM(LTRIM(CONVERT(varchar,'999999999999'))))) + RTRIM(LTRIM(CONVERT(varchar,'999999999999'))) +
REPLICATE('0',7-LEN(RTRIM(LTRIM(CONVERT(varchar,'0'))))) + RTRIM(LTRIM(CONVERT(varchar,'0'))) +
REPLICATE(' ',50)
OrdenExportacion,
Venta.ID,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE '1' END VentaDCantidad,
NULL AS VentaDCantidadInventario,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE 'No Aplica' END VentaDUnidad,
NULL AS UnidadClave,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE 'ANTICIPO' END AS VentaDArticulo,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE CONVERT(DECIMAL(20,2), dbo.fnVentaDTotalUSD(Venta.Moneda, ((AnticiposFacturados-ISNULL(AnticiposImpuestos,0.0))*-1)*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN))))  END VentaDPrecio,
NULL AS VentaDRenglon,
NULL AS VentaDRenglonSub,
NULL AS VentaDRenglonID,
NULL AS VentaDRenglonTipo,
NULL AS sartFraccionArancelaria,
NULL AS sartMarca,
NULL AS sartModelo,
NULL AS sartSubModelo,
NULL AS SerieLote,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE dbo.fnVentaDTotalUSD(Venta.Moneda, 1 * ((AnticiposFacturados-ISNULL(AnticiposImpuestos,0.0))*-1)*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN))) END VentaDTotalUSD
FROM Venta
JOIN EmpresaCFD ON Venta.Empresa = EmpresaCFD.Empresa
JOIN MovTipo mt ON mt.Modulo = 'VTAS' AND mt.Mov = Venta.Mov LEFT OUTER JOIN VentaCFDIRelacionado vcfd
ON Venta.ID = vcfd.ID LEFT OUTER JOIN Empresa
ON Venta.Empresa = Empresa.Empresa
WHERE AnticiposFacturados IS NOT NULL
UNION
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.ID))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.ID))) +
REPLICATE('0',12-LEN(RTRIM(LTRIM(CONVERT(varchar,Ventad.Renglon+'90000000'))))) + RTRIM(LTRIM(CONVERT(varchar,Ventad.Renglon+'90000000'))) +
REPLICATE('0',7-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.RenglonSub))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.RenglonSub))) +
REPLICATE(' ',50)
OrdenExportacion,
VentaD.ID,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE VentaD.CantidadObsequio END VentaDCantidad,
VentaD.CantidadInventario VentaDCantidadInventario,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE VentaD.Unidad END VentaDUnidad,
Unidad.Clave UnidadClave,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE VentaD.Articulo END VentaDArticulo,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE 0.0 END VentaDPrecio ,
VentaD.Renglon VentaDRenglon,
VentaD.RenglonSub VentaDRenglonSub,
VentaD.RenglonID VentaDRenglonID,
VentaD.RenglonTipo VentaDRenglonTipo,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE sart.FraccionArancelaria END sartFraccionArancelaria,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE sart.Marca  END sartMarca,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE sart.Modelo END sartModelo,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE sart.SubModelo END sartSubModelo,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE SerieLoteMov.SerieLote END SerieLote,
0.0 VentaDTotalUSD
FROM VentaD JOIN Art
ON VentaD.Articulo = Art.Articulo JOIN VentaTCalc vtc
ON vtc.ID = VentaD.ID AND vtc.Renglon = VentaD.Renglon AND vtc.RenglonSub = VentaD.RenglonSub LEFT OUTER JOIN Unidad
ON Unidad.Unidad = VentaD.Unidad LEFT OUTER JOIN ArtProv
ON ArtProv.Proveedor = Art.Proveedor AND ArtProv.Articulo = Art.Articulo JOIN Venta
ON Venta.ID = VentaD.ID LEFT OUTER JOIN EmpresaCFD
ON EmpresaCFD.Empresa = Venta.Empresa LEFT OUTER JOIN TipoEmpaque
ON Art.tipoEmpaque=TipoEmpaque.TipoEmpaque JOIN MovTipo mt
ON mt.Modulo = 'VTAS' AND mt.Mov = Venta.Mov LEFT OUTER JOIN EmpresaCfg Ecfg
ON Ecfg.Empresa = Venta.Empresa LEFT OUTER JOIN SATArticuloInfo sart
ON VentaD.Articulo = sart.Articulo LEFT OUTER JOIN SerieLoteMov
ON SerieLoteMov.ID = VentaD.ID AND SerieLoteMov.RenglonID = VentaD.RenglonID LEFT JOIN VentaCFDIRelacionado vcfd
ON VentaD.ID = vcfd.ID LEFT OUTER JOIN Empresa
ON Venta.Empresa = Empresa.Empresa
WHERE VentaD.CantidadObsequio >= 1

