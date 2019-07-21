SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDIRetencionEnviar
@Empresa		varchar(5),
@ID			int,
@Estacion		int

AS BEGIN
DECLARE @Anexos				varchar(550),
@EnviarXML			bit,
@EnviarPDF			bit,
@Enviar				bit,
@Fecha				datetime,
@NombreCorreoEnLote	varchar(100),
/****/
@Perfil				varchar(50),
@Para					varchar(8000),
@CC					varchar(8000),
@CCO					varchar(8000),
@Asunto				varchar(8000),
@Mensaje				varchar(max),
@Formato				varchar(50),
@Importancia			varchar(20),
@Sensitividad			varchar(20),
@Adjuntos				varchar(max),
@SQL					varchar(8000),
@SQLBase				varchar(50),
@SQLAnexar			bit,
@SQLAnexarNombre		varchar(255),
@SQLConEncabezados	bit,
@SQLAncho				int,
@SQLSeparador			char(1),
@mailitem_id			int,
@Estatus				varchar(50),
@Proveedor			varchar(10)
SELECT @Anexos = NULL,
@EnviarXML = 0,
@EnviarPDF = 0,
@Enviar = 0,
@Para = NULL,
@CC = NULL,
@CCO = NULL,
@Asunto = NULL,
@Mensaje = NULL,
@Formato = 'HTML',
@Importancia = 'Normal',
@Sensitividad = 'Normal',
@Adjuntos = NULL,
@SQL = NULL,
@SQLBase = NULL,
@SQLAnexar = 0,
@SQLAnexarNombre = NULL,
@SQLConEncabezados = 1,
@SQLAncho = NULL,
@SQLSeparador = ' '
SELECT @Proveedor = Proveedor FROM Cxp WHERE ID = @ID
SELECT @Asunto = EnviarAsuntoRetencion,
@Mensaje = EnviarMensajeRetencion,
@EnviarXML = EnviarXMLRetencion,
@EnviarPDF = EnviarPDFRetencion,
@Enviar=EnviarRetencion
FROM EmpresaCFD
WHERE Empresa = @Empresa
EXEC spCFDIRetencionAsunto @Empresa, @Proveedor, @ID, @Asunto = @Asunto OUTPUT, @Mensaje = @Mensaje OUTPUT
SELECT @Para =ISNULL (eMail1,'' ) FROM Prov WHERE Proveedor = @Proveedor
IF (@EnviarXML=1	AND @Enviar=1)
SELECT @Anexos = ArchivoXML FROM CFDRetencion WHERE Modulo = 'CXP' AND ModuloID = @ID
IF (@EnviarPDF =1 AND @Enviar =1 )
BEGIN
IF LEN(@Anexos)>0
SET @Anexos=@Anexos+';'
SELECT @Anexos=(ISNULL(@Anexos,'')+ArchivoPDF) FROM CFDRetencion WHERE Modulo = 'CXP' AND ModuloID = @ID
END
SELECT @Perfil = DBMailPerfil FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @Para    = NULLIF(RTRIM(@Para), ''),
@Mensaje = NULLIF(RTRIM(@Mensaje), ''),
@Asunto  = NULLIF(RTRIM(@Asunto), ''),
@Anexos  = NULLIF(RTRIM(@Anexos), ''),
@SQL     = NULLIF(RTRIM(@SQL), ''),
@Fecha   = GETDATE()
IF SUBSTRING(@Anexos,LEN(@Anexos),1) = ';' SELECT @Anexos = STUFF(@Anexos,LEN(@Anexos),1,'')
DELETE FROM ListaID WHERE ID = @ID AND Estacion =@Estacion
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
SELECT @NombreCorreoEnLote = NombreCorreoEnLote FROM Version
EXEC spOutlook @NombreCorreoEnLote, @Fecha, @Asunto, @Mensaje, @Anexos, @EnSilencio = 1, @ID = @ID OUTPUT
EXEC spOutlookPara @ID, @Para
END
SELECT ''
END

