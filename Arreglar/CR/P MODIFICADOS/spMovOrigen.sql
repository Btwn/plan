SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovOrigen
@DModulo				varchar(5),
@DModuloID				int,
@Nivel					int,
@OModulo				varchar(5) OUTPUT,
@OModuloID				int OUTPUT

AS BEGIN
DECLARE
@OModuloResultado			varchar(5),
@OModuloIDResultado			int
SELECT @Nivel = @Nivel + 1
IF NOT EXISTS(SELECT OModulo FROM MovFlujo WITH(NOLOCK) WHERE DModulo = @DModulo AND DID = @DModuloID) OR @Nivel > 20
BEGIN
SELECT @OModulo = @DModulo, @OModuloID = @DModuloID
END ELSE
BEGIN
SELECT @OModuloResultado = OModulo, @OModuloIDResultado = OID FROM MovFlujo WITH(NOLOCK) WHERE DModulo = @DModulo AND DID = @DModuloID
EXEC spMovOrigen @OModuloResultado, @OModuloIDResultado, @Nivel, @OModuloResultado OUTPUT, @OModuloIDResultado OUTPUT
SELECT @OModulo = @OModuloResultado, @OModuloID = @OModuloIDResultado
END
END

