SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFACxpDocumentoPreCalc4 AS
SELECT
Estatus                = c.Estatus,
origen_tipo            = 'auto',
origen_modulo          = 'CXP',
origen_id              = RTRIM(LTRIM(CONVERT(varchar,c.ID))),
empresa                = c.Empresa,
emisor                 = 'terceros',
tipo_documento         = CASE
WHEN mt.Clave IN ('CXP.AF','CXP.A') THEN 'anticipo'
WHEN mt.Clave IN ('CXP.CA','CXP.F','CXP.NC','CXP.CD','CXP.D') THEN 'factura'
WHEN mt.Clave IN ('CXP.CA') THEN 'nota_credito'
ELSE mtmda.DocumentoTipo
END,
subtipo_documento      = CONVERT(varchar(50),NULL),
folio                  = RTRIM(ISNULL(c.Mov,'')) + ' ' + RTRIM(ISNULL(c.MovID,'')),
ejercicio              = c.Ejercicio,
periodo                = c.Periodo,
dia                    = DAY(c.FechaEmision),
fecha					 = c.FechaEmision,
entidad_clave          = c.Proveedor,
entidad_nombre         = pr.Nombre,
entidad_rfc            = pr.RFC,
entidad_id_fiscal      = pr.RFC,
entidad_tipo_tercero   = CASE
WHEN ISNULL(fr.Extranjero,0) = 0 THEN 'nacional'
WHEN ISNULL(fr.Extranjero,0) = 1 THEN 'extranjero'
END,
entidad_tipo_operacion = pr.MFATipoOperacion,
entidad_pais           = mp.Pais,
entidad_nacionalidad   = mp.Nacionalidad,
agente_clave           = pr.Agente,
agente_nombre          = ag.Nombre,
concepto               = ISNULL(c.Concepto,c.Mov),
acumulable_deducible   = 'Si',
importe                = ROUND((cd2.Importe+ISNULL(c2.Retencion2, 0)+ISNULL(c2.Retencion, 0)-(c3.Impuestos*dbo.fnCxpDocumentoPreCalc2Prorrateo(c3.Importe, c3.Impuestos, c3.Retencion, cd2.Importe)))*c2.TipoCambio, 2),
retencion_isr          = c2.Retencion2*c2.TipoCambio,
retencion_iva          = c2.Retencion*c2.TipoCambio,
base_iva               = ROUND((cd2.Importe+ISNULL(c2.Retencion2, 0)+ISNULL(c2.Retencion, 0)-(c3.Impuestos*dbo.fnCxpDocumentoPreCalc2Prorrateo(c3.Importe, c3.Impuestos, c3.Retencion, cd2.Importe)))*c2.TipoCambio, 2),
iva_excento            = 0,
iva_tasa               = dbo.fnMFAIVATasa(c3.Empresa, c3.Importe,c3.Impuestos),
iva                    = ROUND((c3.Impuestos*dbo.fnCxpDocumentoPreCalc2Prorrateo(c3.Importe, c3.Impuestos, c3.Retencion, cd2.Importe))*c2.TipoCambio, 2),
base_ieps              = ROUND((cd2.Importe+ISNULL(c2.Retencion2, 0)+ISNULL(c2.Retencion, 0)-(c3.Impuestos*dbo.fnCxpDocumentoPreCalc2Prorrateo(c3.Importe, c3.Impuestos, c3.Retencion, cd2.Importe)))*c2.TipoCambio, 2),
ieps_tasa              = ROUND(((CONVERT(float,cd2.Importe)/NULLIF((1.0-CONVERT(float,ISNULL(c3.IEPSFiscal,0.0))),0.0))*CONVERT(float,ISNULL(c3.IEPSFiscal,0.0)))/NULLIF(CONVERT(float,cd2.Importe),0.0),2)*100.0,
ieps                   = (dbo.fnCxpDocumentoPreCalc2Prorrateo(c3.Importe, c3.Impuestos, c3.Retencion, cd2.Importe)*(ISNULL(CONVERT(float,c2.Importe),0.0)/NULLIF((1.0-ISNULL(CONVERT(float,c2.IEPSFiscal),0.0)),0.0))*ISNULL(CONVERT(float,c2.IEPSFiscal),0.0))*c2.TipoCambio,
base_isan              = 0.0,
isan                   = 0.0,
/*
importe                = (c.Importe+(dbo.fnMFARetencionIVAFiscal(c2.Importe,c2.Impuestos,c2.Retencion2)*c.Importe)-(ISNULL(c.IVAFiscal, 0)*c.Importe))*c.TipoCambio,
retencion_isr          = 0.0,
retencion_iva          = dbo.fnMFARetencionIVAFiscal(c2.Importe,c2.Impuestos,c2.Retencion2)*cd.Importe*c.TipoCambio,
base_iva               = (c.Importe+(dbo.fnMFARetencionIVAFiscal(c2.Importe,c2.Impuestos,c2.Retencion2)*c.Importe)-(ISNULL(c.IVAFiscal, 0)*c.Importe))*c.TipoCambio,
iva_excento            = 0,
iva_tasa               = dbo.fnMFAIVATasa((c.Importe+(dbo.fnMFARetencionIVAFiscal(c2.Importe,c2.Impuestos,c2.Retencion2)*c.Importe)-(ISNULL(c.IVAFiscal, 0)*c.Importe)),(c.Importe*ISNULL(c.IVAFiscal, 0))),
iva                    = dbo.fnMFAIVA((c.Importe+(dbo.fnMFARetencionIVAFiscal(c2.Importe,c2.Impuestos,c2.Retencion2)*c.Importe)-(ISNULL(c.IVAFiscal, 0)*c.Importe)),c.Importe*ISNULL(c.IVAFiscal, 0))*c.TipoCambio,
base_ieps              = (c.Importe+(dbo.fnMFARetencionIVAFiscal(c2.Importe,c2.Impuestos,c2.Retencion2)*c.Importe)-(ISNULL(c.IVAFiscal, 0)*c.Importe))*c.TipoCambio,
ieps_tasa               = 0.0,
ieps                   = 0.0,
base_isan              = 0.0,
isan                   = 0.0,
*/
ieps_num_reporte         = CONVERT(varchar(20),NULL),
ieps_categoria_concepto  = CONVERT(varchar(20),NULL),
ieps_exento              = 0,
ieps_envase_reutilizable = 0,
ieps_retencion           = NULL,
ieps_cantidad            = 0.0,
ieps_unidad              = CONVERT(varchar(50),NULL),
ieps_cantidad2           = 0.0,
ieps_unidad2             = CONVERT(varchar(50),NULL),
concepto_clave           = c.Concepto,
concepto_es_importacion  = 0,
dinero                   = c.Dinero,
dinero_id                = c.DineroID,
concepto_aplica_ietu     = 'Si',
concepto_aplica_ieps     = 'Si',
concepto_aplica_iva      = 'Si',
EsActivoFijo			   = 0,
TipoActivo			   = NULL,
TipoActividad			   = MFATipoActividad.Tipo
FROM Cxp c
JOIN MovTipo mt ON mt.Mov = c.Mov AND mt.Modulo = 'CXP'
JOIN Prov pr ON pr.Proveedor = c.Proveedor
LEFT OUTER JOIN FiscalRegimen fr ON fr.FiscalRegimen = pr.FiscalRegimen
LEFT OUTER JOIN Pais pa ON pa.Clave = pr.Pais
LEFT OUTER JOIN MFAPais mp ON mp.Pais = pa.Pais
LEFT OUTER JOIN Agente ag ON ag.Agente = pr.Agente
JOIN EmpresaGral eg ON eg.Empresa = c.Empresa
LEFT OUTER JOIN Concepto co ON co.Concepto = c.Concepto AND co.Modulo = 'CXP'
JOIN Version ver ON 1 = 1
JOIN CxpD cd  ON cd.ID = c.ID
JOIN Cxp c2   ON c2.MovID = cd.AplicaID AND cd.Aplica = c2.Mov AND c2.Empresa = c.Empresa
JOIN CxpD cd2 ON c2.ID = cd2.ID
JOIN Cxp c3 ON cd2.AplicaID = c3.MovID AND cd2.Aplica = c3.Mov AND c2.Empresa = c3.Empresa
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'CXP' AND mme.ModuloID = c.ID
LEFT OUTER JOIN MovTipoMFADocExcepcion mtmde ON mtmde.Modulo = 'CXP' AND mtmde.Mov = c.Mov
LEFT OUTER JOIN MovTipoMFADocAdicion mtmda ON mtmda.Modulo = 'CXP' AND mtmda.Mov = c.Mov
LEFT OUTER JOIN MFATipoActividad ON MFATipoActividad.Modulo = 'CXP' AND MFATipoActividad.Mov = c.Mov
WHERE c.Estatus IN ('PENDIENTE','CONCLUIDO')
AND (mt.Clave IN ('CXP.FAC', 'CXP.AF','CXP.CA','CXP.F','CXP.NC','CXP.CA','CXP.A','CXP.CD','CXP.D') OR mtmda.Modulo IS NOT NULL)
AND ((NULLIF(c.Origen,'') IS NULL AND NULLIF(c.OrigenTipo,'') IS NULL AND NULLIF(c.OrigenID,'') IS NULL) OR (c.OrigenTipo = 'CXP'))
AND mtmde.Mov IS NULL
AND mme.ModuloID IS NULL

