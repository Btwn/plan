SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISLog
@Solicitud		uniqueidentifier,
@Conversacion		uniqueidentifier,
@Tabla			varchar(100),
@PaqueteCambios		int,
@PaqueteBajas		int,
@SucursalOrigen		int,
@SucursalDestino	int,
@FechaEnvio		datetime,
@FechaRecibo		datetime

AS BEGIN
INSERT SincroISLog (
Solicitud,  Conversacion,  Tabla,  PaqueteCambios,  PaqueteBajas,  SucursalOrigen,  SucursalDestino,  FechaEnvio,  FechaRecibo)
VALUES (@Solicitud, @Conversacion, @Tabla, @PaqueteCambios, @PaqueteBajas, @SucursalOrigen, @SucursalDestino, @FechaEnvio, @FechaRecibo)
RETURN
END

