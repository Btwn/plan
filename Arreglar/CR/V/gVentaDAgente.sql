SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gVentaDAgente
 AS
SELECT
ID,
Renglon,
RenglonSub,
RID,
Agente,
Fecha,
HoraD,
HoraA,
Minutos,
Actividad,
Estado,
Comentarios,
CantidadEstandar,
FechaConclusion,
CostoActividad,
Sucursal,
SucursalOrigen,
Avance
FROM VentaDAgente
UNION ALL
SELECT
ID,
Renglon,
RenglonSub,
RID,
Agente,
Fecha,
HoraD,
HoraA,
Minutos,
Actividad,
Estado,
Comentarios,
CantidadEstandar,
FechaConclusion,
CostoActividad,
Sucursal,
SucursalOrigen,
Avance
FROM hVentaDAgente
;

