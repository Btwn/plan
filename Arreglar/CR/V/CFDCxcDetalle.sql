SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDCxcDetalle AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,c.ID))))) + RTRIM(LTRIM(CONVERT(varchar,c.ID))) +
REPLICATE(' ',12) +
REPLICATE(' ',7) +
REPLICATE(' ',50)
OrdenExportacion,
'ID' = c.ID,
'Renglon' = ISNULL(d.Renglon,2048),
'CxcDCantidad'			= '1',
'CxcDUnidad'			= CASE WHEN dbo.fnCFDFlexNumDocumento(c.Empresa,d.Aplica,d.AplicaID, d.ID) = '' THEN c.Concepto ELSE 'no aplica' END,
'CxcDArticulo'			= CASE WHEN dbo.fnCFDFlexNumDocumento(c.Empresa,d.Aplica,d.AplicaID, d.ID) = '' THEN c.Concepto ELSE d.Aplica + ' ' + d.AplicaID END,
'CxcDDescripcion'		= ISNULL(NULLIF(dbo.fnCFDFlexNumDocumento(c.Empresa,d.Aplica,d.AplicaID, d.ID),''),c.Concepto),
'CxcDPrecio'			= ISNULL(dbo.fnCFDCxcImporte(d.ID, d.Importe, d.Renglon)*dbo.fnCFDTipoCambioMN(C.TipoCambio, ISNULL(mt.SAT_MN, f.SAT_MN)),c.Importe*dbo.fnCFDTipoCambioMN(C.TipoCambio, ISNULL(mt.SAT_MN, f.SAT_MN))),
'CxcDPrecioTotal'		= ISNULL(dbo.fnCFDCxcImporte(d.ID, d.Importe, d.Renglon)*dbo.fnCFDTipoCambioMN(C.TipoCambio, ISNULL(mt.SAT_MN, f.SAT_MN)),c.Importe*dbo.fnCFDTipoCambioMN(C.TipoCambio, ISNULL(mt.SAT_MN, f.SAT_MN)))
FROM Cxc c
LEFT OUTER JOIN CxcD d ON c.ID = d.ID AND NULLIF(d.AplicaID,'') IS NOT NULL
JOIN MovTipo mt ON mt.Modulo = 'CXC' AND mt.Mov = c.Mov
JOIN Empresa e ON c.Empresa = e.Empresa
JOIN Sucursal s ON c.Sucursal = s.Sucursal
JOIN Cte Cte ON Cte.Cliente = c.Cliente
LEFT OUTER JOIN EmpresaCFD f ON e.Empresa = f.Empresa
LEFT OUTER JOIN CFDFolio ON CFDFolio.Mov = mt.ConsecutivoMov AND CFDFolio.Modulo = mt.Modulo AND CFDFolio.Empresa = e.Empresa
AND dbo.fnFolioConsecutivo(c.MovID) BETWEEN CFDFolio.FolioD AND CFDFolio.FolioA
AND ISNULL(dbo.fnSerieConsecutivo(c.MovID),'') = ISNULL(CFDFolio.Serie,'')
LEFT OUTER JOIN CFD ON CFD.ModuloID = c.ID AND CFD.Modulo = 'CXC'

