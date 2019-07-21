SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.CFDVentaDTercerosImp AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.ID))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.ID))) +
REPLICATE('0',12-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.Renglon))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.Renglon))) +
REPLICATE('0',7-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.RenglonSub))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.RenglonSub))) +
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,CFDVentaDProv.Proveedor))))) + RTRIM(CFDVentaDProv.Proveedor) +
+ RTRIM('zzimpuesto')+  RTRIM('yyyy')
OrdenExportacion,
VentaD.ID,
VentaD.Renglon,
VentaD.RenglonSub,
VentaD.Articulo,
Prov.RFC,
Prov.Nombre,
Prov.Direccion,
Prov.DireccionNumero,
Prov.DireccionNumeroInt,
Prov.Colonia,
Prov.Poblacion,
Prov.EntreCalles,
Prov.Delegacion,
Prov.Estado,
Prov.Pais,
Prov.CodigoPostal,
Prov.Telefonos
FROM VentaD
JOIN CFDVentaDProv ON CFDVentaDProv.ID = VentaD.ID AND VentaD.Renglon = CFDVentaDProv.Renglon AND CFDVentaDProv.RenglonSub = VentaD.RenglonSub AND CFDVentaDProv.Articulo = VentaD.Articulo
JOIN prov ON CFDVentaDprov.Proveedor = Prov.Proveedor

