SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gCompraDPresupuestoEsp
 AS
SELECT
ID,
Renglon,
RenglonSub,
CuentaPresupuesto,
Importe,
Sucursal,
SucursalOrigen
FROM CompraDPresupuestoEsp
UNION ALL
SELECT
ID,
Renglon,
RenglonSub,
CuentaPresupuesto,
Importe,
Sucursal,
SucursalOrigen
FROM hCompraDPresupuestoEsp
;

