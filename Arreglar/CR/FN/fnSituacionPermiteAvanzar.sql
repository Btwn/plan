SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSituacionPermiteAvanzar
(
@Empresa				varchar(5),
@Modulo					varchar(5),
@Mov					varchar(20),
@Estatus				varchar(15),
@Situacion				varchar(50),
@Usuario				varchar(10)
)
RETURNS bit

AS BEGIN
DECLARE
@Resultado				bit,
@Situaciones			bit,
@UsuarioConPermiso		bit,
@ControlUsuarios		bit,
@ID						int
SET @Resultado = 0
SET @Situaciones = ISNULL((SELECT 1 FROM EmpresaCfgModulo WHERE Empresa = @Empresa AND Modulo = @Modulo AND Situaciones = 'Si'),0)
IF @Situaciones = 1
BEGIN
SET @UsuarioConPermiso = ISNULL((SELECT 1 FROM Usuario WHERE Usuario = @Usuario AND ModificarSituacion = 1),0)
IF @UsuarioConPermiso = 1
BEGIN
SELECT @ControlUsuarios = ISNULL(ControlUsuarios,1), @ID = ID FROM MovSituacion WHERE Modulo = @Modulo AND Mov = @Mov AND Estatus = @Estatus AND Situacion = @Situacion
IF @ControlUsuarios = 0
BEGIN
SET @Resultado = 1
END ELSE
BEGIN
SET @Resultado = ISNULL((SELECT 1 FROM MovSituacionUsuario WHERE ID = @ID AND Usuario = @Usuario),0)
END
END
END
RETURN (@Resultado)
END

