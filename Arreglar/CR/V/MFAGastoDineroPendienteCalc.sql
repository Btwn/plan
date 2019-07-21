SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFAGastoDineroPendienteCalc AS
SELECT
mgdpc.origen_tipo,
mgdpc.origen_modulo,
mgdpc.origen_id,
mgdpc.empresa,
mgdpc.emisor,
mgdpc.tipo_documento,
mgdpc.subtipo_documento,
mgdpc.folio,
mgdpc.ejercicio,
mgdpc.periodo,
mgdpc.dia,
mgdpc.fecha,
mgdpc.entidad_clave,
mgdpc.entidad_nombre,
mgdpc.entidad_rfc,
mgdpc.entidad_id_fiscal,
mgdpc.entidad_tipo_tercero,
mgdpc.entidad_tipo_operacion,
mgdpc.entidad_pais,
mgdpc.entidad_nacionalidad,
mgdpc.agente_clave,
mgdpc.agente_nombre,
mgdpc.concepto,
mgdpc.acumulable_deducible,
mgdpc.importe,
mgdpc.retencion_isr,
mgdpc.retencion_iva,
mgdpc.base_iva,
mgdpc.iva_excento,
mgdpc.iva_tasa,
mgdpc.iva,
mgdpc.base_ieps,
mgdpc.ieps_tasa,
mgdpc.ieps,
mgdpc.base_isan,
mgdpc.isan,
mgdpc.ieps_num_reporte,
mgdpc.ieps_categoria_concepto,
mgdpc.ieps_exento,
mgdpc.ieps_envase_reutilizable,
mgdpc.ieps_retencion,
mgdpc.ieps_cantidad,
mgdpc.ieps_unidad,
mgdpc.ieps_cantidad2,
mgdpc.ieps_unidad2,
ISNULL(importe,0.0) + ISNULL(iva,0.0) + ISNULL(ieps,0.0) + ISNULL(isan,0.0) - ISNULL(retencion_isr,0.0) - ISNULL(retencion_iva,0.0) 'importe_total',
mgdpc.concepto_clave,
mgdpc.concepto_es_importacion,
mgdpc.dinero,
mgdpc.dinero_id,
mgdpc.concepto_aplica_ietu,
mgdpc.concepto_aplica_ieps,
mgdpc.concepto_aplica_iva,
mgdpc.EsActivoFijo,
mgdpc.TipoActivo,
mgdpc.TipoActividad,
mgdpc.PorcentajeDeducible
FROM MFAGastoDineroPreCalc mgdpc
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'GAS' AND mme.ModuloID = mgdpc.ID
WHERE mme.ModuloID IS NULL

