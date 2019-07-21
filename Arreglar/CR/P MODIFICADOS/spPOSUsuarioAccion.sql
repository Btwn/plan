SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSUsuarioAccion
@Usuario			varchar(10),
@UsuarioPerfil		varchar(10),
@Sucursal			int,
@Accion				varchar(50),
@ID					varchar(36),
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE
@UsuarioAutoriza	        varchar(10),
@UsuarioAutorizaPerfil		varchar(10)
IF NOT EXISTS(SELECT 1 FROM POSUsuarioAccion pua WITH (NOLOCK) WHERE pua.Usuario = ISNULL(NULLIF(@UsuarioPerfil,''),@Usuario) AND pua.Accion = @Accion)
BEGIN
SELECT @UsuarioAutoriza = UsuarioAutoriza
FROM POSL WITH (NOLOCK)
WHERE ID = @ID
SELECT @UsuarioAutoriza = ISNULL(@UsuarioAutoriza, @Usuario)
SELECT @UsuarioAutorizaPerfil = NULLIF(POSPerfil,'') FROM Usuario WITH (NOLOCK) WHERE Usuario = @UsuarioAutorizaPerfil
IF NOT EXISTS(SELECT 1 FROM POSUsuarioAccion pua WITH (NOLOCK) WHERE pua.Usuario = ISNULL(NULLIF(@UsuarioPerfil,''),@UsuarioAutoriza)
AND pua.Accion = @Accion) AND @Accion NOT IN('CANCELACION DINERO','BENEFICIARIO','IMPORTE ANTICIPO')
SELECT @Ok = 3, @OkRef = @Accion
EXEC spPOSUsuarioDesautoriza @ID
END
END

