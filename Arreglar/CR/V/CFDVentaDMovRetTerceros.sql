SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.CFDVentaDMovRetTerceros AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.ID))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.ID))) +
REPLICATE('0',12-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.Renglon))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.Renglon))) +
REPLICATE('0',7-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.RenglonSub))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.RenglonSub))) +
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,CFDVentaDProv.Proveedor))))) + RTRIM(CFDVentaDProv.Proveedor) +
+ RTRIM('zzimpuesto')+   RTRIM('xy') +
'RETENCION2' + REPLICATE(' ',50 - LEN('RETENCION2'))
OrdenExportacion,
VentaD.ID,
CFDVentaDProv.Proveedor,
'VAT' VentaDRetencionClave,
'IVA' VentaDRetencion,
ISNULL(VentaD.Retencion2,0.0) VentaDImpuestoTasa,
CASE WHEN ISNULL(VentaD.Retencion2,0.0) > 0.0 THEN (VentaD.Precio*(ISNULL(VentaD.Retencion2,0.0)/100.0))*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)) ELSE 0.0 END VentaDRetencionImporte,
'RETENIDO' VentaDCategoriaRetencion
FROM VentaD
JOIN Venta ON VentaD.ID = Venta.ID
JOIN CFDVentaDProv ON CFDVentaDProv.ID = VentaD.ID AND VentaD.Renglon = CFDVentaDProv.Renglon AND CFDVentaDProv.RenglonSub = VentaD.RenglonSub AND CFDVentaDProv.Articulo = VentaD.Articulo
JOIN EmpresaCFD ON Venta.Empresa = EmpresaCFD.Empresa
JOIN MovTipo mt ON mt.Modulo = 'VTAS' AND mt.Mov = Venta.Mov
WHERE NULLIF(CFDVentaDProv.Proveedor,'') IS NOT NULL
AND ISNULL(VentaD.Retencion2,0.0) > 0.0
UNION ALL
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.ID))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.ID))) +
REPLICATE('0',12-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.Renglon))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.Renglon))) +
REPLICATE('0',7-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.RenglonSub))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.RenglonSub))) +
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,CFDVentaDProv.Proveedor))))) + RTRIM(CFDVentaDProv.Proveedor) +
+ RTRIM('zzimpuesto')+      RTRIM('xy') +
'RETENCION1' + REPLICATE(' ',50 - LEN('RETENCION1'))
OrdenExportacion,
VentaD.ID,
CFDVentaDProv.Proveedor,
'ISR' VentaDRetencionClave,
'ISR' VentaDRetencion,
ISNULL(VentaD.Retencion1,0.0) VentaDRetencionTasa,
CASE WHEN ISNULL(VentaD.Retencion1,0.0) > 0.0 THEN (VentaD.Precio*(ISNULL(VentaD.Retencion1,0.0)/100.0))*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)) ELSE 0.0 END VentaDRetencionImporte,
'RETENIDO' VentaDCategoriaRetencion
FROM VentaD
JOIN Venta ON VentaD.ID = Venta.ID
JOIN CFDVentaDProv ON CFDVentaDProv.ID = VentaD.ID AND VentaD.Renglon = CFDVentaDProv.Renglon AND CFDVentaDProv.RenglonSub = VentaD.RenglonSub AND CFDVentaDProv.Articulo = VentaD.Articulo
JOIN EmpresaCFD ON Venta.Empresa = EmpresaCFD.Empresa
JOIN MovTipo mt ON mt.Modulo = 'VTAS' AND mt.Mov = Venta.Mov
WHERE NULLIF(CFDVentaDProv.Proveedor,'') IS NOT NULL
AND ISNULL(VentaD.Retencion1,0.0) > 0.0

