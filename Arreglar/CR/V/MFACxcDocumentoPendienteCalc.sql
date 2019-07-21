SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFACxcDocumentoPendienteCalc
AS
SELECT
origen_tipo,
origen_modulo,
origen_id,
empresa,
emisor,
tipo_documento,
subtipo_documento,
folio,
ejercicio,
periodo,
dia,
fecha,
entidad_clave,
entidad_nombre,
entidad_rfc,
entidad_id_fiscal,
entidad_tipo_tercero,
entidad_tipo_operacion,
entidad_pais,
entidad_nacionalidad,
agente_clave,
agente_nombre,
concepto,
acumulable_deducible,
importe,
retencion_isr,
retencion_iva,
base_iva,
iva_excento,
iva_tasa,
iva,
base_ieps,
ieps_tasa,
ieps,
base_isan,
isan,
ieps_num_reporte,
ieps_categoria_concepto,
ieps_exento,
ieps_envase_reutilizable,
ieps_retencion,
ieps_cantidad,
ieps_unidad,
ieps_cantidad2,
ieps_unidad2,
importe_total,
concepto_clave,
concepto_es_importacion,
dinero,
dinero_id,
concepto_aplica_ietu,
concepto_aplica_ieps,
concepto_aplica_iva,
EsActivoFijo,
TipoActivo,
TipoActividad
FROM MFACxcDocumentoCalc
WHERE Estatus IN ('PENDIENTE','CONCLUIDO')

