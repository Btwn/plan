SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAppValidarUsuario
@Usuario varchar(10),
@Empresa char(5),
@Sucursal int,
@Contrasena varchar(100),
@OkRef varchar(255) OUTPUT

AS BEGIN
DECLARE
@Estatus varchar(20),
@AccesarOtrasSucursalesEnLinea bit,
@Ok int
SELECT @OkRef = 'Ok'
SELECT @Estatus = Estatus, @AccesarOtrasSucursalesEnLinea = AccesarOtrasSucursalesEnLinea FROM Usuario WHERE Usuario.Usuario = @Usuario
IF NOT EXISTS (SELECT Empresa FROM UsuarioD WHERE Usuario = @Usuario AND Empresa = @Empresa) SELECT @Ok = 10060, @OkRef = 'El Usuario No Tiene Acceso a Esta Empresa'
IF @AccesarOtrasSucursalesEnLinea = 0 AND @Ok IS NULL
BEGIN
IF NOT EXISTS (SELECT *FROM UsuarioSucursalAcceso WHERE Usuario = @Usuario AND Sucursal = @Sucursal) SELECT @Ok = 10060, @OkRef = 'El Usuario No Tiene Acceso a Esta Sucursal'
END
IF @Ok IS NULL AND NOT EXISTS(SELECT * FROM Usuario WHERE Usuario = @Usuario AND Contrasena IN (@Contrasena,dbo.fnPassword(UPPER(RTRIM(@Contrasena))))) SELECT @Ok = 10060, @OkRef = 'Contraseña Incorrecta'
IF @Estatus <> 'ALTA' AND @Ok IS NULL
BEGIN
IF @Estatus = 'BLOQUEADO' SELECT @Ok = 10060, @OkRef = 'Usuario Bloqueado' ELSE
IF @Estatus = 'BAJA' SELECT @Ok = 10060, @OkRef = 'Usuario Baja'
END
RETURN
END

