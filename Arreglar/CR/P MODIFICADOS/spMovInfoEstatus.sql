SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovInfoEstatus
@ID			int,
@Modulo		char(5),
@Estatus	varchar(15) OUTPUT

AS BEGIN
EXEC spMovInfo @ID = @ID OUTPUT, @Modulo = @Modulo, @Estatus = @Estatus OUTPUT
END

