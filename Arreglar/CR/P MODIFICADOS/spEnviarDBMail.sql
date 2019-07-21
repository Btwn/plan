SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEnviarDBMail
@Perfil		varchar(50),
@Para		varchar(8000) = NULL,
@CC			varchar(8000) = NULL,
@CCO		varchar(8000) = NULL,
@Asunto		varchar(8000) = NULL,
@Mensaje		text 	      = NULL,
@Formato		varchar(50)   = 'HTML',
@Importancia	varchar(20)   = 'Normal',
@Sensitividad	varchar(20)   = 'Normal',
@Adjuntos		varchar(max) = NULL,
@SQL		varchar(8000) = NULL,
@SQLBase		varchar(50)   = NULL,
@SQLAnexar		bit	      = 0,
@SQLAnexarNombre	varchar(255)  = NULL,
@SQLConEncabezados	bit	      = 1,
@SQLAncho		int 	      = NULL,
@SQLSeparador	char(1)	      = ' '

AS BEGIN
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
@file_attachments = @Adjuntos,
@query = @SQL,
@execute_query_database = @SQLBase,
@attach_query_result_as_file = @SQLAnexar,
@query_attachment_filename = @SQLAnexarNombre,
@query_result_header = @SQLConEncabezados,
@query_result_width = @SQLAncho,
@query_result_separator = @SQLSeparador
END

