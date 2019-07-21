SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gCxcAplicaDif
 AS
SELECT
ID,
OrdenID,
Mov,
Concepto,
Importe,
Impuestos,
Cliente,
ClienteEnviarA,
Referencia,
Sucursal,
SucursalOrigen
FROM CxcAplicaDif
UNION ALL
SELECT
ID,
OrdenID,
Mov,
Concepto,
Importe,
Impuestos,
Cliente,
ClienteEnviarA,
Referencia,
Sucursal,
SucursalOrigen
FROM hCxcAplicaDif
;

