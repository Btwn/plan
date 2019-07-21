SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexEnviarCorreo
@Empresa	varchar(5),
@Para	    varchar(8000),
@Asunto	    varchar(8000),
@Mensaje	varchar(8000) = NULL,
@Anexos	    varchar(8000) = NULL,
@SQL	    varchar(8000) = NULL,
@SQLAncho	int 	      = 250,
@CC		    varchar(8000) = NULL

AS BEGIN
DECLARE
@Perfil		varchar(50),
@ID			int,
@Fecha		datetime,
@NombreCorreoEnLote	varchar(100),
@MedioEnvio varchar(50),
@Smtp				varchar(50),
@PuertoCorreo		varchar(50),
@Usuario			varchar(50),
@Pasword			varchar(50),
@RFC				varchar(50),
@CadenaConexion		varchar(max),
@RutaIntelisisCFDI	varchar(255),
@AlmacenarRuta		varchar(200),
@Shell				varchar(8000),
@Enviar				bit,
@r					varchar(max)
DECLARE @Datos TABLE (ID int IDENTITY(1,1), Datos varchar(255))
SELECT @Perfil = NULLIF(DBMailPerfil,'') FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @MedioEnvio = EnviarMedio FROM  EmpresaCFD  WHERE  Empresa = @Empresa
SELECT @RutaIntelisisCFDI = RutaIntelisisCFDI, @Enviar =  Enviar FROM EmpresaCFD  WHERE Empresa = @Empresa
SELECT @Para    = NULLIF(RTRIM(@Para), ''),
@Mensaje = NULLIF(RTRIM(@Mensaje), '') ,
@Asunto  = NULLIF(RTRIM(@Asunto), ''),
@Anexos  = NULLIF(RTRIM(@Anexos), ''),
@SQL     = NULLIF(RTRIM(@SQL), ''),
@Fecha   = GETDATE()
IF @Enviar = 1
BEGIN
IF @MedioEnvio = 'SQL Mail'
BEGIN
IF @Para IS NOT NULL AND @Perfil IS NOT NULL
BEGIN
IF @SQL IS NOT NULL
EXEC spEnviarDBMail @Perfil, @Para, @CC = @CC, @Asunto = @Asunto, @Adjuntos = @Anexos,@Mensaje = @Mensaje, @Formato = 'HTML', @SQL = @SQL, @SQLAncho = @SQLAncho
ELSE
EXEC spEnviarDBMail @Perfil, @Para, @CC = @CC, @Asunto = @Asunto, @Adjuntos = @Anexos, @Mensaje = @Mensaje, @Formato = 'HTML'
SELECT @NombreCorreoEnLote = NombreCorreoEnLote FROM Version
EXEC spOutlook @NombreCorreoEnLote, @Fecha, @Asunto, @Mensaje, @Anexos, @EnSilencio = 1, @ID = @ID OUTPUT
EXEC spOutlookPara @ID, @Para
END
END
IF @MedioEnvio = 'IntelisisCFDI'
BEGIN
IF SUBSTRING(@Anexos,LEN(@Anexos),1) = ';' SELECT @Anexos = STUFF(@Anexos,LEN(@Anexos),1,'')
SELECT @RFC=RFC FROM EMPRESA WHERE EMPRESA = @Empresa
SELECT @Usuario      = EnviarUsuario,
@Pasword      = EnviarContrasena,
@Smtp         = EnviarSmtp,
@PuertoCorreo = EnviarPuerto
FROM EmpresaCFD
WHERE Empresa=@Empresa
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
END
END

