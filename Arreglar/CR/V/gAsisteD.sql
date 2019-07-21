SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gAsisteD
 AS
SELECT
ID,
Renglon,
Recurso,
Personal,
Registro,
HoraRegistro,
HoraD,
HoraA,
FechaD,
FechaA,
Concepto,
Cantidad,
Tipo,
Observaciones,
Sucursal,
Fecha,
Proyecto,
Actividad,
Costo,
Retardo,
ActividadEstado,
ActividadAvance,
MovimientoRef,
Logico1,
Logico2,
Logico3,
Logico4,
Logico5,
SucursalOrigen,
Extra,
GestionRef,
ActividadABCRef,
MapaLatitud,
MapaLongitud,
MapaPrecision,
MapaUbicacion
FROM AsisteD
UNION ALL
SELECT
ID,
Renglon,
Recurso,
Personal,
Registro,
HoraRegistro,
HoraD,
HoraA,
FechaD,
FechaA,
Concepto,
Cantidad,
Tipo,
Observaciones,
Sucursal,
Fecha,
Proyecto,
Actividad,
Costo,
Retardo,
ActividadEstado,
ActividadAvance,
MovimientoRef,
Logico1,
Logico2,
Logico3,
Logico4,
Logico5,
SucursalOrigen,
Extra,
GestionRef,
ActividadABCRef,
MapaLatitud,
MapaLongitud,
MapaPrecision,
MapaUbicacion
FROM hAsisteD
;

