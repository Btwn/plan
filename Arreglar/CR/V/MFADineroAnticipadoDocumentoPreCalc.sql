SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFADineroAnticipadoDocumentoPreCalc AS
SELECT
Estatus                = c.Estatus,
origen_tipo            = 'auto',
origen_modulo          = 'DIN',
origen_id              = RTRIM(LTRIM(CONVERT(varchar,c.ID))),
empresa                = c.Empresa,
emisor                 = 'empresa',
tipo_documento         = 'anticipo',
subtipo_documento      = CONVERT(varchar(50),NULL),
folio                  = RTRIM(ISNULL(c.Mov,'')) + ' ' + RTRIM(ISNULL(c.MovID,'')),
ejercicio              = c.Ejercicio,
periodo                = c.Periodo,
dia                    = DAY(c.FechaEmision),
fecha					 = c.FechaEmision,
entidad_clave          = cl.Cliente,
entidad_nombre         = cl.Nombre,
entidad_rfc            = cl.RFC,
entidad_id_fiscal      = cl.RFC,
entidad_tipo_tercero   = CASE
WHEN ISNULL(fr.Extranjero,0) = 0 THEN 'nacional'
WHEN ISNULL(fr.Extranjero,0) = 1 THEN 'extranjero'
END,
entidad_tipo_operacion = cl.MFATipoOperacion,
entidad_pais           = mp.Pais,
entidad_nacionalidad   = mp.Nacionalidad,
agente_clave           = NULL,
agente_nombre          = NULL,
concepto               = ISNULL(c.Concepto,c.Mov),
acumulable_deducible   = 'Si',
importe                = ROUND((c.Importe/(1.0+((ISNULL(CONVERT(float,emfa.DINImpuesto1),0.0))/100.0)))*c.TipoCambio, 2),
retencion_isr          = 0.0,
retencion_iva          = c.Retencion*c.TipoCambio,
base_iva               = ROUND((c.Importe/(1.0+((ISNULL(CONVERT(float,emfa.DINImpuesto1),0.0))/100.0)))*c.TipoCambio, 2),
iva_excento            = 0,
iva_tasa               = emfa.DINImpuesto1,
iva                    = ROUND((c.Importe-(c.Importe/(1.0+((ISNULL(CONVERT(float,emfa.DINImpuesto1),0.0))/100.0)))*c.TipoCambio), 2),
base_ieps              = ROUND((c.Importe/(1.0+((ISNULL(CONVERT(float,emfa.DINImpuesto1),0.0))/100.0)))*c.TipoCambio, 2),
ieps_tasa               = ROUND(((CONVERT(float,c.Importe)/NULLIF((1.0-CONVERT(float,ISNULL(c.IEPSFiscal,0.0))),0.0))*CONVERT(float,ISNULL(c.IEPSFiscal,0.0)))/NULLIF(CONVERT(float,c.Importe),0.0),2)*100.0,
ieps                   = (ISNULL(CONVERT(float,c.Importe),0.0)/NULLIF((1.0-ISNULL(CONVERT(float,c.IEPSFiscal),0.0)),0.0))*ISNULL(CONVERT(float,c.IEPSFiscal),0.0)*c.TipoCambio,
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
concepto_clave           = c.Concepto,
concepto_es_importacion  = 0,
dinero                   = c.Mov,
dinero_id                = c.MovID,
concepto_aplica_ietu     = 'Si',
concepto_aplica_ieps     = 'Si',
concepto_aplica_iva      = 'Si',
EsActivoFijo			   = 0,
TipoActivo			   = NULL,
TipoActividad			   = MFATipoActividad.Tipo
FROM Dinero c
JOIN MovTipo mt ON mt.Mov = c.Mov AND mt.Modulo = 'DIN'
JOIN EmpresaMFA emfa ON c.Empresa = emfa.Empresa
JOIN Cte cl ON cl.Cliente = emfa.DINCteDepositosAnticipados
LEFT OUTER JOIN FiscalRegimen fr ON fr.FiscalRegimen = cl.FiscalRegimen
LEFT OUTER JOIN Pais pa ON pa.Clave = cl.Pais
LEFT OUTER JOIN MFAPais mp ON mp.Pais = pa.Pais
JOIN EmpresaGral eg ON eg.Empresa = c.Empresa
LEFT OUTER JOIN Concepto co ON co.Concepto = c.Concepto AND co.Modulo = 'DIN'
JOIN Version ver ON 1 = 1
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'DIN' AND mme.ModuloID = c.ID
LEFT OUTER JOIN MovTipoMFADocExcepcion mtmde ON mtmde.Modulo = 'DIN' AND mtmde.Mov = c.Mov
LEFT OUTER JOIN MovTipoMFADocAdicion mtmda ON mtmda.Modulo = 'DIN' AND mtmda.Mov = c.Mov
LEFT OUTER JOIN MFATipoActividad ON MFATipoActividad.Modulo = 'DIN' AND MFATipoActividad.Mov = c.Mov
WHERE c.Estatus IN ('PENDIENTE','CONCLUIDO', 'CONCILIADO')
AND (mt.Clave IN ('DIN.DA') OR mtmda.Modulo IS NOT NULL)
AND ((NULLIF(c.Origen,'') IS NULL AND NULLIF(c.OrigenTipo,'') IS NULL AND NULLIF(c.OrigenID,'') IS NULL) OR (c.OrigenTipo = 'DIN'))
AND mtmde.Mov IS NULL
AND mme.ModuloID IS NULL

