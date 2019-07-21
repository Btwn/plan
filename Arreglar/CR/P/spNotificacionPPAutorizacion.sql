SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNotificacionPPAutorizacion
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
@GenerarNotificacion		bit = 0 OUTPUT,
@Ok							int = NULL OUTPUT,
@OkRef						varchar(255) = NULL OUTPUT

AS BEGIN
SET @GenerarNotificacion = 1
EXEC xpNotificacionPPAutorizacion @ID, @Modulo, @Notificacion, @NotificacionClave, @Empresa, @Sucursal, @UEN, @Usuario, @Mov, @Estatus, @Situacion, @Proyecto, @ContactoTipo, @Contacto, @Importe, @GenerarNotificacion OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END

