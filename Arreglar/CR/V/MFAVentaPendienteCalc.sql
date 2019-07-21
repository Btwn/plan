SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFAVentaPendienteCalc AS
SELECT
mvc.origen_tipo,
mvc.origen_modulo,
mvc.origen_id,
mvc.empresa,
mvc.emisor,
mvc.tipo_documento,
mvc.subtipo_documento,
mvc.folio,
mvc.ejercicio,
mvc.periodo,
mvc.dia,
mvc.fecha,
mvc.entidad_clave,
mvc.entidad_nombre,
mvc.entidad_rfc,
mvc.entidad_id_fiscal,
mvc.entidad_tipo_tercero,
mvc.entidad_tipo_operacion,
mvc.entidad_pais,
mvc.entidad_nacionalidad,
mvc.agente_clave,
mvc.agente_nombre,
mvc.concepto,
mvc.acumulable_deducible,
mvc.importe,
mvc.retencion_isr,
mvc.retencion_iva,
mvc.base_iva,
mvc.iva_excento,
mvc.iva_tasa,
mvc.iva,
mvc.base_ieps,
mvc.ieps_tasa,
mvc.ieps,
mvc.base_isan,
mvc.isan,
mvc.ieps_num_reporte,
mvc.ieps_categoria_concepto,
mvc.ieps_exento,
mvc.ieps_envase_reutilizable,
mvc.ieps_retencion,
mvc.ieps_cantidad,
mvc.ieps_unidad,
mvc.ieps_cantidad2,
mvc.ieps_unidad2,
mvc.importe_total,
mvc.concepto_clave,
mvc.concepto_es_importacion,
mvc.dinero,
mvc.dinero_id,
mvc.concepto_aplica_ietu,
mvc.concepto_aplica_ieps,
mvc.concepto_aplica_iva,
mvc.EsActivoFijo,
mvc.TipoActivo,
mvc.TipoActividad
FROM MFAVentaCalc mvc
JOIN MFAVentaPendientePreCalc mvppc ON mvppc.ID = mvc.ID
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'VTAS' AND mme.ModuloID = mvc.ID
WHERE mme.ModuloID IS NULL

