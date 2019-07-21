SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFAVentaTCalcExportacion

AS
SELECT
ID,
SUM(ISNULL(ImporteDescuentoGlobal,0.0)) ImporteDescuentoGlobal,
SUM(ISNULL(DescuentosTotales,0.0)) DescuentosTotales,
SUM(ISNULL(ImporteSobrePrecio,0.0)) ImporteSobrePrecio,
SUM(ISNULL(SubTotal,0.0)) SubTotal,
SUM(ISNULL(Impuesto1Total,0.0)) Impuesto1Total,
SUM(ISNULL(Impuesto2Total,0.0)) Impuesto2Total,
SUM(ISNULL(Impuesto3Total,0.0)) Impuesto3Total,
SUM(ISNULL(Retencion1Total,0.0)) Retencion1Total,
SUM(ISNULL(Retencion2Total,0.0)) Retencion2Total,
SUM(ISNULL(Impuestos,0.0)) Impuestos,
SUM(ISNULL(Retencion,0.0)) Retenciones,
SUM(ISNULL(ImporteTotal,0.0)) ImporteTotal,
SUM(ISNULL(TotalNeto,0.0)) TotalNeto
FROM MFAVentaTCalc
LEFT OUTER JOIN EmpresaCFD ON MFAVentaTCalc.Empresa = EmpresaCFD.Empresa
GROUP BY ID

