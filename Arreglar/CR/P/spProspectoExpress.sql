SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProspectoExpress
@Prospecto	varchar(10),
@Empresa	varchar(5)

AS BEGIN
DECLARE
@Perfil		varchar(50),
@Pagina		varchar(20),
@Nombre		varchar(100),
@ApellidoPaterno	varchar(30),
@ApellidoMaterno	varchar(30),
@Usuario		varchar(10),
@eMail		varchar(100),
@Para		varchar(255),
@Mensaje		varchar(255),
@Ok			int,
@OkRef		varchar(255),
@Asunto		varchar(100),
@HTML		varchar(max),
@Conteo		int,
@Agente		varchar(10),
@CC			varchar(255)
SELECT @Mensaje = NULL, @Ok = NULL, @OkRef = NULL, @Conteo = 0
SELECT @Pagina = NULLIF(RTRIM(ProspectoExpressPagina), ''), @Perfil = DBMailPerfil FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @Asunto = Nombre, @HTML = CONVERT(varchar(max), HTML) FROM WebPagina WHERE Pagina = @Pagina
SELECT @Usuario = NULLIF(RTRIM(p.Usuario), ''), @Agente = p.Agente, @CC = dbo.fnCorreoPara(a.Nombre, NULL, NULL, a.eMail)
FROM Prospecto p
LEFT OUTER JOIN Agente a ON a.Agente = p.Agente
WHERE p.Prospecto = @Prospecto
IF @Usuario IS NOT NULL
SELECT @Perfil = ISNULL(NULLIF(RTRIM(DBMailPerfil), ''), @Perfil) FROM Usuario WHERE Usuario = @Usuario
IF @Pagina IS NULL OR @Asunto IS NULL
SELECT @Ok = 40006
IF @Ok IS NULL
BEGIN
DECLARE crProspectoCto CURSOR LOCAL FOR
SELECT Nombre, ApellidoPaterno, ApellidoMaterno, eMail
FROM ProspectoCto
WHERE Prospecto = @Prospecto
OPEN crProspectoCto
FETCH NEXT FROM crProspectoCto INTO @Nombre, @ApellidoPaterno, @ApellidoMaterno, @eMail
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Para = dbo.fnCorreoPara(@Nombre, @ApellidoPaterno, @ApellidoMaterno, @eMail)
IF @Para IS NOT NULL
BEGIN
EXEC spWebPaginaParcear NULL, NULL, @Pagina, @Asunto OUTPUT, NULL, @HTML OUTPUT, NULL, NULL, NULL, @Ok OUTPUT, @OkRef OUTPUT
EXEC spEnviarDBMail @Perfil, @Para, @CC = @CC, @Asunto = @Asunto, @Mensaje = @HTML, @Formato = 'HTML'
SELECT @Conteo = @Conteo + 1
END
END
FETCH NEXT FROM crProspectoCto INTO @Nombre, @ApellidoPaterno, @ApellidoMaterno, @eMail
END  
CLOSE crProspectoCto
DEALLOCATE crProspectoCto
END
IF @Ok IS NULL
SELECT @Mensaje = CONVERT(varchar, @Conteo)+' Correos Enviados.'
ELSE
SELECT @Mensaje = Descripcion+' '+ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
SELECT 'Mensaje' = @Mensaje
RETURN
END

