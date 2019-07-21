SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gCompraGastoDiversoD
 AS
SELECT
ID,
RenglonID,
Concepto,
Acreedor,
ConceptoD,
Importe,
Retencion,
Retencion2,
Retencion3,
Impuestos,
Referencia,
Sucursal,
SucursalOrigen
FROM CompraGastoDiversoD
UNION ALL
SELECT
ID,
RenglonID,
Concepto,
Acreedor,
ConceptoD,
Importe,
Retencion,
Retencion2,
Retencion3,
Impuestos,
Referencia,
Sucursal,
SucursalOrigen
FROM hCompraGastoDiversoD
;

