SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW cSAUXD

AS
SELECT
ID,
Renglon,
Producto,
SubProducto,
Servicio,
Codigo,
Cantidad,
CantidadPendeiente,
CantidadCancelada,
CantidadA,
FechaRequerida,
FechaInicio,
FechaFin,
FechaEntrega,
Estado,
Observaciones,
Prioridad
FROM
SAUXD WITH (NOLOCK)

