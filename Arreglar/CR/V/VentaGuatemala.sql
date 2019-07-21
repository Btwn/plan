SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW VentaGuatemala
AS SELECT
Modulo AS Modulo,
ID As ID,
SUM(CantidadServicio) As TotalCantidadServicio,
SUM(ImporteServicio) As TotalImporteServicio,
SUM(ImpuestoServicio) As TotalImpuestoServicio,
SUM(CantidadBienes) As TotalCantidadBienes,
SUM(ImporteBienes) As TotalImporteBienes,
SUM(ImpuestoBienes) As TotalImpuestoBienes,
SUM(Excento) As TotalExcento
FROM VentaDGuatemala
GROUP BY Modulo, ID

