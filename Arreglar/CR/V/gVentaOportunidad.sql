SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gVentaOportunidad
 AS
SELECT
ID,
ImporteEstimado,
Etapa,
Avance,
ProbabilidadCierre,
FechaEstimadaCierre,
PresupuestoAsignado,
Observaciones,
Sucursal,
SucursalOrigen
FROM VentaOportunidad
UNION ALL
SELECT
ID,
ImporteEstimado,
Etapa,
Avance,
ProbabilidadCierre,
FechaEstimadaCierre,
PresupuestoAsignado,
Observaciones,
Sucursal,
SucursalOrigen
FROM hVentaOportunidad
;

