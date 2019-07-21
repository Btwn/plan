SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sp_layout_importar_aplicaciones
@usuario	varchar(20),
@Empresa	varchar(5) = NULL

AS BEGIN
DECLARE @Base varchar(255)
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE
@log_id				int,
@error				int,
@error_mensaje		varchar(255),
@conteo				int,
@ejercicio			smallint,
@periodo			smallint
SELECT @usuario = UPPER(@usuario)
SELECT @error			= NULL,
@error_mensaje = NULL,
@conteo		= 0
SELECT @Base = db_name()
EXEC sp_layout_log_in @usuario, 'importar aplicaciones', 'importando', @Empresa, @log_id OUTPUT
SELECT empresa, fecha, origen_vista
INTO #fecha
FROM layout_aplicaciones
WHERE Empresa = ISNULL(@Empresa, Empresa)
GROUP BY empresa, fecha, origen_vista
DELETE a
FROM aplicaciones a
JOIN #fecha e ON a.empresa = e.empresa AND a.fecha = e.fecha AND a.origen_vista = e.origen_vista
EXEC spShrink_Log @Base
INSERT INTO aplicaciones (
log_id,
origen_tipo, origen_modulo, origen_id,
empresa, tipo_aplicacion, folio,
ejercicio, periodo, dia,
referencia, importe,
cuenta_bancaria,
aplica_ieps, aplica_ietu, aplica_iva,
origen_vista,
tipo_documento,
fecha
)
SELECT @log_id,
origen_tipo, origen_modulo, origen_id,
UPPER(empresa), LOWER(tipo_aplicacion), UPPER(folio),
ejercicio, periodo, dia,
UPPER(referencia), importe,
UPPER(cuenta_bancaria),
aplica_ieps, aplica_ietu, aplica_iva,
origen_vista,
tipo_documento,
fecha
FROM layout_aplicaciones
WHERE EsIFRS = 0
AND Empresa = ISNULL(@Empresa, Empresa)
SELECT @conteo = @conteo + @@ROWCOUNT
EXEC sp_layout_log_out @log_id, @conteo, @error, @error_mensaje
RETURN
END

