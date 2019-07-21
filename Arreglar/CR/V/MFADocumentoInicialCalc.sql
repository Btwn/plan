SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFADocumentoInicialCalc AS
SELECT
origen_tipo            = 'auto',
origen_modulo          = 'CXC',
origen_id              = RTRIM(LTRIM(CONVERT(varchar,0))),
empresa                = e.Empresa,
emisor                 = 'empresa',
tipo_documento         = 'factura',
subtipo_documento      = 'enajenacion',
folio                  = mdi.Descripcion,
ejercicio              = em.EjercicioInicial,
periodo                = em.PeriodoInicial,
dia                    = 1,
entidad_clave          = e.Empresa,
entidad_nombre         = e.Nombre,
entidad_rfc            = e.RFC,
entidad_id_fiscal      = e.RFC,
entidad_tipo_tercero   = 'nacional',
entidad_tipo_operacion = 'otros',
entidad_pais           = p.Pais,
entidad_nacionalidad   = p.Nacionalidad,
agente_clave           = 'N/A',
agente_nombre          = 'N/A',
concepto               = 'N/A',
acumulable_deducible   = 'Si',
importe                = 1.0,
retencion_isr          = 0.0,
retencion_iva          = 0.0,
base_iva               = 1.0,
iva_excento            = 0.0,
iva_tasa               = em.TasaImpuesto1Omision,
iva                    = 1.0 * (em.TasaImpuesto1Omision/100.0),
base_ieps              = 1.0,
ieps_tasa              = 0.0,
ieps                   = 0.0,
base_isan              = 0.0,
isan                   = 0.0,
importe_total          = 1.0 + (1.0 * (ISNULL(em.TasaImpuesto1Omision,0.0)/100.0)),
ieps_num_reporte         = CONVERT(varchar(20),null),
ieps_categoria_concepto  = CONVERT(varchar(20),null),
ieps_exento              = CONVERT(bit,0),
ieps_envase_reutilizable = CONVERT(bit,0),
ieps_retencion           = CONVERT(float,0.0),
ieps_cantidad            = CONVERT(float,0.0),
ieps_unidad              = CONVERT(varchar(50),0.0),
ieps_cantidad2           = CONVERT(float,0.0),
ieps_unidad2             = CONVERT(varchar(50),0.0),
dinero				   = CONVERT(varchar(20), NULL),
dinero_id				   = CONVERT(varchar(20), NULL),
concepto_aplica_ietu     = 'Si',
concepto_aplica_ieps     = 'Si',
concepto_aplica_iva      = 'Si',
EsActivoFijo			   = 0,
TipoActivo			   = NULL,
TipoActividad			   = NULL
FROM Empresa e
JOIN EmpresaMFA em ON em.Empresa = e.Empresa
JOIN MFADocumentosIniciales mdi ON 1 = 1
LEFT OUTER JOIN Pais pa ON pa.Clave = e.Pais
LEFT OUTER JOIN MFAPais p ON p.Pais = pa.Pais

