SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDIRetencionExtranjeroCalc
AS
SELECT CFDIRetencionD.RID									              'RID',
CFDIRetencionD.Empresa								            'Empresa',
CFDIRetencionD.Proveedor							            'Proveedor',
ISNULL(CFDIRetencionD.EstacionTrabajo, 0)			  'EstacionTrabajo',
ISNULL(CFDIRetencionD.ConceptoSAT, '')				    'ConceptoSAT',
ISNULL(CFDIRetSATRetencion.Complemento, '')      'Complemento',
ISNULL(Prov.CFDIRetTipoContribuyente, '')			  'ConceptoPago',
CASE ISNULL(Prov.CFDIRetBeneficiarioNombre, '')
WHEN '' THEN ''
ELSE ISNULL(Prov.CFDIRetTipoContribuyente, '')
END												                       'BConceptoPago',
CASE ISNULL(Prov.CFDIRetBeneficiarioNombre, '')
WHEN '' THEN CONVERT(char(30), '')
ELSE ISNULL(Prov.CFDIRetBeneficiarioCURP, '')
END												                       'CURP',
ISNULL(CFDIRetSATTipoContribuyente.Sujeto, '')		 'DescripcionConcepto',
CASE ISNULL(Prov.CFDIRetBeneficiarioNombre, '')
WHEN '' THEN ''
ELSE ISNULL(CFDIRetSATTipoContribuyente.Sujeto, '')
END												                        'BDescripcionConcepto',
CASE ISNULL(Prov.CFDIRetBeneficiarioNombre, '')
WHEN '' THEN 'SI'
ELSE 'NO'
END												                        'EsBenefEfectDelCobro',
CASE ISNULL(Prov.CFDIRetBeneficiarioNombre, '')
WHEN '' THEN ''
ELSE ISNULL(Prov.CFDIRetBeneficiarioNombre, '')
END												                        'NomDenRazSocB',
ISNULL(CFDIRetSATPais.Clave, '')					          'PaisDeResidParaEfecFisc',
CASE ISNULL(Prov.CFDIRetBeneficiarioNombre, '')
WHEN '' THEN ''
ELSE ISNULL(NULLIF(RTRIM(Prov.CFDIRetBeneficiarioRFC), ''), '')
END												                        'RFC',
ISNULL(CFDIRetencionCompXMLPlantilla.Version, '')	'Version'
FROM CFDIRetencionD
JOIN Empresa ON CFDIRetencionD.Empresa = Empresa.Empresa
JOIN Prov ON CFDIRetencionD.Proveedor = Prov.Proveedor
LEFT OUTER JOIN Pais ON Prov.Pais = Pais.Pais
LEFT OUTER JOIN CFDIRetSATPais ON Pais.CFDIRetClaveSat = CFDIRetSATPais.Clave
LEFT OUTER JOIN CFDIRetSATTipoContribuyente ON CFDIRetSATTipoContribuyente.Clave = Prov.CFDIRetTipoContribuyente
LEFT OUTER JOIN CFDIRetSATRetencion ON CFDIRetencionD.ConceptoSAT = CFDIRetSATRetencion.Clave
LEFT OUTER JOIN CFDIRetencionCompXMLPlantilla ON CFDIRetencionCompXMLPlantilla.Complemento = CFDIRetSATRetencion.Complemento
WHERE CFDIRetSATRetencion.Complemento = 'Extranjeros'

