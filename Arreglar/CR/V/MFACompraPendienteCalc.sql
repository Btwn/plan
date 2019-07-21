SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFACompraPendienteCalc AS
SELECT
mcc.origen_tipo,
mcc.origen_modulo,
mcc.origen_id,
mcc.empresa,
mcc.emisor,
mcc.tipo_documento,
mcc.subtipo_documento,
mcc.folio,
mcc.ejercicio,
mcc.periodo,
mcc.dia,
mcc.fecha,
mcc.entidad_clave,
mcc.entidad_nombre,
mcc.entidad_rfc,
mcc.entidad_id_fiscal,
mcc.entidad_tipo_tercero,
mcc.entidad_tipo_operacion,
mcc.entidad_pais,
mcc.entidad_nacionalidad,
mcc.agente_clave,
mcc.agente_nombre,
mcc.concepto,
mcc.acumulable_deducible,
mcc.importe,
mcc.retencion_isr,
mcc.retencion_iva,
mcc.base_iva,
mcc.iva_excento,
mcc.iva_tasa,
mcc.iva,
mcc.base_ieps,
mcc.ieps_tasa,
mcc.ieps,
mcc.base_isan,
mcc.isan,
mcc.ieps_num_reporte,
mcc.ieps_categoria_concepto,
mcc.ieps_exento,
mcc.ieps_envase_reutilizable,
mcc.ieps_retencion,
mcc.ieps_cantidad,
mcc.ieps_unidad,
mcc.ieps_cantidad2,
mcc.ieps_unidad2,
mcc.importe_total,
mcc.concepto_clave,
mcc.concepto_es_importacion,
mcc.dinero,
mcc.dinero_id,
mcc.concepto_aplica_ietu,
mcc.concepto_aplica_ieps,
mcc.concepto_aplica_iva,
mcc.EsActivoFijo,
mcc.TipoActivo,
mcc.TipoActividad,
mcc.BaseIVAImportacion
FROM MFACompraCalc mcc
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'COMS' AND mme.ModuloID = mcc.ID
WHERE mme.ModuloID IS NULL

