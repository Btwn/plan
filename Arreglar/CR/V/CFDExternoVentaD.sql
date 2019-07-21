SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDExternoVentaD AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,ID))))) + RTRIM(LTRIM(CONVERT(varchar,ID))) +
REPLICATE('0',12-LEN(RTRIM(LTRIM(CONVERT(varchar,Renglon))))) + RTRIM(LTRIM(CONVERT(varchar,Renglon))) +
REPLICATE('0',7-LEN(RTRIM(LTRIM(CONVERT(varchar,RenglonSub))))) + RTRIM(LTRIM(CONVERT(varchar,RenglonSub))) +
REPLICATE(' ',50)
OrdenExportacion,
ID,
Renglon,
RenglonSub,
VentaCliente,
VentaDCantidad,
VentaDCantidadInventario,
VentaDUnidad,
UnidadClave,
VentaDArticulo,
EAN13,
SKUCliente,
SKUEmpresa,
DUN14,
VentaDDescripcion,
VentaDDescripcion2,
ArtTipoEmpaque,
VentaDPrecio,
VentaDPrecioTotal,
VentaDDescuentoLinea,
VentaDDescuentoImporte,
ventaDImpuesto1,
ventaDImpuesto2,
VentaDImporte,
VentaDImporteUnitario,
VentaDDescLineal,
VentaDDescuentosTotales,
VentaDImporteSobrePrecio,
VentaDSubTotal,
VentaDSubTotalUnitario,
VentaDImpuesto1Total,
VentaDImpuesto2Total,
VentaDImpuestos,
VentaDImporteTotal,
VentaDTotalNeto,
TipoEmpaqueClave,
TipoEmpaqueTipo
FROM CFDExtVentaD

