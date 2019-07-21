SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFACompraPreCalc5 AS
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
concepto               = Concepto.Concepto,
acumulable_deducible   = dbo.fmMFAAcumulableDeducibleCOMSEI(Concepto.Concepto, Cxp.Empresa, Cxp.Mov, em.COMSIVAImportacionAnticipado),
importe                = cxp.Importe*cxp.TipoCambio,
retencion_isr          = cxp.Retencion2*cxp.TipoCambio,
retencion_iva          = cxp.Retencion*cxp.TipoCambio,
base_iva               = (ISNULL(CONVERT(float,cxp.Importe),0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ((CONVERT(float,cxp.Importe)/NULLIF((1.0-ISNULL(CONVERT(float,cxp.IEPSFiscal),0.0)),0.0))*ISNULL(CONVERT(float,cxp.IEPSFiscal),0.0)) ELSE 0.0 END)*cxp.TipoCambio,
iva_excento            = 0,
iva_tasa               = dbo.fnMFAIVATasa(cxp.Empresa, cxp.Importe,cxp.Impuestos),
iva                    = dbo.fnMFAIVA(cxp.Empresa,cxp.Importe,cxp.Impuestos)*cxp.TipoCambio,
base_ieps              = ISNULL(cxp.Importe,0.0)*cxp.TipoCambio,
ieps_tasa               = ROUND(((CONVERT(float,cxp.Importe)/NULLIF((1.0-CONVERT(float,ISNULL(cxp.IEPSFiscal,0.0))),0.0))*CONVERT(float,ISNULL(cxp.IEPSFiscal,0.0)))/NULLIF(CONVERT(float,cxp.Importe),0.0),2)*100.0,
ieps                   = (ISNULL(CONVERT(float,cxp.Importe),0.0)/NULLIF((1.0-ISNULL(CONVERT(float,cxp.IEPSFiscal),0.0)),0.0))*ISNULL(CONVERT(float,cxp.IEPSFiscal),0.0)*cxp.TipoCambio,
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
concepto_clave	       = Concepto.Concepto,
concepto_es_importacion  = 0,
dinero				   = cxp.Dinero,
dinero_id				   = cxp.DineroID,
concepto_aplica_ietu     = dbo.fmMFAAcumulableDeducibleCOMSEI(Concepto.Concepto, Cxp.Empresa, Cxp.Mov, em.COMSIVAImportacionAnticipado),
concepto_aplica_ieps     = dbo.fmMFAAcumulableDeducibleCOMSEI(Concepto.Concepto, Cxp.Empresa, Cxp.Mov, em.COMSIVAImportacionAnticipado),
concepto_aplica_iva      = dbo.fmMFAAcumulableDeducibleCOMSEI(Concepto.Concepto, Cxp.Empresa, Cxp.Mov, em.COMSIVAImportacionAnticipado),
EsActivoFijo			   = 0,
TipoActivo			   = NULL,
TipoActividad			   = MFATipoActividad.Tipo,
0 'BaseIVAImportacion'
FROM Cxp cxp
JOIN Gasto g   ON g.MovID = cxp.OrigenID AND g.Mov = cxp.Origen AND cxp.OrigenTipo = 'GAS' AND g.Empresa = cxp.Empresa
JOIN GastoD gd ON g.ID = gd.ID
JOIN Compra c ON c.MovID = g.OrigenID AND c.Mov = g.Origen AND g.OrigenTipo = 'COMS' AND g.Empresa = c.Empresa
JOIN MovTipo mt ON mt.Mov = c.Mov AND mt.Modulo = 'COMS'
JOIN Prov p ON p.Proveedor = cxp.Proveedor
LEFT OUTER JOIN Concepto ON Concepto.Concepto = gd.Concepto AND Concepto.Modulo = 'COMSG'
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
AND cxp.Mov = EmpresaCfgMov.Gasto
AND (mt.Clave IN ('COMS.EI') OR (mtmda.Modulo IS NOT NULL))
AND mtmde.Mov IS NULL
AND cxp.OrigenTipo = 'GAS'
AND mme.ModuloID IS NULL
AND 1 = CASE ISNULL(em.COMSIVAImportacionAnticipado, 0)
WHEN 0 THEN 1
ELSE CASE ISNULL(Concepto.EsIVAImportacion, 0)
WHEN 0 THEN 1
ELSE 0
END
END

