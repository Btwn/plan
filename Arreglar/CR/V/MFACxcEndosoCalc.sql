SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFACxcEndosoCalc AS
SELECT
origen_tipo            = 'auto',
origen_modulo          = 'CXC',
origen_id              = RTRIM(LTRIM(CONVERT(varchar,c.ID))),
empresa                = c.Empresa,
tipo_aplicacion        = ISNULL(NULLIF(mtmac.TipoAplicacion,''),'redocumentacion'),
folio                  = RTRIM(ISNULL(c.Mov,'')) + ' ' + RTRIM(ISNULL(c.MovID,'')),
ejercicio              = c.Ejercicio,
periodo                = c.Periodo,
dia                    = DAY(c.FechaEmision),
fecha					 = c.FechaEmision,
Referencia             = RTRIM(ISNULL(c.MovAplica,'')) + ' ' + RTRIM(ISNULL(c.MovAplicaID,'')),
importe                = (ISNULL(c.Importe,0.0)+ISNULL(c.Impuestos,0.0)-ISNULL(c.Retencion,0.0))*c.TipoCambio,
cuenta_bancaria        = c.DineroCtaDinero,
aplica_ietu            = ISNULL(NULLIF(mtmree.AplicaIetu,''), 'Si'),
aplica_ieps            = ISNULL(NULLIF(mtmree.AplicaIeps,''), 'Si'),
aplica_iva             = ISNULL(NULLIF(mtmree.AplicaIVA,''), 'Si'),
dinero				 = c.Dinero,
dinero_id				 = c.DineroID,
tipo_documento		 = mtmea.tipo_documento
FROM Cxc c
JOIN MovTipo mt ON mt.Mov = c.Mov AND mt.Modulo = 'CXC'
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'CXC' AND mme.ModuloID = c.ID
LEFT OUTER JOIN MovTipoMFAEndosoAdicion mtmea ON mtmea.Modulo = 'CXC' AND mtmea.Mov = c.Mov AND ISNULL(NULLIF(mtmea.OrigenTipo,''),ISNULL(c.OrigenTipo, '')) = ISNULL(c.OrigenTipo,'') AND ISNULL(NULLIF(mtmea.Origen,''),ISNULL(c.Origen, '')) = ISNULL(c.Origen,'')
LEFT OUTER JOIN MovTipoMFAEndosoExcepcion mtmae ON mtmae.Modulo = 'CXC' AND mtmae.Mov = c.Mov AND ISNULL(NULLIF(mtmae.OrigenTipo,''),ISNULL(c.OrigenTipo,'')) = ISNULL(c.OrigenTipo,'') AND ISNULL(NULLIF(mtmae.Origen,''),ISNULL(c.Origen,'')) = ISNULL(c.Origen,'')
LEFT OUTER JOIN MovTipoMFAAplicacionCambio mtmac ON mtmac.Modulo = 'CXC'AND mtmac.Mov = c.Mov AND ISNULL(NULLIF(mtmac.OrigenTipo,''),ISNULL(c.OrigenTipo,'')) = ISNULL(c.OrigenTipo,'') AND ISNULL(NULLIF(mtmac.Origen,''),ISNULL(c.Origen,'')) = ISNULL(c.Origen,'')
LEFT OUTER JOIN MovTipoMFAAplicaReporteExcepcion mtmree ON mtmree.Modulo = 'CXC' AND mtmree.Mov = c.Mov AND ISNULL(NULLIF(mtmree.OrigenTipo,''),ISNULL(c.OrigenTipo,'')) = ISNULL(c.OrigenTipo,'') AND ISNULL(NULLIF(mtmree.Origen,''),ISNULL(c.Origen,'')) = ISNULL(c.Origen,'')
WHERE c.Estatus IN ('PENDIENTE','CONCLUIDO')
AND (mt.Clave IN ('CXC.FAC') OR mtmea.Modulo IS NOT NULL)
AND c.Importe IS NOT NULL
AND mme.ModuloID IS NULL
AND mtmae.Mov IS NULL

