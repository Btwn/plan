SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sp_procesar_ish
@usuario varchar(20),
@empresa   varchar(5),
@ejercicio   smallint,
@periodo   smallint

AS BEGIN
DECLARE
@log_id    int,
@error    int,
@error_mensaje  varchar(255),
@conteo    int
SELECT @usuario = UPPER(@usuario)
SELECT @error   = NULL,
@error_mensaje = NULL,
@conteo  = 0
EXEC sp_layout_log_in @usuario, 'procesar ISH', 'procesar', @empresa, @log_id OUTPUT
DELETE a
FROM ximpish a
where a.empresa = @empresa and a.periodo = @periodo and a.ejercicio = @ejercicio
INSERT INTO ximpish (
id,empresa,cheque,mov,nombre,
fecha,ejercicio,periodo,importe,
tasa,ish,rfc,sucursal)
select folio, UPPER(empresa), folio,ISNULL(concepto,''),
ISNULL(entidad_nombre,''),dbo.fn_fecha(ejercicio, periodo, dia),
ejercicio,periodo,importe,ISNULL((ish_tasa/100.0),0),
ISNULL(ish,0),entidad_rfc, sucursal
from layout_ish WITH(NOLOCK)
SELECT @conteo = @conteo + @@ROWCOUNT
EXEC sp_layout_log_out @log_id, @conteo, @error, @error_mensaje
RETURN
END

