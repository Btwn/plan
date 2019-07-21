SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISRecibirPrueba
@iDatos			int,
@Solicitud		uniqueidentifier,
@Conversacion		uniqueidentifier,
@FechaEnvio		datetime,
@SucursalLocal		int,
@SucursalSincro		int,
@Ok			int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@FechaRecibo	datetime
SELECT @FechaRecibo = GETDATE()
IF @SucursalLocal <> @SucursalSincro
EXEC spSincroISSolicitud @Solicitud, @FechaRecibo = @FechaRecibo, @Estatus = 'CONCLUIDO'
RETURN
END

