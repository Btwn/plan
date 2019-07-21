SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEnviarCorreo
@Empresa	varchar(5),
@Para	varchar(8000),
@Asunto	varchar(8000),
@Mensaje	varchar(8000) = NULL,
@Anexos	varchar(8000) = NULL,
@SQL	varchar(8000) = NULL,
@SQLAncho	int 	      = 250,
@CC		varchar(8000) = NULL

AS BEGIN
DECLARE
@Perfil		varchar(50),
@ID			int,
@Fecha		datetime,
@NombreCorreoEnLote	varchar(100)
SELECT @Perfil = DBMailPerfil FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @Para    = NULLIF(RTRIM(@Para), ''),
@Mensaje = NULLIF(RTRIM(@Mensaje), ''),
@Asunto  = NULLIF(RTRIM(@Asunto), ''),
@Anexos  = NULLIF(RTRIM(@Anexos), ''),
@SQL     = NULLIF(RTRIM(@SQL), ''),
@Fecha   = GETDATE()
IF SUBSTRING(@Anexos,LEN(@Anexos),1) = ';' SELECT @Anexos = STUFF(@Anexos,LEN(@Anexos),1,'')
IF @Para IS NOT NULL
BEGIN
IF @SQL IS NOT NULL
EXEC spEnviarDBMail @Perfil, @Para, @CC = @CC, @Asunto = @Asunto, @Mensaje = @Mensaje, @Formato = 'HTML', @Adjuntos = @Anexos, @SQL = @SQL, @SQLAncho = @SQLAncho
ELSE
EXEC spEnviarDBMail @Perfil, @Para, @CC = @CC, @Asunto = @Asunto, @Mensaje = @Mensaje, @Formato = 'HTML', @Adjuntos = @Anexos
SELECT @NombreCorreoEnLote = NombreCorreoEnLote FROM Version
EXEC spOutlook @NombreCorreoEnLote, @Fecha, @Asunto, @Mensaje, @Anexos, @EnSilencio = 1, @ID = @ID OUTPUT
EXEC spOutlookPara @ID, @Para
END
END

