SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gSorianaRemision
 AS
SELECT
ID,
Proveedor,
Remision,
Consecutivo,
FechaRemision,
Tienda,
TipoMoneda,
TipoBulto,
EntregaMercancia,
CumpleReqFiscales,
CantidadBultos,
Subtotal,
Descuentos,
IEPS,
IVA,
OtrosImpuestos,
Total,
CantidadPedidos,
FechaEntregaMercancia,
EmpaqueEnCajas,
EmpaqueEnTarimas,
CantidadCajasTarimas
FROM SorianaRemision
UNION ALL
SELECT
ID,
Proveedor,
Remision,
Consecutivo,
FechaRemision,
Tienda,
TipoMoneda,
TipoBulto,
EntregaMercancia,
CumpleReqFiscales,
CantidadBultos,
Subtotal,
Descuentos,
IEPS,
IVA,
OtrosImpuestos,
Total,
CantidadPedidos,
FechaEntregaMercancia,
EmpaqueEnCajas,
EmpaqueEnTarimas,
CantidadCajasTarimas
FROM hSorianaRemision
;

