SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFADineroAnticipadoCobroPreCalc AS
SELECT
origen_tipo            = 'auto',
origen_modulo          = 'DIN',
origen_id              = RTRIM(LTRIM(CONVERT(varchar,d.ID))),
empresa                = d.Empresa,
tipo_aplicacion        = ISNULL(NULLIF(mtmac.TipoAplicacion,''), 'cobro'),
folio                  = RTRIM(ISNULL(d.Mov,'')) + ' ' + RTRIM(ISNULL(d.MovID,'')),
ejercicio              = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN d.Ejercicio ELSE YEAR(d.FechaConciliacion) END,
periodo                = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN d.Periodo ELSE MONTH(d.FechaConciliacion) END,
dia                    = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN DAY(d.FechaEmision) ELSE DAY(d.FechaConciliacion) END,
fecha					 = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN d.FechaEmision ELSE d.FechaConciliacion END,
Referencia             = RTRIM(ISNULL(d.Mov,'')) + ' ' + RTRIM(ISNULL(d.MovID,'')),
importe                = ROUND((d.Importe/(1.0+((ISNULL(CONVERT(float,emfa.DINImpuesto1),0.0))/100.0)))*d.TipoCambio, 2),
retencion_isr          = 0.0,
retencion_iva          = d.Retencion*d.TipoCambio,
base_iva               = ROUND((d.Importe/(1.0+((ISNULL(CONVERT(float,emfa.DINImpuesto1),0.0))/100.0)))*d.TipoCambio, 2),
iva_excento            = 0,
iva_tasa               = emfa.DINImpuesto1,
iva                    = ROUND((d.Importe-(d.Importe/(1.0+((ISNULL(CONVERT(float,emfa.DINImpuesto1),0.0))/100.0)))*d.TipoCambio), 2),
base_ieps              = ROUND((d.Importe/(1.0+((ISNULL(CONVERT(float,emfa.DINImpuesto1),0.0))/100.0)))*d.TipoCambio, 2),
ieps_tasa               = ROUND(((CONVERT(float,d.Importe)/NULLIF((1.0-CONVERT(float,ISNULL(d.IEPSFiscal,0.0))),0.0))*CONVERT(float,ISNULL(d.IEPSFiscal,0.0)))/NULLIF(CONVERT(float,d.Importe),0.0),2)*100.0,
ieps                   = (ISNULL(CONVERT(float,d.Importe),0.0)/NULLIF((1.0-ISNULL(CONVERT(float,d.IEPSFiscal),0.0)),0.0))*ISNULL(CONVERT(float,d.IEPSFiscal),0.0)*d.TipoCambio,
base_isan              = 0.0,
isan                   = 0.0,
cuenta_bancaria        = d.CtaDinero,
aplica_ietu            = 'Si',
aplica_ieps            = 'Si',
aplica_iva             = 'Si',
conciliado			 = ISNULL(d.Conciliado, 0),
dinero				 = d.Mov,
dinero_id				 = d.MovID,
tipo_documento = mtmaa.tipo_documento
FROM Dinero d
JOIN MovTipo mt ON mt.Mov = d.Mov AND mt.Modulo = 'DIN'
JOIN Version ver ON 1 = 1
JOIN EmpresaMFA emfa ON d.Empresa = emfa.Empresa
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'DIN' AND mme.ModuloID = d.ID
LEFT OUTER JOIN MovTipoMFAAplicaAdicion mtmaa ON mtmaa.Modulo = 'DIN' AND mtmaa.Mov = d.Mov AND ISNULL(NULLIF(mtmaa.OrigenTipo,''),ISNULL(d.OrigenTipo, '')) = ISNULL(d.OrigenTipo,'') AND ISNULL(NULLIF(mtmaa.Origen,''),ISNULL(d.Origen, '')) = ISNULL(d.Origen,'')
LEFT OUTER JOIN MovTipoMFAAplicaExcepcion mtmae ON mtmae.Modulo = 'DIN' AND mtmae.Mov = d.Mov AND ISNULL(NULLIF(mtmae.OrigenTipo,''),ISNULL(d.OrigenTipo,'')) = ISNULL(d.OrigenTipo,'') AND ISNULL(NULLIF(mtmae.Origen,''),ISNULL(d.Origen,'')) = ISNULL(d.Origen,'')
LEFT OUTER JOIN MovTipoMFAAplicacionCambio mtmac ON mtmac.Modulo = 'DIN' AND mtmac.Mov = d.Mov AND ISNULL(NULLIF(mtmac.OrigenTipo,''),ISNULL(d.OrigenTipo,'')) = ISNULL(d.OrigenTipo,'') AND ISNULL(NULLIF(mtmac.Origen,''),ISNULL(d.Origen,'')) = ISNULL(d.Origen,'')
LEFT OUTER JOIN MovTipoMFADocConciliado mtdc ON mtdc.Modulo = 'DIN' AND mtdc.Mov = d.Mov
WHERE d.Estatus IN ('PENDIENTE','CONCLUIDO', 'CONCILIADO')
AND (mt.Clave IN ('DIN.DA') OR mtmaa.Modulo IS NOT NULL)
AND d.Importe IS NOT NULL
AND mme.ModuloID IS NULL
AND mtmae.Mov IS NULL

