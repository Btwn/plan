SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISNotificacionProcesarFiltro
@ID							int,
@Modulo						varchar(5),
@Notificacion				varchar(50),
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
SET @GenerarNotificacion = 0
SET @Importe = ISNULL(@Importe,0.0)
IF NOT EXISTS(SELECT 1 FROM NotificacionFiltroNormalizada WHERE RTRIM(Notificacion) = RTRIM(@Notificacion))
SELECT @GenerarNotificacion = 1
ELSE
BEGIN
IF EXISTS(SELECT 1
FROM NotificacionFiltroNormalizada
WHERE RTRIM(Notificacion) = RTRIM(@Notificacion)
AND RTRIM(ISNULL(Empresa,@Empresa)) = RTRIM(@Empresa)
AND ISNULL(Sucursal,@Sucursal) = @Sucursal
AND ISNULL(UEN,@UEN) = @UEN
AND RTRIM(ISNULL(Usuario,@Usuario)) = RTRIM(@Usuario)
AND RTRIM(ISNULL(Modulo,@Modulo)) = RTRIM(@Modulo)
AND RTRIM(ISNULL(Movimiento,@Mov)) = RTRIM(@Mov)
AND RTRIM(ISNULL(Estatus,@Estatus)) = RTRIM(@Estatus)
AND RTRIM(ISNULL(Situacion,@Situacion)) = RTRIM(@Situacion)
AND RTRIM(ISNULL(Proyecto,@Proyecto)) = RTRIM(@Proyecto)
AND RTRIM(ISNULL(ContactoTipo,@ContactoTipo)) = RTRIM(@ContactoTipo)
AND RTRIM(ISNULL(Contacto,@Contacto)) = RTRIM(@Contacto)
AND @Importe BETWEEN ISNULL(ImporteMin,@Importe) AND ISNULL(ImporteMax,@Importe))
SET @GenerarNotificacion = 1
END
END

