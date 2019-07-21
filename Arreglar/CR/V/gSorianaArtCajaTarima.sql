SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gSorianaArtCajaTarima
 AS
SELECT
ID,
Proveedor,
Remision,
FolioPedido,
NumeroCajaTarima,
SucursalDistribuir,
Codigo,
CantidadUnidadCompra
FROM SorianaArtCajaTarima
UNION ALL
SELECT
ID,
Proveedor,
Remision,
FolioPedido,
NumeroCajaTarima,
SucursalDistribuir,
Codigo,
CantidadUnidadCompra
FROM hSorianaArtCajaTarima
;

