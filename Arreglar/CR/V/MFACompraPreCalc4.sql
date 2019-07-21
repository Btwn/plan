SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFACompraPreCalc4 AS
SELECT
ID					 = cxp.ID,
Estatus                = cxp.Estatus,
origen_tipo            = 'auto',
origen_modulo          = 'CXP',
origen_id              = RTRIM(LTRIM(CONVERT(varchar,cxp.ID))),
empresa                = cxp.Empresa,
emisor                 = 'terceros',
tipo_documento         = CASE
WHEN mt.Clave IN ('COMS.EI') THEN 'factura'
ELSE mtmda.DocumentoTipo
END,
subtipo_documento      = CASE
WHEN mt.Clave IN ('COMS.F','COMS.FL','COMS.EG', 'COMS.EI','COMS.CA','COMS.GX') THEN
(CASE WHEN ISNULL(fr.Extranjero,0) = 0 THEN 'adquisicion' ELSE 'importacion' END)
WHEN mt.Clave IN ('COMS.B') THEN
(CASE WHEN ISNULL(fr.Extranjero,0) = 0 THEN 'adquisicion' ELSE 'importacion' END)
WHEN mt.Clave IN ('COMS.D') THEN
(CASE WHEN ISNULL(fr.Extranjero,0) = 0 THEN 'adquisicion' ELSE 'importacion' END)
ELSE ''
END,
folio                  = RTRIM(ISNULL(cxp.Mov,'')) + ' ' + RTRIM(ISNULL(cxp.MovID,'')),
ejercicio              = cxp.Ejercicio,
periodo                = cxp.Periodo,
dia                    = DAY(cxp.FechaEmision),
fecha					 = cxp.FechaEmision,
entidad_clave          = cxp.Proveedor,
entidad_nombre         = p.Nombre,
entidad_rfc            = p.RFC,
entidad_id_fiscal      = p.RFC,
entidad_tipo_tercero   = CASE
WHEN ISNULL(fr.Extranjero,0) = 0 THEN 'nacional'
WHEN ISNULL(fr.Extranjero,0) = 1 THEN 'extranjero'
END,
entidad_tipo_operacion = p.MFATipoOperacion,
entidad_pais           = mp.Pais,
entidad_nacionalidad   = mp.Nacionalidad,
agente_clave           = p.Agente,
agente_nombre          = ag.Nombre,
concepto               = ISNULL(cxp.Concepto,cxp.Mov),
acumulable_deducible   = dbo.fmMFAAcumulableDeducibleCOMSEI(Concepto.Concepto, Cxp.Empresa, Cxp.Mov, em.COMSIVAImportacionAnticipado),
importe                = SUM(((ISNULL(ctc.SubTotal,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(ctc.Impuesto2Total,0.0) ELSE 0.0 END)*c.TipoCambio) + dbo.fnMFABaseIVAImportacion(c.Mov, c.MovID, ctc.ImporteMov, ctc.ImporteTotal, c.Empresa, em.COMSCalcularBaseImportacion)),
retencion_isr          = SUM(ctc.Retencion2Total*c.TipoCambio),
retencion_iva          = SUM(ctc.Retencion1Total*c.TipoCambio),
base_iva               = SUM(((ISNULL(ctc.SubTotal,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(ctc.Impuesto2Total,0.0) ELSE 0.0 END)*c.TipoCambio) + dbo.fnMFABaseIVAImportacion(c.Mov, c.MovID, ctc.ImporteMov, ctc.ImporteTotal, c.Empresa, em.COMSCalcularBaseImportacion)),
iva_excento            = ISNULL(a.Impuesto1Excento,0),
iva_tasa               = dbo.fnMFAIVATasa(cxp.Empresa, cxp.Importe,cxp.Impuestos),
iva                    = 2*dbo.fnMFAIVA(cxp.Empresa,cxp.Importe,cxp.Impuestos)*cxp.TipoCambio,
base_ieps              = SUM(((ISNULL(ctc.SubTotal,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(ctc.Impuesto2Total,0.0) ELSE 0.0 END)*c.TipoCambio) + dbo.fnMFABaseIVAImportacion(c.Mov, c.MovID, ctc.ImporteMov, ctc.ImporteTotal, c.Empresa, em.COMSCalcularBaseImportacion)),
ieps_tasa              = CASE ma.Impuesto WHEN 'Impuesto 2' THEN ISNULL(cd.Impuesto2, 0) ELSE 0 END,
ieps                   = SUM(CASE ma.Impuesto WHEN 'Impuesto 2' THEN ISNULL(ctc.Impuesto2Total, 0)*c.TipoCambio ELSE ISNULL(ctc.Impuesto3Total, 0)*c.TipoCambio END),
base_isan              = 0.0,
isan                   = 0.0,
ieps_num_reporte         = CONVERT(varchar(20),NULL),
ieps_categoria_concepto  = CONVERT(varchar(20),NULL),
ieps_exento              = 0,
ieps_envase_reutilizable = 0,
ieps_retencion           = NULL,
ieps_cantidad            = 0.0,
ieps_unidad              = CONVERT(varchar(50),NULL),
ieps_cantidad2           = 0.0,
ieps_unidad2             = CONVERT(varchar(50),NULL),
concepto_clave	       = cxp.Concepto,
concepto_es_importacion  = 0,
dinero				   = cxp.Dinero,
dinero_id				   = cxp.DineroID,
concepto_aplica_ietu     = 'Si',
concepto_aplica_ieps     = 'Si',
concepto_aplica_iva      = 'Si',
EsActivoFijo			   = 0,
TipoActivo			   = NULL,
TipoActividad			   = MFATipoActividad.Tipo,
BaseIVAImportacion	   = -1
FROM Cxp cxp
JOIN Compra c ON c.MovID = cxp.OrigenID AND c.Mov = cxp.Origen AND cxp.OrigenTipo = 'COMS' AND c.Empresa = cxp.Empresa
JOIN MovTipo mt ON mt.Mov = c.Mov AND mt.Modulo = 'COMS'
JOIN Prov p ON p.Proveedor = c.Proveedor
JOIN CompraD cd ON cd.ID = c.ID
JOIN MFACompraTCalc ctc ON ctc.RenglonSub = cd.RenglonSub AND ctc.Renglon = cd.Renglon AND ctc.ID = cd.ID
JOIN Art a ON a.Articulo = cd.Articulo
LEFT OUTER JOIN MFAArt ma ON ma.Articulo = a.Articulo
LEFT OUTER JOIN Concepto ON Concepto.Concepto = Cxp.Concepto AND Concepto.Modulo = 'COMSG'
LEFT OUTER JOIN FiscalRegimen fr ON fr.FiscalRegimen = p.FiscalRegimen
LEFT OUTER JOIN Pais pa ON pa.Clave = p.Pais
LEFT OUTER JOIN MFAPais mp ON mp.Pais = pa.Pais
LEFT OUTER JOIN Agente ag ON ag.Agente = c.Agente
JOIN EmpresaGral eg ON eg.Empresa = c.Empresa
JOIN EmpresaMFA em ON em.Empresa = c.Empresa
JOIN EmpresaCfg2 ec ON ec.Empresa = em.Empresa
JOIN EmpresaCfgMov ON EmpresaCfgMov.Empresa = c.Empresa
JOIN Version ver ON 1 = 1
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'COMS' AND mme.ModuloID = c.ID
LEFT OUTER JOIN MovTipoMFADocExcepcion mtmde ON mtmde.Modulo = 'COMS' AND mtmde.Mov = c.Mov
LEFT OUTER JOIN MovTipoMFADocAdicion mtmda ON mtmda.Modulo = 'COMS' AND mtmda.Mov = c.Mov
LEFT OUTER JOIN MFATipoActividad ON MFATipoActividad.Modulo = 'COMS' AND MFATipoActividad.Mov = c.Mov
WHERE c.Estatus IN ('CONCLUIDO','PENDIENTE')
AND cxp.Estatus IN ('CONCLUIDO','PENDIENTE')
AND cxp.Mov = EmpresaCfgMov.CxpGastoDiverso
AND (mt.Clave IN ('COMS.EI') OR (mtmda.Modulo IS NOT NULL))
AND mtmde.Mov IS NULL
AND cxp.OrigenTipo = 'COMS'
AND mme.ModuloID IS NULL
AND ISNULL(Concepto.EsIVAImportacion, 0) = 1
AND ISNULL(em.COMSIVAImportacionAnticipado, 0) = 1
GROUP BY cxp.ID, cxp.Estatus, mt.Clave, mtmda.DocumentoTipo, fr.Extranjero, cxp.Mov, cxp.MovID, cxp.Ejercicio, cxp.Periodo, cxp.FechaEmision, cxp.Proveedor,
p.Nombre, p.RFC,p.MFATipoOperacion, mp.Pais, mp.Nacionalidad, p.Agente, ag.Nombre, cxp.Concepto, Concepto.Concepto, Cxp.Empresa, em.COMSIVAImportacionAnticipado, a.Impuesto1Excento,
Cxp.Importe, Cxp.Impuestos, Cxp.TipoCambio, cd.Impuesto2, cxp.Dinero, cxp.DineroID, MFATipoActividad.Tipo, ma.Impuesto,
c.Mov, c.MovID, c.Empresa, em.COMSCalcularBaseImportacion

