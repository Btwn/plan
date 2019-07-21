SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFACrCobroCalc AS
SELECT
origen_tipo            = 'auto',
origen_modulo          = 'CR',
origen_id              = RTRIM(LTRIM(CONVERT(varchar,c.ID))),
empresa                = c.Empresa,
tipo_aplicacion        = ISNULL(NULLIF(mtmac.TipoAplicacion,''),'cobro'),
folio                  = RTRIM(ISNULL(c.Mov,'')) + ' ' + RTRIM(ISNULL(c.MovID,'')),
ejercicio              = c.Ejercicio,
periodo                = c.Periodo,
dia                    = DAY(c.FechaEmision),
fecha					 = c.FechaEmision,
Referencia             = RTRIM(ISNULL(mf.DMov,'')) + ' ' + RTRIM(ISNULL(mf.DMovID,'')),
importe                = vtce.TotalNeto*v.TipoCambio,
cuenta_bancaria        = NULL,
aplica_ietu            = ISNULL(NULLIF(mtmree.AplicaIetu,''), 'Si'),
aplica_ieps            = ISNULL(NULLIF(mtmree.AplicaIeps,''), 'Si'),
aplica_iva             = ISNULL(NULLIF(mtmree.AplicaIVA,''), 'Si'),
dinero				 = NULL,
dinero_id				 = NULL,
tipo_documento		 = NULL
FROM CR c
JOIN MovFlujo mf ON mf.Sucursal = c.Sucursal AND mf.Empresa = c.Empresa AND mf.OModulo = 'CR' AND mf.OID = c.ID AND DModulo = 'VTAS'
JOIN Venta v ON v.ID = mf.DID JOIN MFAVentaTCalcExportacion vtce ON vtce.ID = v.ID
JOIN MovTipo mt ON mt.Mov = c.Mov AND mt.Modulo = 'CR'
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'CR' AND mme.ModuloID = c.ID
LEFT OUTER JOIN MovTipoMFARedocExcepcion mtmae ON mtmae.Modulo = 'CR' AND mtmae.Mov = c.Mov AND ISNULL(NULLIF(mtmae.OrigenTipo,''),ISNULL(c.OrigenTipo,'')) = ISNULL(c.OrigenTipo,'') AND ISNULL(NULLIF(mtmae.Origen,''),ISNULL(c.Origen,'')) = ISNULL(c.Origen,'')
LEFT OUTER JOIN MovTipoMFAAplicacionCambio mtmac ON mtmac.Modulo = 'CR'AND mtmac.Mov = c.Mov AND ISNULL(NULLIF(mtmac.OrigenTipo,''),ISNULL(c.OrigenTipo,'')) = ISNULL(c.OrigenTipo,'') AND ISNULL(NULLIF(mtmac.Origen,''),ISNULL(c.Origen,'')) = ISNULL(c.Origen,'')
LEFT OUTER JOIN MovTipoMFAAplicaReporteExcepcion mtmree ON mtmree.Modulo = 'CR'AND mtmree.Mov = c.Mov AND ISNULL(NULLIF(mtmree.OrigenTipo,''),ISNULL(c.OrigenTipo,'')) = ISNULL(c.OrigenTipo,'') AND ISNULL(NULLIF(mtmree.Origen,''),ISNULL(c.Origen,'')) = ISNULL(c.Origen,'')
WHERE c.Estatus IN ('CONCLUIDO')
AND mt.Clave IN ('CR.C')
AND v.Estatus IN ('CONCLUIDO')
AND mme.ModuloID IS NULL
AND mtmae.Mov IS NULL

