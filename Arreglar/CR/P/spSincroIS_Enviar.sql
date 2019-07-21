SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroIS_Enviar
@Usuario				varchar(10)

AS BEGIN
DECLARE
@SucursalOrigen	int,
@Conversacion	uniqueidentifier,
@Solicitud		uniqueidentifier,
@FechaEnvio		datetime,
@Ok			int,
@OkRef		varchar(255)
SELECT @Ok = NULL, @OkRef = NULL
EXEC spSincroISActualizarSesion @Usuario
SELECT @Solicitud = NEWID(), @Conversacion = NEWID(), @FechaEnvio = GETDATE()
SELECT @SucursalOrigen = Sucursal FROM Version
IF @SucursalOrigen > 0
BEGIN
BEGIN TRANSACTION
EXEC spSetInformacionContexto 'SINCROIS', 1
UPDATE Sucursal SET UltimaSincronizacion = @FechaEnvio WHERE Sucursal = @SucursalOrigen
EXEC spSetInformacionContexto 'SINCROIS', 0
EXEC spSincroISEnviarTablasEnPartes @Solicitud = @Solicitud, @Conversacion = @Conversacion, @FechaEnvio = @FechaEnvio OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
UPDATE IntelisisService SET Estatus = 'SINPROCESAR' WHERE Estatus = 'BORRADOR' AND Conversacion = @Conversacion 
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
END
EXEC spSincroISOk @Solicitud, 'SincroIS/Sincro', NULL, NULL, NULL, NULL, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

