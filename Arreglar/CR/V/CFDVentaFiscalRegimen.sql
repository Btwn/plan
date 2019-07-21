SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDVentaFiscalRegimen AS
SELECT  REPLICATE('0', 20 - LEN(RTRIM(LTRIM(CONVERT(varchar, Venta.ID))))) + RTRIM(LTRIM(CONVERT(varchar, Venta.ID)))
+ REPLICATE('0', 12 - LEN(RTRIM(LTRIM(CONVERT(varchar, 20048))))) + RTRIM(LTRIM(CONVERT(varchar, 2048))) + REPLICATE('0', 7 - LEN(RTRIM(LTRIM(CONVERT(varchar, 0)))))
+ RTRIM(LTRIM(CONVERT(varchar, 0))) + REPLICATE(' ', 50 - LEN(RTRIM(LTRIM(CONVERT(varchar, dbo.fnCFDFlexRegimenFiscal(Venta.Empresa, 'VTAS', Venta.Concepto))))))
+ RTRIM(LTRIM(CONVERT(varchar, dbo.fnCFDFlexRegimenFiscal(Venta.Empresa, 'VTAS', Venta.Concepto))))
OrdenExportacion,
Venta.ID,
dbo.fnCFDFlexRegimenFiscal(Venta.Empresa, 'VTAS', Venta.Concepto) EmisorRegimenFiscal
FROM  Venta

