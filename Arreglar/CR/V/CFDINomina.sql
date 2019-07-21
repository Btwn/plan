SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDINomina

AS
SELECT n.ID,
d.Personal,
pl.VersionComprobante					'version',
CONVERT(varchar(19),DATEADD(mi, -1, GETDATE()), 126) 'fecha',
ISNULL(m.TipoComprobante, '')			'tipoDeComprobante',
'Pago en una sola exhibicion'			'formaDePago',
'CONTADO'								'condicionesDePago',
fp.ClaveSAT + CASE WHEN d.FormaPagoVales	IS NOT NULL THEN ','+d.FormaPagoVales ELSE '' END  'metodoDePago',
CONVERT(varchar(max), CONVERT(money, ISNULL(d.TotalPercepciones, 0))) 'subTotal',
CONVERT(varchar(max), CONVERT(money, ISNULL(d.TotalDeduccionesSinISR, 0))) 'descuento',
'Deducciones nomina'						'motivoDescuento',
ISNULL(n.TipoCambio, 1)					'TipoCambio',
ISNULL(mon.Clave, 'MXN')					'Moneda',
CONVERT(varchar(max), CONVERT(money, ISNULL(d.TotalPercepciones, 0) - ISNULL(d.TotalDeduccionesSinISR, 0) - ISNULL(d.TotalDescuento, 0))) 'total',
ISNULL(s.Poblacion, '')					'LugarExpedicion',
ISNULL(e.RFC, '')						'EmisorRFC',
ISNULL(REPLACE(e.Nombre, '"', ''), '')	'EmisorNombre',
ISNULL(e.Direccion, '')					'DomFiscalCalle',
ISNULL(e.DireccionNumero, '0')			'DomFiscalNoExterior',
ISNULL(e.DireccionNumeroInt, '0')		'DomFiscalNoInterior',
ISNULL(e.Colonia, '')					'DomFiscalColonia',
ISNULL(e.Poblacion, '')					'DomFiscalLocalidad',
ISNULL(e.Delegacion, '')					'DomFiscalMunicipio',
ISNULL(e.Estado, '')						'DomFiscalEstado',
ISNULL(e.Pais, '')						'DomFiscalPais',
ISNULL(e.CodigoPostal, '00000')			'DomFiscalCP',
ISNULL(e.FiscalRegimen, '')				'RegimenFiscal',
ISNULL(s.Direccion, '')					'ExpedidoEnCalle',
ISNULL(s.DireccionNumero, '0')			'ExpedidoEnNoExterior',
ISNULL(s.DireccionNumeroInt, '0')		'ExpedidoEnNoInterior',
ISNULL(s.Colonia, '')					'ExpedidoEnColonia',
ISNULL(s.Poblacion, '')					'ExpedidoEnLocalidad',
ISNULL(s.Delegacion, '')					'ExpedidoEnMunicipio',
ISNULL(s.Estado, '')						'ExpedidoEnEstado',
ISNULL(s.Pais, '')						'ExpedidoEnPais',
ISNULL(s.CodigoPostal, '00000')			'ExpedidoEnCP',
ISNULL(p.Registro2, '')					'ReceptorRFC',
ISNULL(p.Nombre, '')+' '+ISNULL(p.ApellidoPaterno, '')+' '+ISNULL(p.ApellidoMaterno, '') 'ReceptorNombre',
ISNULL(p.Direccion, '')					'ReceptorCalle',
ISNULL(p.DireccionNumero, '0')			'ReceptorNoExterior',
ISNULL(p.DireccionNumeroInt, '0')		'ReceptorNoInterior',
ISNULL(p.Colonia, '')					'ReceptorColonia',
ISNULL(p.Poblacion, '')					'ReceptorLocalidad',
ISNULL(p.Delegacion, '')					'ReceptorMunicipio',
ISNULL(p.Estado, '')						'ReceptorEstado',
ISNULL(p.Pais, '')						'ReceptorPais',
ISNULL(p.CodigoPostal, '00000')			'ReceptorCP',
1.0										'ConceptoCantidad',
'SERVICIO'								'ConceptoUnidad',
''										'ConceptonoIdentificacion',
'PAGO DE NOMINA'							'ConceptoDescripcion',
CONVERT(varchar(max), CONVERT(money, ISNULL(d.TotalPercepciones, 0))) 'ConceptovalorUnitario',
CONVERT(varchar(max), CONVERT(money, ISNULL(d.TotalPercepciones, 0))) 'Conceptoimporte',
CONVERT(varchar(max), CONVERT(money, ISNULL(d.TotalDescuento, 0))) 'ImpuestoTotalRetenido',
0.0										'ImpuestoTotalTrasladado',
CASE WHEN usarTimbrarnomina = 1 THEN ISNULL(ecfdn.noCertificado, '')	 ELSE ISNULL(ecfd.noCertificado, '')  END 'noCertificado',
ISNULL(ct.CLABE, '')                     'NumCtaPago'
FROM Nomina n
JOIN CFDINominaRecibo d ON n.ID = d.ID
JOIN Empresa e ON n.Empresa = e.Empresa
JOIN Sucursal s ON n.Sucursal = s.Sucursal
JOIN CFDINominaMov m ON n.Mov = m.Mov
LEFT OUTER JOIN EmpresaCFD ecfd ON e.Empresa = ecfd.Empresa
LEFT OUTER JOIN EmpresaCFDNomina ecfdn ON e.Empresa = ecfdn.Empresa
LEFT OUTER JOIN CFDINominaXMLPlantilla pl ON m.Version = pl.Version
JOIN Personal p ON d.Personal = p.Personal
LEFT OUTER JOIN CtaDinero ct ON p.CtaDinero = ct.CtaDinero
JOIN Mon ON n.Moneda = Mon.Moneda
LEFT OUTER JOIN FormaPago fp ON fp.FormaPago = d.FormaPago

