SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEnviarReciboNomina
@Empresa     varchar(5),
@ID			int = NULL,
@Personal		varchar(100),
@Estacion		varchar(5)

AS BEGIN
DECLARE
@Anexos				varchar(550),
@EnviarXML			bit,
@EnviarPDF			bit,
@Enviar				bit,
@Fecha				datetime,
@NombreCorreoEnLote	varchar(100),
@Perfil				varchar(50),
@Para				varchar(8000),
@CC					varchar(8000),
@CCO				varchar(8000),
@Asunto				varchar(8000),
@Mensaje			varchar(max),
@Formato			varchar(50),
@Importancia		varchar(20),
@Sensitividad		varchar(20),
@Adjuntos			varchar(max),
@SQL				varchar(8000),
@SQLBase			varchar(50),
@SQLAnexar			bit,
@SQLAnexarNombre	varchar(255),
@SQLConEncabezados	bit,
@SQLAncho			int,
@SQLSeparador		char(1),
@mailitem_id		int,
@Estatus			varchar(50)
SELECT @EnviarXML = 0, @EnviarPDF = 0, @Enviar = 0, @Formato = 'HTML', @Importancia = 'Normal',
@Sensitividad = 'Normal', @SQLAnexar = 0, @SQLConEncabezados = 1, @SQLSeparador = ' ', @Anexos = NULL
EXEC spAsuntoNomina @Empresa,@ID,@Personal,@Asunto=@Asunto OUTPUT
SELECT @Mensaje = EnviarMensajeNomina,@EnviarXML=EnviarXMLNomina,@EnviarPDF=EnviarPDFNomina,@Enviar=EnviarNomina  FROM EmpresaCFD WITH (NOLOCK) WHERE Empresa = @Empresa
SELECT @Para =ISNULL (eMail,'' ) FROM Personal WITH (NOLOCK) WHERE Personal=@Personal
IF (@EnviarXML=1	AND @Enviar=1)
SELECT @Anexos=ArchivoXML FROM CFDINominaRecibo WITH (NOLOCK) WHERE RID= @ID
IF (@EnviarPDF =1 AND @Enviar =1 )
BEGIN
IF LEN(@Anexos)>0
SET @Anexos=@Anexos+';'
SELECT @Anexos=(ISNULL(@Anexos,'')+ArchivoPDF) FROM CFDINominaRecibo WITH (NOLOCK) WHERE RID= @ID
END
SELECT @Perfil = DBMailPerfil FROM EmpresaGral WITH (NOLOCK) WHERE  Empresa = @Empresa
SELECT	 @Para    = NULLIF(RTRIM(@Para), ''),
@Mensaje = NULLIF(RTRIM(@Mensaje), ''),
@Asunto  = NULLIF(RTRIM(@Asunto), ''),
@Anexos  = NULLIF(RTRIM(@Anexos), ''),
@SQL     = NULLIF(RTRIM(@SQL), ''),
@Fecha   = GETDATE()
IF SUBSTRING(@Anexos,LEN(@Anexos),1) = ';' SELECT @Anexos = STUFF(@Anexos,LEN(@Anexos),1,'')
DELETE  FROM ListaModuloID WHERE ID=@ID AND Estacion =@Estacion
IF @Para IS NOT NULL
BEGIN
IF ((SELECT dbo.fnSQL2005()) = 1) OR ((SELECT dbo.fnSQL2008()) = 1) OR ((SELECT dbo.fnSQL2012()) = 1)
EXEC msdb.dbo.sp_send_dbmail
@profile_name = @Perfil,
@recipients = @Para,
@copy_recipients = @CC,
@blind_copy_recipients = @CCO,
@subject = @Asunto,
@body = @Mensaje,
@body_format = @Formato,
@importance = @Importancia,
@sensitivity = @Sensitividad,
@file_attachments = @Anexos,
@query = @SQL,
@execute_query_database = @SQLBase,
@attach_query_result_as_file = @SQLAnexar,
@query_attachment_filename = @SQLAnexarNombre,
@query_result_header = @SQLConEncabezados,
@query_result_width = @SQLAncho,
@query_result_separator = @SQLSeparador,
@mailitem_id	=@mailitem_id OUTPUT
UPDATE CFDINominaRecibo WITH (ROWLOCK) SET EnviarMail=1 WHERE RID =@ID
SELECT @Estatus=sent_status FROM msdb.dbo.sysmail_allitems WITH (NOLOCK) where mailitem_id=@mailitem_id
UPDATE CFDINominaRecibo WITH (ROWLOCK)SET EnviarMailSql= CASE WHEN  @Estatus='sent' THEN 'Enviado' WHEN @Estatus='failed' THEN 'Error' ELSE 'Enviando' END, mailitem_id=@mailitem_id WHERE RID =@ID
SELECT @NombreCorreoEnLote = NombreCorreoEnLote FROM Version WITH(NOLOCK)
EXEC spOutlook @NombreCorreoEnLote, @Fecha, @Asunto, @Mensaje, @Anexos, @EnSilencio = 1, @ID = @ID OUTPUT
EXEC spOutlookPara @ID, @Para
END
SELECT ''
END

