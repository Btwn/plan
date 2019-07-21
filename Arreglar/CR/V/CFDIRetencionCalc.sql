SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDIRetencionCalc
AS
SELECT CFDIRetencionD.RID									  'RID',
CFDIRetencionD.Empresa								  'Empresa',
CFDIRetencionD.Proveedor							  'Proveedor',
ISNULL(CFDIRetencionD.EstacionTrabajo, 0)			  'EstacionTrabajo',
ISNULL(CFDIRetencionD.ConceptoSAT, '')				  'ConceptoSAT',
''													  'CURPE',
CASE Pais.CFDIRetClaveSat WHEN 'MX' THEN 'Nacional' ELSE 'Extranjero' END 'Nacionalidad',
CASE Pais.CFDIRetClaveSat WHEN 'MX' THEN ISNULL(Prov.CURP, '') ELSE '' END 'CURPR',
ISNULL(CFDIRetencionD.ConceptoSAT, '')				  'CveRetenc',
''													  'DescRetenc',
ISNULL(CFDIRetencionD.Ejerc, 0)					  'Ejerc',
CONVERT(varchar(19),DATEADD(mi, -1, GETDATE()), 126)+'-06:00' 'FechaExp',
ISNULL(CFDIRetencionD.FolioInt, '')				  'FolioInt',
ISNULL(CFDIRetencionD.MesFin, 0)					  'MesFin',
ISNULL(CFDIRetencionD.MesIni, 0)					  'MesIni',
CONVERT(varchar(max), CONVERT(money, ISNULL(CFDIRetencionD.montoTotExent, 0)))		'montoTotExent',
CONVERT(varchar(max), CONVERT(money, ISNULL(CFDIRetencionD.montoTotGrav, 0)))		'montoTotGrav',
CONVERT(varchar(max), CONVERT(money, ISNULL(CFDIRetencionD.montoTotOperacion, 0)))	'montoTotOperacion',
CONVERT(varchar(max), CONVERT(money, ISNULL(CFDIRetencionD.montoTotRet, 0)))		'montoTotRet',
ISNULL(Empresa.Nombre, '')							  'NomDenRazSocE',
CASE Pais.CFDIRetClaveSat WHEN 'MX' THEN ISNULL(Prov.Nombre, '') ELSE '' END 'NomDenRazSocR',
CASE WHEN UsarTimbrarRetencion = 1 THEN ISNULL(EmpresaCFD.noCertificado, '')	 ELSE ISNULL(EmpresaCFDRetencion.noCertificado, '')  END 'NumCert',
ISNULL(Empresa.RFC, '')							  'RFCEmisor',
CASE Pais.CFDIRetClaveSat WHEN 'MX' THEN ISNULL(Prov.RFC, '') ELSE '' END 'RFCRecep',
ISNULL(CFDIRetencionCfg.Version, '')				  'Version',
CASE Pais.CFDIRetClaveSat WHEN 'MX' THEN '' ELSE ISNULL(Prov.RFC, '')    END 'NumRegIdTrib',
CASE Pais.CFDIRetClaveSat WHEN 'MX' THEN '' ELSE ISNULL(Prov.Nombre, '') END 'ENomDenRazSocR'
FROM CFDIRetencionD
JOIN Empresa ON CFDIRetencionD.Empresa = Empresa.Empresa
JOIN Prov ON CFDIRetencionD.Proveedor = Prov.Proveedor
LEFT OUTER JOIN Pais ON Prov.Pais = Pais.Pais
JOIN EmpresaCFD ON Empresa.Empresa = EmpresaCFD.Empresa
JOIN EmpresaCFDRetencion  ON Empresa.Empresa = EmpresaCFDRetencion.Empresa
JOIN CFDIRetSATRetencion ON CFDIRetencionD.ConceptoSAT = CFDIRetSATRetencion.Clave
JOIN CFDIRetencionCfg ON 1=1

