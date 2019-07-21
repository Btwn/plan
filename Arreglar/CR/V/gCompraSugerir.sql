SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gCompraSugerir
 AS
SELECT
Estacion,
CompraID,
ID,
Modulo,
ModuloID,
Mov,
MovID,
FechaEmision,
FechaRequerida,
Referencia,
Cliente,
Almacen,
Articulo,
SubCuenta,
Precio,
Descuento,
ServicioArticulo,
ServicioSerie,
ServicioFecha,
ClaveProveedor,
UnidadCompra,
CantidadMinima,
Multiplos,
MultiplosUnidad,
Cantidad,
CantidadA,
FactorDemanda,
Paquete
FROM CompraSugerir
UNION ALL
SELECT
Estacion,
CompraID,
ID,
Modulo,
ModuloID,
Mov,
MovID,
FechaEmision,
FechaRequerida,
Referencia,
Cliente,
Almacen,
Articulo,
SubCuenta,
Precio,
Descuento,
ServicioArticulo,
ServicioSerie,
ServicioFecha,
ClaveProveedor,
UnidadCompra,
CantidadMinima,
Multiplos,
MultiplosUnidad,
Cantidad,
CantidadA,
FactorDemanda,
Paquete
FROM hCompraSugerir
;

