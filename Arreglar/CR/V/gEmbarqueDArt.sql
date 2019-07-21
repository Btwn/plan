SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gEmbarqueDArt
 AS
SELECT
ID,
EmbarqueMov,
Modulo,
ModuloID,
Renglon,
RenglonSub,
ImporteTotal,
CantidadTotal,
Cantidad,
Sucursal,
SucursalOrigen,
Tarima
FROM EmbarqueDArt
UNION ALL
SELECT
ID,
EmbarqueMov,
Modulo,
ModuloID,
Renglon,
RenglonSub,
ImporteTotal,
CantidadTotal,
Cantidad,
Sucursal,
SucursalOrigen,
Tarima
FROM hEmbarqueDArt
;

