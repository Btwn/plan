SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFAVentaContadoPagoCalc AS
SELECT
origen_tipo            = 'auto',
origen_modulo          = 'VTAS',
origen_id              = RTRIM(LTRIM(CONVERT(varchar,v.ID))),
empresa                = v.Empresa,
tipo_aplicacion        = ISNULL(NULLIF(mtmac.TipoAplicacion,''),'cobro'),
folio                  = RTRIM(ISNULL(v.Mov,'')) + ' ' + RTRIM(ISNULL(v.MovID,'')),
ejercicio              = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN v.Ejercicio ELSE YEAR(v.DineroFechaConciliacion) END,
periodo                = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN v.Periodo ELSE MONTH(v.DineroFechaConciliacion) END,
dia                    = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN DAY(v.FechaEmision) ELSE DAY(v.DineroFechaConciliacion) END,
fecha					 = CASE ISNULL(mtdc.Mov, '') WHEN '' THEN v.FechaEmision ELSE v.DineroFechaConciliacion END,
Referencia             = RTRIM(ISNULL(v.Mov,'')) + ' ' + RTRIM(ISNULL(v.MovID,'')),
importe                = v.Importe*v.TipoCambio,
cuenta_bancaria        = v.DineroCtaDinero,
aplica_ietu            = ISNULL(NULLIF(mtmree.AplicaIetu,''), 'Si'),
aplica_ieps            = ISNULL(NULLIF(mtmree.AplicaIeps,''), 'Si'),
aplica_iva             = ISNULL(NULLIF(mtmree.AplicaIVA,''), 'Si'),
conciliado			 = ISNULL(v.DineroConciliado, 0),
dinero				 = v.Dinero,
dinero_id				 = v.DineroID,
tipo_documento		 = mtmpa.tipo_documento
FROM Venta v
JOIN MovTipo mt ON mt.Mov = v.Mov AND mt.Modulo = 'VTAS'
JOIN Cte c ON c.Cliente = v.Cliente
JOIN EmpresaMFA em ON em.Empresa = v.Empresa
JOIN Version ver ON 1 = 1
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'VTAS' AND mme.ModuloID = v.ID
LEFT OUTER JOIN MovTipoMFADocExcepcion mtmde ON mtmde.Modulo = 'VTAS' AND mtmde.Mov = v.Mov
LEFT OUTER JOIN FiscalRegimen fr ON fr.FiscalRegimen = c.FiscalRegimen
LEFT OUTER JOIN Pais pa ON pa.Clave = c.Pais
LEFT OUTER JOIN MFAPais p ON p.Pais = pa.Pais
LEFT OUTER JOIN Agente ag ON ag.Agente = v.Agente
LEFT OUTER JOIN MFATipoActividad ON MFATipoActividad.Modulo = 'VTAS' AND MFATipoActividad.Mov = v.Mov
LEFT OUTER JOIN MovTipoMFAAplicacionCambio mtmac ON mtmac.Modulo = 'VTAS' AND mtmac.Mov = v.Mov AND ISNULL(NULLIF(mtmac.OrigenTipo,''),ISNULL(v.OrigenTipo,'')) = ISNULL(v.OrigenTipo,'') AND ISNULL(NULLIF(mtmac.Origen,''),ISNULL(v.Origen,'')) = ISNULL(v.Origen,'')
LEFT OUTER JOIN MovTipoMFADocConciliado mtdc ON mtdc.Modulo = 'VTAS' AND mtdc.Mov = v.Mov
LEFT OUTER JOIN MovTipoMFAAplicaReporteExcepcion mtmree ON mtmree.Modulo = 'VTAS' AND mtmree.Mov = v.Mov
LEFT OUTER JOIN MovTipoMFAPagoAdicion mtmpa ON mtmpa.Modulo = 'VTAS' AND mtmpa.Mov = v.Mov AND ISNULL(NULLIF(mtmpa.OrigenTipo,''),ISNULL(v.OrigenTipo, '')) = ISNULL(v.OrigenTipo,'') AND ISNULL(NULLIF(mtmpa.Origen,''),ISNULL(v.Origen, '')) = ISNULL(v.Origen,'')
WHERE mtmde.Modulo IS NULL
AND mme.ModuloID IS NULL
AND v.Estatus IN ('CONCLUIDO','PENDIENTE')
AND mt.Clave IN ('VTAS.F')
AND NOT EXISTS(SELECT ID FROM Cxc WHERE Mov = v.Mov AND MovID = v.MovID AND Empresa = v.Empresa)

