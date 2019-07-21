SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFACxcCobroCalc AS
SELECT
origen_tipo            = 'auto',
origen_modulo          = 'CXC',
origen_id              = RTRIM(LTRIM(CONVERT(varchar,c.ID))),
empresa                = c.Empresa,
tipo_aplicacion        = ISNULL(NULLIF(mtmac.TipoAplicacion,''),'cobro'),
folio                  = CASE
WHEN ISNULL(c.DineroID,'') = '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 0
THEN RTRIM(ISNULL(c.Mov,'')) + ' ' + RTRIM(ISNULL(c.MovID,''))
WHEN ISNULL(c.DineroID,'') <> '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 1
THEN RTRIM(ISNULL(c.Dinero,'')) + ' ' + RTRIM(ISNULL(c.DineroID,''))
ELSE RTRIM(ISNULL(c.Mov,'')) + ' ' + RTRIM(ISNULL(c.MovID,''))
END,
ejercicio              = CASE
WHEN ISNULL(c.DineroID,'') = '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 0
THEN CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mt.Clave WHEN 'CXC.DP' THEN YEAR(c.FechaConclusion) ELSE c.Ejercicio END ELSE YEAR(c.DineroFechaConciliacion) END
WHEN ISNULL(c.DineroID,'') <> '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 1
THEN CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mt.Clave WHEN 'CXC.DP' THEN
YEAR(CONVERT(DATETIME,dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,6,c.DineroCtaDinero))) ELSE dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,3,c.DineroCtaDinero) END ELSE YEAR(CONVERT(DATETIME,dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,5,c.DineroCtaDinero))) END
ELSE CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mt.Clave WHEN 'CXC.DP' THEN YEAR(c.FechaConclusion) ELSE c.Ejercicio END ELSE YEAR(c.DineroFechaConciliacion) END
END,
periodo                = CASE
WHEN ISNULL(c.DineroID,'') = '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 0
THEN CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mt.Clave WHEN 'CXC.DP' THEN MONTH(c.FechaConclusion)ELSE c.Periodo END ELSE MONTH(c.DineroFechaConciliacion) END
WHEN ISNULL(c.DineroID,'') <> '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 1
THEN CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mt.Clave WHEN 'CXC.DP' THEN MONTH(CONVERT(DATETIME,dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,6,c.DineroCtaDinero))) ELSE dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,4,c.DineroCtaDinero) END ELSE MONTH(CONVERT(DATETIME,dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,5,c.DineroCtaDinero))) END
ELSE CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mt.Clave WHEN 'CXC.DP' THEN MONTH(c.FechaConclusion)ELSE c.Periodo END ELSE MONTH(c.DineroFechaConciliacion) END
END,
dia                    = CASE
WHEN ISNULL(c.DineroID,'') = '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 0
THEN CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mt.Clave WHEN 'CXC.DP' THEN DAY(c.FechaConclusion) ELSE DAY(c.FechaEmision) END ELSE DAY(c.DineroFechaConciliacion) END
WHEN ISNULL(c.DineroID,'') <> '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 1
THEN CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mt.Clave WHEN 'CXC.DP' THEN DAY(CONVERT(DATETIME,dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,6,c.DineroCtaDinero))) ELSE DAY(dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,1,c.DineroCtaDinero)) END ELSE DAY(CONVERT(DATETIME,dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,5,c.DineroCtaDinero))) END
ELSE CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mt.Clave WHEN 'CXC.DP' THEN DAY(c.FechaConclusion) ELSE DAY(c.FechaEmision) END ELSE DAY(c.DineroFechaConciliacion) END
END,
fecha					 = CASE
WHEN ISNULL(c.DineroID,'') = '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 0
THEN CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mt.Clave WHEN 'CXC.DP' THEN c.FechaConclusion ELSE c.FechaEmision END ELSE c.DineroFechaConciliacion END
WHEN ISNULL(c.DineroID,'') <> '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 1
THEN CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mt.Clave WHEN 'CXC.DP' THEN CONVERT(DATETIME,dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,6,c.DineroCtaDinero)) ELSE CONVERT(DATETIME,dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,1,c.DineroCtaDinero)) END ELSE CONVERT(DATETIME,dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,5,c.DineroCtaDinero)) END
ELSE CASE ISNULL(mtdc.Mov, '') WHEN '' THEN CASE mt.Clave WHEN 'CXC.DP' THEN c.FechaConclusion ELSE c.FechaEmision END ELSE c.DineroFechaConciliacion END
END,
Referencia             = RTRIM(ISNULL(cd.Aplica,'')) + ' ' + RTRIM(ISNULL(cd.AplicaID,'')),
importe                = CASE
WHEN ISNULL(c.DineroID,'') = '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 0
THEN (cd.Importe+ISNULL(cd.DescuentoRecargos, 0))*c.TipoCambio
WHEN ISNULL(c.DineroID,'') <> '' AND (SELECT FuncionTesoreria FROM EmpresaMFA WHERE Empresa = c.Empresa) = 1
THEN (cd.Importe+ISNULL(cd.DescuentoRecargos, 0))*(dbo.fnBuscadatosdinero(c.Dinero,c.DineroID,c.Empresa,2,c.DineroCtaDinero))
ELSE (cd.Importe+ISNULL(cd.DescuentoRecargos, 0))*c.TipoCambio
END,
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
WHERE c.Estatus IN ('PENDIENTE','CONCLUIDO')
AND (mt.Clave IN ('CXC.C','CXC.DP','CXC.NCP') OR mtmca.Modulo IS NOT NULL)
AND cd.Importe IS NOT NULL
AND mme.ModuloID IS NULL
AND mtmcpe.Mov IS NULL

