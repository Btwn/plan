SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.CFDVentaDTercerosImpCte AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.ID))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.ID))) +
REPLICATE('0',12-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.Renglon))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.Renglon))) +
REPLICATE('0',7-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.RenglonSub))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.RenglonSub))) +
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,CFDVentaDCte.Cliente ))))) + RTRIM(CFDVentaDCte.Cliente ) +
+ RTRIM('zzimpuesto')+  RTRIM('yyyy')
OrdenExportacion,
VentaD.ID,
VentaD.Renglon,
VentaD.RenglonSub,
VentaD.Articulo,
Cte.RFC,
Cte.Nombre,
Cte.Direccion,
Cte.DireccionNumero,
Cte.DireccionNumeroInt,
Cte.Colonia,
Cte.Poblacion,
Cte.EntreCalles,
Cte.Delegacion,
Cte.Estado,
Cte.Pais,
Cte.CodigoPostal,
Cte.Telefonos
FROM VentaD
JOIN CFDVentaDCte ON CFDVentaDCte.ID = VentaD.ID AND VentaD.Renglon = CFDVentaDCte.Renglon AND CFDVentaDCte.RenglonSub = VentaD.RenglonSub AND CFDVentaDCte.Articulo = VentaD.Articulo
JOIN Cte ON CFDVentaDCte.Cliente  = Cte.Cliente

