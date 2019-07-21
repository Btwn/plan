SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sp_layout_importar_polizas
@usuario	varchar(20)

AS BEGIN
DECLARE
@log_id				int,
@error				int,
@error_mensaje		varchar(255),
@conteo				int,
@empresa			varchar(5),
@ejercicio			smallint,
@periodo			smallint
SELECT @usuario = UPPER(@usuario)
SELECT @error			= NULL,
@error_mensaje = NULL,
@conteo		= 0
DECLARE cr_layout CURSOR LOCAL STATIC FOR
SELECT empresa, ejercicio, periodo
FROM layout_polizas
GROUP BY empresa, ejercicio, periodo
ORDER BY empresa, ejercicio, periodo
OPEN cr_layout
FETCH NEXT FROM cr_layout INTO @empresa, @ejercicio, @periodo
WHILE @@FETCH_STATUS <> -1 AND @@ERROR = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC sp_layout_log_in @usuario, 'importar polizas', 'importando', @Empresa, @log_id OUTPUT
DELETE
FROM polizas
WHERE empresa = @empresa
AND ejercicio = @ejercicio
AND periodo   = @periodo
INSERT INTO polizas (
log_id,
empresa, ejercicio, periodo, cuenta_contable,
cargos, abonos, fecha)
SELECT @log_id,
UPPER(empresa), ejercicio, periodo, UPPER(cuenta_contable),
cargos, abonos, fecha
FROM layout_polizas
WHERE empresa = @empresa
AND ejercicio = @ejercicio
AND periodo = @periodo
SELECT @conteo = @conteo + @@ROWCOUNT
EXEC sp_layout_log_out @log_id, @conteo, @error, @error_mensaje
END
FETCH NEXT FROM cr_layout INTO @empresa, @ejercicio, @periodo
END
CLOSE cr_layout
DEALLOCATE cr_layout
RETURN
END

