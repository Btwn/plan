SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSUsuarioPerfilAccion (
@ID		varchar(36),
@Accion	varchar(50))
RETURNS bit

AS
BEGIN
DECLARE
@Usuario			varchar(10),
@UsuarioAutoriza	varchar(10),
@POSPerfil			varchar(10),
@Resultado			bit
SET @Resultado    = 0
SELECT @Usuario =  Usuario, @UsuarioAutoriza = NULLIF(UsuarioAutoriza,'')
FROM POSL WITH(NOLOCK)
WHERE ID = @ID
SELECT @POSPerfil = NULLIF(POSPerfil,'')
FROM Usuario WITH(NOLOCK)
WHERE Usuario = @Usuario
IF @UsuarioAutoriza IS NOT NULL
IF EXISTS(SELECT * FROM POSUsuarioAccion WITH(NOLOCK)  WHERE Accion = @Accion AND Usuario = ISNULL(@POSPerfil,@Usuario))
SET @Resultado = 1
RETURN (@Resultado)
END

