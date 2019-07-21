SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISSolicitud
@Solicitud			uniqueidentifier,
@Tipo				varchar(100)	= NULL,
@SucursalOrigen		int				= NULL,
@SucursalDestino	int				= NULL,
@FechaEnvio			datetime		= NULL,
@FechaRecibo		datetime		= NULL,
@Estatus			varchar(15)		= NULL

AS BEGIN
DECLARE
@FechaConclusion	datetime
IF @Estatus = 'CONCLUIDO' SELECT @FechaConclusion = GETDATE()
IF @Solicitud IS NOT NULL
BEGIN
UPDATE SincroISSolicitud
SET Tipo = ISNULL(@Tipo, Tipo),
SucursalOrigen = ISNULL(@SucursalOrigen, SucursalOrigen),
SucursalDestino = ISNULL(@SucursalDestino, SucursalDestino),
FechaEnvio = ISNULL(@FechaEnvio, FechaEnvio),
FechaRecibo = ISNULL(@FechaRecibo, FechaRecibo),
FechaConclusion = ISNULL(@FechaConclusion, FechaConclusion),
Estatus = ISNULL(@Estatus, Estatus)
WHERE Solicitud = @Solicitud
IF @@ROWCOUNT = 0
INSERT SincroISSolicitud (
Solicitud,  Tipo,  SucursalOrigen,  SucursalDestino,  FechaEnvio,  FechaRecibo,  FechaConclusion,  Estatus)
VALUES (@Solicitud, @Tipo, @SucursalOrigen, @SucursalDestino, @FechaEnvio, @FechaRecibo, @FechaConclusion, @Estatus)
END
RETURN
END

