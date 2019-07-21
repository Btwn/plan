SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFACxpPagoCalc AS
SELECT
origen_tipo            = 'auto',
origen_modulo          = 'CXP',
origen_id              = RTRIM(LTRIM(CONVERT(varchar,c.ID))),
empresa                = c.Empresa,
tipo_aplicacion        = ISNULL(NULLIF(mtmac.TipoAplicacion,''),'pago'),
folio                  = CASE
WHEN ISNULL(c.DineroID,'') = '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 0
THEN RTRIM(ISNULL(c.Mov,'')) + ' ' + RTRIM(ISNULL(c.MovID,''))
WHEN ISNULL(c.DineroID,'') <> '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 1
THEN RTRIM(ISNULL(c.Dinero,'')) + ' ' + RTRIM(ISNULL(c.DineroID,''))
ELSE RTRIM(ISNULL(c.Mov,'')) + ' ' + RTRIM(ISNULL(c.MovID,''))
END,
ejercicio              = CASE
WHEN ISNULL(c.DineroID,'') = '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 0
THEN CASE ISNULL(mtdc.Mov, '') WHEN '' THEN c.Ejercicio ELSE YEAR(c.DineroFechaConciliacion) END
WHEN ISNULL(c.DineroID,'') <> '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 1
THEN CASE ISNULL(mtdc.Mov, '') WHEN '' THEN dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,3,c.DineroCtaDinero) ELSE YEAR(CONVERT(DATETIME,dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,5,c.DineroCtaDinero))) END
ELSE CASE ISNULL(mtdc.Mov, '') WHEN '' THEN c.Ejercicio ELSE YEAR(c.DineroFechaConciliacion) END
END,
periodo                = CASE
WHEN ISNULL(c.DineroID,'') = '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 0
THEN CASE ISNULL(mtdc.Mov, '') WHEN '' THEN c.Periodo ELSE MONTH(c.DineroFechaConciliacion) END
WHEN ISNULL(c.DineroID,'') <> '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 1
THEN CASE ISNULL(mtdc.Mov, '') WHEN '' THEN dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,4,c.DineroCtaDinero)  ELSE MONTH(CONVERT(DATETIME,dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,5,c.DineroCtaDinero))) END
ELSE CASE ISNULL(mtdc.Mov, '') WHEN '' THEN c.Periodo ELSE MONTH(c.DineroFechaConciliacion) END
END,
dia                    = CASE
WHEN ISNULL(c.DineroID,'') = '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 0
THEN CASE ISNULL(mtdc.Mov, '') WHEN '' THEN DAY(c.FechaEmision) ELSE DAY(c.DineroFechaConciliacion) END
WHEN ISNULL(c.DineroID,'') <> '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 1
THEN CASE ISNULL(mtdc.Mov, '') WHEN '' THEN DAY(dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,1,c.DineroCtaDinero)) ELSE DAY(CONVERT(DATETIME,dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,5,c.DineroCtaDinero))) END
ELSE CASE ISNULL(mtdc.Mov, '') WHEN '' THEN DAY(c.FechaEmision) ELSE DAY(c.DineroFechaConciliacion) END
END,
fecha					 = CASE
WHEN ISNULL(c.DineroID,'') = '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 0
THEN CASE ISNULL(mtdc.Mov, '') WHEN '' THEN c.FechaEmision ELSE c.DineroFechaConciliacion END
WHEN ISNULL(c.DineroID,'') <> '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 1
THEN CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CONVERT(DATETIME, dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,1,c.DineroCtaDinero)) ELSE CONVERT(DATETIME,dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,5,c.DineroCtaDinero)) END
ELSE CASE ISNULL(mtdc.Mov, '') WHEN '' THEN c.FechaEmision ELSE c.DineroFechaConciliacion END
END,
Referencia             = RTRIM(ISNULL(cd.Aplica,'')) + ' ' + RTRIM(ISNULL(cd.AplicaID,'')),
importe                = CASE
WHEN ISNULL(c.DineroID,'') = '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 0
THEN cd.Importe*c.TipoCambio
WHEN ISNULL(c.DineroID,'') <> '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 1
THEN cd.Importe*(dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,2,c.DineroCtaDinero))
ELSE cd.Importe*c.TipoCambio
END,
cuenta_bancaria        = c.DineroCtaDinero,
aplica_ietu            = ISNULL(NULLIF(mtmree.AplicaIetu,''), 'Si'),
aplica_ieps            = ISNULL(NULLIF(mtmree.AplicaIeps,''), 'Si'),
aplica_iva             = ISNULL(NULLIF(mtmree.AplicaIVA,''), 'Si'),
conciliado			 = ISNULL(c.DineroConciliado, 0),
dinero			     = c.Dinero,
dinero_id				 = c.DineroID,
tipo_documento		 = mtmpa.tipo_documento
FROM Cxp c
JOIN CxpD cd ON cd.ID = c.ID
JOIN MovTipo mt ON mt.Mov = c.Mov AND mt.Modulo = 'CXP'
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'CXP' AND mme.ModuloID = c.ID
LEFT OUTER JOIN MovTipoMFAPagoAdicion mtmpa ON mtmpa.Modulo = 'CXP' AND mtmpa.Mov = c.Mov AND ISNULL(NULLIF(mtmpa.OrigenTipo,''),ISNULL(c.OrigenTipo, '')) = ISNULL(c.OrigenTipo,'') AND ISNULL(NULLIF(mtmpa.Origen,''),ISNULL(c.Origen, '')) = ISNULL(c.Origen,'')
LEFT OUTER JOIN MovTipoMFACobroPagoExcepcion mtmcpe ON mtmcpe.Modulo = 'CXP' AND mtmcpe.Mov = c.Mov AND ISNULL(NULLIF(mtmcpe.OrigenTipo,''),ISNULL(c.OrigenTipo,'')) = ISNULL(c.OrigenTipo,'') AND ISNULL(NULLIF(mtmcpe.Origen,''),ISNULL(c.Origen,'')) = ISNULL(c.Origen,'')
LEFT OUTER JOIN MovTipoMFAAplicacionCambio mtmac ON mtmac.Modulo = 'CXP'AND mtmac.Mov = c.Mov AND ISNULL(NULLIF(mtmac.OrigenTipo,''),ISNULL(c.OrigenTipo,'')) = ISNULL(c.OrigenTipo,'') AND ISNULL(NULLIF(mtmac.Origen,''),ISNULL(c.Origen,'')) = ISNULL(c.Origen,'')
LEFT OUTER JOIN MovTipoMFAAplicaReporteExcepcion mtmree ON mtmree.Modulo = 'CXP' AND mtmree.Mov = c.Mov AND ISNULL(NULLIF(mtmree.OrigenTipo,''), 'CXP') = 'CXP' AND ISNULL(NULLIF(mtmree.Origen,''), ISNULL(cd.Aplica,'')) = ISNULL(cd.Aplica,'')
LEFT OUTER JOIN MovTipoMFADocConciliado mtdc ON mtdc.Modulo = 'CXP' AND mtdc.Mov = c.Mov
WHERE c.Estatus IN ('PENDIENTE','CONCLUIDO')
AND (mt.Clave IN ('CXP.P','CXP.NCP','CXP.DP') OR mtmpa.Modulo IS NOT NULL)
AND cd.Importe IS NOT NULL
AND mme.ModuloID IS NULL
AND mtmcpe.Mov IS NULL

