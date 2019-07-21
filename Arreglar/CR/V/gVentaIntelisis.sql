SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gVentaIntelisis
 AS
SELECT
ID,
Descripcion,
Problema,
SolucionActual,
SolucionSugerida,
Layout,
Ejemplos,
Filtros,
Ubicacion,
Respaldo,
Version,
ContactoSolicitante,
ContactoDudas,
ContactoAutorizacion,
ContactoFacturacion,
FechaSolicitud,
FechaRequerida,
FechaAutorizacion,
Solucion,
Requerimientos,
Instrucciones,
FechaEntregaPrometida,
FechaEntregaReal,
VersionEntrega,
AgenteProgramador,
AgenteCalidad,
Sucursal,
SucursalOrigen
FROM VentaIntelisis
UNION ALL
SELECT
ID,
Descripcion,
Problema,
SolucionActual,
SolucionSugerida,
Layout,
Ejemplos,
Filtros,
Ubicacion,
Respaldo,
Version,
ContactoSolicitante,
ContactoDudas,
ContactoAutorizacion,
ContactoFacturacion,
FechaSolicitud,
FechaRequerida,
FechaAutorizacion,
Solucion,
Requerimientos,
Instrucciones,
FechaEntregaPrometida,
FechaEntregaReal,
VersionEntrega,
AgenteProgramador,
AgenteCalidad,
Sucursal,
SucursalOrigen
FROM hVentaIntelisis
;

