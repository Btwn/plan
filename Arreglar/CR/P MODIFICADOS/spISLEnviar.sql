SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISLEnviar
@ID		int,
@Empresa	varchar(5),
@Usuario	varchar(10),
@Licencia	varchar(50),
@LicenciaXML	varchar(max)

AS BEGIN
DECLARE
@Perfil	varchar(50),
@Para	varchar(255),
@Asunto	varchar(255)
SELECT @Perfil = DBMailPerfil FROM EmpresaGral WITH (NOLOCK)  WHERE Empresa = @Empresa
SELECT @Para = eMail
FROM IntelisisSL WITH (NOLOCK) 
WHERE Licencia = @Licencia
SELECT @Asunto = 'Intelisis - Licencia '+@Licencia
EXEC spEnviarDBMail @Perfil, @Para, @Asunto, @LicenciaXML
RETURN
END

