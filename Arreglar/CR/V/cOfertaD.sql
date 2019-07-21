SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW cOfertaD

AS
SELECT
ID,
Renglon,
Articulo,
SubCuenta,
Obsequio,
Cantidad,
Porcentaje,
Precio,
Importe,
Sucursal,
SucursalOrigen,
Moneda,
Unidad,
Factor,
UnidadObsequio,
FactorObsequio,
SubCuentaObsequio
FROM
OfertaD

