SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gConciliacionD
 AS
SELECT
ID,
RID,
Fecha,
Concepto,
Referencia,
Cargo,
Abono,
Observaciones,
Manual,
TipoMovimiento,
Auxiliar,
ContD,
ConceptoGasto,
Acreedor,
ObligacionFiscal,
Seccion,
Sucursal,
SucursalOrigen,
Tasa,
TipoImporte,
ObligacionFiscal2
FROM ConciliacionD WITH(NOLOCK)
UNION ALL
SELECT
ID,
RID,
Fecha,
Concepto,
Referencia,
Cargo,
Abono,
Observaciones,
Manual,
TipoMovimiento,
Auxiliar,
ContD,
ConceptoGasto,
Acreedor,
ObligacionFiscal,
Seccion,
Sucursal,
SucursalOrigen,
Tasa,
TipoImporte,
ObligacionFiscal2
FROM hConciliacionD WITH(NOLOCK)
;

