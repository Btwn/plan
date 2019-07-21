SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sp_layout_afectar_exentus
@log_id						int,
@empresa					varchar(5),
@ejercicio					smallint,
@periodo					smallint,
@tipo						varchar(50),
@conteo_datosietu			int			OUTPUT,
@conteo_ximpiva				int			OUTPUT,
@conteo_cuentascontables	int			OUTPUT,
@conteo_saldosini			int			OUTPUT,
@conteo_movcontables		int			OUTPUT,
@FechaD						datetime	= NULL,
@FechaA						datetime	= NULL

AS BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE
@dia					 smallint,
@tipo_aplicacion		 varchar(50),
@emisor					 varchar(50),
@folio					 varchar(50),
@referencia				 varchar(50),
@importe				 float,
@cuenta_bancaria		 varchar(50),
@fecha					 datetime,
@factor					 float,
@importe_total			 float,
@entidad_clave           varchar(20),
@entidad_nombre          varchar(150),
@entidad_rfc             varchar(15),
@entidad_id_fiscal       varchar(50),
@entidad_tipo_tercero    varchar(50),
@entidad_tipo_operacion  varchar(50),
@entidad_pais            varchar(20),
@entidad_nacionalidad    varchar(50),
@aplica_ieps		varchar(2),
@aplica_ietu		varchar(2),
@aplica_iva		    varchar(2),
@origen_modulo		varchar(50),
@NoModulos			int,
@tipo_documento		varchar(50),
@Base				varchar(255),
@origen_vista		varchar(255)
SELECT @Base = db_name()
IF @tipo IN ('todo', 'flujo')
BEGIN
DECLARE cr_flujo CURSOR LOCAL STATIC FOR
SELECT a.dia, LOWER(a.tipo_aplicacion), a.folio, a.referencia, ISNULL(a.importe, 0.0), a.cuenta_bancaria, lae.entidad_clave, lae.entidad_nombre, lae.entidad_rfc, lae.entidad_id_fiscal, lae.entidad_tipo_tercero, lae.entidad_tipo_operacion, lae.entidad_pais, lae.entidad_nacionalidad,
a.aplica_ieps, a.aplica_ietu, a.aplica_iva, a.origen_modulo, ISNULL(RTRIM(a.tipo_documento), ''), a.fecha, a.origen_vista
FROM aplicaciones a
LEFT OUTER JOIN layout_aplicacion_entidad lae ON lae.folio = a.folio AND lae.referencia = a.referencia AND lae.empresa = a.empresa
WHERE a.empresa = @empresa
AND ejercicio = ISNULL(@ejercicio, Ejercicio)
AND periodo   = ISNULL(@periodo, periodo)
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND a.tipo_aplicacion IN ('cobro', 'pago')
ORDER BY dia
OPEN cr_flujo
FETCH NEXT FROM cr_flujo INTO @dia, @tipo_aplicacion, @folio, @referencia, @importe, @cuenta_bancaria, @entidad_clave, @entidad_nombre, @entidad_rfc, @entidad_id_fiscal, @entidad_tipo_tercero, @entidad_tipo_operacion, @entidad_pais, @entidad_nacionalidad, @aplica_ieps, @aplica_ietu, @aplica_iva, @origen_modulo, @tipo_documento, @fecha, @origen_vista
WHILE @@FETCH_STATUS <> -1 AND @@ERROR = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @factor = 0.0, @importe_total = 0.0,
@emisor = dbo.fn_emisor(@tipo_aplicacion),
@NoModulos = 0
IF @Ejercicio IS NOT NULL AND @Periodo IS NOT NULL
SELECT @fecha = dbo.fn_fecha(@ejercicio, @periodo, @dia)
IF @Ejercicio IS NULL
SELECT @Ejercicio = YEAR(@fecha)
IF @Periodo IS NULL
SELECT @Periodo  = MONTH(@fecha)
SELECT @NoModulos = COUNT(DISTINCT origen_modulo) FROM documentos WHERE folio = @referencia AND origen_modulo IN('GAS', 'CXC', 'CXP', 'VTAS') AND Empresa = @empresa AND ISNULL(origen_tipo, '') <> 'calc' AND ISNULL(EsRedocumentacion, 0) = 0
IF @NoModulos > 1
SELECT @importe_total = SUM(CASE ISNULL(BaseIVAImportacion, 0) WHEN -1 THEN iva ELSE importe_total - ISNULL(BaseIVAImportacion, 0) END)
FROM documentos
WHERE empresa = @empresa AND referencia = @referencia
AND origen_modulo = @origen_modulo
AND ISNULL(origen_tipo, '') <> 'calc'
AND ISNULL(EsRedocumentacion, 0) = 0
ELSE
SELECT @importe_total = SUM(CASE ISNULL(BaseIVAImportacion, 0) WHEN -1 THEN iva ELSE importe_total - ISNULL(BaseIVAImportacion, 0) END)
FROM documentos
WHERE empresa = @empresa AND referencia = @referencia
AND ISNULL(origen_tipo, '') <> 'calc'
AND ISNULL(EsRedocumentacion, 0) = 0
IF @origen_vista <> 'MFAVentaContadoPagoCalc'
SELECT @factor = @importe / NULLIF(@importe_total, 0.0)
ELSE
SELECT @factor = 1
IF NULLIF(@factor, 0.0) IS NOT NULL
BEGIN
IF @NoModulos > 1
BEGIN
IF @aplica_ietu = 'Si'
BEGIN
INSERT INTO DatosIetu (
empresa, movimiento,
nocliente,
nombre,
concepto, referencia,
fecha,  ejercicio,	periodoasi,
tipo, cuenta,
ietu, retencion, retencion2, impuestos,
SubTipoIetu
)
SELECT @empresa, @referencia,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_clave ELSE ISNULL(@entidad_clave,'') END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_nombre ELSE ISNULL(@entidad_nombre,'') END,
concepto, @folio,
@fecha, @ejercicio, @periodo,
ISNULL(dbo.fn_tipo_datosietu(@tipo_aplicacion), 1), @cuenta_bancaria,
ISNULL(SUM(importe)*@factor,0)*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0),
ISNULL(SUM(retencion_isr)*@factor,0)*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0),
ISNULL(SUM(retencion_iva)*@factor,0)*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0),
ISNULL(SUM(base_iva*(iva_tasa/100.0)*@factor),0)*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0),
dbo.fn_subtipo_datosietu(concepto_clave, @tipo_aplicacion)
FROM documentos
WHERE empresa = @empresa AND referencia = @referencia and lower(acumulable_deducible) = 'si' 
AND origen_modulo = @origen_modulo
AND referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes')
AND ISNULL(origen_modulo, '') <> 'NOM'
AND ISNULL(origen_tipo, '') <> 'calc'
AND ISNULL(EsRedocumentacion, 0) = 0
AND ISNULL(concepto_aplica_ietu, '') = 'Si'
GROUP BY
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_clave ELSE ISNULL(@entidad_clave,'') END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_nombre ELSE ISNULL(@entidad_nombre,'') END,
concepto,
iva_tasa,
concepto_clave,
origen_modulo,
ISNULL(@tipo_documento, tipo_documento),
PorcentajeDeducible
SELECT @conteo_datosietu = @conteo_datosietu + @@ROWCOUNT
IF @referencia IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes')
BEGIN
INSERT INTO DatosIetu(
empresa, movimiento, nocliente, nombre, concepto, referencia, fecha, ejercicio, periodoasi, tipo, cuenta,ietu, retencion, retencion2, impuestos, SubTipoIetu)
SELECT @empresa, @referencia, ISNULL(@entidad_clave,''), ISNULL(@entidad_nombre,''), @referencia, @folio, @fecha, @ejercicio, @periodo, ISNULL(dbo.fn_tipo_datosietu(@tipo_aplicacion), 1), @cuenta_bancaria, ISNULL(@importe*@factor,0), ISNULL(@importe*@factor,0), ISNULL(@importe*@factor,0), ISNULL(@importe*@factor,0), dbo.fn_subtipo_datosietu(@referencia, @tipo_aplicacion)
SELECT @conteo_datosietu = @conteo_datosietu + @@ROWCOUNT
END
END
IF @aplica_iva = 'Si'
BEGIN
INSERT INTO ximpiva (
id, empresa, nombre, mov,
tipoiva, tipoopera, tasa, origen,
rfc, idfiscal, tipoter, tipoope,
cvepais, naciona, cheque,
fecha, ejercicio, periodo,
importe, iva, reten2,
EsActivoFijo, TipoActivo, TipoActividad
)
SELECT @referencia, @empresa,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_nombre ELSE ISNULL(@entidad_nombre,'') END,
concepto,
ISNULL(dbo.fn_tipoiva(@tipo_aplicacion),0), dbo.fn_tipoopera(origen_modulo, iva_excento, iva_tasa, entidad_tipo_tercero, concepto_es_importacion, @tipo_documento), ISNULL(iva_tasa/100.0,0), 2,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_rfc ELSE ISNULL(@entidad_rfc,'') END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_id_fiscal ELSE ISNULL(@entidad_id_fiscal,'') END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN dbo.fn_tipoter(entidad_tipo_tercero) ELSE dbo.fn_tipoter(ISNULL(@entidad_tipo_tercero,'')) END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN dbo.fn_tipoope(entidad_tipo_operacion) ELSE dbo.fn_tipoope(ISNULL(@entidad_tipo_operacion,'')) END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_pais ELSE ISNULL(@entidad_pais,'') END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_nacionalidad ELSE ISNULL(@entidad_nacionalidad,'') END,
@folio,
@fecha, @ejercicio, @periodo,
CASE dbo.fn_tipoopera(origen_modulo, iva_excento, iva_tasa, entidad_tipo_tercero, concepto_es_importacion, @tipo_documento)
WHEN 1  THEN ISNULL((SUM(base_iva) + CASE ISNULL(SUM(ieps_iva), 0) WHEN 0 THEN 0 ELSE ISNULL(SUM(ieps), 0) END), 0)*@factor*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0)
WHEN 9  THEN ISNULL((SUM(base_iva) + CASE ISNULL(SUM(ieps_iva), 0) WHEN 0 THEN 0 ELSE ISNULL(SUM(ieps), 0) END), 0)*@factor*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0)
WHEN 10 THEN ISNULL((SUM(base_iva) + CASE ISNULL(SUM(ieps_iva), 0) WHEN 0 THEN 0 ELSE ISNULL(SUM(ieps), 0) END), 0)*@factor*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0)
ELSE ISNULL((SUM(importe)+ CASE ISNULL(SUM(ieps_iva), 0) WHEN 0 THEN 0 ELSE ISNULL(SUM(ieps), 0) END)*@factor,0)*dbo.fn_documento_factor(origen_modulo, @tipo_documento) *(ISNULL(PorcentajeDeducible, 100.0)/100.0)
END,
CASE dbo.fn_tipoopera(origen_modulo, iva_excento, iva_tasa, entidad_tipo_tercero, concepto_es_importacion, @tipo_documento)
WHEN 1  THEN ISNULL(SUM(iva), 0)*@factor*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0)
WHEN 9  THEN ISNULL(SUM(iva), 0)*@factor*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0)
WHEN 10 THEN ISNULL(SUM(iva), 0)*@factor*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0)
ELSE ISNULL(SUM((importe + CASE ISNULL(ieps_iva, 0) WHEN 0 THEN 0 ELSE ISNULL(ieps, 0) END)*(iva_tasa/100.0))*@factor,0)*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0)
END,
ISNULL(SUM(retencion_iva)*@factor,0)*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0),
ISNULL(EsActivoFijo, 0), TipoActivo, ISNULL(TipoActividad, 'gravado')
FROM documentos
WHERE empresa = @empresa AND referencia = @referencia and lower(acumulable_deducible) = 'si' 
AND origen_modulo = @origen_modulo
AND ISNULL(origen_modulo, '') <> 'NOM'
AND ISNULL(origen_tipo, '') <> 'calc'
AND ISNULL(EsRedocumentacion, 0) = 0
AND ISNULL(concepto_aplica_iva, '') = 'Si'
AND referencia NOT IN ('Redondeo')
GROUP BY
origen_tipo,
origen_modulo,
origen_id,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_nombre ELSE ISNULL(@entidad_nombre,'') END,
concepto, iva_excento,
iva_tasa,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_rfc ELSE ISNULL(@entidad_rfc,'') END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_id_fiscal ELSE ISNULL(@entidad_id_fiscal,'') END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN dbo.fn_tipoter(entidad_tipo_tercero) ELSE dbo.fn_tipoter(ISNULL(@entidad_tipo_tercero,'')) END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN dbo.fn_tipoope(entidad_tipo_operacion) ELSE dbo.fn_tipoope(ISNULL(@entidad_tipo_operacion,'')) END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_pais ELSE ISNULL(@entidad_pais,'') END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_nacionalidad ELSE ISNULL(@entidad_nacionalidad,'') END,
entidad_tipo_tercero,
concepto_es_importacion,
ISNULL(@tipo_documento, tipo_documento),
EsActivoFijo, TipoActivo, TipoActividad,
PorcentajeDeducible
SELECT @conteo_ximpiva = @conteo_ximpiva + @@ROWCOUNT
END
IF @aplica_ieps = 'Si'
BEGIN
INSERT INTO DatosIeps (
empresa, documento, documento_id, tipo_movimiento,
nocliente,
rfc,
nombre,
concepto, referencia,
fecha,  ejercicio,	periodo,
importe,
retencion_ieps,
tasa_ieps,
importe_ieps,
num_reporte,
categoria_concepto,
es_exento,
es_envase_reutilizable,
cantidad,
unidad,
cantidad1,
unidad1
)
SELECT @empresa, folio, origen_id, subtipo_documento,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_clave ELSE ISNULL(@entidad_clave,'') END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_rfc ELSE ISNULL(@entidad_rfc,'') END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_nombre ELSE ISNULL(@entidad_nombre,'') END,
concepto, @folio,
@fecha, @ejercicio, @periodo,
ISNULL(SUM(importe)*@factor,0)*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0),
ISNULL(SUM(retencion_isr)*@factor,0)*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0),
ieps_tasa,
ISNULL(SUM(ieps)*@factor,0)*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0),
ieps_num_reporte,
ieps_categoria_concepto,
ieps_exento,
ieps_envase_reutilizable,
SUM(ieps_cantidad),
ieps_unidad,
SUM(ieps_cantidad2),
ieps_unidad2
FROM documentos
WHERE empresa = @empresa AND referencia = @referencia and lower(acumulable_deducible) = 'si' 
AND origen_modulo = @origen_modulo
AND ISNULL(origen_modulo, '') <> 'NOM'
AND ISNULL(origen_tipo, '') <> 'calc'
AND ISNULL(EsRedocumentacion, 0) = 0
AND ISNULL(concepto_aplica_ieps, '') = 'Si'
AND referencia NOT IN ('Redondeo')
GROUP BY folio, origen_id, subtipo_documento, entidad_clave, entidad_rfc, entidad_nombre, concepto, ieps_tasa, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_unidad, ieps_unidad2, origen_modulo, ISNULL(@tipo_documento, tipo_documento),
PorcentajeDeducible
SELECT @conteo_datosietu = @conteo_datosietu + @@ROWCOUNT
END
END
ELSE IF @NoModulos <= 1
BEGIN
IF @aplica_ietu = 'Si'
BEGIN
INSERT INTO DatosIetu (
empresa, movimiento,
nocliente,
nombre,
concepto, referencia,
fecha,  ejercicio,	periodoasi,
tipo, cuenta,
ietu, retencion, retencion2, impuestos,
SubTipoIetu
)
SELECT @empresa, @referencia,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_clave ELSE ISNULL(@entidad_clave,'') END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_nombre ELSE ISNULL(@entidad_nombre,'') END,
concepto, @folio,
@fecha, @ejercicio, @periodo,
ISNULL(dbo.fn_tipo_datosietu(@tipo_aplicacion), 1), @cuenta_bancaria,
ISNULL(SUM(importe)*@factor,0)*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0),
ISNULL(SUM(retencion_isr)*@factor,0)*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0),
ISNULL(SUM(retencion_iva)*@factor,0)*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0),
ISNULL(SUM(base_iva*(iva_tasa/100.0)*@factor),0)*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0),
dbo.fn_subtipo_datosietu(concepto_clave, @tipo_aplicacion)
FROM documentos
WHERE empresa = @empresa AND referencia = @referencia and lower(acumulable_deducible) = 'si' 
AND referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes')
AND ISNULL(origen_modulo, '') <> 'NOM'
AND ISNULL(origen_tipo, '') <> 'calc'
AND ISNULL(EsRedocumentacion, 0) = 0
AND ISNULL(concepto_aplica_ietu, '') = 'Si'
AND referencia NOT IN ('Redondeo')
GROUP BY
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_clave ELSE ISNULL(@entidad_clave,'') END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_nombre ELSE ISNULL(@entidad_nombre,'') END,
concepto,
iva_tasa,
concepto_clave,
origen_modulo,
ISNULL(@tipo_documento, tipo_documento),
PorcentajeDeducible
SELECT @conteo_datosietu = @conteo_datosietu + @@ROWCOUNT
IF @referencia IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes')
BEGIN
INSERT INTO DatosIetu(
empresa, movimiento, nocliente, nombre, concepto, referencia, fecha, ejercicio, periodoasi, tipo, cuenta,ietu, retencion, retencion2, impuestos, SubTipoIetu)
SELECT @empresa, @referencia, ISNULL(@entidad_clave,''), ISNULL(@entidad_nombre,''), @referencia, @folio, @fecha, @ejercicio, @periodo, ISNULL(dbo.fn_tipo_datosietu(@tipo_aplicacion), 1), @cuenta_bancaria, ISNULL(@importe*@factor,0), ISNULL(@importe*@factor,0), ISNULL(@importe*@factor,0), ISNULL(@importe*@factor,0), dbo.fn_subtipo_datosietu(@referencia, @tipo_aplicacion)
SELECT @conteo_datosietu = @conteo_datosietu + @@ROWCOUNT
END
END
IF @aplica_iva = 'Si'
BEGIN
INSERT INTO ximpiva (
id, empresa, nombre, mov,
tipoiva, tipoopera, tasa, origen,
rfc, idfiscal, tipoter, tipoope,
cvepais, naciona, cheque,
fecha, ejercicio, periodo,
importe, iva, reten2,
EsActivoFijo, TipoActivo, TipoActividad)
SELECT @referencia, @empresa,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_nombre ELSE ISNULL(@entidad_nombre,'') END,
concepto,
ISNULL(dbo.fn_tipoiva(@tipo_aplicacion),0), dbo.fn_tipoopera(origen_modulo, iva_excento, iva_tasa, entidad_tipo_tercero, concepto_es_importacion, @tipo_documento), ISNULL(iva_tasa/100.0,0), 2,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_rfc ELSE ISNULL(@entidad_rfc,'') END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_id_fiscal ELSE ISNULL(@entidad_id_fiscal,'') END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN dbo.fn_tipoter(entidad_tipo_tercero) ELSE dbo.fn_tipoter(ISNULL(@entidad_tipo_tercero,'')) END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN dbo.fn_tipoope(entidad_tipo_operacion) ELSE dbo.fn_tipoope(ISNULL(@entidad_tipo_operacion,'')) END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_pais ELSE ISNULL(@entidad_pais,'') END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_nacionalidad ELSE ISNULL(@entidad_nacionalidad,'') END,
@folio,
@fecha, @ejercicio, @periodo,
CASE dbo.fn_tipoopera(origen_modulo, iva_excento, iva_tasa, entidad_tipo_tercero, concepto_es_importacion, @tipo_documento)
WHEN 1  THEN ISNULL((SUM(base_iva) + CASE ISNULL(SUM(ieps_iva), 0) WHEN 0 THEN 0 ELSE ISNULL(SUM(ieps), 0) END), 0)*@factor*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0)
WHEN 9  THEN ISNULL((SUM(base_iva) + CASE ISNULL(SUM(ieps_iva), 0) WHEN 0 THEN 0 ELSE ISNULL(SUM(ieps), 0) END), 0)*@factor*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0)
WHEN 10 THEN ISNULL((SUM(base_iva) + CASE ISNULL(SUM(ieps_iva), 0) WHEN 0 THEN 0 ELSE ISNULL(SUM(ieps), 0) END), 0)*@factor*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0)
ELSE ISNULL((SUM(importe)+ CASE ISNULL(SUM(ieps_iva), 0) WHEN 0 THEN 0 ELSE ISNULL(SUM(ieps), 0) END)*@factor,0)*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0)
END,
CASE dbo.fn_tipoopera(origen_modulo, iva_excento, iva_tasa, entidad_tipo_tercero, concepto_es_importacion, @tipo_documento)
WHEN 1  THEN ISNULL(SUM(iva), 0)*@factor*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0)
WHEN 9  THEN ISNULL(SUM(iva), 0)*@factor*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0)
WHEN 10 THEN ISNULL(SUM(iva), 0)*@factor*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0)
ELSE ISNULL(SUM((importe+CASE ISNULL(ieps_iva, 0) WHEN 0 THEN 0 ELSE ISNULL(ieps, 0) END)*(iva_tasa/100.0))*@factor,0)*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0)
END,
ISNULL(SUM(retencion_iva)*@factor,0)*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0),
ISNULL(EsActivoFijo, 0), TipoActivo, ISNULL(TipoActividad, 'gravado')
FROM documentos
WHERE empresa = @empresa AND referencia = @referencia and lower(acumulable_deducible) = 'si' 
AND ISNULL(origen_modulo, '') <> 'NOM'
AND ISNULL(origen_tipo, '') <> 'calc'
AND ISNULL(EsRedocumentacion, 0) = 0
AND ISNULL(concepto_aplica_iva, '') = 'Si'
AND referencia NOT IN ('Redondeo')
GROUP BY
origen_tipo,
origen_modulo,
origen_id,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_nombre ELSE ISNULL(@entidad_nombre,'') END,
concepto, iva_excento,
iva_tasa,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_rfc ELSE ISNULL(@entidad_rfc,'') END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_id_fiscal ELSE ISNULL(@entidad_id_fiscal,'') END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN dbo.fn_tipoter(entidad_tipo_tercero) ELSE dbo.fn_tipoter(ISNULL(@entidad_tipo_tercero,'')) END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN dbo.fn_tipoope(entidad_tipo_operacion) ELSE dbo.fn_tipoope(ISNULL(@entidad_tipo_operacion,'')) END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_pais ELSE ISNULL(@entidad_pais,'') END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_nacionalidad ELSE ISNULL(@entidad_nacionalidad,'') END,
entidad_tipo_tercero,
concepto_es_importacion,
ISNULL(@tipo_documento, tipo_documento),
EsActivoFijo, TipoActivo, TipoActividad,
PorcentajeDeducible
SELECT @conteo_ximpiva = @conteo_ximpiva + @@ROWCOUNT
END
IF @aplica_ieps = 'Si'
BEGIN
INSERT INTO DatosIeps (
empresa, documento, documento_id, tipo_movimiento,
nocliente,
rfc,
nombre,
concepto, referencia,
fecha,  ejercicio,	periodo,
importe,
retencion_ieps,
tasa_ieps,
importe_ieps,
num_reporte,
categoria_concepto,
es_exento,
es_envase_reutilizable,
cantidad,
unidad,
cantidad1,
unidad1
)
SELECT @empresa, folio, origen_id, subtipo_documento,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_clave ELSE ISNULL(@entidad_clave,'') END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_rfc ELSE ISNULL(@entidad_rfc,'') END,
CASE WHEN @referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes') THEN entidad_nombre ELSE ISNULL(@entidad_nombre,'') END,
concepto, @folio,
@fecha, @ejercicio, @periodo,
ISNULL(SUM(importe)*@factor,0)*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0),
ISNULL(SUM(retencion_isr)*@factor,0)*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0),
ieps_tasa,
ISNULL(SUM(ieps)*@factor,0)*dbo.fn_documento_factor(origen_modulo, @tipo_documento)*(ISNULL(PorcentajeDeducible, 100.0)/100.0),
ieps_num_reporte,
ieps_categoria_concepto,
ieps_exento,
ieps_envase_reutilizable,
SUM(ieps_cantidad),
ieps_unidad,
SUM(ieps_cantidad2),
ieps_unidad2
FROM documentos
WHERE empresa = @empresa AND referencia = @referencia and lower(acumulable_deducible) = 'si' 
AND ISNULL(origen_modulo, '') <> 'NOM'
AND ISNULL(origen_tipo, '') <> 'calc'
AND ISNULL(EsRedocumentacion, 0) = 0
AND ISNULL(concepto_aplica_ieps, '') = 'Si'
AND referencia NOT IN ('Redondeo')
GROUP BY folio, origen_id, subtipo_documento, entidad_clave, entidad_rfc, entidad_nombre, concepto, ieps_tasa, ieps_num_reporte, ieps_categoria_concepto, ieps_exento, ieps_envase_reutilizable, ieps_unidad, ieps_unidad2, origen_modulo, ISNULL(@tipo_documento, tipo_documento),
PorcentajeDeducible
SELECT @conteo_datosietu = @conteo_datosietu + @@ROWCOUNT
END
END
END
END
FETCH NEXT FROM cr_flujo INTO @dia, @tipo_aplicacion, @folio, @referencia, @importe, @cuenta_bancaria, @entidad_clave, @entidad_nombre, @entidad_rfc, @entidad_id_fiscal, @entidad_tipo_tercero, @entidad_tipo_operacion, @entidad_pais, @entidad_nacionalidad, @aplica_ieps, @aplica_ietu, @aplica_iva, @origen_modulo, @tipo_documento, @fecha, @origen_vista
END
CLOSE cr_flujo
DEALLOCATE cr_flujo
END
EXEC spShrink_log @Base
IF @tipo IN ('todo', 'contabilidad')
BEGIN
INSERT INTO CuentasContables(
CuentaContable,  CuentaControl,  Nivel, Descripcion,
Clase,
Tipo,
Moneda)
SELECT cuenta_contable, cuenta_control, nivel, descripcion,
dbo.fn_clase_cuenta(clase_cuenta),
dbo.fn_tipo_cuenta(tipo_cuenta),
MFAMon.Codigo
FROM cuentas
LEFT OUTER JOIN MFAMon ON cuentas.moneda = MFAMon.Moneda
WHERE empresa = @empresa AND ejercicio = @ejercicio
SELECT @conteo_cuentascontables = @conteo_cuentascontables + @@ROWCOUNT
INSERT INTO SaldosIni (
Empresa, CuentaContable,  anio,      saldoinicial)
SELECT empresa, cuenta_contable, ejercicio, SUM(saldo_inicial)
FROM cuentas
WHERE empresa = @empresa AND ejercicio = @ejercicio
GROUP BY empresa, cuenta_contable, ejercicio
SELECT @conteo_saldosini = @conteo_saldosini + @@ROWCOUNT
INSERT INTO MovContables (
Empresa, CuentaContable,  anio,      mes,     cargo,       abono)
SELECT empresa, cuenta_contable, ejercicio, periodo, SUM(cargos), SUM(abonos)
FROM polizas
WHERE empresa = @empresa
AND ejercicio = ISNULL(@ejercicio, YEAR(@FechaA))
AND periodo   = ISNULL(@periodo, MONTH(@FechaA))
GROUP BY empresa, cuenta_contable, ejercicio, periodo
EXEC spShrink_log @Base
END
RETURN
END

