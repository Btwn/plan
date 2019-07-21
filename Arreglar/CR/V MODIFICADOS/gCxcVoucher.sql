SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gCxcVoucher
 AS
SELECT
ID,
RID,
Sucursal,
Mov,
Referencia,
Concepto,
EnviarA,
Cargo,
Abono,
Nuevo,
Aceptar,
IDAplica,
SucursalOrigen
FROM CxcVoucher WITH(NOLOCK)
UNION ALL
SELECT
ID,
RID,
Sucursal,
Mov,
Referencia,
Concepto,
EnviarA,
Cargo,
Abono,
Nuevo,
Aceptar,
IDAplica,
SucursalOrigen
FROM hCxcVoucher WITH(NOLOCK)
;

