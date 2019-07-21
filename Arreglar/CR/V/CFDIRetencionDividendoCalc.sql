SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDIRetencionDividendoCalc
AS
SELECT CFDIRetencionD.Modulo,
CFDIRetencionD.ModuloID,
CFDIRetencionD.RID									                'RID',
CFDIRetencionD.Empresa								              'Empresa',
CFDIRetencionD.Proveedor							              'Proveedor',
ISNULL(CFDIRetencionD.EstacionTrabajo, 0)			    'EstacionTrabajo',
ISNULL(CFDIRetencionD.ConceptoSAT, '')				      'ConceptoSAT',
ISNULL(CFDIRetSATRetencion.Complemento, '')        'Complemento',
ISNULL(CFDIRetencionCompXMLPlantilla.Version, '')  'Version',
CFDIRetGastoComplemento.CveTipDivOUtil				      'CveTipDivOUtil',
CASE CFDIRetencionD.TipoTercero
WHEN 'Nacional'   THEN CONVERT(varchar(max), CONVERT(money, ISNULL(Retencion1, 0)))
ELSE                   CONVERT(varchar(max), CONVERT(money, ISNULL(0, 0)))
END                                                  'MontISRAcredRetMexico',
CASE CFDIRetencionD.TipoTercero
WHEN 'Extranjero' THEN CONVERT(varchar(max), CONVERT(money, ISNULL(Retencion1, 0)))
ELSE                   CONVERT(varchar(max), CONVERT(money, ISNULL(0, 0)))
END                                                'MontISRAcredRetExtranjero',
CFDIRetGastoComplemento.MontRetExtDivExt          'MontRetExtDivExt',
CFDIRetGastoComplemento.TipoSocDistrDiv            'TipoSocDistrDiv',
CFDIRetGastoComplemento.MontISRAcredNal  	        'MontISRAcredNal',
CFDIRetGastoComplemento.MontDivAcumNal			        'MontDivAcumNal',
CFDIRetGastoComplemento.MontDivAcumExt  		        'MontDivAcumExt',
CFDIRetGastoComplemento.ProporcionRem			        'ProporcionRem'
FROM CFDIRetencionD
JOIN Empresa                                  ON CFDIRetencionD.Empresa = Empresa.Empresa
JOIN Prov                                     ON CFDIRetencionD.Proveedor = Prov.Proveedor
LEFT OUTER JOIN Pais                          ON Prov.Pais = Pais.Pais
LEFT OUTER JOIN CFDIRetSATPais                ON Pais.CFDIRetClaveSat = CFDIRetSATPais.Clave
LEFT OUTER JOIN CFDIRetSATTipoContribuyente   ON CFDIRetSATTipoContribuyente.Clave = Prov.CFDIRetTipoContribuyente
LEFT OUTER JOIN CFDIRetSATRetencion           ON CFDIRetencionD.ConceptoSAT = CFDIRetSATRetencion.Clave
LEFT OUTER JOIN CFDIRetencionCompXMLPlantilla ON CFDIRetencionCompXMLPlantilla.Complemento = CFDIRetSATRetencion.Complemento
LEFT OUTER JOIN CFDIRetencionArt a            ON CFDIRetencionD.Concepto = a.Articulo AND CFDIRetencionD.Modulo = 'COMS'
LEFT OUTER JOIN CFDIRetencionConcepto c       ON CFDIRetencionD.Concepto = c.Concepto AND CFDIRetencionD.Modulo <> 'COMS'
LEFT OUTER JOIN CFDIRetGastoComplemento       ON CFDIRetencionD.ModuloID = CFDIRetGastoComplemento.ID
WHERE CFDIRetSATRetencion.Complemento = 'Dividendos'
AND CFDIRetencionD.Modulo = 'GAS'

