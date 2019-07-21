SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNotificacionPMAutorizacion
@ID							int,
@Modulo						varchar(5),
@Notificacion				varchar(50),
@NotificacionClave			varchar(50),
@Empresa					varchar(5),
@Sucursal					int,
@UEN						int,
@Usuario					varchar(10),
@Mov						varchar(50),
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
@Asunto						varchar(255) OUTPUT,
@Mensaje					varchar(max) OUTPUT,
@Ok							int = NULL OUTPUT,
@OkRef						varchar(255) = NULL OUTPUT

AS BEGIN
SELECT @Mensaje = @Mensaje + CHAR(10) + CHAR(13) + dbo.fnNotificacionCadenaAutorizacion(@Empresa, @Sucursal, @Modulo, @ID, @Estatus, @Situacion, @Usuario)
EXEC xpNotificacionPMAutorizacion @ID, @Modulo, @Notificacion, @NotificacionClave, @Empresa, @Sucursal, @UEN, @Usuario, @Mov, @Estatus, @Situacion, @Proyecto, @ContactoTipo, @Contacto, @Importe, @EmpresaNombre, @SucursalNombre, @UENNombre, @UsuarioNombre, @ContactoNombre, @FechaEmision, @Asunto OUTPUT, @Mensaje OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END

