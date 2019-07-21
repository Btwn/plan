SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFAGastoCxpPendienteCalc AS
SELECT
mgc.origen_tipo,
mgc.origen_modulo,
mgc.origen_id,
mgc.empresa,
mgc.emisor,
mgc.tipo_documento,
mgc.subtipo_documento,
mgc.folio,
mgc.ejercicio,
mgc.periodo,
mgc.dia,
mgc.fecha,
mgc.entidad_clave,
mgc.entidad_nombre,
mgc.entidad_rfc,
mgc.entidad_id_fiscal,
mgc.entidad_tipo_tercero,
mgc.entidad_tipo_operacion,
mgc.entidad_pais,
mgc.entidad_nacionalidad,
mgc.agente_clave,
mgc.agente_nombre,
mgc.concepto,
mgc.acumulable_deducible,
mgc.importe,
mgc.retencion_isr,
mgc.retencion_iva,
mgc.base_iva,
mgc.iva_excento,
mgc.iva_tasa,
mgc.iva,
mgc.base_ieps,
mgc.ieps_tasa,
mgc.ieps,
mgc.base_isan,
mgc.isan,
mgc.ieps_num_reporte,
mgc.ieps_categoria_concepto,
mgc.ieps_exento,
mgc.ieps_envase_reutilizable,
mgc.ieps_retencion,
mgc.ieps_cantidad,
mgc.ieps_unidad,
mgc.ieps_cantidad2,
mgc.ieps_unidad2,
mgc.importe_total,
mgc.concepto_clave,
mgc.concepto_es_importacion,
mgc.dinero,
mgc.dinero_id,
mgc.concepto_aplica_ietu,
mgc.concepto_aplica_ieps,
mgc.concepto_aplica_iva,
mgc.EsActivoFijo,
mgc.TipoActivo,
mgc.TipoActividad,
mgc.PorcentajeDeducible
FROM MFAGastoCalc mgc
JOIN MFAGastoCxpPendientePreCalc mgppc ON mgppc.ID = mgc.ID
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'GAS' AND mme.ModuloID = mgc.ID
WHERE mme.ModuloID IS NULL

