SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFACxcCobroSinAnticipadoCalc AS
SELECT
origen_tipo            = 'auto',
origen_modulo          = 'CXC',
origen_id              = RTRIM(LTRIM(CONVERT(varchar,c.ID))),
empresa                = c.Empresa,
tipo_aplicacion        = ISNULL(NULLIF(mtmac.TipoAplicacion,''),'cobro'),
folio                  = RTRIM(ISNULL(c.Mov,'')) + ' ' + RTRIM(ISNULL(c.MovID,'')),
ejercicio              = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mt.Clave WHEN 'CXC.DP' THEN YEAR(c.FechaConclusion) ELSE c.Ejercicio         END ELSE YEAR(c.DineroFechaConciliacion) END,
periodo                = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mt.Clave WHEN 'CXC.DP' THEN MONTH(c.FechaConclusion)ELSE c.Periodo           END ELSE MONTH(c.DineroFechaConciliacion) END,
dia                    = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mt.Clave WHEN 'CXC.DP' THEN DAY(c.FechaConclusion)  ELSE DAY(c.FechaEmision) END ELSE DAY(c.DineroFechaConciliacion) END,
fecha					 = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mt.Clave WHEN 'CXC.DP' THEN c.FechaConclusion ELSE c.FechaEmision END ELSE c.DineroFechaConciliacion END,
Referencia             = RTRIM(ISNULL(cd.Aplica,'')) + ' ' + RTRIM(ISNULL(cd.AplicaID,'')),
importe                = (cd.Importe+ISNULL(cd.DescuentoRecargos, 0))*c.TipoCambio,
cuenta_bancaria        = c.DineroCtaDinero,
aplica_ietu            = ISNULL(NULLIF(mtmree.AplicaIetu,''), 'Si'),
aplica_ieps            = ISNULL(NULLIF(mtmree.AplicaIeps,''), 'Si'),
aplica_iva             = ISNULL(NULLIF(mtmree.AplicaIVA,''), 'Si'),
conciliado			 = ISNULL(c.DineroConciliado, 0),
dinero				 = c.Dinero,
dinero_id				 = c.DineroID,
tipo_documento		 = mtmca.tipo_documento
FROM Cxc c
JOIN CxcD cd ON cd.ID = c.ID
JOIN MovTipo mt ON mt.Mov = c.Mov AND mt.Modulo = 'CXC'
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'CXC' AND mme.ModuloID = c.ID
LEFT OUTER JOIN MovTipoMFACobroAdicion mtmca ON mtmca.Modulo = 'CXC' AND mtmca.Mov = c.Mov AND ISNULL(NULLIF(mtmca.OrigenTipo,''),ISNULL(c.OrigenTipo, '')) = ISNULL(c.OrigenTipo,'') AND ISNULL(NULLIF(mtmca.Origen,''),ISNULL(c.Origen, '')) = ISNULL(c.Origen,'')
LEFT OUTER JOIN MovTipoMFACobroPagoExcepcion mtmcpe ON mtmcpe.Modulo = 'CXC' AND mtmcpe.Mov = c.Mov AND ISNULL(NULLIF(mtmcpe.OrigenTipo,''),ISNULL(c.OrigenTipo,'')) = ISNULL(c.OrigenTipo,'') AND ISNULL(NULLIF(mtmcpe.Origen,''),ISNULL(c.Origen,'')) = ISNULL(c.Origen,'')
LEFT OUTER JOIN MovTipoMFAAplicacionCambio mtmac ON mtmac.Modulo = 'CXC' AND mtmac.Mov = c.Mov AND ISNULL(NULLIF(mtmac.OrigenTipo,''),ISNULL(c.OrigenTipo,'')) = ISNULL(c.OrigenTipo,'') AND ISNULL(NULLIF(mtmac.Origen,''),ISNULL(c.Origen,'')) = ISNULL(c.Origen,'')
LEFT OUTER JOIN MovTipoMFAAplicaReporteExcepcion mtmree ON mtmree.Modulo = 'CXC' AND mtmree.Mov = c.Mov AND ISNULL(NULLIF(mtmree.OrigenTipo,''), 'CXC') = 'CXC' AND ISNULL(NULLIF(mtmree.Origen,''), ISNULL(cd.Aplica,'')) = ISNULL(cd.Aplica,'')
LEFT OUTER JOIN MovTipoMFADocConciliado mtdc ON mtdc.Modulo = 'CXC' AND mtdc.Mov = c.Mov
LEFT OUTER JOIN FormaPago fp1 ON c.FormaCobro = fp1.FormaPago
LEFT OUTER JOIN MovTipo mtfp1 ON fp1.MovIngresos = mtfp1.Mov AND mtfp1.Modulo = 'DIN'
LEFT OUTER JOIN FormaPago fp2 ON c.FormaCobro1 = fp2.FormaPago
LEFT OUTER JOIN MovTipo mtfp2 ON fp2.MovIngresos = mtfp2.Mov AND mtfp2.Modulo = 'DIN'
WHERE c.Estatus IN ('PENDIENTE','CONCLUIDO')
AND (mt.Clave IN ('CXC.C','CXC.DP','CXC.NCP') OR mtmca.Modulo IS NOT NULL)
AND cd.Importe IS NOT NULL
AND mme.ModuloID IS NULL
AND mtmcpe.Mov IS NULL
AND ISNULL(mtfp1.Clave, '') <> 'DIN.DA'
AND ISNULL(mtfp2.Clave, '') <> 'DIN.DA'

