SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFANominaDocumentoPreCalc AS
SELECT
Estatus                = c.Estatus,
origen_tipo            = 'auto',
origen_modulo          = 'NOM',
origen_id              = RTRIM(LTRIM(CONVERT(varchar,c.ID))),
empresa                = c.Empresa,
emisor                 = 'terceros',
tipo_documento         = CASE
WHEN mt.Clave IN ('CXP.AF','CXP.A') THEN 'anticipo'
WHEN mt.Clave IN ('CXP.CA','CXP.F','CXP.NC','CXP.CD','CXP.D') THEN 'factura'
WHEN mt.Clave IN ('CXP.CA') THEN 'nota_credito'
ELSE mtmda.DocumentoTipo
END,
subtipo_documento      = CONVERT(varchar(50),NULL),
folio                  = RTRIM(ISNULL(c.Mov,'')) + ' ' + RTRIM(ISNULL(c.MovID,'')),
ejercicio              = c.Ejercicio,
periodo                = c.Periodo,
dia                    = DAY(c.FechaEmision),
fecha					 = c.FechaEmision,
entidad_clave          = NULL,
entidad_nombre         = NULL,
entidad_rfc            = NULL,
entidad_id_fiscal      = NULL,
entidad_tipo_tercero   = NULL,
entidad_tipo_operacion = NULL,
entidad_pais           = NULL,
entidad_nacionalidad   = NULL,
agente_clave           = NULL,
agente_nombre          = NULL,
concepto               = ISNULL(c.Concepto,c.Mov),
acumulable_deducible   = 'Si',
importe                = (ISNULL(c.Percepciones, 0) - ISNULL(c.Deducciones, 0))*c.TipoCambio,
retencion_isr          = 0.0,
retencion_iva          = 0.0,
base_iva               = 0.0,
iva_excento            = 0.0,
iva_tasa               = 0.0,
iva                    = 0.0,
base_ieps              = 0.0,
ieps_tasa              = 0.0,
ieps                   = 0.0,
base_isan              = 0.0,
isan                   = 0.0,
ieps_num_reporte         = CONVERT(varchar(20),NULL),
ieps_categoria_concepto  = CONVERT(varchar(20),NULL),
ieps_exento              = 0,
ieps_envase_reutilizable = 0,
ieps_retencion           = NULL,
ieps_cantidad            = 0.0,
ieps_unidad              = CONVERT(varchar(50),NULL),
ieps_cantidad2           = 0.0,
ieps_unidad2             = CONVERT(varchar(50),NULL),
concepto_clave	       = c.Concepto,
concepto_es_importacion  = 0,
dinero				   = NULL,
dinero_id				   = NULL,
concepto_aplica_ietu     = 'Si',
concepto_aplica_ieps     = 'Si',
concepto_aplica_iva      = 'Si',
EsActivoFijo			   = 0,
TipoActivo			   = NULL,
TipoActividad			   = MFATipoActividad.Tipo
FROM Nomina c
JOIN MovTipo mt ON mt.Mov = c.Mov AND mt.Modulo = 'NOM'
JOIN EmpresaGral eg ON eg.Empresa = c.Empresa
LEFT OUTER JOIN Concepto co ON co.Concepto = c.Concepto AND co.Modulo = 'CXP'
JOIN Version ver ON 1 = 1
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'NOM' AND mme.ModuloID = c.ID
LEFT OUTER JOIN MovTipoMFADocExcepcion mtmde ON mtmde.Modulo = 'NOM' AND mtmde.Mov = c.Mov
LEFT OUTER JOIN MovTipoMFADocAdicion mtmda ON mtmda.Modulo = 'NOM' AND mtmda.Mov = c.Mov
LEFT OUTER JOIN MFATipoActividad ON MFATipoActividad.Modulo = 'NOM' AND MFATipoActividad.Mov = c.Mov
WHERE c.Estatus IN ('CONCLUIDO')
AND (mt.Clave IN ('NOM.N', 'NOM.NE') OR mtmda.Modulo IS NOT NULL)
AND mtmde.Mov IS NULL
AND mme.ModuloID IS NULL

