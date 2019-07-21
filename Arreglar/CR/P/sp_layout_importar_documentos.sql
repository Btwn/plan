SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sp_layout_importar_documentos
@usuario	varchar(20),
@Empresa	varchar(5) = NULL

AS BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE
@log_id				int,
@error				int,
@error_mensaje		varchar(255),
@conteo				int,
@ejercicio			smallint,
@periodo			smallint,
@Base				varchar(255)
SELECT @error			= NULL,
@error_mensaje = NULL,
@conteo		= 0
SELECT @usuario = UPPER(@usuario)
SELECT @Base = db_name()
EXEC sp_layout_log_in @usuario, 'importar documentos', 'importando', @Empresa, @log_id OUTPUT
SELECT empresa, fecha, origen_vista
INTO #fecha
FROM layout_documentos
WHERE Empresa = ISNULL(@Empresa, Empresa)
GROUP BY empresa, fecha, origen_vista
DELETE a
FROM documentos a
JOIN #fecha e ON a.empresa = e.empresa AND a.fecha = e.fecha AND a.origen_vista = e.origen_vista
EXEC spShrink_Log @Base
INSERT INTO documentos (
log_id,
origen_tipo, origen_modulo, origen_id,
empresa, emisor, tipo_documento, folio,
ejercicio, periodo, dia,
entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, entidad_cuenta_contable,
concepto, concepto_cuenta_contable, acumulable_deducible,
importe, retencion_isr, retencion_iva,
base_iva, iva_excento, iva_tasa, iva,
base_ieps, ieps_tasa, ieps, base_isan, isan,
base_otros_impuestos, otros_impuestos_tasa, otros_impuestos, otros_impuestos_tipo, otros_impuestos_cuenta_contable,
importe_total,
referencia,
ieps_num_reporte,
ieps_categoria_concepto,
ieps_exento,
ieps_envase_reutilizable,
ieps_retencion,
ieps_cantidad,
ieps_unidad,
ieps_cantidad2,
ieps_unidad2,
subtipo_documento,
concepto_clave,
concepto_es_importacion,
concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva,
EsActivoFijo, TipoActivo, TipoActividad,
fecha,
BaseIVAImportacion,
ieps_iva,
origen_vista,
PorcentajeDeducible
)
SELECT @log_id,
origen_tipo, origen_modulo, origen_id,
UPPER(empresa), LOWER(emisor), LOWER(tipo_documento), UPPER(folio),
ejercicio, periodo, dia,
UPPER(entidad_clave), entidad_nombre, UPPER(entidad_rfc), UPPER(entidad_id_fiscal), LOWER(entidad_tipo_tercero), LOWER(entidad_tipo_operacion), UPPER(entidad_pais), entidad_nacionalidad,	entidad_cuenta_contable,
concepto, concepto_cuenta_contable, acumulable_deducible,
importe, retencion_isr, retencion_iva,
base_iva, ISNULL(iva_excento, 0), iva_tasa, iva,
base_ieps, ieps_tasa, ieps, base_isan, isan,
base_otros_impuestos, otros_impuestos_tasa, otros_impuestos, otros_impuestos_tipo, otros_impuestos_cuenta_contable,
importe_total,
UPPER(folio),
ieps_num_reporte,
ieps_categoria_concepto,
ieps_exento,
ieps_envase_reutilizable,
ieps_retencion,
ieps_cantidad,
ieps_unidad,
ieps_cantidad2,
ieps_unidad2,
subtipo_documento,
concepto_clave,
concepto_es_importacion,
concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva,
EsActivoFijo, TipoActivo, TipoActividad,
fecha,
BaseIVAImportacion,
ieps_iva,
origen_vista,
ISNULL(PorcentajeDeducible, 100)
FROM layout_documentos
WHERE EsIFRS = 0
AND Empresa = ISNULL(@Empresa, Empresa)
SELECT @conteo = @conteo + @@ROWCOUNT
EXEC sp_layout_log_out @log_id, @conteo, @error, @error_mensaje
RETURN
END

