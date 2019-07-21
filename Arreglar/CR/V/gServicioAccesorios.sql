SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gServicioAccesorios
 AS
SELECT
ID,
RenglonID,
Articulo,
Serie,
Observaciones,
Sucursal,
SucursalOrigen
FROM ServicioAccesorios
UNION ALL
SELECT
ID,
RenglonID,
Articulo,
Serie,
Observaciones,
Sucursal,
SucursalOrigen
FROM hServicioAccesorios
;

