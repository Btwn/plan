SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gVentaFEA
 AS
SELECT
ID,
Serie,
Folio,
Aprobacion,
Procesar,
Cancelar,
Cancelada,
Error,
Firmada,
Sello,
Certificado,
CadenaOriginal,
Documento,
Mensaje,
Sucursal,
SucursalOrigen
FROM VentaFEA
UNION ALL
SELECT
ID,
Serie,
Folio,
Aprobacion,
Procesar,
Cancelar,
Cancelada,
Error,
Firmada,
Sello,
Certificado,
CadenaOriginal,
Documento,
Mensaje,
Sucursal,
SucursalOrigen
FROM hVentaFEA
;

