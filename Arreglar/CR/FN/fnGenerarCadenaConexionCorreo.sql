SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnGenerarCadenaConexionCorreo
(
@Ruta						varchar(255),
@RecibirCorreoPerfil		varchar(50)
)
RETURNS varchar(max)

AS BEGIN
DECLARE
@CadenaConexion				varchar(max),
@UIDTexto					varchar(50)
SELECT
@CadenaConexion = 'ServidorP3=' + LTRIM(RTRIM(ISNULL(Servidor,''))) +
';UsuarioP3=' + LTRIM(RTRIM(ISNULL(Usuario,''))) +
';ContraseñaP3=' + LTRIM(RTRIM(ISNULL(Contrasena,''))) +
';Cuenta="' + LTRIM(RTRIM(ISNULL(NombreCuenta,''))) + '"' +
';Servidor=' + @@SERVERNAME +
';BaseDatos=' + DB_NAME() +
';Empresa=' + '' +
';MaxCaracteres=65536' +
';PuertoP3=' + CONVERT(varchar, Puerto) +
';UsarSSL=' + CONVERT(varchar, ActivarSSL) +
';Ruta="' +  @Ruta + '"'
FROM CFDFlexPerfilDBMail
WHERE NombrePerfil = @RecibirCorreoPerfil
RETURN (@CadenaConexion)
END

