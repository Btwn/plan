SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sp_layout_aplicaciones
@log_id				int,
@empresa			varchar(5),
@ejercicio			smallint,
@periodo			smallint,
@conteo_documentos	int			OUTPUT,
@FechaD				datetime	= NULL,
@FechaA				datetime	= NULL

AS BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE
@folio_id				int,
@referencia_id			int,
@aplicacion_id			int,
@folio					varchar(50),
@referencia				varchar(50),
@tipo_aplicacion		varchar(50),
@tipo_documento			varchar(50),
@importe				float,
@importe_total			float,
@factor					float,
@entidad_clave          varchar(20),
@entidad_nombre         varchar(150),
@entidad_rfc            varchar(15),
@entidad_id_fiscal      varchar(50),
@entidad_tipo_tercero   varchar(50),
@entidad_tipo_operacion varchar(50),
@entidad_pais           varchar(20),
@entidad_nacionalidad   varchar(50),
@origen_modulo			varchar(50),
@EsRedocumentacion		bit,
@Base					varchar(255),
@EjercicioAux			int,
@EjercicioAuxAnt		int,
@PeriodoAux				int,
@PeriodoAuxAnt			int
CREATE TABLE #Valida(RID int IDENTITY, empresa varchar(5), origen_modulo varchar(50) NULL, folio varchar(50) NULL)
CREATE INDEX Valida ON #Valida(empresa, origen_modulo, folio)
SELECT @Base = db_name()
/*
SELECT @EjercicioAuxAnt = 0
WHILE(1=1)
BEGIN
SELECT @EjercicioAux = MIN(Ejercicio)
FROM aplicaciones
WHERE empresa = @Empresa
AND tipo_aplicacion IN ('aplicacion', 'redocumentacion')
AND Ejercicio > @EjercicioAuxAnt
IF @EjercicioAux IS NULL BREAK
SELECT @EjercicioAuxAnt = @EjercicioAux
SELECT @PeriodoAuxAnt = 0
WHILE(1=1)
BEGIN
SELECT @PeriodoAux = MIN(Periodo)
FROM aplicaciones
WHERE empresa = @Empresa
AND tipo_aplicacion IN ('aplicacion', 'redocumentacion')
AND Ejercicio = @EjercicioAux
AND Periodo > @PeriodoAuxAnt
IF @PeriodoAux IS NULL BREAK
SELECT @PeriodoAuxAnt = @PeriodoAux
DELETE documentos WHERE ISNULL(EsRedocumentacion, 0) = 1 and empresa = @empresa AND Ejercicio = @EjercicioAux AND Periodo = @PeriodoAux
EXEC spShrink_Log @Base
END
END
*/
DECLARE cr_aplicaciones CURSOR LOCAL STATIC FOR
SELECT a.aplicacion_id, a.tipo_aplicacion, a.folio, a.referencia, ISNULL(a.importe, 0.0), lae.entidad_clave, lae.entidad_nombre, lae.entidad_rfc, lae.entidad_id_fiscal, lae.entidad_tipo_tercero, lae.entidad_tipo_operacion, lae.entidad_pais, lae.entidad_nacionalidad, a.origen_modulo
FROM aplicaciones a
LEFT OUTER JOIN layout_aplicacion_entidad lae ON lae.folio = a.folio AND lae.referencia = a.referencia AND lae.empresa = a.empresa
WHERE a.empresa = @empresa
AND a.tipo_aplicacion IN ('aplicacion', 'redocumentacion')
ORDER BY dia
OPEN cr_aplicaciones
FETCH NEXT FROM cr_aplicaciones INTO @aplicacion_id, @tipo_aplicacion, @folio, @referencia, @importe, @entidad_clave, @entidad_nombre, @entidad_rfc, @entidad_id_fiscal, @entidad_tipo_tercero, @entidad_tipo_operacion, @entidad_pais, @entidad_nacionalidad, @origen_modulo
WHILE @@FETCH_STATUS <> -1 AND @@ERROR = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @importe_total = 0.0, @factor = 0.0, @tipo_documento = NULL
IF NOT EXISTS(SELECT RID FROM #Valida WHERE empresa = @empresa AND origen_modulo = @origen_modulo AND folio = @folio)
BEGIN
INSERT INTO #Valida(empresa, origen_modulo, folio) SELECT @empresa, @origen_modulo, @folio
IF EXISTS(SELECT TOP 1 documento_id FROM documentos WHERE empresa = @empresa AND folio = @folio)
SELECT @EsRedocumentacion = 1
ELSE
SELECT @EsRedocumentacion = 0
END
IF @EsRedocumentacion = 0
BEGIN
IF @tipo_aplicacion = 'redocumentacion'
BEGIN
SELECT @tipo_documento = (SELECT TOP(1) tipo_documento FROM documentos WHERE empresa = @empresa AND folio = @referencia ORDER BY documento_id)
SELECT @importe_total = SUM(importe_total - ISNULL(BaseIVAImportacion, 0))
FROM documentos
WHERE empresa = @empresa AND referencia = @referencia
SELECT @factor = @importe / NULLIF(@importe_total, 0.0)
IF ISNULL(@factor, 0.0) <> 0.0 AND @tipo_documento IN ('factura', 'nota_cargo')
BEGIN
INSERT INTO documentos (
log_id,
origen_tipo,
origen_modulo,
empresa,
emisor,
tipo_documento,
folio,
ejercicio,
periodo,
dia,
entidad_clave,
entidad_nombre,
entidad_rfc,
entidad_id_fiscal,
entidad_tipo_tercero,
entidad_tipo_operacion,
entidad_pais,
entidad_nacionalidad,
concepto,
acumulable_deducible,
importe,
retencion_isr,
retencion_iva,
base_iva,
iva_excento,
iva_tasa, iva,
base_ieps,
ieps_tasa,
ieps,
base_isan,
isan,
importe_total,
referencia,
aplicacion_id,
ieps_num_reporte,
ieps_categoria_concepto,
ieps_exento,
ieps_envase_reutilizable,
ieps_retencion,
ieps_cantidad,
ieps_unidad,
ieps_cantidad2,
ieps_unidad2,
/*REQ16520*/
concepto_clave,
/*REQ16748*/
concepto_es_importacion,
/*BUG20353*/
concepto_aplica_ieps,
concepto_aplica_ietu,
concepto_aplica_iva,
/*BUG22460*/
fecha,
/*BUG22759*/
EsRedocumentacion,
/*BUG22833*/
BaseIVAImportacion,
/*BUG23552*/
ieps_iva,
origen_vista,
PorcentajeDeducible)
SELECT
@log_id,
/*BUG16688 BUG22759*/
origen_tipo,
@origen_modulo,
empresa,
emisor,
@tipo_documento,
@folio,
ejercicio,
periodo,
dia,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_clave ELSE @entidad_clave END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_nombre ELSE @entidad_nombre END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_rfc ELSE @entidad_rfc END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_id_fiscal ELSE @entidad_id_fiscal END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_tipo_tercero ELSE @entidad_tipo_tercero END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_tipo_operacion ELSE @entidad_tipo_operacion END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_pais ELSE @entidad_pais END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_nacionalidad ELSE @entidad_nacionalidad END,
concepto,
acumulable_deducible,
SUM(importe)*@factor,
SUM(retencion_isr)*@factor,
SUM(retencion_iva)*@factor,
SUM(base_iva)*@factor,
iva_excento,
iva_tasa,
SUM(iva)*@factor,
SUM(base_ieps)*@factor,
ieps_tasa,
SUM(ieps)*@factor,
SUM(base_isan)*@factor,
SUM(isan)*@factor,
SUM(importe_total)*@factor,
@folio,
@aplicacion_id,
ieps_num_reporte,
ieps_categoria_concepto,
ieps_exento,
ieps_envase_reutilizable,
SUM(ieps_retencion),
SUM(ieps_cantidad),
ieps_unidad,
SUM(ieps_cantidad2),
ieps_unidad2,
/*REQ16520*/
concepto_clave,
/*REQ16748*/
concepto_es_importacion,
/*BUG20353*/
concepto_aplica_ieps,
concepto_aplica_ietu,
concepto_aplica_iva,
/*BUG22460*/
fecha,
/*BUG22759*/
@EsRedocumentacion,
/*BUG22833*/
SUM(BaseIVAImportacion)*@factor,
/*BUG23552*/
SUM(ieps_iva)*@factor,
origen_vista,
ISNULL(PorcentajeDeducible, 100)
FROM documentos
WHERE empresa = @empresa AND referencia = @referencia 
GROUP BY origen_tipo,origen_modulo,origen_id,empresa,emisor,ejercicio,periodo,dia,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_clave ELSE @entidad_clave END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_nombre ELSE @entidad_nombre END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_rfc ELSE @entidad_rfc END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_id_fiscal ELSE @entidad_id_fiscal END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_tipo_tercero ELSE @entidad_tipo_tercero END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_tipo_operacion ELSE @entidad_tipo_operacion END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_pais ELSE @entidad_pais END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_nacionalidad ELSE @entidad_nacionalidad END,
concepto,acumulable_deducible,iva_excento, iva_tasa,ieps_tasa, ieps_num_reporte, ieps_categoria_concepto,
ieps_exento, ieps_envase_reutilizable,	ieps_unidad, ieps_unidad2,/*REQ16520*/concepto_clave,/*REQ16748*/concepto_es_importacion,/*BUG20353*/concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva,/*BUG22460*/
fecha, origen_vista,
PorcentajeDeducible
SELECT @conteo_documentos = @conteo_documentos + @@ROWCOUNT
END
END ELSE
BEGIN
SELECT @tipo_documento = (SELECT TOP(1) tipo_documento FROM documentos WHERE empresa = @empresa AND folio = @folio ORDER BY documento_id)
SELECT @importe_total = SUM(importe_total - ISNULL(BaseIVAImportacion, 0))
FROM documentos
WHERE empresa = @empresa AND referencia = @folio
SELECT @factor = @importe / NULLIF(@importe_total, 0.0)
IF ISNULL(@factor, 0.0) <> 0.0 AND @tipo_documento IN ('nota_credito', 'nota_cargo', 'devolucion')
BEGIN
IF @tipo_documento IN ('nota_credito')
SELECT @factor = -@factor
INSERT INTO documentos (
log_id,
origen_tipo, origen_modulo,
empresa, emisor, tipo_documento, folio,
ejercicio, periodo, dia,
entidad_clave,
entidad_nombre,
entidad_rfc,
entidad_id_fiscal,
entidad_tipo_tercero,
entidad_tipo_operacion,
entidad_pais,
entidad_nacionalidad,
concepto, acumulable_deducible,
importe, retencion_isr, retencion_iva,
base_iva, iva_excento, iva_tasa, iva,
base_ieps, ieps_tasa, ieps, base_isan, isan,
importe_total,
referencia, aplicacion_id,
ieps_num_reporte,
ieps_categoria_concepto,
ieps_exento,
ieps_envase_reutilizable,
ieps_retencion,
ieps_cantidad,
ieps_unidad,
ieps_cantidad2,
ieps_unidad2,
concepto_clave,
concepto_es_importacion,
concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva,
fecha,
EsRedocumentacion,
BaseIVAImportacion,
/*BUG23552*/
ieps_iva,
origen_vista,
PorcentajeDeducible
)
SELECT @log_id,
origen_tipo,
@origen_modulo,
empresa, emisor, tipo_documento, folio,
ejercicio, periodo, dia,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_clave ELSE @entidad_clave END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_nombre ELSE @entidad_nombre END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_rfc ELSE @entidad_rfc END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_id_fiscal ELSE @entidad_id_fiscal END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_tipo_tercero ELSE @entidad_tipo_tercero END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_tipo_operacion ELSE @entidad_tipo_operacion END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_pais ELSE @entidad_pais END,
CASE WHEN folio NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_nacionalidad ELSE @entidad_nacionalidad END,
concepto, acumulable_deducible,
importe*@factor, retencion_isr*@factor, retencion_iva*@factor,
base_iva*@factor, iva_excento, iva_tasa, iva*@factor,
base_ieps*@factor, ieps_tasa, ieps*@factor, base_isan*@factor, isan*@factor,
importe_total*@factor,
@referencia, @aplicacion_id,
ieps_num_reporte,
ieps_categoria_concepto,
ieps_exento,
ieps_envase_reutilizable,
ieps_retencion,
ieps_cantidad,
ieps_unidad,
ieps_cantidad2,
ieps_unidad2,
concepto_clave,
concepto_es_importacion,
concepto_aplica_ieps, concepto_aplica_ietu, concepto_aplica_iva,
fecha,
@EsRedocumentacion,
BaseIVAImportacion*@factor,
/*BUG23552*/
ieps_iva*@factor,
origen_vista,
ISNULL(PorcentajeDeducible, 100)
FROM documentos
WHERE empresa = @empresa AND folio = @folio AND origen_tipo <> 'calc'
SELECT @conteo_documentos = @conteo_documentos + @@ROWCOUNT
END
END
END
END
FETCH NEXT FROM cr_aplicaciones INTO @aplicacion_id, @tipo_aplicacion, @folio, @referencia, @importe, @entidad_clave, @entidad_nombre, @entidad_rfc, @entidad_id_fiscal, @entidad_tipo_tercero, @entidad_tipo_operacion, @entidad_pais, @entidad_nacionalidad, @origen_modulo
END
CLOSE cr_aplicaciones
DEALLOCATE cr_aplicaciones
RETURN
END

