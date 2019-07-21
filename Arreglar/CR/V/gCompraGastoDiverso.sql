SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gCompraGastoDiverso
 AS
SELECT
ID,
Concepto,
Acreedor,
RenglonID,
Importe,
PorcentajeImpuestos,
Moneda,
TipoCambio,
Prorrateo,
FechaEmision,
Condicion,
Vencimiento,
Referencia,
Retencion,
Retencion2,
Retencion3,
Impuestos,
Multiple,
Sucursal,
PedimentoEspecifico,
SucursalOrigen,
ProrrateoNivel
FROM CompraGastoDiverso
UNION ALL
SELECT
ID,
Concepto,
Acreedor,
RenglonID,
Importe,
PorcentajeImpuestos,
Moneda,
TipoCambio,
Prorrateo,
FechaEmision,
Condicion,
Vencimiento,
Referencia,
Retencion,
Retencion2,
Retencion3,
Impuestos,
Multiple,
Sucursal,
PedimentoEspecifico,
SucursalOrigen,
ProrrateoNivel
FROM hCompraGastoDiverso
;

