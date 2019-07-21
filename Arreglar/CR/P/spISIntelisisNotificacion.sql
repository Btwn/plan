SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisNotificacion
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT,
@CambiarEstado  bit = 1 OUTPUT

AS BEGIN
DECLARE
@Empresa						varchar(5),
@Fecha						datetime,
@TipoFechaNotificacion		varchar(50),
@AnticipacionFechaTipo		varchar(20),
@AnticipacionFecha			int,
@Vencimiento					datetime,
@Para							varchar(max),
@CC							varchar(max),
@CCO							varchar(max),
@Asunto						varchar(255),
@Mensaje						varchar(max),
@Modulo						varchar(5),
@ModuloID						int,
@Notificacion					varchar(50),
@Hoy							datetime,
@Usuario						varchar(10),
@Referencia					varchar(100),
@SubReferencia				varchar(100),
@InfoEmpresa					varchar(5),
@InfoSucursal					int,
@InfoUEN						int,
@InfoUsuario					varchar(10),
@InfoMov						varchar(20),
@InfoEstatus					varchar(15),
@InfoSituacion				varchar(50),
@InfoProyecto					varchar(50),
@InfoCtoTipo					varchar(20),
@InfoContacto					varchar(10),
@InfoImporte					float,
@InfoFechaEmision				datetime,
@InfoVencimiento				datetime,
@InfoFechaRegistro			datetime,
@GenerarNotificacion			bit,
@Anexos						varchar(max)
SET @GenerarNotificacion = 0
SET @Hoy = dbo.fnFechaSinHora(GETDATE())
DECLARE @Usuarios TABLE
(
Usuario			varchar(10) COLLATE DATABASE_DEFAULT NULL
)
DECLARE @Filtro TABLE
(
Empresa			varchar(5) COLLATE DATABASE_DEFAULT NULL,
Sucursal			int,
UEN				int,
Usuario			varchar(10) COLLATE DATABASE_DEFAULT NULL,
Modulo			varchar(5) COLLATE DATABASE_DEFAULT NULL,
Movimiento		varchar(20) COLLATE DATABASE_DEFAULT NULL,
Estatus			varchar(15) COLLATE DATABASE_DEFAULT NULL,
Situacion			varchar(50) COLLATE DATABASE_DEFAULT NULL,
Proyecto			varchar(50) COLLATE DATABASE_DEFAULT NULL,
ContactoTipo		varchar(20) COLLATE DATABASE_DEFAULT NULL,
Contacto			varchar(50) COLLATE DATABASE_DEFAULT NULL,
ImporteMax		float,
ImporteMin		float
)
SELECT
@Referencia = Referencia
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud')
WITH (Referencia varchar(100))
SELECT
@Empresa = Empresa,
@Fecha = dbo.fnFechaSinHora(Fecha),
@TipoFechaNotificacion = TipoFechaNotificacion,
@AnticipacionFechaTipo = AnticipacionFechaTipo,
@AnticipacionFecha = AnticipacionFecha,
@Vencimiento = dbo.fnFechaSinHora(Vencimiento),
@Para = Para,
@CC = CC,
@CCO = CCO,
@Asunto = Asunto,
@Mensaje = Mensaje,
@Modulo = Modulo,
@ModuloID = ModuloID,
@Notificacion = NotificacionNombre,
@Anexos		= Anexos
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/Notificacion')
WITH (Empresa varchar(5), Fecha datetime, TipoFechaNotificacion varchar(50), AnticipacionFechaTipo varchar(20), AnticipacionFecha int, Vencimiento datetime, Para varchar(max), CC varchar(max), CCO  varchar(max), Asunto varchar(255), Mensaje varchar(max), Modulo varchar(5), ModuloID int, NotificacionNombre varchar(50), Anexos varchar(max))
INSERT @Filtro (Empresa, Sucursal, UEN, Usuario, Modulo, Movimiento, Estatus, Situacion, Proyecto, ContactoTipo, Contacto, ImporteMax, ImporteMin)
SELECT
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
ImporteMax,
ImporteMin
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/Filtros/Filtro')
WITH (Empresa varchar(5), Sucursal int, UEN int, Usuario varchar(10), Modulo varchar(5), Movimiento varchar(20), Estatus varchar(15),Situacion varchar(50), Proyecto varchar(50), ContactoTipo varchar(20), Contacto varchar(10), ImporteMax float, ImporteMin float)
IF @TipoFechaNotificacion = '(Vencimiento)' OR EXISTS(SELECT 1 FROM @Filtro)
BEGIN
EXEC spMovInfo @ModuloID, @Modulo, @Empresa = @InfoEmpresa OUTPUT, @Sucursal = @InfoSucursal OUTPUT, @UEN = @InfoUEN OUTPUT, @Usuario = @InfoUsuario OUTPUT, @Mov = @InfoMov OUTPUT, @Estatus = @InfoEstatus OUTPUT, @Situacion = @InfoSituacion OUTPUT, @Proyecto = @InfoProyecto OUTPUT, @CtoTipo = @InfoCtoTipo OUTPUT, @Contacto = @InfoContacto OUTPUT, @Importe = @InfoImporte OUTPUT, @FechaEmision = @InfoFechaEmision OUTPUT, @Vencimiento = @InfoVencimiento OUTPUT, @FechaRegistro = @InfoFechaRegistro OUTPUT
SET @InfoEmpresa      = ISNULL(@InfoEmpresa,'')
SET @InfoSucursal     = ISNULL(@InfoSucursal,-1)
SET @InfoUEN          = ISNULL(@InfoUEN,-1)
SET @InfoUsuario      = ISNULL(@InfoUsuario,'')
SET @Modulo           = ISNULL(@Modulo,'')
SET @InfoMov          = ISNULL(@InfoMov,'')
SET @InfoEstatus      = ISNULL(@InfoEstatus,'')
SET @InfoSituacion    = ISNULL(@InfoSituacion,'')
SET @InfoProyecto     = ISNULL(@InfoProyecto,'')
SET @InfoCtoTipo      = ISNULL(@InfoCtoTipo,'')
SET @InfoContacto     = ISNULL(@InfoContacto,'')
SET @InfoImporte      = ISNULL(@InfoImporte,0.0)
SET @InfoVencimiento  = ISNULL(@InfoVencimiento,@InfoFechaEmision)
END
IF NOT EXISTS(SELECT 1 FROM @Filtro)
SELECT @GenerarNotificacion = 1
ELSE
BEGIN
IF EXISTS(SELECT 1
FROM @Filtro
WHERE RTRIM(ISNULL(Empresa,@InfoEmpresa)) = RTRIM(@InfoEmpresa)
AND ISNULL(Sucursal,@InfoSucursal) = @InfoSucursal
AND ISNULL(UEN,@InfoUEN) = @InfoUEN
AND RTRIM(ISNULL(Usuario,@InfoUsuario)) = RTRIM(@InfoUsuario)
AND RTRIM(ISNULL(Modulo,@Modulo)) = RTRIM(@Modulo)
AND RTRIM(ISNULL(Movimiento,@InfoMov)) = RTRIM(@InfoMov)
AND RTRIM(ISNULL(Estatus,@InfoEstatus)) = RTRIM(@InfoEstatus)
AND RTRIM(ISNULL(Situacion,@InfoSituacion)) = RTRIM(@InfoSituacion)
AND RTRIM(ISNULL(Proyecto,@InfoProyecto)) = RTRIM(@InfoProyecto)
AND RTRIM(ISNULL(ContactoTipo,@InfoCtoTipo)) = RTRIM(@InfoCtoTipo)
AND RTRIM(ISNULL(Contacto,@InfoContacto)) = RTRIM(@InfoContacto)
AND @InfoImporte BETWEEN ISNULL(ImporteMin,@InfoImporte) AND ISNULL(ImporteMax,@InfoImporte))
SET @GenerarNotificacion = 1
END
IF @TipoFechaNotificacion = '(Vencimiento)'
BEGIN
SELECT @Fecha = dbo.fnNotificacionFecha(@TipoFechaNotificacion,@Fecha,@AnticipacionFechaTipo, @AnticipacionFecha,@InfoFechaEmision,@InfoVencimiento)
END
IF @Fecha IS NOT NULL AND @Fecha <= @Hoy
BEGIN
IF  @GenerarNotificacion = 1
BEGIN
EXEC spIntelisisServiceEnviarCorreo @Empresa, @Para, @CC, @CCO, @Asunto, @Mensaje, @Anexos
INSERT @Usuarios (Usuario)
SELECT  Usuario
FROM  dbo.fnCorreosAUsuarios(@Para)
INSERT @Usuarios (Usuario)
SELECT  Usuario
FROM  dbo.fnCorreosAUsuarios(@CC)
INSERT @Usuarios (Usuario)
SELECT  Usuario
FROM  dbo.fnCorreosAUsuarios(@CCO)
DECLARE crUsuarios CURSOR FOR
SELECT DISTINCT Usuario
FROM @Usuarios
WHERE NULLIF(Usuario,'') IS NOT NULL
OPEN crUsuarios
FETCH NEXT FROM crUsuarios INTO @Usuario
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
INSERT UsuarioNotificacion (Usuario,  IntelisisServiceID, Empresa,  Modulo,  ModuloID,  FechaNotificacion,  Notificacion,  Asunto,  Mensaje,  Para,  CC,  CCO,  Estatus,     Anexos)
VALUES (@Usuario, @ID,                @Empresa, @Modulo, @ModuloID, @Fecha,             @Notificacion, @Asunto, @Mensaje, @Para, @CC, @CCO, 'PENDIENTE', @Anexos)
IF @@ERROR <> 0 SELECT @Ok = 1, @OkRef = 'UsuarioNotificacion'
FETCH NEXT FROM crUsuarios INTO @Usuario
END
CLOSE crUsuarios
DEALLOCATE crUsuarios
IF @Ok IS NULL
SET @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@Referencia,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + ' Proceso="Enviado"/></Intelisis>'
END ELSE
BEGIN
SET @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@Referencia,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + ' Proceso="No Enviado"/></Intelisis>'
END
END ELSE
BEGIN
SET @CambiarEstado = 0
END
END

