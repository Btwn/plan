SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFACxpDineroPreCalc2 AS
SELECT
origen_tipo            = 'auto',
origen_modulo          = 'CXP',
origen_id              = RTRIM(LTRIM(CONVERT(varchar,d.ID))),
empresa                = c.Empresa,
tipo_aplicacion        = ISNULL(NULLIF(mtmac.TipoAplicacion,''), 'pago'),
folio                  = RTRIM(ISNULL(d.Mov,'')) + ' ' + RTRIM(ISNULL(d.MovID,'')),
ejercicio              = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN d.Ejercicio ELSE YEAR(d.FechaConciliacion) END,
periodo                = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN d.Periodo ELSE MONTH(d.FechaConciliacion) END,
dia                    = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN DAY(d.FechaEmision) ELSE DAY(d.FechaConciliacion) END,
fecha					 = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN d.FechaEmision ELSE d.FechaConciliacion END,
Referencia             = RTRIM(ISNULL(c.Mov,'')) + ' ' + RTRIM(ISNULL(c.MovID,'')),
importe                = c.Importe*dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,2,c.DineroCtaDinero),
retencion_isr          = 0.0,
retencion_iva          = c.Retencion*dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,2,c.DineroCtaDinero),
base_iva               = (ISNULL(CONVERT(float,c.Importe),0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ((CONVERT(float,c.Importe)/NULLIF((1.0-ISNULL(CONVERT(float,c.IEPSFiscal),0.0)),0.0))*ISNULL(CONVERT(float,c.IEPSFiscal),0.0)) ELSE 0.0 END)*dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,2,c.DineroCtaDinero),
iva_excento            = 0,
iva_tasa               = dbo.fnMFAIVATasa(c.Empresa, c.Importe,c.Impuestos),
iva                    = dbo.fnMFAIVA(c.Empresa,c.Importe,c.Impuestos)*dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,2,c.DineroCtaDinero),
base_ieps              = ISNULL(c.Importe,0.0)*dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,2,c.DineroCtaDinero),
ieps_tasa               = ROUND(((CONVERT(float,c.Importe)/NULLIF((1.0-CONVERT(float,ISNULL(c.IEPSFiscal,0.0))),0.0))*CONVERT(float,ISNULL(c.IEPSFiscal,0.0)))/NULLIF(CONVERT(float,c.Importe),0.0),2)*100.0,
ieps                   = (ISNULL(CONVERT(float,c.Importe),0.0)/NULLIF((1.0-ISNULL(CONVERT(float,c.IEPSFiscal),0.0)),0.0))*ISNULL(CONVERT(float,c.IEPSFiscal),0.0)*dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,2,c.DineroCtaDinero),
base_isan              = 0.0,
isan                   = 0.0,
cuenta_bancaria        = d.CtaDinero,
aplica_ietu            = ISNULL(NULLIF(mtmree.AplicaIetu,''), 'Si'),
aplica_ieps            = ISNULL(NULLIF(mtmree.AplicaIeps,''), 'Si'),
aplica_iva             = ISNULL(NULLIF(mtmree.AplicaIVA,''), 'Si'),
conciliado			 = ISNULL(d.Conciliado, 0),
dinero				 = d.Mov,
dinero_id				 = d.MovID,
tipo_documento		 = mtmaa.tipo_documento
FROM Dinero d
JOIN MovFlujo mf ON d.ID = mf.DID AND mf.OModulo = 'DIN' AND DModulo = 'DIN'
JOIN Dinero d2 ON d2.ID = mf.OID
JOIN MovTipo mt ON mt.Mov = d.Mov AND mt.Modulo = 'DIN'
JOIN MovTipo mt2 ON mt2.Mov = d2.Mov AND mt2.Modulo = 'DIN'
JOIN Cxp c ON d2.OrigenTipo = 'CXP' AND d2.Origen = c.Mov AND d2.OrigenID = c.MovID AND d2.Empresa = c.Empresa
JOIN MovTipo mt3 ON mt3.Mov = c.Mov AND mt3.Modulo = 'CXP'
JOIN Version ver ON 1 = 1
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'DIN' AND mme.ModuloID = d.ID
LEFT OUTER JOIN MovTipoMFAAplicaAdicion mtmaa ON mtmaa.Modulo = 'DIN' AND mtmaa.Mov = d.Mov AND ISNULL(NULLIF(mtmaa.OrigenTipo,''), 'CXP') = 'CXP' AND ISNULL(NULLIF(mtmaa.Origen,''),ISNULL(c.Mov, '')) = ISNULL(c.Mov,'')
LEFT OUTER JOIN MovTipoMFAAplicaExcepcion mtmae ON mtmae.Modulo = 'DIN' AND mtmae.Mov = d.Mov AND ISNULL(NULLIF(mtmae.OrigenTipo,''),'CXP') = 'CXP' AND ISNULL(NULLIF(mtmae.Origen,''),ISNULL(c.Mov,'')) = ISNULL(c.Mov,'')
LEFT OUTER JOIN MovTipoMFAAplicacionCambio mtmac ON mtmac.Modulo = 'DIN' AND mtmac.Mov = d.Mov AND ISNULL(NULLIF(mtmac.OrigenTipo,''),'CXP') = 'CXP' AND ISNULL(NULLIF(mtmac.Origen,''),ISNULL(c.Mov,'')) = ISNULL(c.Mov,'')
LEFT OUTER JOIN MovTipoMFAAplicaReporteExcepcion mtmree ON mtmree.Modulo = 'DIN' AND mtmree.Mov = d.Mov AND ISNULL(NULLIF(mtmree.OrigenTipo,''), 'CXP') = 'CXP' AND ISNULL(NULLIF(mtmree.Origen,''), ISNULL(c.Mov,'')) = ISNULL(c.Mov,'')
LEFT OUTER JOIN MovTipoMFADocConciliado mtdc ON mtdc.Modulo = 'DIN' AND mtdc.Mov = c.Mov
WHERE c.Estatus IN ('PENDIENTE','CONCLUIDO')
AND d2.Estatus IN ('PENDIENTE','CONCLUIDO')
AND d.Estatus IN ('PENDIENTE','CONCLUIDO', 'CONCILIADO')
AND (mt.Clave IN ('DIN.CH', 'DIN.CHE', 'DIN.D', 'DIN.DE'))
AND (mt2.Clave IN ('DIN.SCH', 'DIN.SD'))
AND (mt3.Clave IN ('CXP.A') /*OR mtmaa.Modulo IS NOT NULL*/)
AND d.Importe IS NOT NULL
AND c.Importe IS NOT NULL
AND mme.ModuloID IS NULL
AND mtmae.Mov IS NULL

