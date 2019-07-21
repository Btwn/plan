SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSConsecutivoAutoAsignaAntes
@ID		varchar(36)
AS BEGIN
DECLARE	@Empresa			varchar(5),
@Sucursal			int,
@Mov				varchar(20),
@MovID				varchar(20),
@Prefijo			varchar(5),
@Consecutivo		int,
@noAprobacion		int,
@FechaAprobacion	datetime,
@Ok					int,
@OkRef				int
SELECT @Empresa				= Empresa,
@Sucursal			= Sucursal,
@Mov					= Mov,
@MovID				= NULLIF(MovID,'')
FROM POSL WITH (NOLOCK)
WHERE ID = @ID
IF @MovID IS NULL
BEGIN
EXEC spPOSConsecutivoAuto @Empresa, @Sucursal, @Mov, @MovID OUTPUT, @Prefijo OUTPUT, @Consecutivo OUTPUT, @noAprobacion OUTPUT, @FechaAprobacion OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
UPDATE POSL SET MovID = @MovID WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND Mov = @Mov AND ID = @ID
END
RETURN
END

