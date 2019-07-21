SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW IntelisisServiceBorrador

AS
SELECT
iss.ID,
iss.Sistema,
iss.Contenido,
iss.Referencia,
iss.SubReferencia,
iss.Version,
iss.Usuario,
iss.Solicitud,
iss.Resultado,
iss.Estatus,
iss.FechaEstatus,
iss.Ok,
iss.OkRef,
iss.SucursalOrigen,
iss.SucursalDestino
FROM IntelisisService iss JOIN IntelisisService is1
ON is1.Conversacion = iss.Conversacion JOIN Version
ON 1 = 1
WHERE is1.SubReferencia = 'SincroFinal'
AND is1.Estatus = 'BORRADOR'
AND iss.SucursalDestino <> Version.Sucursal
AND is1.SucursalDestino <> Version.Sucursal

