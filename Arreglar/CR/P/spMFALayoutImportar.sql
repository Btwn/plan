SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMFALayoutImportar
@Usuario						varchar(20),
@Empresa						varchar(5),
@Ejercicio					int,
@Periodo						int,
@FechaD						datetime	= NULL,
@FechaA						datetime	= NULL,
@EnSilencio					bit			= 0

AS BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE
@cmd				varchar(8000),
@with				varchar(255),
@moneda				varchar(10),
@PeriodoInicial		int,
@EjercicioInicial	int,
@log_id				int,
@CobrosConciliados	bit,
@PagosConciliados	bit,
@AnticiposPagadosPeriodo	bit,
@CxpAnticiposPagadosPeriodo	bit,
@IncluirNomina				bit,
@IFRS						bit,
@IncluirPolizasTesoreria	bit,
@IncluirNotasAnteriores		bit,
@IncluirPolizasNomina		bit,
@GASComprobantesPorConcepto	bit,
@DINDepositosAnticipados	bit,
@IncluirPolizasEspecificas	bit,
@ImportarFacturasContado	bit,
@ValidarReferencias			bit,
@Base						varchar(255),
@DefImpuesto				float,
@CxcChequesDevueltosNegativo bit,
@CxpChequesDevueltosNegativo bit,
@IncluirNotas				 bit
SELECT @Base = db_name()
SELECT @usuario = UPPER(@usuario)
SELECT @PeriodoInicial = PeriodoInicial,
@EjercicioInicial = EjercicioInicial,
@CobrosConciliados = NULLIF(CobrosConciliados, 0),
@PagosConciliados = NULLIF(PagosConciliados, 0),
@AnticiposPagadosPeriodo = ISNULL(AnticiposPagadosPeriodo, 0),
@CxpAnticiposPagadosPeriodo = ISNULL(CxpAnticiposPagadosPeriodo, 0),
@IncluirNomina = ISNULL(IncluirNomina, 0),
@IFRS = ISNULL(IFRS, 0),
@IncluirPolizasTesoreria = ISNULL(IncluirPolizasTesoreria, 0),
@IncluirNotasAnteriores = ISNULL(IncluirNotasAnteriores, 0),
@IncluirPolizasNomina = ISNULL(IncluirPolizasNomina, 0),
@GASComprobantesPorConcepto = ISNULL(GASComprobantesPorConcepto, 0),
@DINDepositosAnticipados = ISNULL(DINDepositosAnticipados, 0),
@IncluirPolizasEspecificas = ISNULL(IncluirPolizasEspecificas, 0),
@ImportarFacturasContado	= ISNULL(ImportarFacturasContado, 0),
@ValidarReferencias = ISNULL(ValidarReferencias, 0),
@CxcChequesDevueltosNegativo = ISNULL(CxcChequesDevueltosNegativo, 0),
@CxpChequesDevueltosNegativo = ISNULL(CxpChequesDevueltosNegativo, 0),
@IncluirNotas				  = ISNULL(IncluirNotas, 0)
FROM EmpresaMFA
WHERE Empresa = @Empresa
SELECT @moneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @DefImpuesto = ISNULL(DefImpuesto, 0) FROM EmpresaGral WHERE Empresa = @Empresa
TRUNCATE TABLE layout_documentos
TRUNCATE TABLE layout_aplicaciones
PRINT 'Al iniciar: ' + CONVERT(varchar,getdate(),126)
IF @Ejercicio = @EjercicioInicial AND @PeriodoInicial = @Periodo AND @FechaD IS NULL AND @FechaA IS NULL
BEGIN
PRINT 'Inicio Ejercicio y periodo inicial: ' + CONVERT(varchar,getdate(),126)
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,              EsActivoFijo, TipoActivo, TipoActividad,  fecha,  BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFADocumentoInicialCalc', EsActivoFijo, TipoActivo, TipoActividad, @FechaA, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), 100.0
FROM MFADocumentoInicialCalc WITH(NOLOCK)
WHERE ejercicio = @ejercicio
AND periodo = @periodo
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin Documentos iniciales (Q1): ' + CONVERT(varchar,getdate(),126)
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,            EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFAVentaPendienteCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), 100.0
FROM MFAVentaPendienteCalc WITH(NOLOCK)
WHERE ((ejercicio = @ejercicio AND periodo < @periodo) OR (ejercicio < @ejercicio))
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin Documentos periodos anteriores venta (Q2): ' + CONVERT(varchar,getdate(),126)
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,             EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFACompraPendienteCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), 100.0
FROM MFACompraPendienteCalc WITH(NOLOCK)
WHERE ((ejercicio = @ejercicio AND periodo < @periodo) OR (ejercicio < @ejercicio))
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin Documentos periodos anteriores compra (Q3): ' + CONVERT(varchar,getdate(),126)
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,               EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFAGastoCxpPendienteCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), PorcentajeDeducible
FROM MFAGastoCxpPendienteCalc WITH(NOLOCK)
WHERE ((ejercicio = @ejercicio AND periodo < @periodo) OR (ejercicio < @ejercicio))
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin Documentos periodos anteriores gasto Cxp (Q4): ' + CONVERT(varchar,getdate(),126)
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,               EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFAGastoCxcPendienteCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), PorcentajeDeducible
FROM MFAGastoCxcPendienteCalc WITH(NOLOCK)
WHERE ((ejercicio = @ejercicio AND periodo < @periodo) OR (ejercicio < @ejercicio))
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin Documentos periodos anteriores gasto Cxc (Q4): ' + CONVERT(varchar,getdate(),126)
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,                  EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFAGastoDineroPendienteCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), PorcentajeDeducible
FROM MFAGastoDineroPendienteCalc WITH(NOLOCK)
WHERE ((ejercicio = @ejercicio AND periodo < @periodo) OR (ejercicio < @ejercicio))
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin Documentos periodos anteriores gasto Dinero (Q4.1): ' + CONVERT(varchar,getdate(),126)
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,                   EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFACxcDocumentoPendienteCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), 100.0
FROM MFACxcDocumentoPendienteCalc WITH(NOLOCK)
WHERE ((ejercicio = @ejercicio AND periodo < @periodo) OR (ejercicio < @ejercicio))
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin Documentos periodos anteriores cxc (Q5): ' + CONVERT(varchar,getdate(),126)
IF @DINDepositosAnticipados = 1
BEGIN
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,                       EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFADineroAnticipadoDocumentoCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), 100.0
FROM MFADineroAnticipadoDocumentoCalc WITH(NOLOCK)
WHERE ((ejercicio = @ejercicio AND periodo < @periodo) OR (ejercicio < @ejercicio))
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin Documentos periodos anteriores Deposito Anticipado (Q5.1): ' + CONVERT(varchar,getdate(),126)
END
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,                   EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFACxpDocumentoPendienteCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), 100.0
FROM MFACxpDocumentoPendienteCalc WITH(NOLOCK)
WHERE ((ejercicio = @ejercicio AND periodo < @periodo) OR (ejercicio < @ejercicio))
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin Documentos periodos anteriores cxp (Q6): ' + CONVERT(varchar,getdate(),126)
IF @IncluirNomina = 1
BEGIN
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,                         EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFANominaCxpDocumentoPendienteCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), 100.0
FROM MFANominaCxpDocumentoPendienteCalc WITH(NOLOCK)
WHERE ((ejercicio = @ejercicio AND periodo < @periodo) OR (ejercicio < @ejercicio))
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin Documentos de Nomina periodos anteriores cxp (Q6.1): ' + CONVERT(varchar,getdate(),126)
END
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,       fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFACxcEndosoCalc', fecha
FROM MFACxcEndosoCalc WITH(NOLOCK)
WHERE ((ejercicio = @ejercicio AND periodo < @periodo) OR (ejercicio < @ejercicio))
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin endoso periodos anteriores cxc (Q7): ' + CONVERT(varchar,getdate(),126)
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,       fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFACxpEndosoCalc', fecha
FROM MFACxpEndosoCalc WITH(NOLOCK)
WHERE ((ejercicio = @ejercicio AND periodo < @periodo) OR (ejercicio < @ejercicio))
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin endoso periodos anteriores cxp (Q8): ' + CONVERT(varchar,getdate(),126)
IF @IFRS = 1 AND @IncluirPolizasNomina = 1
BEGIN
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, EsIFRS, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,             EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, 1,      concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFANominaDocumentoCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), 100.0
FROM MFANominaDocumentoCalc WITH(NOLOCK)
WHERE ((ejercicio = @ejercicio AND periodo < @periodo) OR (ejercicio < @ejercicio))
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin documentos Nomina (Q14.1): ' + CONVERT(varchar,getdate(),126)
END
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,                fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFACxcRedocumentacionCalc', fecha
FROM MFACxcRedocumentacionCalc WITH(NOLOCK)
WHERE ((ejercicio = @ejercicio AND periodo < @periodo) OR (ejercicio < @ejercicio))
AND empresa = @empresa
EXEC spShrink_Log @Base
IF @CxcChequesDevueltosNegativo = 1
BEGIN
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,               EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva, PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFACxcChequeDevueltoCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  0,        100.0
FROM MFACxcChequeDevueltoCalc WITH(NOLOCK)
WHERE ((ejercicio = @ejercicio AND periodo < @periodo) OR (ejercicio < @ejercicio))
AND empresa = @empresa
EXEC spShrink_Log @Base
END
IF @CxpChequesDevueltosNegativo = 1
BEGIN
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,               EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva, PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFACxpChequeDevueltoCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  0,        100.0
FROM MFACxpChequeDevueltoCalc WITH(NOLOCK)
WHERE ((ejercicio = @ejercicio AND periodo < @periodo) OR (ejercicio < @ejercicio))
AND empresa = @empresa
EXEC spShrink_Log @Base
END
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,                fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFACxpRedocumentacionCalc', fecha
FROM MFACxpRedocumentacionCalc WITH(NOLOCK)
WHERE ((ejercicio = @ejercicio AND periodo < @periodo) OR (ejercicio < @ejercicio))
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin Ejercicio y periodo inicial: : ' + CONVERT(varchar,getdate(),126)
IF @IncluirNotasAnteriores = 1
BEGIN
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,  EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFANotaCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), 100.0
FROM MFANotaCalc WITH(NOLOCK)
WHERE ((ejercicio = @ejercicio AND periodo < @periodo) OR (ejercicio < @ejercicio))
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin Notas periodos anteriores (Q8.1): ' + CONVERT(varchar,getdate(),126)
END
END
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, importe_total, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,       EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, importe_total, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFALayoutDocCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), 100.0
FROM MFALayoutDocCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin documentos manuales (Q9): ' + CONVERT(varchar,getdate(),126)
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,   EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFAVentaCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), 100.0
FROM MFAVentaCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin documentos ventas (Q10): ' + CONVERT(varchar,getdate(),126)
IF @ImportarFacturasContado = 1
BEGIN
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,          EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFAVentaContadoCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), 100.0
FROM MFAVentaContadoCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin documentos ventas contado (Q10.1): ' + CONVERT(varchar,getdate(),126)
END
IF @IncluirNotas = 0
BEGIN
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,  EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFANotaCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), 100.0
FROM MFANotaCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin documentos notas (Q10.5): ' + CONVERT(varchar,getdate(),126)
END
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,    EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFACompraCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), 100.0
FROM MFACompraCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin documentos compras (Q11): ' + CONVERT(varchar,getdate(),126)
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,   EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFAGastoCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), PorcentajeDeducible
FROM MFAGastoCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin documentos gastos (Q12): ' + CONVERT(varchar,getdate(),126)
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,          EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFACxcDocumentoCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), 100.0
FROM MFACxcDocumentoCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin documentos cxc (Q13): ' + CONVERT(varchar,getdate(),126)
IF @DINDepositosAnticipados = 1
BEGIN
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,                       EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFADineroAnticipadoDocumentoCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), 100.0
FROM MFADineroAnticipadoDocumentoCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin Documentos Deposito Anticipado (Q13.1): ' + CONVERT(varchar,getdate(),126)
END
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,          EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFACxpDocumentoCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), 100.0
FROM MFACxpDocumentoCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin documentos cxp (Q14): ' + CONVERT(varchar,getdate(),126)
IF @IFRS = 1 AND @IncluirPolizasNomina = 1
BEGIN
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, EsIFRS, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,             EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, 1,      concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFANominaDocumentoCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), 100.0
FROM MFANominaDocumentoCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin documentos Nomina (Q14.1): ' + CONVERT(varchar,getdate(),126)
END
IF @IncluirNomina = 1
BEGIN
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,                EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva,                                                 PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFANominaCxpDocumentoCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  dbo.fnMFAIEPSIVA(@Empresa, @DefImpuesto, iva_tasa, ieps), 100.0
FROM MFANominaCxpDocumentoCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin documentos Nomina cxp (Q14.1): ' + CONVERT(varchar,getdate(),126)
END
IF @CxcChequesDevueltosNegativo = 1
BEGIN
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,               EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva, PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFACxcChequeDevueltoCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  0,        100.0
FROM MFACxcChequeDevueltoCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,                    fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFACxcChequeDevueltoCobroCalc', fecha
FROM MFACxcChequeDevueltoCobroCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
END
IF @CxpChequesDevueltosNegativo = 1
BEGIN
INSERT layout_documentos(origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, origen_vista,               EsActivoFijo, TipoActivo, TipoActividad, fecha, BaseIVAImportacion, ieps_iva, PorcentajeDeducible)
SELECT origen_tipo, origen_modulo, origen_id, empresa, emisor, tipo_documento, subtipo_documento, folio, ejercicio, periodo, dia, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad, agente_clave, agente_nombre, concepto, acumulable_deducible, importe, retencion_isr, retencion_iva, base_iva, iva_excento, iva_tasa, iva, base_ieps, ieps_tasa, ieps, base_isan, isan, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_retencion, ieps_cantidad, ieps_unidad, ieps_cantidad2, ieps_unidad2, importe_total, concepto_clave, concepto_es_importacion, dinero, dinero_id, concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva, 'MFACxpChequeDevueltoCalc', EsActivoFijo, TipoActivo, TipoActividad, fecha, 0,                  0,        100.0
FROM MFACxpChequeDevueltoCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,                    fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFACxpChequeDevueltoPagoCalc', fecha
FROM MFACxpChequeDevueltoPagoCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
END
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,              fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFALayoutAplicacionCalc', fecha
FROM MFALayoutAplicacionCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin aplicaciones manuales (Q15): ' + CONVERT(varchar,getdate(),126)
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,           fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFACxcAplicacionCalc', fecha
FROM MFACxcAplicacionCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin aplicaciones cxc (Q16): ' + CONVERT(varchar,getdate(),126)
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,       fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFACxcEndosoCalc', fecha
FROM MFACxcEndosoCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin endosos cxc (Q17): ' + CONVERT(varchar,getdate(),126)
IF @DINDepositosAnticipados = 0
BEGIN
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,      fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFACxcCobroCalc', fecha
FROM MFACxcCobroCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND ISNULL(@CobrosConciliados, conciliado) = conciliado
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin cobros cxc (Q18): ' + CONVERT(varchar,getdate(),126)
END
ELSE
BEGIN
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,                   fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFACxcCobroSinAnticipadoCalc', fecha
FROM MFACxcCobroSinAnticipadoCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo = ISNULL(@periodo, periodo)
AND fecha >= ISNULL(@FechaD, fecha)
AND fecha <= ISNULL(@FechaA, fecha)
AND ISNULL(@CobrosConciliados, conciliado) = conciliado
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin cobros cxc (Q18): ' + CONVERT(varchar,getdate(),126)
END
IF @DINDepositosAnticipados = 1
BEGIN
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,                   fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFADineroAnticipadoCobroCalc', fecha
FROM MFADineroAnticipadoCobroCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND ISNULL(@CobrosConciliados, conciliado) = conciliado
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin cobros cxc (Q18): ' + CONVERT(varchar,getdate(),126)
END
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,     fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFACxcPagoCalc', fecha
FROM MFACxcPagoCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND ISNULL(@PagosConciliados, conciliado) = conciliado
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin pagos cxc (Q19): ' + CONVERT(varchar,getdate(),126)
IF @ImportarFacturasContado = 1
BEGIN
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,              fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFAVentaContadoPagoCalc', fecha
FROM MFAVentaContadoPagoCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND ISNULL(@PagosConciliados, conciliado) = conciliado
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin pagos Ventas Contado  (Q19.1): ' + CONVERT(varchar,getdate(),126)
END
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,                fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFACxcRedocumentacionCalc', fecha
FROM MFACxcRedocumentacionCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin redocumentacion cxc (Q20): ' + CONVERT(varchar,getdate(),126)
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,           fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFACxpAplicacionCalc', fecha
FROM MFACxpAplicacionCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin aplicaciones cxp (Q21): ' + CONVERT(varchar,getdate(),126)
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,       fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFACxpEndosoCalc', fecha
FROM MFACxpEndosoCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin endosos cxp (Q22): ' + CONVERT(varchar,getdate(),126)
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,     fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFACxpPagoCalc', fecha
FROM MFACxpPagoCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND ISNULL(@PagosConciliados, conciliado) = conciliado
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin pagos cxp (Q23): ' + CONVERT(varchar,getdate(),126)
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,      fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFACxpCobroCalc', fecha
FROM MFACxpCobroCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND ISNULL(@CobrosConciliados, conciliado) = conciliado
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin cobros cxp (Q24): ' + CONVERT(varchar,getdate(),126)
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,                fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFACxpRedocumentacionCalc', fecha
FROM MFACxpRedocumentacionCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin redocumentacion cxp (Q25): ' + CONVERT(varchar,getdate(),126)
IF @GASComprobantesPorConcepto = 0
BEGIN
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,       fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFAGastoPagoCalc', fecha
FROM MFAGastoPagoCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND ISNULL(@PagosConciliados, conciliado) = conciliado
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin GastosComprobante (Q30): ' + CONVERT(varchar,getdate(),126)
END
ELSE IF @GASComprobantesPorConcepto = 1
BEGIN
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,               fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFAGastoConceptoPagoCalc', fecha
FROM MFAGastoConceptoPagoCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND ISNULL(@PagosConciliados, conciliado) = conciliado
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin Gastos Concepto Comprobante (Q30.1): ' + CONVERT(varchar,getdate(),126)
END
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,             fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFAGastoDineroPagoCalc', fecha
FROM MFAGastoDineroPagoCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND ISNULL(@PagosConciliados, conciliado) = conciliado
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin Pagos Gastos sin Cxc ni Cxp (Q30.1): ' + CONVERT(varchar,getdate(),126)
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,     fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFACrCobroCalc', fecha
FROM MFACrCobroCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin cobros notas (Q26): ' + CONVERT(varchar,getdate(),126)
IF @CxpAnticiposPagadosPeriodo  = 1
BEGIN
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,       fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFACxpDineroCalc', fecha
FROM MFACxpDineroCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND ISNULL(@PagosConciliados, conciliado) = conciliado
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin Anticipos Pagados Cxp (Q31): ' + CONVERT(varchar,getdate(),126)
END
IF @AnticiposPagadosPeriodo  = 1
BEGIN
INSERT layout_aplicaciones(origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, origen_vista,       fecha)
SELECT origen_tipo, origen_modulo, origen_id, empresa, tipo_aplicacion, folio, ejercicio, periodo, dia, referencia, importe, cuenta_bancaria, aplica_ieps, aplica_ietu, aplica_iva, dinero, dinero_id, tipo_documento, 'MFACxcDineroCalc', fecha
FROM MFACxcDineroCalc WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND ISNULL(@PagosConciliados, conciliado) = conciliado
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin Anticipos Pagados Cxp (Q32): ' + CONVERT(varchar,getdate(),126)
END
IF @IFRS = 1 AND @IncluirPolizasTesoreria = 1
BEGIN
INSERT layout_aplicaciones(origen_tipo,   origen_modulo,   origen_id,   empresa,   tipo_aplicacion,   folio,   ejercicio,   periodo,   dia,   referencia,   importe,   cuenta_bancaria,   aplica_ieps,   aplica_ietu,   aplica_iva,     dinero,   dinero_id,   EsIFRS, tipo_documento, origen_vista,  fecha)
SELECT m.origen_tipo, m.origen_modulo, m.origen_id, m.empresa, m.tipo_aplicacion, m.folio, m.ejercicio, m.periodo, m.dia, m.referencia, m.importe, m.cuenta_bancaria, m.aplica_ieps, m.aplica_ietu, m.aplica_iva, m.dinero, m.dinero_id, 1,      tipo_documento, 'MFADineroCalc', fecha
FROM MFADineroCalc m WITH(NOLOCK)
WHERE ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND empresa = @empresa
EXEC spShrink_Log @Base
PRINT 'Fin Polizas Aplicaciones Tesorería (Q33): ' + CONVERT(varchar,getdate(),126)
END
EXEC spInsertarLayoutAplicacionEntidad @Empresa
EXEC spShrink_Log @Base
PRINT 'Fin cobros notas (Q26.5): ' + CONVERT(varchar,getdate(),126)
EXEC spMFAAplicacionesAgregarAplicacionCuenta @Empresa
IF @IFRS = 1
BEGIN
EXEC spMFAContBalanzaCfg @Empresa, @Ejercicio, @Periodo, @FechaD, @FechaA
EXEC spShrink_Log @Base
END
EXEC spMFADocumentosAgregarDocumentoCuenta @IFRS, @IncluirPolizasEspecificas, @Empresa
/*
EXEC spMFADocumentosAgregarCuenta
PRINT 'Fin agregar cuenta (Q26.5): ' + CONVERT(varchar,getdate(),126)
*/
EXEC sp_layout_importar_aplicaciones @usuario, @Empresa
EXEC spShrink_Log @Base
PRINT 'Fin importar aplicaciones (Q27): ' + CONVERT(varchar,getdate(),126)
EXEC sp_layout_importar_documentos @usuario, @Empresa
EXEC spShrink_Log @Base
PRINT 'Fin importar documentos (Q28): ' + CONVERT(varchar,getdate(),126)
EXEC @log_id = sp_layout_procesar @Usuario, @Empresa, @Ejercicio, @Periodo, 'flujo', @FechaD, @FechaA, @IFRS, @ValidarReferencias
EXEC spShrink_Log @Base
PRINT 'Fin procesamiento (Q29): ' + CONVERT(varchar,getdate(),126)
IF @EnSilencio = 0
BEGIN
SELECT * FROM layout_log WHERE log_id = @log_id
SELECT * FROM layout_logd WHERE log_id = @log_id
END
RETURN @log_id
END

