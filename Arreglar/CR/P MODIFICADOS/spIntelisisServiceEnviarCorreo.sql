SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisServiceEnviarCorreo
@Empresa	varchar(5),
@Para		varchar(8000),
@CC			varchar(8000),
@CCO		varchar(8000),
@Asunto		varchar(8000),
@Mensaje	varchar(8000) = NULL,
@Anexos		varchar(max) = NULL

AS BEGIN
DECLARE
@Perfil		varchar(50),
@ID			int,
@NombreCorreoEnLote	varchar(100)
SELECT @Perfil = DBMailPerfil FROM EmpresaGral WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @Para    = NULLIF(RTRIM(@Para), ''),
@CC      = NULLIF(RTRIM(@CC), ''),
@CCO     = NULLIF(RTRIM(@CCO), ''),
@Asunto  = NULLIF(RTRIM(@Asunto), ''),
@Mensaje = NULLIF(RTRIM(@Mensaje), ''),
@Anexos  = NULLIF(RTRIM(@Anexos), '')
IF @Para IS NOT NULL
BEGIN
EXEC spEnviarDBMail @Perfil, @Para, @CC = @CC, @CCO = @CCO, @Asunto = @Asunto, @Mensaje = @Mensaje, @Formato = 'HTML', @Adjuntos = @Anexos
END
END

