SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gVentaDLogPicos
 AS
SELECT
ID,
Renglon,
RenglonSub,
CantidadCancelada,
FechaCancelacion,
Sucursal,
SucursalOrigen
FROM VentaDLogPicos
UNION ALL
SELECT
ID,
Renglon,
RenglonSub,
CantidadCancelada,
FechaCancelacion,
Sucursal,
SucursalOrigen
FROM hVentaDLogPicos
;

