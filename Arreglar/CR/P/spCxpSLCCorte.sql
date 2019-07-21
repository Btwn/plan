SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCxpSLCCorte
@Estacion				int,
@Modulo					varchar(20),
@ID						int,
@IDGenerar				int,
@MovGenerar				varchar(20),
@MovIDGenerar			varchar(20),
@FechaCorte				datetime,
@Accion					varchar(20),
@Estatus				varchar(15),
@EstatusNuevo			varchar(15),
@Ok						int OUTPUT,
@OkRef					varchar(255) OUTPUT

AS BEGIN
DECLARE
@CorteIDAnterior			int,
@ImporteCorte				float,
@OModulo					varchar(5),
@OModuloID					int
EXEC spMovOrigen @Modulo, @ID, 0, @OModulo OUTPUT, @OModuloID OUTPUT
IF @Accion IN ('AFECTAR') AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @EstatusNuevo IN ('PENDIENTE')
BEGIN
IF EXISTS(SELECT 1 FROM SerieLoteConsignacionAux WITH(UPDLOCK,ROWLOCK) WHERE OModulo = @OModulo AND OModuloID = @OModuloID)
BEGIN
SELECT @CorteIDAnterior = dbo.fnSerieLoteConsignacionUltimoCorteTemp(@Estacion, @Modulo, @IDGenerar)
IF ISNULL(@CorteIDAnterior,0) = ISNULL(dbo.fnSerieLoteConsignacionUltimoCorte(@OModulo, @OModuloID),0) AND @Ok IS NULL
BEGIN
IF dbo.fnSerieLoteConsignacionCorteVerificado(@Estacion, @Modulo, @IDGenerar) = 1
BEGIN
UPDATE SerieLoteConsignacionAux
SET CorteID = @IDGenerar,
CorteIDAnterior = @CorteIDAnterior
FROM SerieLoteConsignacionAux slca JOIN SerieLoteConsignacionAuxTemp slcat
ON slcat.RIDOriginal = slca.RID
WHERE slcat.Estacion = @Estacion
AND slcat.Modulo = @Modulo
AND slcat.ModuloID = @IDGenerar
AND NULLIF(slcat.CorteID,0) IS NULL
END ELSE SELECT @Ok = 75520
END ELSE SELECT @Ok = 75520
END ELSE SELECT @Ok = 75520
END ELSE
IF @Accion = 'CANCELAR' AND @Estatus IN ('PENDIENTE') AND @EstatusNuevo IN ('CANCELADO')
BEGIN
IF dbo.fnSerieLoteConsignacionUltimoCorte(@OModulo, @OModuloID) <> @IDGenerar SELECT @Ok = 75530, @OkRef =  ISNULL(@MovGenerar,'') + ' ' + ISNULL(@MovIDGenerar,'')
IF @Ok IS NULL
BEGIN
IF EXISTS(SELECT 1 FROM SerieLoteConsignacionAux WITH(UPDLOCK,ROWLOCK) WHERE CorteID = @IDGenerar)
BEGIN
UPDATE SerieLoteConsignacionAux SET CorteID = NULL, CorteIDAnterior = NULL WHERE CorteID = @IDGenerar
END
END
END
END

