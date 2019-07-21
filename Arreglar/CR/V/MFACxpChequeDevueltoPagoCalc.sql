SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFACxpChequeDevueltoPagoCalc AS
SELECT
origen_tipo            = 'auto',
origen_modulo          = 'CXP',
origen_id              = RTRIM(LTRIM(CONVERT(varchar,c.ID))),
empresa                = c.Empresa,
tipo_aplicacion        = ISNULL(NULLIF(mtmac.TipoAplicacion,''),'pago'),
folio                  = RTRIM(ISNULL(c.Mov,'')) + ' ' + RTRIM(ISNULL(c.MovID,'')),
ejercicio              = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mt.Clave WHEN 'CXP.DP' THEN YEAR(c.FechaConclusion) ELSE c.Ejercicio         END ELSE YEAR(c.DineroFechaConciliacion) END,
periodo                = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mt.Clave WHEN 'CXP.DP' THEN MONTH(c.FechaConclusion)ELSE c.Periodo           END ELSE MONTH(c.DineroFechaConciliacion) END,
dia                    = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mt.Clave WHEN 'CXP.DP' THEN DAY(c.FechaConclusion)  ELSE DAY(c.FechaEmision) END ELSE DAY(c.DineroFechaConciliacion) END,
fecha					 = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mt.Clave WHEN 'CXP.DP' THEN c.FechaConclusion ELSE c.FechaEmision END ELSE c.DineroFechaConciliacion END,
Referencia             = RTRIM(ISNULL(c.Mov,'')) + ' ' + RTRIM(ISNULL(c.MovID,'')),
importe                = (c.Importe+ISNULL(c.Impuestos, 0))*c.TipoCambio,
cuenta_bancaria        = c.DineroCtaDinero,
aplica_ietu            = ISNULL(NULLIF(mtmree.AplicaIetu,''), 'Si'),
aplica_ieps            = ISNULL(NULLIF(mtmree.AplicaIeps,''), 'Si'),
aplica_iva             = ISNULL(NULLIF(mtmree.AplicaIVA,''), 'Si'),
conciliado			 = ISNULL(c.DineroConciliado, 0),
dinero				 = c.Dinero,
dinero_id				 = c.DineroID,
tipo_documento		 = 'nota_credito'
FROM Cxp c
JOIN MovTipo mt ON mt.Mov = c.Mov AND mt.Modulo = 'CXP'
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'CXP' AND mme.ModuloID = c.ID
LEFT OUTER JOIN MovTipoMFACobroPagoExcepcion mtmcpe ON mtmcpe.Modulo = 'CXP' AND mtmcpe.Mov = c.Mov AND ISNULL(NULLIF(mtmcpe.OrigenTipo,''),ISNULL(c.OrigenTipo,'')) = ISNULL(c.OrigenTipo,'') AND ISNULL(NULLIF(mtmcpe.Origen,''),ISNULL(c.Origen,'')) = ISNULL(c.Origen,'')
LEFT OUTER JOIN MovTipoMFAAplicacionCambio mtmac ON mtmac.Modulo = 'CXP' AND mtmac.Mov = c.Mov AND ISNULL(NULLIF(mtmac.OrigenTipo,''),ISNULL(c.OrigenTipo,'')) = ISNULL(c.OrigenTipo,'') AND ISNULL(NULLIF(mtmac.Origen,''),ISNULL(c.Origen,'')) = ISNULL(c.Origen,'')
LEFT OUTER JOIN MovTipoMFAAplicaReporteExcepcion mtmree ON mtmree.Modulo = 'CXP' AND mtmree.Mov = c.Mov AND ISNULL(NULLIF(mtmree.OrigenTipo,''), 'CXP') = 'CXP' AND ISNULL(NULLIF(mtmree.Origen,''), ISNULL(c.Mov,'')) = ISNULL(c.Mov,'')
LEFT OUTER JOIN MovTipoMFADocConciliado mtdc ON mtdc.Modulo = 'CXP' AND mtdc.Mov = c.Mov
WHERE c.Estatus IN ('PENDIENTE','CONCLUIDO')
AND (mt.Clave IN ('Cxp.CD'))
AND c.Importe IS NOT NULL
AND mme.ModuloID IS NULL
AND mtmcpe.Mov IS NULL

