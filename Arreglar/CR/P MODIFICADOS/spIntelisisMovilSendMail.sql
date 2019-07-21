SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spIntelisisMovilSendMail
@IDVisita int,
@Ok		  int		   OUTPUT,
@OkRef	  varchar(255) OUTPUT

AS
BEGIN
SET NOCOUNT ON
DECLARE @account_id       int,
@profile_name     sysname,
@account_name     sysname,
@description      nvarchar(512),
@recipients       varchar(max),
@SMTP_servername  sysname,
@copy_recipients  sysname,
@email_address    varchar(128),
@display_name     varchar(128),
@Empresa          char(5),
@Agente			  varchar(10),
@Para			  varchar(10),
@subject		  nvarchar(255),
@body			  nvarchar(MAX),
@file_attachments nvarchar(MAX),
@FechaD           datetime,
@FechaA           datetime,
@iCal             varchar(MAX),
@Sumary           varchar(255),
@Location         varchar(255),
@iCalsPath		  varchar(255),
@Filename		  varchar(255),
@DescriptionMail  varchar(max)
SELECT
@FechaD          = CD.FechaD,
@FechaA          = CD.FechaA,
@Empresa         = Ca.Empresa,
@profile_name    = Ca.Usuario,
@account_name    = Ca.Usuario,
@email_address   = Us.eMail,
@copy_recipients = Us.eMail,
@display_name    = Us.Nombre,
@Para            = Ca.Agente,
@Sumary          = 'Cliente: ' + Ct.Nombre,
@Location        = isnull(Ct.Direccion, '') + isnull(' ' + Ct.DireccionNumero, ''),
@DescriptionMail = isnull(Ct.Direccion, '') +
isnull(' ' + Ct.DireccionNumero, '') +
isnull(' Int ' + Ct.DireccionNumeroInt, '') +
isnull('\n' + 'Entre Calles ' + Ct.EntreCalles, '') +
isnull('\n' + 'Colonia ' + Ct.Colonia, '') +
isnull(', ' + Ct.Delegacion, '') +
isnull(', ' + Ct.Poblacion, '') +
isnull('\n' + 'C�digo Postal: ' + Ct.CodigoPostal, '') +
isnull('\n' + 'Observaciones: ' + Ct.Observaciones, '')
FROM CampanaD CD
 WITH(NOLOCK) JOIN Campana Ca  WITH(NOLOCK) ON Ca.ID = CD.ID
JOIN Cte Ct  WITH(NOLOCK) ON CD.Contacto = Ct.Cliente
JOIN Usuario Us  WITH(NOLOCK) ON Ca.Usuario = Us.Usuario
WHERE CD.RID = @IDVisita
SELECT @SMTP_servername = CC.ServidorSMTP,
@recipients      = Ag.eMail,
@Empresa         = CC.Empresa,
@iCalsPath       = CC.iCalsPath
FROM MovilUsuarioCfg MU
 WITH(NOLOCK) JOIN Agente Ag  WITH(NOLOCK) ON MU.Agente = Ag.Agente
