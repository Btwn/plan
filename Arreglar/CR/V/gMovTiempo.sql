SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gMovTiempo
 AS
SELECT
Modulo,
ID,
IDOrden,
FechaComenzo,
FechaTermino,
FechaInicio,
Estatus,
Situacion,
Sucursal,
Usuario
FROM MovTiempo
UNION ALL
SELECT
Modulo,
ID,
IDOrden,
FechaComenzo,
FechaTermino,
FechaInicio,
Estatus,
Situacion,
Sucursal,
Usuario
FROM hMovTiempo
;

