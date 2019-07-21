SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnNotificacionCorreosDestinatarios
(
@Notificacion				varchar(50),
@Usuario					varchar(10),
@Seccion					varchar(20),
@ContactoTipo				varchar(20),
@Contacto					varchar(10)
)
RETURNS varchar(max)

AS BEGIN
DECLARE
@ListaCorreos			varchar(max),
@RID					int,
@TipoDestinatario		varchar(20),
@Destinatario			varchar(100),
@DestinatarioCorreo	varchar(255),
@Correo				varchar(255),
@Personal				varchar(10),
@MiJefe				varchar(10),
@ElJefeDeMiJefe		varchar(10)
SET @ListaCorreos = ''
DECLARE crNotificacionDestinatario CURSOR FOR
SELECT RID, ISNULL(TipoDestinatario,''), ISNULL(Destinatario,''), ISNULL(DestinatarioCorreo,'')
FROM NotificacionDestinatario
WHERE Notificacion = @Notificacion
AND SeccionDestinatario = @Seccion
OPEN crNotificacionDestinatario
FETCH NEXT FROM crNotificacionDestinatario INTO @RID, @TipoDestinatario, @Destinatario, @DestinatarioCorreo
WHILE @@FETCH_STATUS = 0
BEGIN
IF @TipoDestinatario = '(YO)'
BEGIN
SELECT @Correo = ISNULL(eMail,''), @Personal = Personal FROM Usuario WHERE Usuario = @Usuario
IF NULLIF(@Correo,'') IS NULL SELECT @Correo = ISNULL(eMail,'') FROM Personal WHERE Personal = @Personal
END ELSE
IF @TipoDestinatario = '(MI JEFE)'
BEGIN
SELECT @Personal = Personal FROM Usuario WHERE Usuario = @Usuario
IF NULLIF(@Personal,'') IS NOT NULL SELECT @MiJefe = NULLIF(ReportaA,'') FROM Personal WHERE Personal = @Personal
IF @MiJefe IS NOT NULL SELECT @Correo = ISNULL(eMail,'') FROM Personal WHERE Personal = @MiJefe AND Estatus NOT IN('BAJA')
SET @Correo = ISNULL(@Correo,'')
END ELSE
IF @TipoDestinatario = '(EL JEFE DE MI JEFE)'
BEGIN
SELECT @Personal = Personal FROM Usuario WHERE Usuario = @Usuario
IF NULLIF(@Personal,'') IS NOT NULL SELECT @MiJefe = NULLIF(ReportaA,'') FROM Personal WHERE Personal = @Personal
IF @MiJefe IS NOT NULL SELECT @ElJefeDeMiJefe = NULLIF(ReportaA,'') FROM Personal WHERE Personal = @MiJefe
IF @ElJefeDeMiJefe IS NOT NULL SELECT @Correo = ISNULL(eMail,'') FROM Personal WHERE Personal = @ElJefeDeMiJefe AND Estatus NOT IN('BAJA')
SET @Correo = ISNULL(@Correo,'')
END ELSE
IF @TipoDestinatario = '(ESPECIFICO)'
BEGIN
SET @Correo = ISNULL(@DestinatarioCorreo,'')
END ELSE
IF @TipoDestinatario = '(CONTACTO)'
BEGIN
IF @ContactoTipo = 'Cliente'   SELECT @Correo = ISNULL(ISNULL(NULLIF(Email1,''),NULLIF(Email2,'')),'') FROM Cte    WHERE Cliente   = @Contacto ELSE
IF @ContactoTipo = 'Proveedor' SELECT @Correo = ISNULL(ISNULL(NULLIF(Email1,''),NULLIF(Email2,'')),'') FROM Prov   WHERE Proveedor = @Contacto ELSE
IF @ContactoTipo = 'Agente'    SELECT @Correo = ISNULL(NULLIF(Email,''),'') FROM Agente WHERE Agente = @Contacto ELSE
SET @Correo = ''
END ELSE
IF @TipoDestinatario = '(SUBORDINADOS)'
BEGIN
SET @Correo = dbo.fnNotificacionCorreoSubAlterno(@Usuario)
END
IF NULLIF(@ListaCorreos,'') IS NOT NULL AND NULLIF(@Correo,'') IS NOT NULL SELECT @ListaCorreos = @ListaCorreos + ';' + @Correo ELSE
IF NULLIF(@ListaCorreos,'') IS NULL AND NULLIF(@Correo,'') IS NOT NULL SELECT @ListaCorreos = @ListaCorreos + @Correo
FETCH NEXT FROM crNotificacionDestinatario INTO @RID, @TipoDestinatario, @Destinatario, @DestinatarioCorreo
END
CLOSE crNotificacionDestinatario
DEALLOCATE crNotificacionDestinatario
RETURN (@ListaCorreos)
END

