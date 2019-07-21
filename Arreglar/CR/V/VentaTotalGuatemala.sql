SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW VentaTotalGuatemala
AS SELECT
vg.Modulo,
vg.ID,
CASE WHEN ISNULL(fr.Extranjero,0) = 1 THEN TotalCantidadServicio + TotalCantidadBienes ELSE 0.0 END TotalCantidadExportacion,
CASE WHEN ISNULL(fr.Extranjero,0) = 1 THEN TotalImporteServicio + TotalImporteBienes ELSE 0.0 END TotalImporteExportacion,
CASE WHEN ISNULL(fr.Extranjero,0) = 1 THEN TotalImpuestoServicio + TotalImpuestoBienes ELSE 0.0 END TotalImpuestoExportacion,
CASE WHEN ISNULL(fr.Extranjero,0) = 1 THEN 0.0 ELSE TotalCantidadServicio END TotalCantidadServicio,
CASE WHEN ISNULL(fr.Extranjero,0) = 1 THEN 0.0 ELSE TotalImporteServicio END TotalImporteServicio,
CASE WHEN ISNULL(fr.Extranjero,0) = 1 THEN 0.0 ELSE TotalImpuestoServicio END TotalImpuestoServicio,
CASE WHEN ISNULL(fr.Extranjero,0) = 1 THEN 0.0 ELSE TotalCantidadBienes END TotalCantidadBienes,
CASE WHEN ISNULL(fr.Extranjero,0) = 1 THEN 0.0 ELSE TotalImporteBienes END TotalImporteBienes,
CASE WHEN ISNULL(fr.Extranjero,0) = 1 THEN 0.0 ELSE TotalImpuestoBienes END TotalImpuestoBienes,
ISNULL(mt.GuatemalaLibroVentaExento,0) GuatemalaLibroVentaExento,
vg.TotalExcento
FROM VentaGuatemala vg JOIN Venta v
ON vg.ID = v.ID JOIN MovTipo mt
ON v.Mov = mt.Mov AND mt.Modulo = 'VTAS' JOIN Cte c
ON v.Cliente = c.Cliente LEFT OUTER JOIN FiscalRegimen fr
ON c.FiscalRegimen = fr.FiscalRegimen
UNION ALL
SELECT
vg.Modulo,
vg.ID,
CASE WHEN ISNULL(fr.Extranjero,0) = 1 THEN TotalCantidadServicio + TotalCantidadBienes ELSE 0.0 END TotalCantidadExportacion,
CASE WHEN ISNULL(fr.Extranjero,0) = 1 THEN TotalImporteServicio + TotalImporteBienes ELSE 0.0 END TotalImporteExportacion,
CASE WHEN ISNULL(fr.Extranjero,0) = 1 THEN TotalImpuestoServicio + TotalImpuestoBienes ELSE 0.0 END TotalImpuestoExportacion,
CASE WHEN ISNULL(fr.Extranjero,0) = 1 THEN 0.0 ELSE TotalCantidadServicio END TotalCantidadServicio,
CASE WHEN ISNULL(fr.Extranjero,0) = 1 THEN 0.0 ELSE TotalImporteServicio END TotalImporteServicio,
CASE WHEN ISNULL(fr.Extranjero,0) = 1 THEN 0.0 ELSE TotalImpuestoServicio END TotalImpuestoServicio,
CASE WHEN ISNULL(fr.Extranjero,0) = 1 THEN 0.0 ELSE TotalCantidadBienes END TotalCantidadBienes,
CASE WHEN ISNULL(fr.Extranjero,0) = 1 THEN 0.0 ELSE TotalImporteBienes END TotalImporteBienes,
CASE WHEN ISNULL(fr.Extranjero,0) = 1 THEN 0.0 ELSE TotalImpuestoBienes END TotalImpuestoBienes,
ISNULL(mt.GuatemalaLibroVentaExento,0) GuatemalaLibroVentaExento,
vg.TotalExcento
FROM VentaGuatemala vg JOIN CxC v
ON vg.ID = v.ID JOIN MovTipo mt
ON v.Mov = mt.Mov AND mt.Modulo = 'CXC' JOIN Cte c
ON v.Cliente = c.Cliente LEFT OUTER JOIN FiscalRegimen fr
ON c.FiscalRegimen = fr.FiscalRegimen

