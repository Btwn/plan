SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spSincroSemillaOk]
@Modulo	varchar(5),
@ID	int,
@Mov	varchar(20),
@Ok	int		OUTPUT,
@OkRef	varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Del			int,
@Al				int,
@SucursalPrincipal		int,
@ValidarSincroSemilla	bit,
@Seguimiento		varchar(20),
@OrigenTipo			varchar(10)
SELECT @ValidarSincroSemilla = ValidarSincroSemilla, @SucursalPrincipal = Sucursal FROM Version
IF @ValidarSincroSemilla = 1
BEGIN
IF @SucursalPrincipal = 0 SELECT @Del = 0 ELSE SELECT @Del = 50000000 + (@SucursalPrincipal * 7000000)
SELECT @Al = 70000000 + (( @SucursalPrincipal + 1) * 7000000)
IF NOT (@ID BETWEEN @Del AND @Al-1)
BEGIN
EXEC spSucursalMovSeguimiento @SucursalPrincipal, @Modulo, @Mov, @Seguimiento OUTPUT
IF NOT (@Seguimiento = 'MATRIZ' AND @SucursalPrincipal = 0)
BEGIN
EXEC spMovInfo @ID, @Modulo, @OrigenTipo = @OrigenTipo OUTPUT
IF @OrigenTipo <> 'E/COLLAB'
SELECT @Ok = 72070, @OkRef = CONVERT(varchar, @ID)
END
END
END
END

