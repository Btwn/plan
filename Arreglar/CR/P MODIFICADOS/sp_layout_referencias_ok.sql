SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sp_layout_referencias_ok
@log_id				int,
@empresa			varchar(5),
@ejercicio			smallint,
@periodo			smallint,
@error				int				OUTPUT,
@error_mensaje		varchar(255)	OUTPUT,
@FechaD				datetime		= NULL,
@FechaA				datetime		= NULL,
@ValidarReferencias	bit				= 1

AS BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
INSERT layout_logd (
log_id,  folio, referencia, aplicacion_origen_id, aplicacion_origen_modulo, aplicacion_tipo_aplicacion, empresa, origen_vista)
SELECT @log_id, folio, referencia, origen_id,            origen_modulo,            tipo_aplicacion,            empresa, origen_vista
FROM aplicaciones WITH(NOLOCK)
WHERE empresa = @empresa
AND periodo = @periodo
AND fecha     >= ISNULL(@FechaD, fecha)
AND fecha     <= ISNULL(@FechaA, fecha)
AND referencia NOT IN (SELECT folio FROM documentos WITH(NOLOCK) WHERE empresa = @empresa UNION ALL SELECT folio FROM aplicaciones WITH(NOLOCK) WHERE empresa = @empresa)
IF @@ROWCOUNT > 0
IF @ValidarReferencias	= 1
SELECT @error = 1, @error_mensaje = 'Referencias Invalidas'
ELSE
SELECT @error = NULL, @error_mensaje = 'Referencias Invalidas'
END

