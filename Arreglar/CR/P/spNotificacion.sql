SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNotificacion
@ID							int,
@Modulo						varchar(5),
@Ok							int = NULL OUTPUT,
@OkRef						varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Notificacion				varchar(50),
@NotificacionClave		varchar(50),
@Empresa					varchar(5),
@Sucursal					int,
@UEN						int,
@Usuario					varchar(10),
@Mov						varchar(20),
@MovID					varchar(20),
@Estatus					varchar(15),
@Situacion				varchar(50),
@Proyecto					varchar(50),
@ContactoTipo				varchar(20),
@Contacto					varchar(10),
@Importe					float,
@FechaEmision				datetime,
@GenerarNotificacion		bit,
@Asunto					varchar(255),
@Mensaje					varchar(max),
@Para						varchar(max),
@CC						varchar(max),
@CCO						varchar(max),
@EmpresaNombre			varchar(100),
@SucursalNombre			varchar(100),
@UENNombre				varchar(100),
@UsuarioNombre			varchar(100),
@ContactoNombre			varchar(100),
@Vencimiento				datetime,
@TipoFechaNotificacion	varchar(50),
@FechaNotificacion		datetime,
@AnticipacionFechaTipo	varchar(20),
@AnticipacionFecha		int,
@MedioComunicacion		varchar(15),
@CondicionUsuario			varchar(max),
@FechaRegistro			datetime,
@Movimiento				varchar(50),
@Anexos					varchar(8000)
EXEC spMovInfo @ID, @Modulo, @Empresa = @Empresa OUTPUT, @Sucursal = @Sucursal OUTPUT, @UEN = @UEN OUTPUT, @Usuario = @Usuario OUTPUT, @Mov = @Mov OUTPUT, @MovID = @MovID OUTPUT, @Estatus = @Estatus OUTPUT, @Situacion = @Situacion OUTPUT, @Proyecto = @Proyecto OUTPUT, @CtoTipo = @ContactoTipo OUTPUT, @Contacto = @Contacto OUTPUT, @Importe = @Importe OUTPUT, @FechaEmision = @FechaEmision OUTPUT, @Vencimiento = @Vencimiento OUTPUT, @FechaRegistro = @FechaRegistro OUTPUT
SET @Empresa      = ISNULL(@Empresa,'')
SET @Sucursal     = ISNULL(@Sucursal,-1)
SET @UEN          = ISNULL(@UEN,-1)
SET @Usuario      = ISNULL(@Usuario,'')
SET @Modulo       = ISNULL(@Modulo,'')
SET @Mov          = LTRIM(RTRIM(ISNULL(@Mov,'')))
SET @MovID        = LTRIM(RTRIM(ISNULL(@MovID,'')))
SET @Estatus      = ISNULL(@Estatus,'')
SET @Situacion    = ISNULL(@Situacion,'')
SET @Proyecto     = ISNULL(@Proyecto,'')
SET @ContactoTipo = ISNULL(@ContactoTipo,'')
SET @Contacto     = ISNULL(@Contacto,'')
SET @Importe      = ISNULL(@Importe,0.0)
SET @Vencimiento  = ISNULL(@Vencimiento,@FechaEmision)
IF @FechaRegistro IS NULL
SELECT @FechaRegistro = GETDATE()
SET @Movimiento = @Mov + ' ' + @MovID
SELECT @EmpresaNombre  = ISNULL(Nombre,'') FROM Empresa WHERE Empresa = @Empresa
SELECT @SucursalNombre = ISNULL(Nombre,'') FROM Sucursal WHERE Sucursal = @Sucursal
SELECT @UENNombre      = ISNULL(Nombre,'') FROM UEN WHERE UEN = @UEN
SELECT @UsuarioNombre  = ISNULL(Nombre,'') FROM Usuario WHERE Usuario = @Usuario
IF @ContactoTipo = 'Cliente'   SELECT @ContactoNombre = ISNULL(Nombre,'') FROM Cte    WHERE Cliente   = @Contacto ELSE
IF @ContactoTipo = 'Proveedor' SELECT @ContactoNombre = ISNULL(Nombre,'') FROM Prov   WHERE Proveedor = @Contacto ELSE
IF @ContactoTipo = 'Agente'    SELECT @ContactoNombre = ISNULL(Nombre,'') FROM Agente WHERE Agente    = @Contacto ELSE
SET @ContactoNombre = ''
DECLARE crNotificacion CURSOR FOR
SELECT Notificacion, Clave, Asunto, Mensaje, RTRIM(ISNULL(TipoFechaNotificacion,'(Emision)')), FechaNotificacion, ISNULL(AnticipacionFechaTipo,'APLAZAR'), ISNULL(AnticipacionFecha,0.0), ISNULL(MedioComunicacion,'EMAIL'), RTRIM(ISNULL(CondicionUsuario,''))
FROM Notificacion
WHERE Estatus = 'ACTIVA'
OPEN crNotificacion
FETCH NEXT FROM crNotificacion INTO @Notificacion, @NotificacionClave, @Asunto, @Mensaje, @TipoFechaNotificacion, @FechaNotificacion, @AnticipacionFechaTipo, @AnticipacionFecha, @MedioComunicacion, @CondicionUsuario
WHILE @@FETCH_STATUS = 0 AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
SET @GenerarNotificacion = 0
EXEC spNotificacionProcesarFiltro @ID, @Modulo, @Notificacion, @Empresa, @Sucursal, @UEN, @Usuario, @Mov, @Estatus, @Situacion, @Proyecto, @ContactoTipo, @Contacto, @Importe, @GenerarNotificacion OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @GenerarNotificacion = 1
BEGIN
EXEC spNotificacionProcesarParametros @ID, @Modulo, @Notificacion, @NotificacionClave, @Empresa, @Sucursal, @UEN, @Usuario, @Mov, @Estatus, @Situacion, @Proyecto, @ContactoTipo, @Contacto, @Importe, @GenerarNotificacion OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @GenerarNotificacion = 1
BEGIN
EXEC spNotificacionVerificarVigencia @Notificacion, @FechaEmision, @GenerarNotificacion OUTPUT
IF @GenerarNotificacion = 1
BEGIN
EXEC spNotificacionVerificarVigenciaHora @Notificacion, @FechaRegistro, @GenerarNotificacion OUTPUT
IF @GenerarNotificacion = 1
BEGIN
EXEC spNotificacionEnFrecuencia @Notificacion, @FechaEmision, @GenerarNotificacion OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @GenerarNotificacion = 1
BEGIN
EXEC spNotificacionCondicionUsuario @ID, @Modulo, @Notificacion, @NotificacionClave, @Empresa, @Sucursal, @UEN, @Usuario, @Mov, @Estatus, @Situacion, @Proyecto, @ContactoTipo, @Contacto, @Importe, @EmpresaNombre, @SucursalNombre, @UENNombre, @UsuarioNombre, @ContactoNombre, @FechaEmision, @CondicionUsuario, @GenerarNotificacion OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @GenerarNotificacion = 1
BEGIN
EXEC spNotificacionEvaluarConsultas @@SPID, @ID, @Modulo, @Notificacion, @NotificacionClave, @Empresa, @Sucursal, @UEN, @Usuario, @Mov, @Estatus, @Situacion, @Proyecto, @ContactoTipo, @Contacto, @Importe, @EmpresaNombre, @SucursalNombre, @UENNombre, @UsuarioNombre, @ContactoNombre, @FechaEmision, @Ok OUTPUT, @OkRef OUTPUT
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
EXEC spNotificacionParsearMensaje @@SPID, @ID, @Modulo, @Notificacion, @NotificacionClave, @Empresa, @Sucursal, @UEN, @Usuario, @Movimiento, @Estatus, @Situacion, @Proyecto, @ContactoTipo, @Contacto, @Importe, @EmpresaNombre, @SucursalNombre, @UENNombre, @UsuarioNombre, @ContactoNombre, @FechaEmision, @Asunto OUTPUT, @Mensaje OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
SELECT @FechaNotificacion = dbo.fnNotificacionFecha(@TipoFechaNotificacion,@FechaNotificacion,@AnticipacionFechaTipo, @AnticipacionFecha,@FechaEmision,@Vencimiento)
SELECT @Para = dbo.fnNotificacionCorreosDestinatarios(@Notificacion, @Usuario, 'Para', @ContactoTipo, @Contacto)
SELECT @CC = dbo.fnNotificacionCorreosDestinatarios(@Notificacion, @Usuario, 'CC', @ContactoTipo, @Contacto)
SELECT @CCO = dbo.fnNotificacionCorreosDestinatarios(@Notificacion, @Usuario, 'CCO', @ContactoTipo, @Contacto)
EXEC spNotificacionAnexo @@SPID, @ID, @Modulo, @Notificacion, @NotificacionClave, @Empresa, @Sucursal, @UEN, @Usuario, @Mov, @MovID, @Movimiento, @Estatus, @Situacion, @Proyecto, @ContactoTipo, @Contacto, @Importe, @EmpresaNombre, @SucursalNombre, @UENNombre, @UsuarioNombre, @ContactoNombre, @FechaEmision, @Ok OUTPUT, @OkRef OUTPUT, @Anexos OUTPUT
IF @Ok IS NULL
EXEC spNotificacionInsertarIS @Empresa, @Usuario, @Notificacion, @Modulo, @ID, @MedioComunicacion, @FechaNotificacion, @TipoFechaNotificacion, @AnticipacionFechaTipo, @AnticipacionFecha, @Vencimiento, @Para, @CC, @CCO, @Asunto, @Mensaje, @Anexos, @Ok OUTPUT, @OkRef OUTPUT
END
END
END
END
END
END
END
FETCH NEXT FROM crNotificacion INTO @Notificacion, @NotificacionClave, @Asunto, @Mensaje, @TipoFechaNotificacion, @FechaNotificacion, @AnticipacionFechaTipo, @AnticipacionFecha, @MedioComunicacion, @CondicionUsuario
END
CLOSE crNotificacion
DEALLOCATE crNotificacion
END

