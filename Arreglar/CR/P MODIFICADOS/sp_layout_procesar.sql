SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sp_layout_procesar
@usuario	varchar(20),
@empresa	varchar(5),
@ejercicio	smallint,
@periodo	smallint,
@tipo		varchar(50)	= 'todo',
@FechaD		datetime	= NULL,
@FechaA		datetime	= NULL,
@IFRS				bit			= 0,
@ValidarReferencias bit			= 1

AS BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE
@log_id						int,
@error						int,
@error_mensaje				varchar(255),
@conteo						int,
@conteo_documentos			int,
@conteo_aplcaciones			int,
@conteo_datosietu			int,
@conteo_ximpiva				int,
@conteo_cuentascontables	int,
@conteo_saldosini			int,
@conteo_movcontables		int,
@Base						varchar(255)
SELECT @error						= NULL,
@error_mensaje				= NULL,
@conteo_documentos			= 0,
@conteo_aplcaciones		= 0,
@conteo_datosietu			= 0,
@conteo_ximpiva			= 0,
@conteo_cuentascontables	= 0,
@conteo_saldosini			= 0,
@conteo_movcontables		= 0,
@tipo						= LOWER(@tipo),
@Base						= db_name()
EXEC sp_layout_log_in @usuario, 'procesar', 'procesando', @empresa, @log_id OUTPUT
EXEC sp_layout_init @log_id, @empresa, @ejercicio, @periodo, @tipo, @FechaD, @FechaA
EXEC spShrink_log @Base
IF @tipo IN ('todo', 'flujo') 
BEGIN
IF @IFRS = 0
EXEC sp_layout_referencias_ok @log_id, @empresa, @ejercicio, @periodo, @error OUTPUT, @error_mensaje OUTPUT, @FechaD, @FechaA, @ValidarReferencias
END
IF @error IS NULL
BEGIN
IF @tipo IN ('todo', 'flujo') 
BEGIN
EXEC sp_layout_aplicaciones @log_id, @empresa, @ejercicio, @periodo, @conteo_documentos OUTPUT, @FechaD, @FechaA
EXEC spShrink_log @Base
END
EXEC sp_layout_afectar_exentus @log_id, @empresa, @ejercicio, @periodo, @tipo,
@conteo_datosietu OUTPUT, @conteo_ximpiva OUTPUT,
@conteo_cuentascontables OUTPUT, @conteo_saldosini OUTPUT, @conteo_movcontables OUTPUT, @FechaD, @FechaA
SELECT @conteo = @conteo_documentos + @conteo_aplcaciones + @conteo_datosietu + @conteo_ximpiva
END
EXEC sp_layout_log_out @log_id, @conteo, @error, @error_mensaje
RETURN @log_id
END

