SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gMovTarea
 AS
SELECT
Modulo,
ID,
RenglonID,
Tarea,
Problema,
Solucion,
Estado,
Fecha,
Responsable,
FechaEstimada,
FechaConclusion,
Sucursal,
Usuario,
Tiempo,
Logico1,
Logico2,
Logico3,
Orden,
Comentarios,
SucursalOrigen
FROM MovTarea
UNION ALL
SELECT
Modulo,
ID,
RenglonID,
Tarea,
Problema,
Solucion,
Estado,
Fecha,
Responsable,
FechaEstimada,
FechaConclusion,
Sucursal,
Usuario,
Tiempo,
Logico1,
Logico2,
Logico3,
Orden,
Comentarios,
SucursalOrigen
FROM hMovTarea
;

