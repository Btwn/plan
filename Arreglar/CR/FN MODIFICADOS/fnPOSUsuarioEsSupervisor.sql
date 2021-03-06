SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSUsuarioEsSupervisor (
@ID		varchar(36)
)
RETURNS bit

AS
BEGIN
DECLARE
@Usuario    varchar(10),
@POSPerfil  varchar(10),
@Resultado  bit
SELECT @Resultado    = 0
SELECT @Usuario =  UsuarioAutoriza
FROM POSL WITH(NOLOCK)
WHERE ID = @ID
SELECT @POSPerfil = NULLIF(POSPerfil,'')
FROM Usuario WITH(NOLOCK)
WHERE Usuario = @Usuario
IF EXISTS(SELECT * FROM Usuario WITH(NOLOCK) WHERE ISNULL(POSEsSupervisor,0) = 1 AND Usuario = ISNULL(@POSPerfil,@Usuario))
SELECT @Resultado = 1
RETURN (@Resultado)
END

