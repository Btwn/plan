SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSUsuarioAutorizaValidaSuc
@Usuario		varchar(20),
@Sucursal		int

AS
BEGIN
DECLARE
@PuedeAutorizar		int
SELECT @PuedeAutorizar = 0
IF EXISTS(SELECT 1 FROM UsuarioSucursalAcceso us WITH (NOLOCK) WHERE us.Usuario = @Usuario AND us.Sucursal = @Sucursal)
SELECT @PuedeAutorizar = 1
IF EXISTS(SELECT 1 FROM Usuario u WITH (NOLOCK) WHERE u.Usuario = @Usuario AND u.Sucursal = @Sucursal) AND @PuedeAutorizar = 0
SELECT @PuedeAutorizar = 1
IF (SELECT AccesarOtrasSucursalesEnLinea FROM Usuario u WITH (NOLOCK) WHERE u.Usuario = @Usuario) = 1 AND @PuedeAutorizar = 0
SELECT @PuedeAutorizar = 1
SELECT @PuedeAutorizar
END