JOIN CampanaMovilCfg CC  WITH(NOLOCK) ON MU.Empresa = CC.Empresa
WHERE Ag.Agente = @Para
IF ISNULL(@SMTP_servername,'') = ''
BEGIN
select @Ok = 53060, @OkRef = 'No se encuentra configurado el servidor de correo, el usuario no recibira notificaci�n por correo'
RETURN(0)
END
IF ISNULL(@iCalsPath,'') = ''
BEGIN
select @Ok = 53070, @OkRef = 'No se encuentra configurada la ruta de archivos iCal, el usuario no recibira notificaci�n por Calendar'
RETURN(0)
END
IF ISNULL(@account_name,'') = '' OR ISNULL(@email_address,'') = '' OR ISNULL(@recipients,'') = ''
BEGIN
select @Ok = 53050, @OkRef = @account_name
RETURN(0)
END
BEGIN TRANSACTION
IF @Ok IS NULL AND NOT EXISTS (SELECT * FROM msdb.dbo.sysmail_account WHERE name = @account_name )
BEGIN
DECLARE @rv INT
SET @description = 'Cuenta de correo para el usuario ' + @account_name
EXECUTE @rv = msdb.dbo.sysmail_add_account_sp
@account_name = @account_name,
@email_address = @email_address,
@display_name = @display_name,
@replyto_address = @email_address,
@description = @description,
@mailserver_name = @SMTP_servername,
@port = 25,
@account_id = @account_id OUTPUT
IF @rv<>0
BEGIN
select @Ok = 1, @OkRef = 'Error al crear la cuenta de correo (' + @account_name + ').'
ROLLBACK TRANSACTION
END
END
IF @Ok IS NULL AND NOT EXISTS (SELECT * FROM msdb.dbo.sysmail_profile WHERE name = @profile_name)
BEGIN
SET @description = 'Perfil de correo: ' + @profile_name
EXECUTE @rv = msdb.dbo.sysmail_add_profile_sp @profile_name = @profile_name, @description = @description
IF @rv<>0
BEGIN
select @Ok = 1, @OkRef = 'Error al crear el perfil para el correo (' + @profile_name + ').'
ROLLBACK TRANSACTION
END
END
IF @Ok IS NULL AND @account_id IS NOT NULL
BEGIN
EXECUTE @rv = msdb.dbo.sysmail_add_profileaccount_sp
@profile_name = @profile_name,
@account_name = @account_name,
@sequence_number = 1
IF @rv<>0
BEGIN
select @Ok = 1, @OkRef = 'Error al asociar el perfil con la cuenta(' + @account_name + ').'
ROLLBACK TRANSACTION
END
END
IF @Ok IS NULL
BEGIN
BEGIN TRY
SET @iCal = 'BEGIN:VCALENDAR
PRODID:-//Intelisis Pedidos M�vil//ES
VERSION:2.0
CALSCALE:GREGORIAN
METHOD:PUBLISH
X-WR-TIMEZONE:America/Mexico_City
BEGIN:VEVENT
DTSTART:' +  isnull(convert(varchar(30), @FechaD, 112) + 'T' + replace(convert(varchar(30), @FechaD, 108), ':', ''),'') + '
DTEND:' +  isnull(convert(varchar(30), @FechaA, 112) + 'T' + replace(convert(varchar(30), @FechaA, 108), ':', ''),'') + '
UID:mobile@intelisis.com
DESCRIPTION:' + isnull(@Sumary,'') + ' \n\n\nDireccion:\n' + isnull(@DescriptionMail,'') + '
LOCATION:' + isnull(@Location,'') + '
STATUS:TENTATIVE
SUMMARY:Visita a ' + isnull(@Sumary,'') + '
TRANSP:OPAQUE
END:VEVENT
END:VCALENDAR'
SET @body = 'Se gener� una nueva visita para el ' + isnull(@Sumary,'') + '
Fecha y hora: Del ' + isnull(convert(varchar(30), @FechaD, 126) ,'') + ' al ' + isnull(convert(varchar(30), @FechaA, 126) ,'') + '
Direcci�n: ' + isnull(@Location,'')
SET @Filename = 'iCal_' + CAST(@IDVisita AS VARCHAR(10)) + '.ics'
SET @file_attachments = @iCalsPath + '\' + @Filename
PRINT @file_attachments
EXECUTE dbo.spWriteStringToFile @String = @iCal, @Path = @iCalsPath, @Filename = @Filename
SET @subject = 'Intelisis Pedidos M�vil - Cita Generada'
EXEC msdb.dbo.sp_send_dbmail
@profile_name     = @profile_name,
@recipients       = @recipients,
@copy_recipients  = @copy_recipients,
@subject          = @subject,
@body             = @body,
@file_attachments = @file_attachments
END TRY
BEGIN CATCH
select @Ok = 1, @OkRef = ERROR_MESSAGE()
ROLLBACK TRANSACTION
RETURN(0)
END CATCH
END
COMMIT TRANSACTION
SET NOCOUNT OFF
END

