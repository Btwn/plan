SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDCxc AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,c.ID))))) + RTRIM(LTRIM(CONVERT(varchar,c.ID))) +
REPLICATE(' ',12) +
REPLICATE(' ',7) +
REPLICATE(' ',50)
OrdenExportacion,
'ID' = c.ID,
'EmpresaRFC'			= e.RFC,
'EmpresaNombre'			= e.Nombre,
'EmpresaCalle'			= e.Direccion,
'EmpresaNumeroExterior' = e.DireccionNumero,
'EmpresaNumeroInterior' = e.DireccionNumeroInt,
'EmpresaColonia'		= e.Colonia,
'EmpresaLocalidad'		= e.Poblacion,
'EmpresaMunicipio'		= e.Delegacion,
'EmpresaEstado'			= e.Estado,
'EmpresaPais'			= e.Pais,
'EmpresaCodigoPostal'	= e.CodigoPostal,
'SucursalGLN'            = s.GLN,
'SucursalNombre'         = s.Nombre,
'SucursalRFC'            = s.RFC,
'SucursalCalle'          = s.Direccion,
'SucursalNumeroExterior' = s.DireccionNumero,
'SucursalNumeroInterior' = s.DireccionNumeroInt,
'SucursalColonia'        = s.Colonia,
'SucursalLocalidad'      = s.Delegacion + ' ' + s.Estado,
'SucursalMunicipio'      = s.Delegacion,
'SucursalEstado'         = s.Estado,
'SucursalPais'           = s.Pais,
'SucursalCodigoPostal'   = s.CodigoPostal,
'CxcFechaRegistro'		= c.FechaRegistro,
'CxcSerie'				= dbo.fnSerieConsecutivo(C.MovID),
'CxcFolio'				= dbo.fnFolioConsecutivo(C.MovID),
'CxcCondicion'			= c.Condicion,
'CxcSubTotal'			= (SELECT sum(SubTotal) FROM MovImpuesto WHERE Modulo = 'CXC' AND ModuloID=c.ID)*dbo.fnCFDTipoCambioMN(C.TipoCambio, ISNULL(mt.SAT_MN, f.SAT_MN)),
'CxcTipoComprobante'	= mt.CFD_tipoDeComprobante,
'CxcTotal'				= (SELECT sum(SubTotal) FROM MovImpuesto WHERE Modulo = 'CXC' AND ModuloID=c.ID)+(isnull((SELECT Importe FROM CFDCXCMovImpuesto WHERE ID = c.ID),0) -(SELECT ISNULL(SUM(ISNULL(Importe,0.0)),0.0) FROM CFDCXCMovRetencion WHERE ID = c.ID))*dbo.fnCFDTipoCambioMN(C.TipoCambio, ISNULL(mt.SAT_MN, f.SAT_MN)),
'ClienteRFC'			= Cte.RFC,
'ClienteNombre'			= Cte.Nombre,
'ClienteCalle'			= Cte.Direccion,
'ClienteNumeroExterior' = Cte.DireccionNumero,
'ClienteNumeroInterior' = Cte.DireccionNumeroInt,
'ClienteColonia'		= Cte.Colonia,
'ClienteLocalidad'		= Cte.Poblacion,
'ClienteMunicipio'		= Cte.Delegacion,
'ClienteEstado'			= Cte.Estado,
'ClientePais'			= Cte.Pais,
'ClienteCodigoPostal'	= Cte.CodigoPostal,
'CFDanoAprobacion'		= YEAR(CFDFolio.FechaAprobacion),
'CFDnoAprobacion'		= CFDFolio.noAprobacion,
'CxcDCantidad'			= '1',
'CxcDUnidad'			= C.Concepto,
'CxcDArticulo'			= C.Concepto,
'CxcDDescripcion'		= C.Concepto,
'CxcDPrecio'			= c.Importe*dbo.fnCFDTipoCambioMN(C.TipoCambio, ISNULL(mt.SAT_MN, f.SAT_MN)),
'CxcDPrecioTotal'		= C.Importe*dbo.fnCFDTipoCambioMN(C.TipoCambio, ISNULL(mt.SAT_MN, f.SAT_MN)),
'CxcImporteImpuesto1'	= dbo.fnCFDCxcMovImpuestoExcento(c.ID,((SELECT SUM(Importe1) FROM MovImpuesto WHERE Modulo = 'CXC' AND ModuloID=c.ID))*dbo.fnCFDTipoCambioMN(C.TipoCambio, ISNULL(mt.SAT_MN, f.SAT_MN))) ,
'CxcImporteImpuesto2'	= dbo.fnCFDCxcMovImpuestoExcento(c.ID,((SELECT SUM(Importe2) FROM MovImpuesto WHERE Modulo = 'CXC' AND ModuloID=c.ID))*dbo.fnCFDTipoCambioMN(C.TipoCambio, ISNULL(mt.SAT_MN, f.SAT_MN))) ,
'CxcImporte'			= c.Importe*dbo.fnCFDTipoCambioMN(C.TipoCambio, ISNULL(mt.SAT_MN, f.SAT_MN)) ,
'CxcRetencion'			= dbo.fnCFDCxcMovRetencionExcento(c.ID,(SELECT ISNULL(SUM(ISNULL(Importe,0.0)),0.0) FROM CFDCXCMovRetencion WHERE ID = c.ID)*dbo.fnCFDTipoCambioMN(C.TipoCambio, ISNULL(mt.SAT_MN, f.SAT_MN))),
'CXCVencimiento'		= c.Vencimiento,
'CXCMoneda'				= c.Moneda,
'CXCTipoCambio'			= c.TipoCambio,
'NumCtaPago'			= NULLIF(RIGHT(c.Referencia, 4),'No Aplica'),
CFD.Modulo CFDModulo,
CFD.ModuloID CFDModuloID,
CFD.Fecha CFDFecha,
CFD.Ejercicio CFDEjercicio,
CFD.Periodo CFDPeriodo,
CFD.Empresa CFDEmpresa,
CFD.MovID CFDMovID,
CFD.Serie CFDSerie,
CFD.Folio CFDFolio,
CFD.RFC CFDRFC,
CFD.Aprobacion CFDAprobacion,
CFD.Importe CFDImporte,
CFD.Impuesto1 CFDImpuesto1,
CFD.Impuesto2 CFDImpuesto2,
CFD.FechaCancelacion CFDFechaCancelacion,
CFD.noCertificado CFDnoCertificado,
CFD.Sello CFDSello,
CFD.CadenaOriginal CFDCadenaOriginal,
CFD.CadenaOriginal1 CFDCadenaOriginal1,
CFD.CadenaOriginal2 CFDCadenaOriginal2,
CFD.CadenaOriginal3 CFDCadenaOriginal3,
CFD.CadenaOriginal4 CFDCadenaOriginal4,
CFD.CadenaOriginal5 CFDCadenaOriginal5,
CFD.GenerarPDF CFDGenerarPDF,
CFD.Retencion1 CFDRetencion1,
CFD.Retencion2 CFDRetencion2,
CFD.TipoCambio CFDTipoCambio,
CFD.Timbrado CFDTimbrado,
CFD.UUID CFDUUID,
CFD.FechaTimbrado CFDFechaTimbrado,
CFD.SelloSAT CFDSelloSAT,
CFD.TFDVersion CFDTFDVersion,
CFD.noCertificadoSAT CFDnoCertificadoSAT
FROM Cxc c
JOIN MovTipo mt ON mt.Modulo = 'CXC' AND mt.Mov = c.Mov
JOIN Empresa e ON c.Empresa = e.Empresa
JOIN Sucursal s ON c.Sucursal = s.Sucursal
JOIN Cte Cte ON Cte.Cliente = c.Cliente
LEFT OUTER JOIN EmpresaCFD f ON e.Empresa = f.Empresa
LEFT OUTER JOIN CFDFolio ON CFDFolio.Mov = mt.ConsecutivoMov AND CFDFolio.Modulo = mt.Modulo AND CFDFolio.Empresa = e.Empresa
AND dbo.fnFolioConsecutivo(c.MovID) BETWEEN CFDFolio.FolioD AND CFDFolio.FolioA
AND ISNULL(dbo.fnSerieConsecutivo(c.MovID),'') = ISNULL(CFDFolio.Serie,'')
LEFT OUTER JOIN CFD ON CFD.ModuloID = c.ID AND CFD.Modulo = 'CXC'

