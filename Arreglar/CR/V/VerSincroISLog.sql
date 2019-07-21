SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW VerSincroISLog

AS
SELECT RID,
CONVERT(varchar(36), Solicitud) AS Solicitud,
CONVERT(varchar(36), Conversacion) AS Conversacion,
'ConversacionTabla' = Tabla,
PaqueteCambios,
PaqueteBajas,
SucursalOrigen,
SucursalDestino,
FechaEnvio,
FechaRecibo
FROM SincroISLog

