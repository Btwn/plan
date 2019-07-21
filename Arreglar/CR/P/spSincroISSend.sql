SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISSend
@Tipo				varchar(100),
@Datos				xml,
@Conversacion		uniqueidentifier,
@SucursalOrigen		int,
@SucursalDestino	int,
@Tabla				varchar(100),
@SincroSolicitud	uniqueidentifier,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Usuario			varchar(10),
@Contrasena			varchar(32),
@Solicitud			varchar(max),
@ID					int
IF @Datos IS NOT NULL
BEGIN
SELECT @Solicitud = '<?xml version="1.0" encoding="windows-1252"?><Intelisis'+
dbo.fnXML('Sistema', 'Intelisis')+
dbo.fnXML('Contenido', 'Solicitud')+
dbo.fnXML('Referencia', 'SincroIS')+
dbo.fnXML('SubReferencia', @Tipo)+
dbo.fnXML('Tipo', 'SolicitudPrueba')+'>'+
'<Solicitud>'+CONVERT(varchar(max), @Datos)+'</Solicitud>'+
'</Intelisis>'
EXEC spSincroISUsuario @Usuario OUTPUT, @Contrasena OUTPUT
EXEC spIntelisisService @Usuario, @Contrasena, @Solicitud, @Ok OUTPUT, @OkRef OUTPUT, 0, 0, @ID = @ID OUTPUT
UPDATE IntelisisService SET Conversacion = @Conversacion, SucursalOrigen = @SucursalOrigen, SucursalDestino = @SucursalDestino, SincroTabla = @Tabla, SincroSolicitud = @SincroSolicitud WHERE ID = @ID
IF @Tipo NOT IN ('SolicitarRespaldo','SolicitarTRCL','SolicitarPrueba')
BEGIN
UPDATE IntelisisService SET Estatus = 'BORRADOR' WHERE ID = @ID
DELETE FROM IntelisisServiceLog WHERE ID = @ID AND Estatus = 'SINPROCESAR'
END
END
RETURN
END

