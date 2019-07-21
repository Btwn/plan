SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNotificacionInsertarIS
@Empresa					varchar(5),
@Usuario					varchar(10),
@Notificacion				varchar(50),
@Modulo						varchar(5),
@ModuloID					int,
@MedioComunicacion			varchar(15),
@FechaNotificacion			datetime,
@TipoFechaNotificacion		varchar(50),
@AnticipacionFechaTipo		varchar(20),
@AnticipacionFecha			int,
@Vencimiento				datetime,
@Para						varchar(max),
@CC							varchar(max),
@CCO						varchar(max),
@Asunto						varchar(255),
@Mensaje					varchar(max),
@Anexos						varchar(max),
@Ok							int			 OUTPUT,
@OkRef						varchar(255) OUTPUT

AS BEGIN
DECLARE
@Solicitud				varchar(max),
@FechaXML					varchar(50),
@ModuloIDXML				varchar(20),
@Hoy						datetime,
@Contrasena				varchar(32),
@Resultado				varchar(max),
@IntelisisServiceID		int,
@NotificacionXML			varchar(50),
@ModuloXML				varchar(5),
@ParaXML					varchar(max),
@CCXML					varchar(max),
@CCOXML					varchar(max),
@AsuntoXML				varchar(255),
@MensajeXML				varchar(max),
@TipoFechaNotificacionXML	varchar(50),
@AnticipacionFechaTipoXML	varchar(20),
@AnticipacionFechaXML		varchar(20),
@VencimientoXML			varchar(50),
@Filtros					varchar(max),
@AnexosXML				varchar(max)
SELECT @Contrasena = Contrasena FROM Usuario WHERE Usuario = @Usuario
SET @Filtros =
(SELECT
NULLIF(dbo.fneDocXMLAUTF8(Empresa,0,1),'') Empresa,
Sucursal Sucursal,
UEN UEN,
NULLIF(dbo.fneDocXMLAUTF8(Usuario,0,1),'') Usuario,
NULLIF(dbo.fneDocXMLAUTF8(Modulo,0,1),'') Modulo,
NULLIF(dbo.fneDocXMLAUTF8(Movimiento,0,1),'') Movimiento,
NULLIF(dbo.fneDocXMLAUTF8(Estatus,0,1),'') Estatus,
NULLIF(dbo.fneDocXMLAUTF8(Situacion,0,1),'') Situacion,
NULLIF(dbo.fneDocXMLAUTF8(Proyecto,0,1),'') Proyecto,
NULLIF(dbo.fneDocXMLAUTF8(ContactoTipo,0,1),'') ContactoTipo,
NULLIF(dbo.fneDocXMLAUTF8(Contacto,0,1),'') Contacto,
NULLIF(ImporteMax,0) ImporteMax,
NULLIF(ImporteMin,0) ImporteMin
FROM NotificacionFiltroNormalizada
WHERE RTRIM(Notificacion) = RTRIM(@Notificacion)
AND ValidarAlEmitir = 1
FOR XML RAW('Filtro'))
IF NULLIF(@Filtros,'') IS NOT NULL SET @Filtros = '<Filtros>' + @Filtros + '</Filtros>'
SET @Hoy = dbo.fnFechaSinHora(GETDATE())
SET @MedioComunicacion = UPPER(@MedioComunicacion)
SET @NotificacionXML = dbo.fneDocXMLAUTF8(ISNULL(@Notificacion,''),0,1)
SET @ModuloXML = dbo.fneDocXMLAUTF8(ISNULL(@Modulo,''),0,1)
SET @ModuloIDXML = LTRIM(RTRIM(CONVERT(varchar,ISNULL(@ModuloID,0))))
SET @FechaXML = RTRIM(CONVERT(varchar,ISNULL(@FechaNotificacion,@Hoy),126))
SET @TipoFechaNotificacionXML = RTRIM(dbo.fneDocXMLAUTF8(ISNULL(@TipoFechaNotificacion,''),0,1))
SET @AnticipacionFechaTipoXML = RTRIM(dbo.fneDocXMLAUTF8(ISNULL(@AnticipacionFechaTipo,''),0,1))
SET @AnticipacionFechaXML = RTRIM(CONVERT(varchar,ISNULL(@AnticipacionFecha,0)))
SET @VencimientoXML = RTRIM(CONVERT(varchar,ISNULL(@Vencimiento,@Hoy),126))
SET @ParaXML = dbo.fneDocXMLAUTF8(ISNULL(@Para,''),0,1)
SET @CCXML = dbo.fneDocXMLAUTF8(ISNULL(@CC,''),0,1)
SET @CCOXML = dbo.fneDocXMLAUTF8(ISNULL(@CCO,''),0,1)
SET @AsuntoXML = dbo.fneDocXMLAUTF8(ISNULL(@Asunto,''),0,1)
SET @MensajeXML = dbo.fneDocXMLAUTF8(ISNULL(@Mensaje,''),0,1)
SET @AnexosXML = dbo.fneDocXMLAUTF8(ISNULL(@Anexos,''),0,1)
SET @Solicitud = '<Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Notificacion" SubReferencia="' + @MedioComunicacion + '" Version="1.0">' +
'  <Solicitud>' +
'    <Notificacion Empresa = "' + @Empresa + '" Fecha="' + @FechaXML  + '" TipoFechaNotificacion="' + @TipoFechaNotificacionXML  + '" AnticipacionFechaTipo="' + @AnticipacionFechaTipoXML  + '" AnticipacionFecha="' + @AnticipacionFechaXML + '" Vencimiento="' + @VencimientoXML + '" Para="' + @ParaXML + '" CC="' + @CCXML + '" CCO="' + @CCOXML + '" Asunto="' + @AsuntoXML + '" Mensaje="' + @MensajeXML + '" Modulo="' + @ModuloXML + '" ModuloID="' + @ModuloIDXML + '" NotificacionNombre="' + @NotificacionXML + '" Anexos="' + @AnexosXML +'" />' +
@Filtros +
'  </Solicitud>' +
'</Intelisis>'
EXEC spIntelisisService @Usuario, @Contrasena, @Solicitud, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, 1, 0, @IntelisisServiceID OUTPUT
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
INSERT NotificacionHist (Fecha,     IntelisisServiceID,  Empresa,  Modulo,  ModuloID,  FechaNotificacion,  Notificacion,  Asunto,  Mensaje,  Para,  CC,  CCO,  Anexos)
VALUES (GETDATE(), @IntelisisServiceID, @Empresa, @Modulo, @ModuloID, @FechaNotificacion, @Notificacion, @Asunto, @Mensaje, @Para, @CC, @CCO, @Anexos)
IF @@ERROR <> 0 SELECT @Ok = 1, @OkRef = 'NotificacionHist'
END
END

