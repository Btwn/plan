SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sp_layout_log_out
@log_id				int,
@conteo				int,
@error				int,
@error_mensaje		varchar(255)

AS BEGIN
DECLARE
@estatus	varchar(50)
IF NULLIF(@error, 0) IS NOT NULL OR @error_mensaje = 'Referencias Invalidas'
SELECT @estatus = 'error'
ELSE
SELECT @estatus = 'concluido'
UPDATE layout_log
SET estatus = @estatus,
conteo = @conteo,
error = @error,
error_mensaje = @error_mensaje,
fin = GETDATE()
WHERE log_id = @log_id
END

