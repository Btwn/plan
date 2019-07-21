SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDIRetencionInteresesCalc
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
CFDIRetSATIntereses.SistFinanciero                 'SistFinanciero',
CFDIRetSATIntereses.RetiroAORESRetInt              'RetiroAORESRetInt',
CFDIRetSATIntereses.OperFinancDerivad              'OperFinancDerivad',
CFDIRetSATIntereses.MontIntNominal                 'MontIntNominal',
CFDIRetSATIntereses.MontIntReal                    'MontIntReal',
CFDIRetSATIntereses.Perdida                        'Perdida'
FROM CFDIRetencionD
JOIN Empresa ON CFDIRetencionD.Empresa = Empresa.Empresa
LEFT OUTER JOIN CFDIRetSATRetencion ON CFDIRetencionD.ConceptoSAT = CFDIRetSATRetencion.Clave
LEFT OUTER JOIN CFDIRetencionCompXMLPlantilla ON CFDIRetencionCompXMLPlantilla.Complemento = CFDIRetSATRetencion.Complemento
LEFT OUTER JOIN CFDIRetSATIntereses ON CFDIRetencionD.ModuloID = CFDIRetSATIntereses.ID
WHERE CFDIRetSATRetencion.Complemento = 'INTERESES'
AND CFDIRetencionD.Modulo = 'GAS'

