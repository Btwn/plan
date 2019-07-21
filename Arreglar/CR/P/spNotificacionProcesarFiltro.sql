SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNotificacionProcesarFiltro
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
WHERE LTRIM(RTRIM(Notificacion)) = LTRIM(RTRIM(@Notificacion))
AND LTRIM(RTRIM(ISNULL(Empresa,@Empresa))) = LTRIM(RTRIM(@Empresa))
AND ISNULL(Sucursal,@Sucursal) = @Sucursal
AND ISNULL(UEN,@UEN) = @UEN
AND LTRIM(RTRIM(ISNULL(Usuario,@Usuario))) = LTRIM(RTRIM(@Usuario))
AND LTRIM(RTRIM(ISNULL(Modulo,@Modulo))) = LTRIM(RTRIM(@Modulo))
AND LTRIM(RTRIM(ISNULL(Movimiento,@Mov))) = LTRIM(RTRIM(@Mov))
AND LTRIM(RTRIM(ISNULL(Estatus,@Estatus))) = LTRIM(RTRIM(@Estatus))
AND LTRIM(RTRIM(ISNULL(Situacion,@Situacion))) = LTRIM(RTRIM(@Situacion))
AND LTRIM(RTRIM(ISNULL(Proyecto,@Proyecto))) = LTRIM(RTRIM(@Proyecto))
AND LTRIM(RTRIM(ISNULL(ContactoTipo,@ContactoTipo))) = LTRIM(RTRIM(@ContactoTipo))
AND LTRIM(RTRIM(ISNULL(Contacto,@Contacto))) = LTRIM(RTRIM(@Contacto))
AND @Importe BETWEEN ISNULL(ImporteMin,@Importe) AND ISNULL(ImporteMax,@Importe))
SET @GenerarNotificacion = 1
END
END

