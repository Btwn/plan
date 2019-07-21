SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gVentaEntrega
 AS
SELECT
ID,
Embarque,
EmbarqueFecha,
EmbarqueReferencia,
Recibo,
ReciboFecha,
ReciboReferencia,
EntregaMercancia,
Sucursal,
SucursalOrigen,
Direccion,
DireccionNumero,
DireccionNumeroInt,
CodigoPostal,
Delegacion,
Colonia,
Poblacion,
Estado,
TotalCajas,
Telefono,
TelefonoMovil
FROM VentaEntrega
UNION ALL
SELECT
ID,
Embarque,
EmbarqueFecha,
EmbarqueReferencia,
Recibo,
ReciboFecha,
ReciboReferencia,
EntregaMercancia,
Sucursal,
SucursalOrigen,
Direccion,
DireccionNumero,
DireccionNumeroInt,
CodigoPostal,
Delegacion,
Colonia,
Poblacion,
Estado,
TotalCajas,
Telefono,
TelefonoMovil
FROM hVentaEntrega
;

