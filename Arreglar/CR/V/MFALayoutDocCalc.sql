SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFALayoutDocCalc AS
SELECT
origen_tipo            = mld.origen_tipo,
origen_modulo          = ISNULL(mld.origen_modulo,mld.origen_tipo),
origen_id              = mld.origen_id,
empresa                = mld.empresa,
emisor                 = mld.emisor,
tipo_documento         = mld.tipo_documento,
subtipo_documento      = mld.subtipo_documento,
folio                  = mld.folio,
ejercicio              = YEAR(mld.fecha),
periodo                = MONTH(mld.fecha),
dia                    = DAY(mld.fecha),
fecha					 = mld.fecha,
entidad_clave          = mld.entidad_clave,
entidad_nombre         = me.entidad_clave,
entidad_rfc            = me.entidad_rfc,
entidad_id_fiscal      = me.entidad_rfc,
entidad_tipo_tercero   = me.entidad_tipo_tercero,
entidad_tipo_operacion = me.entidad_tipo_operacion,
entidad_pais           = me.entidad_pais,
entidad_nacionalidad   = me.entidad_nacionalidad,
agente_clave           = mld.agente_clave,
agente_nombre          = a.Nombre,
concepto               = mc.concepto_descripcion,
acumulable_deducible   = mldd.acumulable_deducible,
importe                = mldd.importe,
retencion_isr          = mldd.retencion_isr,
retencion_iva          = mldd.retencion_iva,
base_iva               = mldd.base_iva,
iva_excento            = mldd.iva_excento,
iva_tasa               = mldd.iva_tasa,
iva                    = mldd.iva,
base_ieps              = mldd.base_ieps,
ieps_tasa              = mldd.ieps_tasa,
ieps                   = mldd.ieps,
base_isan              = mldd.base_isan,
isan                   = mldd.isan,
ieps_num_reporte         = mldd.ieps_num_reporte,
ieps_categoria_concepto  = mldd.ieps_categoria_concepto,
ieps_exento              = mldd.ieps_exento,
ieps_envase_reutilizable = mldd.ieps_envase_reutilizable,
ieps_retencion           = mldd.ieps_retencion,
ieps_cantidad            = mldd.ieps_cantidad,
ieps_unidad              = mldd.ieps_unidad,
ieps_cantidad2           = mldd.ieps_cantidad2,
ieps_unidad2             = mldd.ieps_unidad2,
importe_total            = mldd.importe_total,
dinero				   = NULL,
dinero_id				   = NULL,
concepto_aplica_ietu     = ISNULL(NULLIF(mtmce.AplicaIetu,''), 'Si'),
concepto_aplica_ieps     = ISNULL(NULLIF(mtmce.AplicaIeps,''), 'Si'),
concepto_aplica_iva      = ISNULL(NULLIF(mtmce.AplicaIVA,''), 'Si'),
EsActivoFijo			   = 0,
TipoActivo			   = NULL,
TipoActividad			   = NULL
FROM MFALayoutDocumento mld
JOIN MFALayoutDocumentoD mldd ON mldd.DocumentoID = mld.DocumentoID
JOIN MFAEntidad me ON me.entidad_clave = mld.entidad_clave
LEFT OUTER JOIN Agente a ON a.Agente = mld.agente_clave
JOIN MFAConcepto mc ON mc.concepto_clave = mldd.concepto
LEFT OUTER JOIN MovTipoMFAConceptoExcepcion mtmce ON mc.concepto_clave = mtmce.Concepto

