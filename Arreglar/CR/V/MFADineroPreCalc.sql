SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFADineroPreCalc AS
SELECT
origen_tipo            = 'auto',
origen_modulo          = 'DIN',
origen_id              = RTRIM(LTRIM(CONVERT(varchar,d.ID))),
empresa                = d.Empresa,
tipo_aplicacion        = ISNULL(NULLIF(mtmac.TipoAplicacion,''), 'pago'),
folio                  = RTRIM(ISNULL(d.Mov,'')) + ' ' + RTRIM(ISNULL(d.MovID,'')),
ejercicio              = d.Ejercicio,
periodo                = d.Periodo,
dia                    = DAY(d.FechaEmision),
fecha					 = d.FechaEmision,
Referencia             = RTRIM(ISNULL(d.Mov,'')) + ' ' + RTRIM(ISNULL(d.MovID,'')),
importe                = d.Importe*d.TipoCambio,
retencion_isr          = 0.0,
retencion_iva          = d.Retencion*d.TipoCambio,
base_iva               = (ISNULL(CONVERT(float,d.Importe),0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ((CONVERT(float,d.Importe)/NULLIF((1.0-ISNULL(CONVERT(float,d.IEPSFiscal),0.0)),0.0))*ISNULL(CONVERT(float,d.IEPSFiscal),0.0)) ELSE 0.0 END)*d.TipoCambio,
iva_excento            = 0,
iva_tasa               = dbo.fnMFAIVATasa(d.Empresa, d.Importe,d.Impuestos),
iva                    = dbo.fnMFAIVA(d.Empresa,d.Importe,d.Impuestos)*d.TipoCambio,
base_ieps              = ISNULL(d.Importe,0.0)*d.TipoCambio,
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
tipo_documento		 = mtmaa.tipo_documento
FROM Dinero d
JOIN MovTipo mt ON mt.Mov = d.Mov AND mt.Modulo = 'DIN'
JOIN Version ver ON 1 = 1
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'DIN' AND mme.ModuloID = d.ID
LEFT OUTER JOIN MovTipoMFAAplicaAdicion mtmaa ON mtmaa.Modulo = 'DIN' AND mtmaa.Mov = d.Mov AND ISNULL(NULLIF(mtmaa.OrigenTipo,''),ISNULL(d.OrigenTipo, '')) = ISNULL(d.OrigenTipo,'') AND ISNULL(NULLIF(mtmaa.Origen,''),ISNULL(d.Origen, '')) = ISNULL(d.Origen,'')
LEFT OUTER JOIN MovTipoMFAAplicaExcepcion mtmae ON mtmae.Modulo = 'DIN' AND mtmae.Mov = d.Mov AND ISNULL(NULLIF(mtmae.OrigenTipo,''),ISNULL(d.OrigenTipo,'')) = ISNULL(d.OrigenTipo,'') AND ISNULL(NULLIF(mtmae.Origen,''),ISNULL(d.Origen,'')) = ISNULL(d.Origen,'')
LEFT OUTER JOIN MovTipoMFAAplicacionCambio mtmac ON mtmac.Modulo = 'DIN' AND mtmac.Mov = d.Mov AND ISNULL(NULLIF(mtmac.OrigenTipo,''),ISNULL(d.OrigenTipo,'')) = ISNULL(d.OrigenTipo,'') AND ISNULL(NULLIF(mtmac.Origen,''),ISNULL(d.Origen,'')) = ISNULL(d.Origen,'')
WHERE d.Estatus IN ('PENDIENTE','CONCLUIDO', 'CONCILIADO')
AND (mt.Clave IN ('DIN.A', 'DIN.AB', 'DIN.ACXC', 'DIN.ACXP', 'DIN.AP', 'DIN.C', 'DIN.CB', 'DIN.CD', 'DIN.CH', 'DIN.CHE', 'DIN.CNI', 'DIN.CP', 'DIN.D', 'DIN.DA', 'DIN.DE', 'DIN.DF', 'DIN.E', 'DIN.F', 'DIN.I', 'DIN.INV', 'DIN.PR', 'DIN.RE', 'DIN.REI', 'DIN.RET', 'DIN.RND', 'DIN.SCH', 'DIN.SD', 'DIN.T', 'DIN.TC') OR mtmaa.Modulo IS NOT NULL)
AND d.Importe IS NOT NULL
AND mme.ModuloID IS NULL
AND mtmae.Mov IS NULL

