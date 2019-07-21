SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spPNetEnviarCorreoPersonal
@Personal	varchar(10),
@Condicion	varchar(20),
@Parametro1	varchar(MAX) = NULL,
@Parametro2	varchar(MAX) = NULL,
@Parametro3	varchar(MAX) = NULL
AS
BEGIN
DECLARE
@eMail				varchar(255),
@Empresa			varchar(5),
@Nombre				varchar(20),
@eMailAutoPerfil	varchar(50),
@eMailAutoAsunto	varchar(255),
@eMailAutoMensaje	varchar(max)
SELECT @eMail = ISNULL(pnet.eMail, p.eMail), @Empresa = p.Empresa
FROM Personal p /*LEFT*/ JOIN pNetUsuario pnet ON p.Personal = pnet.Usuario
WHERE p.Personal = @Personal
SELECT @Nombre = MIN(Nombre)
FROM EmpresaCfgPNetPlantillas
WHERE Empresa = @Empresa AND ISNULL(Condicion,'') = @Condicion AND ISNULL(Estatus,'') = 'ACTIVA'
WHILE @Nombre IS NOT NULL AND @eMail IS NOT NULL
BEGIN
SELECT @eMailAutoPerfil = NULL, @eMailAutoAsunto = NULL, @eMailAutoMensaje = NULL
SELECT @eMailAutoPerfil = Perfil, @eMailAutoAsunto = Asunto, @eMailAutoMensaje = Mensaje
FROM EmpresaCfgPNetPlantillas
WHERE Empresa = @Empresa AND Nombre = @Nombre AND ISNULL(Condicion,'') = @Condicion AND ISNULL(Estatus,'') = 'ACTIVA'
IF (@Condicion = 'Generar Nómina')
BEGIN
SET @eMailAutoMensaje = replace(@eMailAutoMensaje, '@@Periodo', @Parametro1)
END
IF ISNULL(@eMailAutoPerfil,'') = '' SELECT @eMailAutoPerfil = DBMailPerfil FROM EmpresaGral WHERE Empresa = @Empresa
IF ISNULL(@eMailAutoPerfil,'') <> '' AND ISNULL(@eMail,'') <> ''
BEGIN
EXEC spEnviarDBMail @Perfil = @eMailAutoPerfil, @Para = @eMail, @Asunto = @eMailAutoAsunto, @Mensaje = @eMailAutoMensaje, @Formato = 'HTML'
END
SELECT @Nombre = MIN(Nombre) FROM EmpresaCfgPNetPlantillas WHERE Empresa = @Empresa AND ISNULL(Condicion,'') = 'Alta Personal' AND ISNULL(Estatus,'') = 'ACTIVA' AND Nombre > @Nombre
END
RETURN
END

