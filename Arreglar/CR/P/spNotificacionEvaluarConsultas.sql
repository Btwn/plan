SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNotificacionEvaluarConsultas
@Estacion					int,
@ID							int,
@Modulo						varchar(5),
@Notificacion				varchar(50),
@NotificacionClave			varchar(50),
@Empresa					varchar(5),
@Sucursal					int,
@UEN						int,
@Usuario					varchar(10),
@Mov						varchar(20),
@Estatus					varchar(15),
@Situacion					varchar(50),
@Proyecto					varchar(50),
@ContactoTipo				varchar(20),
@Contacto					varchar(10),
@Importe					float,
@EmpresaNombre				varchar(100),
@SucursalNombre				varchar(100),
@UENNombre					varchar(100),
@UsuarioNombre				varchar(100),
@ContactoNombre				varchar(100),
@FechaEmision				datetime,
@Ok							int = NULL OUTPUT,
@OkRef						varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@ConsultaNombre			varchar(50),
@Consulta					varchar(max),
@Resultado				varchar(255)
DELETE FROM NotificacionConsultaTemp WHERE Estacion = @Estacion AND Notificacion = @Notificacion
DECLARE crNotificacionConsulta CURSOR FOR
SELECT ConsultaNombre, Consulta
FROM NotificacionConsulta
WHERE Notificacion = @Notificacion
OPEN crNotificacionConsulta
FETCH NEXT FROM crNotificacionConsulta INTO @ConsultaNombre, @Consulta
WHILE @@FETCH_STATUS = 0 AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
EXEC spNotificacionEvaluarConsulta @ID, @Modulo, @Notificacion, @NotificacionClave, @Empresa, @Sucursal, @UEN, @Usuario, @Mov, @Estatus, @Situacion, @Proyecto, @ContactoTipo, @Contacto, @Importe, @EmpresaNombre, @SucursalNombre, @UENNombre, @UsuarioNombre, @ContactoNombre, @FechaEmision, @Consulta, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
IF NOT EXISTS(SELECT 1 FROM NotificacionConsultaTemp WHERE Estacion = @Estacion AND Notificacion = @Notificacion AND ConsultaNombre = @ConsultaNombre)
BEGIN
INSERT NotificacionConsultaTemp (Estacion,  Notificacion,  ConsultaNombre,  Valor)
VALUES (@Estacion, @Notificacion, @ConsultaNombre, ISNULL(@Resultado,''))
IF @@ERROR <> 0 SELECT @Ok = 1, @OkRef = @Notificacion
END ELSE
BEGIN
UPDATE NotificacionConsultaTemp SET Valor = ISNULL(@Resultado,'') WHERE Estacion = @Estacion AND Notificacion = @Notificacion AND ConsultaNombre = @ConsultaNombre
IF @@ERROR <> 0 SELECT @Ok = 1, @OkRef = @Notificacion
END
END
FETCH NEXT FROM crNotificacionConsulta INTO @ConsultaNombre, @Consulta
END
CLOSE crNotificacionConsulta
DEALLOCATE crNotificacionConsulta
RETURN
END

