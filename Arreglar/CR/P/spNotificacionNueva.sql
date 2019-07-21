SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNotificacionNueva
@Estacion			int,
@Notificacion		varchar(50),
@Clave				varchar(50)

AS BEGIN
DECLARE
@Transaccion		varchar(50),
@Ok			int,
@OkRef			varchar(255)
IF EXISTS(SELECT 1 FROM Notificacion WHERE Notificacion = @Notificacion) RETURN
SELECT @Ok = NULL, @OkRef = NULL
SET @Transaccion = 'spNotificacionNueva' + RTRIM(LTRIM(CONVERT(varchar,@Estacion)))
BEGIN TRANSACTION @Transaccion
INSERT Notificacion (Notificacion, Clave, Descripcion, Asunto, Mensaje, Estatus, MedioComunicacion, TipoFechaNotificacion, FechaNotificacion, AnticipacionFechaTipo, AnticipacionFecha, Frecuencia, Lunes, Martes, Miercoles, Jueves, Viernes, Sabado, Domingo, DiaMes, FechaInicio)
SELECT
@Notificacion,
Clave,
Descripcion,
Asunto,
Mensaje,
'INACTIVA',
MedioComunicacion,
TipoFechaNotificacion,
FechaNotificacion,
AnticipacionFechaTipo,
AnticipacionFecha,
Frecuencia,
Lunes,
Martes,
Miercoles,
Jueves,
Viernes,
Sabado,
Domingo,
DiaMes,
FechaInicio
FROM NotificacionClave
WHERE Clave = @Clave
IF NULLIF(@@ERROR,0) IS NOT NULL SELECT @Ok = 1, @OkRef = 'Notificacion'
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
INSERT NotificacionParam (Notificacion, Parametro, Valor)
SELECT
@Notificacion,
Parametro,
ValorOmision
FROM NotificacionClaveParam
WHERE Clave = @Clave
IF NULLIF(@@ERROR,0) IS NOT NULL SELECT @Ok = 1, @OkRef = 'NotificacionParam'
END
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
INSERT NotificacionConsulta (Notificacion, ConsultaNombre, Consulta)
SELECT
@Notificacion,
ConsultaNombre,
Consulta
FROM NotificacionClaveConsulta
WHERE Clave = @Clave
IF NULLIF(@@ERROR,0) IS NOT NULL SELECT @Ok = 1, @OkRef = 'NotificacionConsulta'
END
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
INSERT NotificacionDestinatario (Notificacion, TipoDestinatario, SeccionDestinatario, Destinatario, DestinatarioCorreo)
SELECT
@Notificacion,
TipoDestinatario,
SeccionDestinatario,
Destinatario,
DestinatarioCorreo
FROM NotificacionClaveDestinatario
WHERE Clave = @Clave
IF NULLIF(@@ERROR,0) IS NOT NULL SELECT @Ok = 1, @OkRef = 'NotificacionDestinatario'
END
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
INSERT NotificacionFiltro (Notificacion, Empresa, Sucursal, UEN, Usuario, Modulo, Movimiento, Estatus, Situacion, Proyecto, ContactoTipo, Contacto, ImporteMin, ImporteMax, ValidarAlEmitir)
SELECT
@Notificacion,
Empresa,
Sucursal,
UEN,
Usuario,
Modulo,
Movimiento,
Estatus,
Situacion,
Proyecto,
ContactoTipo,
Contacto,
ImporteMin,
ImporteMax,
ValidarAlEmitir
FROM NotificacionClaveFiltro
WHERE Clave = @Clave
IF NULLIF(@@ERROR,0) IS NOT NULL SELECT @Ok = 1, @OkRef = 'NotificacionFiltro'
END
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
COMMIT TRANSACTION @Transaccion
END ELSE
BEGIN
ROLLBACK TRANSACTION @Transaccion
SELECT 'ERROR: ' + CONVERT(varchar,@Ok) + ', ' + (SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok) +'. ' + ISNULL(@OkRef,'')
END
END

