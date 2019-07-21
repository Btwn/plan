SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFACxpAplicacionCalc AS
SELECT DISTINCT
origen_tipo            = 'auto',
origen_modulo          = 'CXP',
origen_id              = RTRIM(LTRIM(CONVERT(varchar,c.ID))),
empresa                = c.Empresa,
tipo_aplicacion        = ISNULL(NULLIF(mtmac.TipoAplicacion,''),'aplicacion'),
folio                  = RTRIM(ISNULL(ISNULL(c.MovAplica,c.Mov), '')) + ' ' + RTRIM(ISNULL(ISNULL(c.MovAplicaID,c.MovID), '')),
ejercicio              = c.Ejercicio,
periodo                = c.Periodo,
dia                    = DAY(c.FechaEmision),
fecha					 = c.FechaEmision,
Referencia             = RTRIM(ISNULL(cd.Aplica,'')) + ' ' + RTRIM(ISNULL(cd.AplicaID,'')),
importe                = cd.Importe*c.TipoCambio,
cuenta_bancaria        = c.DineroCtaDinero,
aplica_ietu            = ISNULL(NULLIF(mtmree.AplicaIetu,''), 'Si'),
aplica_ieps            = ISNULL(NULLIF(mtmree.AplicaIeps,''), 'Si'),
aplica_iva             = ISNULL(NULLIF(mtmree.AplicaIVA,''), 'Si'),
dinero				 = c.Dinero,
dinero_id				 = c.DineroID,
tipo_documento		 = mtmaa.tipo_documento
FROM Cxp c
JOIN CxpD cd ON cd.ID = c.ID
JOIN MovTipo mt ON mt.Mov = c.Mov AND mt.Modulo = 'CXP'
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'CXP' AND mme.ModuloID = c.ID
LEFT OUTER JOIN MovTipoMFAAplicaAdicion mtmaa ON mtmaa.Modulo = 'CXP' AND mtmaa.Mov = c.Mov AND ISNULL(NULLIF(mtmaa.OrigenTipo,''),ISNULL(c.OrigenTipo, '')) = ISNULL(c.OrigenTipo,'') AND ISNULL(NULLIF(mtmaa.Origen,''),ISNULL(c.Origen, '')) = ISNULL(c.Origen,'')
LEFT OUTER JOIN MovTipoMFAAplicaExcepcion mtmae ON mtmae.Modulo = 'CXP' AND mtmae.Mov = c.Mov AND ISNULL(NULLIF(mtmae.OrigenTipo,''),ISNULL(c.OrigenTipo,'')) = ISNULL(c.OrigenTipo,'') AND ISNULL(NULLIF(mtmae.Origen,''),ISNULL(c.Origen,'')) = ISNULL(c.Origen,'')
LEFT OUTER JOIN MovTipoMFAAplicacionCambio mtmac ON mtmac.Modulo = 'CXP'AND mtmac.Mov = c.Mov AND ISNULL(NULLIF(mtmac.OrigenTipo,''),ISNULL(c.OrigenTipo,'')) = ISNULL(c.OrigenTipo,'') AND ISNULL(NULLIF(mtmac.Origen,''),ISNULL(c.Origen,'')) = ISNULL(c.Origen,'')
LEFT OUTER JOIN MovTipoMFAAplicaReporteExcepcion mtmree ON mtmree.Modulo = 'CXP' AND mtmree.Mov = c.Mov AND ISNULL(NULLIF(mtmree.OrigenTipo,''), 'CXP') = 'CXP' AND ISNULL(NULLIF(mtmree.Origen,''), ISNULL(cd.Aplica,'')) = ISNULL(cd.Aplica,'')
WHERE c.Estatus IN ('PENDIENTE','CONCLUIDO')
AND (mt.Clave IN ('CXP.ACA','CXP.AE','CXP.ANC') OR mtmaa.Modulo IS NOT NULL)
AND cd.Importe IS NOT NULL
AND mme.ModuloID IS NULL
AND mtmae.Mov IS NULL

