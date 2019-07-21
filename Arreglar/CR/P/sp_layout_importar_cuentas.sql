SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sp_layout_importar_cuentas
@usuario	varchar(20)

AS BEGIN
DECLARE
@log_id				int,
@error				int,
@error_mensaje		varchar(255),
@conteo				int,
@empresa			varchar(5),
@ejercicio			smallint
SELECT @usuario = UPPER(@usuario)
SELECT @error			= NULL,
@error_mensaje = NULL,
@conteo		= 0
DECLARE cr_layout CURSOR LOCAL STATIC FOR
SELECT empresa, ejercicio
FROM layout_cuentas
GROUP BY empresa, ejercicio
ORDER BY empresa, ejercicio
OPEN cr_layout
FETCH NEXT FROM cr_layout INTO @empresa, @ejercicio
WHILE @@FETCH_STATUS <> -1 AND @@ERROR = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC sp_layout_log_in @usuario, 'importar cuentas', 'importando', @Empresa, @log_id OUTPUT
DELETE
FROM cuentas
WHERE empresa = @empresa AND ejercicio = @ejercicio
INSERT INTO cuentas (
log_id,
empresa, ejercicio, cuenta_contable, cuenta_control, descripcion, nivel, clase_cuenta, tipo_cuenta, moneda,
saldo_inicial)
SELECT @log_id,
UPPER(empresa), ejercicio, cuenta_contable, cuenta_control, descripcion, nivel, LOWER(clase_cuenta), LOWER(tipo_cuenta), moneda,
saldo_inicial
FROM layout_cuentas
WHERE empresa = @empresa AND ejercicio = @ejercicio
SELECT @conteo = @conteo + @@ROWCOUNT
EXEC sp_layout_log_out @log_id, @conteo, @error, @error_mensaje
END
FETCH NEXT FROM cr_layout INTO @empresa, @ejercicio
END
CLOSE cr_layout
DEALLOCATE cr_layout
RETURN
END

