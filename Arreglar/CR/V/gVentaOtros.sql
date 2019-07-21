SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gVentaOtros
 AS
SELECT
ID,
Tapones,
Tapetes,
Espejos,
FarosAlojeno,
RadioCassette,
Cenicero,
LlantaRefaccion,
Gato,
Encendedor,
Antena,
Herramienta,
Limpiadores,
Gasolina,
RayonesGolpes,
ObjetosUnidad,
Observaciones,
Sucursal,
Logico1,
Logico2,
Logico3,
Logico4,
Coordenadas,
SucursalOrigen
FROM VentaOtros
UNION ALL
SELECT
ID,
Tapones,
Tapetes,
Espejos,
FarosAlojeno,
RadioCassette,
Cenicero,
LlantaRefaccion,
Gato,
Encendedor,
Antena,
Herramienta,
Limpiadores,
Gasolina,
RayonesGolpes,
ObjetosUnidad,
Observaciones,
Sucursal,
Logico1,
Logico2,
Logico3,
Logico4,
Coordenadas,
SucursalOrigen
FROM hVentaOtros
;

