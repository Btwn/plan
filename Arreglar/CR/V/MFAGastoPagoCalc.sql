SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFAGastoPagoCalc AS
SELECT
origen_tipo            = 'auto',
origen_modulo          = 'GAS',
origen_id              = RTRIM(LTRIM(CONVERT(varchar,c.ID))),
empresa                = c.Empresa,
tipo_aplicacion        = ISNULL(NULLIF(mtmac.TipoAplicacion,''),'pago'),
folio                  = RTRIM(ISNULL(c.Mov,'')) + ' ' + RTRIM(ISNULL(c.MovID,'')),
ejercicio              = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN c.Ejercicio ELSE YEAR(c.DineroFechaConciliacion) END,
periodo                = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN c.Periodo ELSE MONTH(c.DineroFechaConciliacion) END,
dia                    = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN DAY(c.FechaEmision) ELSE DAY(c.DineroFechaConciliacion) END,
fecha					 = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN c.FechaEmision ELSE c.DineroFechaConciliacion END,
Referencia             = RTRIM(ISNULL(c.Mov,'')) + ' ' + RTRIM(ISNULL(c.MovID,'')),
importe                = SUM((ISNULL(cd.Importe,0.0)+ISNULL(cd.Impuestos,0.0)+ISNULL(cd.Impuestos2,0.0))*c.TipoCambio),
cuenta_bancaria        = NULL,
aplica_ietu            = ISNULL(NULLIF(mtmree.AplicaIetu,''), 'Si'),
aplica_ieps            = ISNULL(NULLIF(mtmree.AplicaIeps,''), 'Si'),
aplica_iva             = ISNULL(NULLIF(mtmree.AplicaIVA,''), 'Si'),
conciliado			= ISNULL(c.DineroConciliado, 0),
dinero			    = c.Dinero,
dinero_id			    = c.DineroID,
tipo_documento		= mtmpa.DocumentoTipo
FROM Gasto c
JOIN GastoD cd ON cd.ID = c.ID
JOIN MovTipo mt ON mt.Mov = c.Mov AND mt.Modulo = 'GAS'
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'GAS' AND mme.ModuloID = c.ID
LEFT OUTER JOIN MovTipoMFADocAdicion mtmpa ON mtmpa.Modulo = 'GAS' AND mtmpa.Mov = c.Mov
LEFT OUTER JOIN MovTipoMFADocExcepcion mtmcpe ON mtmcpe.Modulo = 'GAS' AND mtmcpe.Mov = c.Mov
LEFT OUTER JOIN MovTipoMFAAplicacionCambio mtmac ON mtmac.Modulo = 'GAS'AND mtmac.Mov = c.Mov
LEFT OUTER JOIN MovTipoMFAAplicaReporteExcepcion mtmree ON mtmree.Modulo = 'GAS' AND mtmree.Mov = c.Mov
LEFT OUTER JOIN MovTipoMFADocConciliado mtdc ON mtdc.Modulo = 'GAS' AND mtdc.Mov = c.Mov
WHERE c.Estatus IN ('PENDIENTE','CONCLUIDO')
AND (mt.Clave IN ('GAS.C') OR mtmpa.Modulo IS NOT NULL)
AND cd.Importe IS NOT NULL
AND mme.ModuloID IS NULL
AND mtmcpe.Mov IS NULL
GROUP BY RTRIM(LTRIM(CONVERT(varchar,c.ID))), c.Empresa, ISNULL(NULLIF(mtmac.TipoAplicacion,''),'pago'), RTRIM(ISNULL(c.Mov,'')) + ' ' + RTRIM(ISNULL(c.MovID,'')), c.Ejercicio, c.Periodo, DAY(c.FechaEmision), RTRIM(ISNULL(c.Mov,'')) + ' ' + RTRIM(ISNULL(c.MovID,'')), ISNULL(NULLIF(mtmree.AplicaIetu,''), 'Si'), ISNULL(NULLIF(mtmree.AplicaIeps,''), 'Si'), ISNULL(NULLIF(mtmree.AplicaIVA,''), 'Si'), ISNULL(c.DineroConciliado, 0), c.Dinero, c.DineroID, mtdc.Mov, c.DineroFechaConciliacion, mtmpa.DocumentoTipo, c.FechaEmision

