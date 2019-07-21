SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spEnviarReciboNominaCFDI
@Empresa		varchar(5),
@ID			int = NULL,
@Personal		varchar(100),
@Estacion		varchar(5)

AS BEGIN
DECLARE
@Anexos				varchar(100),
@EnviarXML			bit,
@EnviarPDF			bit,
@Enviar				bit,
@Fecha				datetime,
@NombreCorreoEnLote	varchar(100),
/****/
@Para				varchar(8000),
@Asunto				varchar(8000),
@Mensaje			varchar(max),
@Adjuntos			varchar(max),
@Estatus			varchar(50),
@Smtp				varchar(50),
@PuertoCorreo		varchar(50),
@Usuario			varchar(50),
@Pasword			varchar(50),
@Cuenta				varchar(50),
@RFC				varchar(50),
@CadenaConexion		varchar(max),
@AlmacenarRuta		varchar(200),
@RutaIntelisisCFDI	varchar(255),
@Shell				varchar(8000),
@r					varchar(max)
DECLARE @Datos TABLE (ID int IDENTITY(1,1), Datos varchar(255))
SELECT @EnviarXML= 0, @EnviarPDF = 0, @Enviar = 0
EXEC spAsuntoNomina @Empresa,@ID,@Personal,@Asunto=@Asunto OUTPUT
SELECT @Mensaje = EnviarMensajeNomina,@EnviarXML=EnviarXMLNomina,@EnviarPDF=EnviarPDFNomina,@Enviar=EnviarNomina,@RutaIntelisisCFDI = RutaIntelisisCFDI  FROM EmpresaCFD  WHERE Empresa = @Empresa
SELECT @Para =ISNULL (eMail,'' ) FROM Personal  WHERE Personal=@Personal
IF (@EnviarXML=1	AND @Enviar=1)
SELECT @Anexos=ArchivoXML FROM CFDINominaRecibo  WHERE RID= @ID
IF (@EnviarPDF =1 AND @Enviar =1 )
BEGIN
IF LEN(@Anexos)>0
SET @Anexos=@Anexos+';'
SELECT @Anexos=(ISNULL(@Anexos,'')+ArchivoPDF) FROM CFDINominaRecibo  WHERE RID= @ID
END
SELECT	 @Para    = NULLIF(RTRIM(@Para), ''),
@Mensaje = NULLIF(RTRIM(@Mensaje), ''),
@Asunto  = NULLIF(RTRIM(@Asunto), ''),
@Anexos  = NULLIF(RTRIM(@Anexos), ''),
@Fecha   = GETDATE()
IF SUBSTRING(@Anexos,LEN(@Anexos),1) = ';' SELECT @Anexos = STUFF(@Anexos,LEN(@Anexos),1,'')
SELECT @RFC=RFC FROM EMPRESA WHERE EMPRESA=@Empresa
SELECT @Usuario=DireccionCorreo, @Pasword= ContrasenaCorreo,@Smtp=SmtpCorreo,@PuertoCorreo=PuertoCorreo FROM EmpresaCFDNomina where Empresa=@Empresa
SELECT @CadenaConexion = '<IntelisisCFDI>'+
'<IDSESION>'+convert(varchar,@@SPID)+'</IDSESION>'+
'<FECHA>'+Convert (varchar,GETDATE())+'</FECHA>'+
'<SERVIDOR>INTELISIS</SERVIDOR>'+
'<USUARIO>'+@Usuario+'</USUARIO>'+
'<PASSWORD>'+@Pasword+'</PASSWORD>'+
'<CUENTA>'+ISNULL(@Para,'')+'</CUENTA>'+
'<ACCION>ENVIARCORREO</ACCION>'+
'<RFC>'+@RFC+'</RFC>'+
'<ASUNTO>'+@Asunto+'</ASUNTO>'+
'<SMTP>'+@Smtp+'</SMTP>'+
'<PUERTO>'+@PuertoCorreo+'</PUERTO>'+
'<MENSAJE>'+@Mensaje+'</MENSAJE>'+
'<RUTAARCHIVO>'+@Anexos+'</RUTAARCHIVO>'+
'</IntelisisCFDI>'
SELECT @Shell = CHAR(34)+CHAR(34)+@RutaIntelisisCFDI+CHAR(34)+' '+CHAR(34)+@CadenaConexion+CHAR(34)+CHAR(34)
INSERT @Datos
EXEC @r =  xp_cmdshell @Shell
END
SELECT @Estatus=Datos FROM @Datos WHERE Datos IS NOT NULL ORDER BY ID Asc
DELETE  FROM ListaModuloID WHERE ID=@ID AND Estacion =@Estacion
UPDATE CFDINominaRecibo SET EnviarMailSql= CASE WHEN  @Estatus='Envio Exitoso' THEN 'Enviado'   ELSE 'Error en el envio' END WHERE RID =@ID
SELECT ''

