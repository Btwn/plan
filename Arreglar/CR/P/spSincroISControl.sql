SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISControl
@SucursalOrigen		int,
@SucursalDestino	int,
@Conversacion		uniqueidentifier	OUTPUT,
@FechaEnvio		datetime		OUTPUT,
@Desde			timestamp		OUTPUT,
@Hasta			timestamp		OUTPUT

AS BEGIN
SELECT @Desde = 0, @FechaEnvio = GETDATE()
SELECT @Desde = ISNULL(MAX(SincroID), 0)
FROM SincroISControl
WHERE SucursalDestino = @SucursalDestino
INSERT SincroISControl (
SucursalOrigen,  SucursalDestino,  Conversacion,  FechaEnvio,  SincroIDAnterior)
VALUES (@SucursalOrigen, @SucursalDestino, @Conversacion, @FechaEnvio, @Desde)
SELECT @Hasta = @@DBTS
RETURN
END

